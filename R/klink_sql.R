#' Kellogg SQL connections
#' @description Enables internal users with Connect API keys to create connections to Kellogg SQL databases with a simple function
#'
#' In order to use these tools users must first:
#'
#' 1. Have an RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge, instructions can be found here: <https://rstudioconnect.analytics.kellogg.com/RStudio_Knowledge_Library/>
#'
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#'
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' 4. Install DBI and odbc packages
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

  # Retrieve wishes using zoltar
  # DEV
  if(environment == "DEV"){
    # retrieve server
    server <- klink::zoltar("MS_SQL_ANALYTICS_DEV_server")
    # retrieve credentials
    if (database == "KG_R_APPS") {
      uid <- klink::zoltar("KG_R_APPS_DEV_userid")
      pwd <- klink::zoltar("KG_R_APPS_DEV_pwd")
    } else if (database %in% c("KG_SAS")) {
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
      if (database == "KG_R_APPS") {
        uid <- klink::zoltar("KG_R_APPS_PROD_userid")
        pwd <- klink::zoltar("KG_R_APPS_PROD_pwd")
      } else if (database %in% c("KG_SAS")) {
        uid <- klink::zoltar("KG_SAS_PROD_userid")
        pwd <- klink::zoltar("KG_SAS_PROD_pwd")
      } else {
        # !!! using KG_ANALYTICS_APPS as catch-all/default for now
        uid <- klink::zoltar("KG_ANALYTICS_APPS_DEV_userid")
        pwd <- klink::zoltar("KG_ANALYTICS_APPS_DEV_pwd")
      }
    } else {
      "invalid combination of environment, and database"
    } # / wishes closure

  # Create DB connection object
  DBI::dbConnect(
    odbc::odbc()
    ,Driver = "freetds" #"SQLServer"
    ,Server = server
    ,Database = database
    ,UID = uid
    ,PWD = pwd
  )

  } # / function closure
