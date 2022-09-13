#' zuul
#' @description Logs zoltar usage
#'
#' In order to use these tools users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge, instructions can be found here: <https://rstudioconnect.analytics.kellogg.com/RStudio_Knowledge_Library/>
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @param
#'
#' @usage zull()
#'
#' @return Data frame containing usage details
#' @export
#'
#' @examples
#' zuul()

zuul <- function(){
  # Gather info
  env_user <- tryCatch(
    expr = {Sys.getenv("USER")},
    error = function(e){"UNDEFINED"},
    warning = function(w){"UNDEFINED"}
  )

  session_user <- tryCatch(
    expr = {if(klink::r_object_exists(session)){
      if(!is.null(session$user)){
        paste0("session$user = ", session$user)
        } else {"UNDEFINED"}
    } else {"UNDEFINED"}
    },
    error = function(e){"UNDEFINED"},
    warning = function(w){"UNDEFINED"}
  )

  api_user <- tryCatch(
    expr = {httr::content(
      httr::GET("https://rstudioconnect.analytics.kellogg.com/__api__/v1/user",
                httr::add_headers(Authorization =
                                    paste0("Key ", Sys.getenv("CONNECT_API_KEY")))), # / httr::GET
      as = "parsed",
      type = "application/json",
      encoding = 'UTF-8'
    )[[2]]},
    error = function(e){"UNDEFINED"},
    warning = function(w){"UNDEFINED"}
    )

  # Out
  return(data.frame(env_user = env_user, session_user = session_user, api_user = api_user))
}
