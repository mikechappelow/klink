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
  # Check User
  user <- httr::content(
    httr::GET("https://rstudioconnect.analytics.kellogg.com/__api__/v1/user",
              httr::add_headers(Authorization =
                                  paste0("Key ", Sys.getenv("CONNECT_API_KEY")))), # / httr::GET
    as = "parsed",
    type = "application/json",
    encoding = 'UTF-8'
    )

  # Compare Vs User Access Table - future state
  # user$username
  # user$user_role
  # user$locked

  # Retrieve from zoltar_list
  if(user$locked == FALSE){
    zoltar_con <- klink::klink_sql("PROD", "KG_R_APPS")
    out <- DBI::dbGetQuery(zoltar_con, "SELECT * FROM [KG_R_APPS].[dbo].[zoltar_list]")
    DBI::dbDisconnect(zoltar_con)

    return(out)
    } else {"Error: You don't have permission to access this item. Have you set up your CONNECT_API_KEY? (see documentation: ?klink_list)"}
}

