#' Kellogg S3 (kortex) connection
#' @description Defines system environment variables required to utilize aws.s3 functions and returns paws s3 connection by way of iam role assumption.
#'
#' In order to use these tools users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge).
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name "CONNECT_API_KEY" <https://rstats.wtf/r-startup.html>
#'
#' Note: the klink_s3() function currently only works from within our RStudio server environment
#'
#' @param ignore_existing Logical indicating whether to ignore existing connections when executing function. Setting to TRUE can cause warnings/errors but may be useful if you want to flush your connection.
#'
#' @usage klink_s3(ignore_existing = FALSE)
#' @return populates user environment with required role and settings to access the corresponding S3 environment
#' @export
#'
#' @examples
#' # Retrieve required system settings (in background) and appropriate s3 bucket name
#' klink_s3()
#'
#' # Use example aws.s3 functions to retrieve information from s3 bucket
#' # (making sure to reference the bucket as "s3BucketName")
#'
#' aws.s3::get_bucket_df(s3BucketName, max = 20)[["Key"]]
#'
#' s3_other$list_objects(Bucket = s3BucketName)

klink_s3 <- function(ignore_existing = FALSE){
  
  # Check for existing s3 connections
  if(ignore_existing == FALSE & Sys.getenv("AWS_SECRET_ACCESS_KEY") != ""){
    warning("You appear to have an existing S3 connection. You can only assume one role at a time. To open a new connection you must first start a new session.")
    
    # If no existing connection
  } else {
    
    # Check current env
    current_env <- klink::env_checker()
    
    zoltar_url <- if(current_env == "kortex_prod"){'ZOLTAR_KORTEX_PROD_URL_TBD'
    } else if(current_env == "kortex_dev") {'https://dev.positconnect.analytics.kellogg.com/zoltar/wish'
    } else if(current_env == "keystone_prod") {'https://rstudioconnect.analytics.kellogg.com/zoltar/wish'
    } else {"undefined"}
    
    # If DEV
    
    if(current_env %in% c("kortex_dev", "keystone_dev")){
      bucket_name <- klink::zoltar("s3BucketName_kortex_DEV")
      
      # If PROD
    } else if(current_env %in% c("kortex_prod", "keystone_prod")){
      bucket_name <- klink::zoltar("s3BucketName_kortex")
    }
    
    # If zoltar returned error, pass that error back as the output of function
    if(grepl("^Error", bucket_name, ignore.case = TRUE)){
      return(bucket_name) # would be error message from zoltar
      
      # If no error, proceed with defining connection
    } else {
      
      # Return bucket name to global environment as "S3BucketName"
      assign("s3BucketName",
             value = bucket_name,
             envir = globalenv()
      )
      
      # Find iam
      iam <- if(current_env == "kortex_dev"){klink::zoltar("s3iam_posit_kortex_DEV")
      } else if(current_env == "keystone_dev"){klink::zoltar("s3iam_posit_keystone_DEV")
      } else if(current_env == "kortex_prod"){klink::zoltar("s3iam_posit_keystone_PROD")
      } else {klink::zoltar("s3iam_posit_kortex_PROD")}
      
      # Use paws to assume iam and form s3 connection
      s3_other <- paws::s3(
        config = list(
          credentials = list(
            r <- aws.iam::assume_role(iam, "rstudio", use=TRUE)
          ),
          region = "us-east-1"
        )
      )
      
    }
    
    # BOTH
    assign("s3_other",
           value = s3_other,
           envir = globalenv()
    )
  } # / if no existing connection
} # / function
