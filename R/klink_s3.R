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
#' @return
#' @export
#'
#' @examples
#' # Retrieve required system settings (in background) and appropriate s3 bucket name
#' klink_s3()
#'
#' # Use example aws.s3 functions to retrieve information from s3 bucket
#' # (making sure to reference the bucket as "s3BucketName")
#' aws.s3::get_bucket_df(s3BucketName, max = 20)[["Key"]]

klink_s3 <- function(){
  # Check for existing s3 connections
  if(Sys.getenv("AWS_SECRET_ACCESS_KEY") != ""){
    print("Already connected to an S3 bucket")
    } else {

      # Check whether in PROD or DEV
        current_server <- system2(command = "hostname", stdout  = TRUE)

        # PROD
        if(current_server %in% paste0("usaws",1170:1173)){

          bucket_name <- klink::zoltar("s3BucketName_kortex")

          if(grepl("^Error", bucket_name, ignore.case = TRUE)){
            return(bucket_name) # would be error message from zoltar
          } else {

            # Return bucket name to global environment as "S3BucketName_kortex"
            assign("s3BucketName",
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
          }
          } else {

            # DEV or UNKNOWN SERVER
            bucket_name <- klink::zoltar("s3BucketName_kortex_DEV")

            if(grepl("^Error", bucket_name, ignore.case = TRUE)){
              return(bucket_name) # would be error message from zoltar

              } else {

                # Return bucket name to global environment as "S3BucketName_kortex"
                assign("s3BucketName",
                       value = bucket_name,
                       envir = globalenv()
                       )

                # Use paws to assume iam and form s3 connection
                suppressWarnings(
                  s3_other <- paws::s3(
                    config = list(
                      credentials = list(
                        r <- assume_role("arn:aws:iam::953495608177:role/S3Access-From-Leg-Corp-Rstudio-to-kna-npd", "rstudio", use=TRUE)
                        ),
                      region = "us-east-1"
                      ) # / list
                    ) # / s3
                ) # / suppressWarnings
                }

        }

        # BOTH
        assign("s3_other",
               value = s3_other,
               envir = globalenv()
               )
        }
}
