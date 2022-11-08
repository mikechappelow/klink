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

klink_s3 <- function(){

  # Check for existing s3 connections
  if(Sys.getenv("AWS_SECRET_ACCESS_KEY") != ""){
    print("You appear to have an existing S3 connection. You can only assume one role at a time. To open a new connection you must first start a new session.")
  #----------------------------------------------------------------------------

  # If no existing connection
    } else {
      # load ec2 meta data package
      require(aws.ec2metadata)

      # Check whether in PROD or DEV
        current_server <- system2(command = "hostname", stdout  = TRUE)

        #----------------------------------------------------------------------
        # if DEV

        if(current_server %in% paste0("usaws",3170:3174)){
          # if DEV or UNKNOWN HOST
          bucket_name <- klink::zoltar("s3BucketName_kortex_DEV")

          #--------------------------------------------------------------------
          # if zoltar returned error, pass that error back as the output of function

          if(grepl("^Error", bucket_name, ignore.case = TRUE)){
            return(bucket_name) # would be error message from zoltar

          #--------------------------------------------------------------------
          # if no error, proceed with defining connection
          } else {

            # Return bucket name to global environment as "S3BucketName"
            assign("s3BucketName",
                   value = bucket_name,
                   envir = globalenv()
                   )

            # Use paws to assume iam and form s3 connection
            # suppressWarnings(
            s3_other <- paws::s3(
              config = list(
                credentials = list(
                  r <- aws.iam::assume_role("arn:aws:iam::953495608177:role/S3Access-From-Leg-Corp-Rstudio-to-kna-npd", "rstudio", use=TRUE)
                ),
                region = "us-east-1"
              )
            )
            # ) # / suppressWarnings

          }
        } else { # / else (servers in DEV)

          #--------------------------------------------------------------------
          # PROD

          # Retrieve bucket name
          bucket_name <- klink::zoltar("s3BucketName_kortex")

          #--------------------------------------------------------------------
          # if zoltar returns error, pass that as function output

          if(grepl("^Error", bucket_name, ignore.case = TRUE)){
            return(bucket_name) # would be error message from zoltar

          #--------------------------------------------------------------------
          # otherwise proceed defining connection
            } else {

              # Return bucket name to global environment as "S3BucketName_kortex"
              assign("s3BucketName",
                     value = bucket_name,
                     envir = globalenv()
                     )

              # Use paws to assume iam and form s3 connection
              # suppressWarnings(
              s3_other <- paws::s3(
                config = list(
                  credentials = list(
                    r <- aws.iam::assume_role("arn:aws:iam::895344418283:role/S3Access-From-Leg-Corp-Rstudio-to-kna-prd", "rstudio", use=TRUE)
                    ),
                  region = "us-east-1"
                  )
                )
              # ) # / suppressWarnings
            }
          } # / PROD closure

        #----------------------------------------------------------------------
        # BOTH
        assign("s3_other",
               value = s3_other,
               envir = globalenv()
               )
        } # / if no existing connection
} # / function
