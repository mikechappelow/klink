#' Kellogg Snowflake connections
#' @description Enables users to create read-only connections to Kellogg Snowflake databases
#'
#' In order to use these tools users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge).
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @param environment character string containing desired environment. Currently only "DEV" and "PROD" are supported.
#' @param database character string containing exact name of desired database. Any database in the specified snowflake environment should be valid so long as the service account being used has adequate permissions.
#' @param warehouse character string containing exact name of desired warehouse.
#' @param schema character string containing exact name of desired schema.
#' @param connection_pane OPTIONAL logical indicating whether information about your connection should be added to the Connections pane, default is TRUE.
#'
#' @usage klink_snowflake(environment, database, warehouse, schema, connection_pane = TRUE)
#'
#' @return Returns Snowflake DBI connection object
#' @export
#'
#' @examples
#' # With connection pane
#' dev_con <- klink_snowflake(environment = "DEV", database = "DEV_KEU", warehouse = "KEU_IT_SMALL", schema = "PRCURMT")
#'
#' # Without connection pane
#' prod_con <- klink_snowflake("PROD", "KEU", "KEU_IT_SMALL", "PRCURMT", connection_pane = FALSE)

klink_snowflake <- function(environment, database, warehouse, schema, connection_pane = TRUE){
  current_env <- klink::env_checker()
  
  # Kortex PROD (request matches environment)
  if(current_env == "kortex_prod" & environment == "PROD"){
    zoltar_url <- 'https://prod.positconnect.analytics.kellogg.com/zoltar/wish'
    dsn <- "Snowflake"
    uid <- klink::zoltar("SNOWFLAKE_PROD_UID")
  
  # Kortex DEV (request matches environment)
  } else if(current_env == "kortex_dev" & environment == "DEV"){
    zoltar_url <- 'https://dev.positconnect.analytics.kellogg.com/zoltar/wish'
    dsn <- "snowflake"
    uid <- klink::zoltar("SNOWFLAKE_DEV_UID")
  
  # Mismatch  
  } else {
    "Error: Please ensure that current working environment and desired environment match"
  }
  
  # connection or zoltar error message return
  if(grepl("^Error", uid, ignore.case = TRUE)){
    return(uid) # would be error message from zoltar
    
  # else attempt connection
  } else {
    # Create DB connection object
    conn <- DBI::dbConnect(odbc::odbc(),
                           DSN          = dsn,
                           UID          = uid,
                           Database     = database,
                           Warehouse    = warehouse,
                           Schema       = schema
                           )
    
    # Updates connections pane w db structure
    if(connection_pane == TRUE){
      odbc:::on_connection_opened(conn,
                                  paste("snowflake",
                                        environment
                                        # ,database
                                        # ,server
                                        ,sep = "_")
                                  )
      }
    
    return(conn)
  }
}
