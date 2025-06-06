#' Kellogg RDS PostgreSQL connections
#' @description Enables users to create connections to Kellogg PostgreSQL databases
#'
#' In order to use these tools users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge).
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @param environment character string containing desired environment. Currently only "DEV" is supported.
#' @param database character string containing name of desired database. Any database in the specified postgres environment should be valid so long as the service account being used has adequate permissions.
#' @param server OPTIONAL character string containing exact server name in R format (beware of /s). If server argument is provided the function will attempt to pass specified value into the connection call.
#' @param connection_pane OPTIONAL logical indicating whether information about your connection should be added to the Connections pane, default is TRUE.
#'
#' @usage klink_postgres(environment, database, server = NULL, connection_pane = TRUE)
#'
#' @return Returns PostgreSQL DBI connection object
#' @export
#'
#' @examples
#' # With connection pane
#' dev_con <- klink_postgres(environment = "DEV", database = "postgres")
#'
#' # Without connection pane
#' dev_con <- klink_postgres("DEV", "postgres", connection_pane = FALSE)

klink_postgres <- function(environment, database, server = NULL, connection_pane = TRUE){
  
  current_env <- klink::env_checker()
  
  # Kortex PROD
  if(current_env == "prod" & environment == "PROD"){
    zoltar_url <- 'https://prod.positconnect.analytics.kellogg.com/zoltar/wish'
    if(!is.null(server)){
      server_val <- server
    } else {
      server_val <- klink::zoltar("RDS_PROD_server")
    }
    port_val <- klink::zoltar("RDS_PROD_port")
    uid <- klink::zoltar("RDS_PROD_uid")
    pwd <- klink::zoltar("RDS_PROD_pwd")
    
    # Kortex DEV
  } else if(current_env == "dev" & environment == "DEV"){
    zoltar_url <- 'https://dev.positconnect.analytics.kellogg.com/zoltar/wish'
    if(!is.null(server)){
      server_val <- server
    } else {
      server_val <- klink::zoltar("RDS_DEV_server")
    }
    port_val <- klink::zoltar("RDS_DEV_port")
    uid <- klink::zoltar("RDS_DEV_uid")
    pwd <- klink::zoltar("RDS_DEV_pwd")
    
  } else {
    "Error: Please ensure that current working environment and desired environment match"
  }
  
  # connection or zoltar error message return
  #----------------------------------------------------------------------------
  if(grepl("^Error", uid, ignore.case = TRUE)){
    return(uid) # would be error message from zoltar
  } else if(grepl("^Error", pwd, ignore.case = TRUE)) {
    return(pwd)
  } else {
    
    # Create DB connection object
    conn <- DBI::dbConnect(
      odbc::odbc()
      ,Driver = "postgresql"
      ,Server = server_val
      ,Port = port_val
      ,Database = database
      ,UID = uid
      ,PWD = pwd
      ,BoolAsChar = ""
      ,timeout = 10
    )
    
    # Updates connections pane w db structure
    if(connection_pane == TRUE){
      odbc:::on_connection_opened(conn,
                                  paste("postgres",
                                        environment
                                        # ,database
                                        # ,server
                                        ,sep = "_")
      )
    }
    
    return(conn)
  }
  
} # / function closure
