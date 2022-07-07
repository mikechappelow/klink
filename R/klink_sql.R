#' Kellogg SQL connections
#' @description Enables users to create connections to Kellogg SQL databases with a simple function
#'
#' In order to use these tools users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge).
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @param environment Valid arguments are "PROD" or "DEV"
#' @param database Any database in the specified SQL environment should be valid. In current version values of  KG_R_APPS will attempt to use KG_R_APPS svc account credentials, KG_SAS will use KG_SAS credentials, and all other databases will attempt to use KG_ANALYTICS_APPS. If you have suggestions for refining or correcting these functions please contact package authors.
#'
#' @return Returns SQL odbc connection object
#' @export
#'
#' @examples
#' conn <- klink_sql("DEV", "KG_ANALYTICS_APPS")

klink_sql <- function(environment, database){

  # retrieve wishes using zoltar
  #----------------------------------------------------------------------------
  # DEV
  if(environment == "DEV"){
    # retrieve server
    server <- klink::zoltar("MS_SQL_ANALYTICS_DEV_server")
    # retrieve credentials
    if (database %in% c("KG_R_APPS", "KNA_FIN")) {
      uid <- klink::zoltar("KG_R_APPS_DEV_userid")
      pwd <- klink::zoltar("KG_R_APPS_DEV_pwd")
    } else if (database %in% c("KG_SAS", "KG_SC", "KG_EXTERNAL")) {
      uid <- klink::zoltar("KG_SAS_DEV_userid")
      pwd <- klink::zoltar("KG_SAS_DEV_pwd")
    } else {
      # !!! using KG_ANALYTICS_APPS as catch-all/default for now
      uid <- klink::zoltar("KG_ANALYTICS_APPS_DEV_userid")
      pwd <- klink::zoltar("KG_ANALYTICS_APPS_DEV_pwd")
    }

    # PROD
    } else if(environment == "PROD") {
      # retrieve server
      server <- klink::zoltar("MS_SQL_ANALYTICS_PROD_server")
      # retrieve credentials
      if (database %in% c("KG_R_APPS", "KNA_FIN")) {
        uid <- klink::zoltar("KG_R_APPS_PROD_userid")
        pwd <- klink::zoltar("KG_R_APPS_PROD_pwd")
      } else if (database %in% c("KG_SAS", "KG_SC", "KG_EXTERNAL")) {
        uid <- klink::zoltar("KG_SAS_PROD_userid")
        pwd <- klink::zoltar("KG_SAS_PROD_pwd")
      } else {
        # !!! using KG_ANALYTICS_APPS as catch-all/default for now
        uid <- klink::zoltar("KG_ANALYTICS_APPS_DEV_userid")
        pwd <- klink::zoltar("KG_ANALYTICS_APPS_DEV_pwd")
      }
    } else {
      "Error: Invalid environment name. Should be 'DEV' or 'PROD'."
    }

  # connection or zoltar error message handling
  #----------------------------------------------------------------------------
  if(grepl("^Error", uid, ignore.case = TRUE)){
    return(uid) # would be error message from zoltar
    } else if(grepl("^Error", pwd, ignore.case = TRUE)) {
      return(pwd)
      } else {
        # Create DB connection object
        DBI::dbConnect(
          odbc::odbc()
          ,Driver = "freetds" #"SQLServer"
          ,Server = server
          ,Database = database
          ,UID = uid
          ,PWD = pwd
          )
      }

  } # / function closure
