#' zoltar
#' @description Allows internal users with Connect API keys to reference zoltar API and retrieve secrets
#'
#' In order to use these tools users must first:
#' 
#' 1. Have an RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge, instructions can be found here: <https://rstudioconnect.analytics.kellogg.com/RStudio_Knowledge_Library/>
#' 
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @param x A string containing the name of secret to be retrieved (must be wrapped in quotation marks)
#'
#' @return If name is found, a string containing the secret value else a string stating that zoltar is unable to grant your wish
#' @export
#'
#' @examples
#' zoltar("s3BucketName")
#' zoltar("MS_SQL_ANALYTICS_DEV_server")

zoltar <- function(x){
  httr::content(httr::GET(url = "https://rstudioconnect.analytics.kellogg.com/zoltar/wish",
                          query = list(wish=x),
                          httr::add_headers(Authorization =
                                              paste0("Key ", Sys.getenv("CONNECT_API_KEY")))),
                as = "parsed")[[1]]
}
