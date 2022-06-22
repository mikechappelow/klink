#' Kellogg s3 (foreign) connection
#' @description Defines system environment variables required to utilize aws.s3 functions and returns proper value for s3BucketName
#'
#' Requires:
#'
#' In order to use these tools users must first:
#'
#' 1. Have an RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge).
#'
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#'
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @return
#' @export
#'
#' @examples
#' # Retrieve required system settings (in background) and appropriate s3 bucket name
#' klink_s3R()
#'
#' # Use example aws.s3 functions to retrieve information from s3 bucket
#' aws.s3::object_exists("/data/R_training/package_list.rds", bucket = s3BucketName)
#' aws.s3::object_size("/data/R_training/package_list.rds", bucket = s3BucketName)

klink_s3R <- function(){
  # Check for existing s3 connections
  if(Sys.getenv("AWS_SECRET_ACCESS_KEY") != ""){
    print("Already connected to an S3 bucket")
  }else{
    bucket_name <- klink::zoltar("s3BucketName")

    if(grepl("^Error", bucket_name, ignore.case = TRUE)){
      return(bucket_name) # would be error message from zoltar

      } else {
        # Retrieve and set required global environmental vars
        Sys.setenv("AWS_ACCESS_KEY_ID" = klink::zoltar("aws_key"),
                   "AWS_SECRET_ACCESS_KEY" = klink::zoltar("aws_secretkey"),
                   "AWS_DEFAULT_REGION" = "us-east-1",
                   envir = globalenv()
                   )

        # Return bucket name as "S3BucketName"
        assign("s3BucketName",
               value = bucket_name, #klink::zoltar("s3BucketName"),
               envir = globalenv())
      }
  }
}

