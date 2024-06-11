#' Kellogg SQL connections
#' @description Enables users to create connections to Kellogg SQL databases with a simple function
#'
#' In order to use these tools users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge).
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @param environment character string containing desired environment. Valid arguments are "PROD" or "DEV".
#' @param database optional character string containing name of desired database. Any database in the specified SQL environment should be valid.
#' @param server character string containing exact server name in R format (beware of /s). If no argument provided will attempt to use Keystone servers. If server argument is provided the function will attempt to pass specified value into the connection call.
#' @param connection_pane logical indicating whether information about your connection should be added to the Connections pane, default is TRUE.
#'
#' @usage klink_sql(environment, database, server = NULL, connection_pane = TRUE)
#'
#' @return Returns SQL DBI connection object
#' @export
#'
#' @examples
#' # Typical connection w/ connection pane
#' keystone_example <- klink_sql(environment = "DEV", database = "KG_ANALYTICS_APPS")
#' # Typical connection w/o connection pane
#' keystone_example <- klink_sql("DEV", "KG_ANALYTICS_APPS", connection_pane = FALSE)
#' # Connection to non-standard SQL server
#' # (these are supported on a case-by-case basis, contact data science team for support)
#' other__ex <- klink_sql("DEV", "KG_ANALYTICS_APPS", server = "USAWSCWSQL5066\\ANALYTICSDEV3")

klink_sql <- function(environment, database = NULL, server = NULL, connection_pane = TRUE){

  # retrieve wishes using zoltar
  # Non-standard keystone SERVERS
  #----------------------------------------------------------------------------
  if(!is.null(server)){
    server_val <- server

    # USAWSCWSQL5066
    #-------------------------
    if(environment == "DEV"){
      # SQL5066
      if (grepl("USAWSCWSQL5066", toupper(server))){
        uid <- klink::zoltar("USAWSCWSQL5066_DEV_userid")
        pwd <- klink::zoltar("USAWSCWSQL5066_DEV_pwd")
        }       
      # USAWSCWSQL5004
      #-------------------------
      else if (grepl("USAWSCWSQL5004", toupper(server))){
        uid <- klink::zoltar("USAWSCWSQL5004_uid")
        pwd <- klink::zoltar("USAWSCWSQL5004_pwd")
        }
      else {"Unknown request, please contact Data Science team for support"}
    } # / USAWSCWSQL5004
    
      # USAWSCWSQL0066
      #-------------------------
    } else if(environment == "PROD"){
      # SQL0066
      if (grepl("USAWSCWSQL0066", toupper(server))){
        if(grepl("KG_ANALYTICS_APPS", toupper(database))){
          uid <- klink::zoltar("Usawscwsql0066_KG_ANALYTICS_APPS_PROD_uid")
          pwd <- klink::zoltar("Usawscwsql0066_KG_ANALYTICS_APPS_PROD_pwd")
        } else {
          uid <- klink::zoltar("Usawscwsql0066_KG_SAS_PROD_userid") # this seems to no longer be valid
          pwd <- klink::zoltar("Usawscwsql0066_KG_SAS_PROD_pwd")
          # uid <- klink::zoltar("USAWSCWSQL5066_PROD_userid") # this is the same as KG_ANALYTICS_APPS above
          # pwd <- klink::zoltar("USAWSCWSQL5066_PROD_pwd")
        }
      }
    
  } # / manual server designations

  # DEV
  #----------------------------------------------------------------------------
  else if(environment == "DEV"){

    # server
    server_val <- klink::zoltar("MS_SQL_ANALYTICS_DEV_server")

    # retrieve credentials for keystone DBs
    if (database %in% c("KG_R_APPS", "KNA_FIN")) {
      uid <- klink::zoltar("KG_R_APPS_DEV_userid")
      pwd <- klink::zoltar("KG_R_APPS_DEV_pwd")
    } else if (database %in% c("KG_SAS", "KG_SC", "KG_EXTERNAL",
                               "KNA_ECC", "KG_SANDBOX", "KG_MEMSQL",
                               "KG_VIEWS")) {
      uid <- klink::zoltar("KG_SAS_DEV_userid")
      pwd <- klink::zoltar("KG_SAS_DEV_pwd")
    } else if (database %in% c("KG_SAS_WRITE")) {
      database <- "KG_SAS" # replacing with true db name
      uid <- klink::zoltar("KG_SAS_DEV_WRITE_uid")
      pwd <- klink::zoltar("KG_SAS_DEV_WRITE_pwd")
    } else if (database %in% c("KG_ANALYTICS_APPS", "WKKC_KG_ANALYTICS_APPS")) {
      uid <- klink::zoltar("KG_ANALYTICS_APPS_DEV_userid")
      pwd <- klink::zoltar("KG_ANALYTICS_APPS_DEV_pwd")
    } else {
      # using KG_SAS as catch-all/default for now
      uid <- klink::zoltar("KG_SAS_DEV_uid")
      pwd <- klink::zoltar("KG_SAS_DEV_pwd")
    }

    # PROD
    #----------------------------------------------------------------------------
  } else if(environment == "PROD") {

    # server
    server_val <- klink::zoltar("MS_SQL_ANALYTICS_PROD_server")

    # retrieve credentials for keystone DBs
    if (database %in% c("KG_R_APPS", "KNA_FIN")) {
      uid <- klink::zoltar("KG_R_APPS_PROD_userid")
      pwd <- klink::zoltar("KG_R_APPS_PROD_pwd")
    } else if (database %in% c("KG_SAS", "KG_SC", "KG_EXTERNAL",
                               "KNA_ECC", "KG_SANDBOX", "KG_MEMSQL",
                               "KG_VIEWS")) {
      uid <- klink::zoltar("KG_SAS_PROD_userid")
      pwd <- klink::zoltar("KG_SAS_PROD_pwd")
    } else if (database %in% c("KG_SAS_WRITE")) {
      database <- "KG_SAS" # replacing with true db name
      uid <- klink::zoltar("KG_SAS_PROD_WRITE_uid")
      pwd <- klink::zoltar("KG_SAS_PROD_WRITE_pwd")
    } else if (database %in% c("KG_ANALYTICS_APPS", "WKKC_KG_ANALYTICS_APPS")) {
      uid <- klink::zoltar("KG_ANALYTICS_APPS_PROD_userid")
      pwd <- klink::zoltar("KG_ANALYTICS_APPS_PROD_pwd")
    } else {
      # using KG_SAS as catch-all/default for now
      uid <- klink::zoltar("KG_SAS_PROD_userid")
      pwd <- klink::zoltar("KG_SAS_PROD_pwd")
    }
  } else {
    "Error: Invalid environment name. Should be 'DEV' or 'PROD'."
  }

  # Connection or Error Message
  #----------------------------------------------------------------------------
  if(grepl("^Error", uid, ignore.case = TRUE)){
    return(uid) # would be error message from zoltar
  } else if(grepl("^Error", pwd, ignore.case = TRUE)) {
    return(pwd)
  } else {
    # Create DB connection object
    conn <- DBI::dbConnect(
      odbc::odbc()
      ,Driver = "freetds" #"SQLServer"
      ,Server = I(server_val)
      ,Database = I(database)
      ,UID = I(uid)
      ,PWD = I(pwd)
    )

    # Updates connections pane w db structure
    if(connection_pane == TRUE){
      odbc:::on_connection_opened(conn,
                                  paste("ms_sql", environment, database, server, sep = "_"))
    }

    return(conn)
  }

} # / function closure
