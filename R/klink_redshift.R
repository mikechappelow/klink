#' Kellogg redshift connections
#' @description Enables users to create connections to Kellogg redshift databases
#'
#' In order to use these tools users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge).
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @param environment Required character string containing desired environment. Valid arguments are "PROD", "DEV", or "QA"
#' @param region Required character string containing name of desired region. Currently supported arguments are "KNA" (default), "KEU", or "AMEA"
#' @param server Optional character string containing exact server name in R format (beware of /s). As of now, there is only one known server for each environment. As such, this argument is optional and currently unused.
#' @param database Optional character string containing exact database name in R format.
#' @param connection_pane Optional logical indicating whether information about your connection should be added to the Connections pane, default is TRUE (turning this off results in faster initial connections and reduction of unnecessary data in automated processes).
#'
#' @usage klink_redshift(environment, region = "KNA", server = NULL, database = NULL, connection_pane = TRUE)
#'
#' @return Returns redshift DBI connection object
#' @export
#'
#' @examples
#' # Connect w/ connection pane
#' red_dev <- klink_redshift(environment = "DEV", region = "KNA")
#'
#' # Connect w/o connection pane
#' red_dev <- klink_redshift(environment = "DEV", region = "AMEA", connection_pane = FALSE)
#'
#' # Example queries
#' DBI::dbGetQuery(red_dev, "SELECT DISTINCT tablename FROM PG_TABLE_DEF")
#' DBI::dbGetQuery(red_dev, "SELECT TOP 10 * FROM fin_acctg_ops.fisc_cal_wk")


klink_redshift <- function(environment, region = "KNA", database = NULL, server = NULL, connection_pane = TRUE){
  # !!! Need to add some error handling for environment/region arguments

  # connection strings
  env_reg <- paste0("REDSHIFT_",toupper(region),"_",toupper(environment))
  server_val <- klink::zoltar(paste0(env_reg,"_server"))
  port <- klink::zoltar(paste0(env_reg,"_port"))
  uid <- klink::zoltar(paste0(env_reg,"_uid"))
  pwd <- klink::zoltar(paste0(env_reg,"_pwd"))
  if(is.null(database)){database <- paste0("klg_nga_",tolower(region))}

  # connection or zoltar error message return
  if(grepl("^Error", uid, ignore.case = TRUE)){
    return(uid) # would be error message from zoltar
  } else if(grepl("^Error", pwd, ignore.case = TRUE)) {
    return(pwd)
  } else {
    conn <- DBI::dbConnect(odbc::odbc(),
                           Driver       = "redshift",
                           servername   = server_val,
                           database     = database,
                           UID          = uid,
                           PWD          = pwd,
                           Port         = 5439)

    # update connection pane w metadata if TRUE
    if(connection_pane == TRUE){
      odbc:::on_connection_opened(conn,
                                  paste("redshift", environment, database, server, sep = "_"))
    }

    return(conn)
  }
}
