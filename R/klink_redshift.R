#' Kellogg redshift connections
#' @description Enables users to create connections to Kellogg redshift databases
#'
#' In order to use these tools users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge).
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @param environment character string containing desired environment. Valid arguments are "PROD", "DEV", or "QA"
#' @param database character string containing name of desired database. As of now, there is only one known databse for each environment. As such, this argument is optional and currently unused.
#' @param server character string containing exact server name in R format (beware of /s). As of now, there is only one known server for each environment. As such, this argument is optional and currently unused.
#'
#' @usage klink_redshift(environment, database = NULL, server = NULL)
#'
#' @return Returns redshift DBI connection object
#' @export
#'
#' @examples
#' conn <- klink_redshift(environment = "DEV")
#' DBI::dbListTables(conn)

klink_redshift <- function(environment, database = NULL, server = NULL){

  # DEV
  if(environment %in% c("DEV","dev","Dev")){

    # server
    server_val <- klink::zoltar("REDSHIFT_DEV_server")
    uid <- klink::zoltar("REDSHIFT_DEV_uid")
    pwd <- klink::zoltar("REDSHIFT_DEV_pwd")
    database <- "klg_nga_kna"

    # PROD
    } else if(environment %in% c("PROD","prod","Prod")) {
      server_val <- klink::zoltar("REDSHIFT_PROD_server")
      uid <- klink::zoltar("REDSHIFT_PROD_uid")
      pwd <- klink::zoltar("REDSHIFT_PROD_pwd")
      database <- "klg_nga_kna"

    # QA
    } else if(environment %in% c("QA", "qa", "Qa")) {
      server_val <- klink::zoltar("REDSHIFT_QA_server")
      uid <- klink::zoltar("REDSHIFT_QA_uid")
      pwd <- klink::zoltar("REDSHIFT_QA_pwd")
      database <- "klg_nga_kna"

    # INVALID
    } else {
      "Error: Invalid environment name. Should be one of 'DEV', 'PROD', or 'QA'"
    }

  # connection or zoltar error message return
  #----------------------------------------------------------------------------
  if(grepl("^Error", uid, ignore.case = TRUE)){
    return(uid) # would be error message from zoltar
    } else if(grepl("^Error", pwd, ignore.case = TRUE)) {
      return(pwd)
      } else {
        DBI::dbConnect(odbc::odbc(),
                       Driver       = "redshift",
                       servername   = server_val,
                       database     = database,
                       UID          = uid,
                       PWD          = pwd,
                       Port         = 5439)
      }

  } # / function closure
