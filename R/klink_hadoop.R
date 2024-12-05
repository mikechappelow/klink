#' Kellogg Hadoop connections
#' @description Enables users to create connections to Kellogg Hadoop databases with a simple function
#' Note: Currently, you can only connect to Hadoop DEV from the UAT Workbench/Connect servers and PROD from the PROD Workbench/Connect servers.
#'
#' In order to use these tools users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge).
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @param environment character string containing desired environment. Valid arguments are "PROD" or "DEV".
#' @param schema character string containing name of desired database. Any database in the specified Hadoop environment should be valid.
#' @param connection_pane logical indicating whether information about your connection should be added to the Connections pane, default is TRUE.
#'
#' @usage klink_hadoop(environment, schema, connection_pane = TRUE)
#'
#' @return Returns Hadoop DBI connection object
#' @export
#'
#' @examples
#' # Typical connection w/ connection pane
#' prod_example <- klink_hadoop(environment = "PROD", schema = "KNA_BW")
#'
#' # Typical connection w/o connection pane
#' dev_example <- klink_hadoop("DEV", "KNA_BW", connection_pane = FALSE)

klink_hadoop <- function(environment, schema, connection_pane = TRUE){
  
  current_env <- klink::env_checker()
  #----------------------------------------------------------------------------
  # DEV
  #----------------------------------------------------------------------------
  if(current_env %in% c("kortex_dev", "keystone_dev")){
     #environment == "DEV"){
    system(paste0("kinit ",
                  klink::zoltar("DEV_HADOOP_userid"), " <<< ",
                  klink::zoltar("DEV_HADOOP_pwd")))
    host <- klink::zoltar("DEV_HADOOP_server")
    port <- klink::zoltar("DEV_HADOOP_port")

    #--------------------------------------------------------------------------
    # PROD
    #--------------------------------------------------------------------------
  } else if(current_env %in% c("kortex_prod", "keystone_prod")){
    # environment == "PROD") {
    system(paste0("kinit ",
                  klink::zoltar("PROD_HADOOP_userid"), " <<< ",
                  klink::zoltar("PROD_HADOOP_pwd")))
    host <- klink::zoltar("PROD_HADOOP_server")
    port <- klink::zoltar("PROD_HADOOP_port")
  }

  #----------------------------------------------------------------------------
  # Connection or Error Message
  #----------------------------------------------------------------------------
  if(grepl("^Error", host, ignore.case = TRUE)){
    return(host) # would be error message from zoltar
  } else if(grepl("^Error", port, ignore.case = TRUE)) {
    return(port)
  } else {
    # Create DB connection object
    conn <- DBI::dbConnect(odbc::odbc(),
                           Driver = "Hive",
                           Host = host,
                           Port = port,
                           Schema= schema,
                           AuthMech=1, # kerberos
                           ThriftTransport=1, #2,
                           HiveServerType=2,
                           AllowSelfSignedServerCert=1,
                           SSL=1,
                           TrustedCerts= #ifelse(# environment == "PROD",
                            if(current_env == "kortex_prod"){"/usr/rstudio_prod/serverpro/certs/hive_prod.pem"
                              } else if(current_env == "keystone_prod"){'/usr/rstudio/serverpro/certs/hive_prod.pem'
                                } else {'/usr/rstudio_dev/serverpro/certs/hive.pem'},
                           HttpPathPrefix='/cliservice')

    # Updates connections pane w db structure
    if(connection_pane == TRUE){
      odbc:::on_connection_opened(conn,
                                  paste("hadoop_",
                                        environment,
                                        schema, sep = "_"))
    }
    cat("Password Accepted")
    return(conn)
  }
} # / function closure

