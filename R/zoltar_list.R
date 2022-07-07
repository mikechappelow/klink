#' Zoltar variables list
#' @description Enables users to retrieve list of all valid zoltar API requests
#'
#' In order to use these tools users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge).
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @return Returns list of valid zoltar API requests
#' @export
#'
#' @examples
#' zoltar_list()


zoltar_list <- function(){
  # Clean API output and split into list
  strsplit(
    gsub(
      pattern = ('"|\\[|\\]'),
      replacement = '',

      # Use RStudio Connect API to retrieve zoltar environmental var info
      x = httr::content(
        httr::GET("https://rstudioconnect.analytics.kellogg.com/__api__/v1/content/898b7328-3d00-47d3-9716-0a065dd61083/environment",
                  httr::add_headers(Authorization =
                                      paste0("Key ", Sys.getenv("CONNECT_API_KEY")))), # / httr::GET
        as = "text",
        type = "application/json",
        encoding = 'UTF-8'
        ) # / httr::content

      ), # / gsub

    split = ",")[[1]] # / strsplit
}
