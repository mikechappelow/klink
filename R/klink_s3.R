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
#' @param region Character string representing the regional bucket you need to connect to. Current options are 'globa', 'kna', 'keu', 'kla', and 'kamea'. Default is 'kna' in order to avoid breaking code written using previous versions.
#' @param ignore_existing Logical indicating whether to ignore existing connections when executing function. Setting to TRUE can cause warnings/errors but may be useful if you want to flush your connection.
#'
#' @usage klink_s3(region = 'kna', ignore_existing = FALSE)
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
#' aws.s3::get_bucket_df(region = 'kna', s3BucketName, max = 20)[["Key"]]
#'
#' s3_other$list_objects(Bucket = s3BucketName)

klink_s3 <- function(region = "kna", ignore_existing = FALSE){
  
  # Check for existing s3 connections
  if(ignore_existing == FALSE & Sys.getenv("AWS_SECRET_ACCESS_KEY") != ""){
    warning("You appear to have an existing S3 connection. You can only assume one role at a time. To open a new connection you must first start a new session.")
    
    # If no existing connection
  } else {
    
    #===========================================================================
    # Environmental / Regional Variations
    #===========================================================================
    # Check current env
    current_env <- klink::env_checker()
    
    # Kortex PROD
    if(current_env == "kortex_prod"){
      zoltar_url <- 'https://prod.positconnect.analytics.kellogg.com/zoltar/wish'
      if(tolower(region) == 'global'){
        bucket_name <- klink::zoltar("s3BucketName_global_kortex_prod")
        iam <- klink::zoltar("s3iam_global_kortex_prod")
      } else if(tolower(region) == 'kna'){
        bucket_name <- klink::zoltar("s3BucketName_kna_kortex_prod")
        iam <- klink::zoltar("s3iam_kna_kortex_prod")
      } else if(tolower(region) == 'keu'){
        bucket_name <- klink::zoltar("s3BucketName_keu_kortex_prod")
        iam <- klink::zoltar("s3iam_keu_kortex_prod")
      } else if(tolower(region) == 'kamea'){
        bucket_name <- klink::zoltar("s3BucketName_kamea_kortex_prod")
        iam <- klink::zoltar("s3iam_kamea_kortex_prod")
      } else { # kla
        bucket_name <- klink::zoltar("s3BucketName_kla_kortex_prod")
        iam <- klink::zoltar("s3iam_kla_kortex_prod")
      }
    
    # Kortex DEV
    } else if(current_env == "kortex_dev"){
      zoltar_url <- 'https://dev.positconnect.analytics.kellogg.com/zoltar/wish'
      if(tolower(region) == 'global'){
        bucket_name <- klink::zoltar("s3BucketName_global_kortex_dev")
        iam <- klink::zoltar("s3iam_global_kortex_dev")
      } else if(tolower(region) == 'kna'){
        bucket_name <- klink::zoltar("s3BucketName_kna_kortex_dev")
        iam <- klink::zoltar("s3iam_kna_kortex_dev")
      } else if(tolower(region) == 'keu'){
        bucket_name <- klink::zoltar("s3BucketName_keu_kortex_dev")
        iam <- klink::zoltar("s3iam_keu_kortex_dev")
      } else if(tolower(region) == 'kamea'){
        bucket_name <- klink::zoltar("s3BucketName_kamea_kortex_dev")
        iam <- klink::zoltar("s3iam_kamea_kortex_dev")
      } else { # kla
        bucket_name <- klink::zoltar("s3BucketName_kla_kortex_dev")
        iam <- klink::zoltar("s3iam_kla_kortex_dev")
      }
      
    # Keystone PROD  
    } else if(current_env == "keystone_prod"){
      zoltar_url <- 'https://rstudioconnect.analytics.kellogg.com/zoltar/wish'
      bucket_name <- klink::zoltar("s3BucketName_kortex_DEV")
      iam <- klink::zoltar("s3iam_posit_keystone_DEV")
      # iam <- if(tolower(region) == 'kna'){
      #     klink::zoltar("s3iam_posit_keystone_PROD")
      #   } else if(tolower(region) == 'keu'){
      #     klink::zoltar('')
      #   } else if(tolower(region) == 'kamea'){
      #     klink::zoltar('')
      #   } else { # kla
      #     klink::zoltar('')
      #   }
  
    # Keystone DEV - Not supported, should probably just delete
    } else {
      zoltar_url <- 'undefined'
      bucket_name <- klink::zoltar("s3BucketName_kortex_DEV")
      iam <- klink::zoltar("s3iam_posit_keystone_DEV")
      # iam <- if(tolower(region) == 'kna'){
      #     klink::zoltar("s3iam_posit_keystone_DEV")  
      #   } else if(tolower(region) == 'keu'){
      #     klink::zoltar('')
      #   } else if(tolower(region) == 'kamea'){
      #     klink::zoltar('')
      #   } else { # kla
      #     klink::zoltar('')
      #   }
    }
    
    #===========================================================================
    # All Environments / Regions
    #===========================================================================
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
    
    # Assign required vars to global environment
    assign("s3_other",
           value = s3_other,
           envir = globalenv()
    )
    
  } # / if no existing connection
} # / function
