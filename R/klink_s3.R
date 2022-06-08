#' Kellogg S3 (kortex) connection
#' @description Defines system environment variables required to utilize aws.s3 functions and returns paws s3 connection by way of iam role assumption.
#'
#' Requires:
#'
#' In order to use these tools users must first:
#'
#' 1. Have an RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge).
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name "CONNECT_API_KEY" <https://rstats.wtf/r-startup.html>
#'
#' 4. install aws.s3 package (not technically needed to run function but necessary in order to make use of the settings created)
#'
#' @return
#' @export
#'
#' @examples
#' # Retrieve required system settings (in background) and appropriate s3 bucket name
#' klink_s3()
#'
#' # Use example aws.s3 functions to retrieve information from s3 bucket
#' # (making sure to reference the bucket as "s3BucketName_kortex")
#' aws.s3::get_bucket_df(s3BucketName_kortex,max = 20)[["Key"]]

klink_s3 <- function(){
  bucket_name <- klink::zoltar("s3BucketName_kortex")

  if(grepl("^Error", bucket_name, ignore.case = TRUE)){
    return(bucket_name) # would be error message from zoltar
  }
   else {
     # Return bucket name to global environment as "S3BucketName_kortex"
     assign("s3BucketName_kortex",
            value = bucket_name,
            envir = globalenv()
            )

     # Use paws to assume iam and form s3 connection
     suppressWarnings(
       s3_other <- paws::s3(
       config = list(
         credentials = list(
           r <- aws.iam::assume_role("arn:aws:iam::895344418283:role/S3Access-From-Leg-Corp-Rstudio-to-kna-prd", "rstudio", use=TRUE)
           ),
         region = "us-east-1"
         )
       )
     )

     assign("s3_other",
            value = s3_other,
            envir = globalenv()
            )
  }
}
