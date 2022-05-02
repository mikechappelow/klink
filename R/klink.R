#' klink is an internal R package intended to provide helpful functions focused on easily forming connections to data sources.
#'
#' The klink functions are a general group of functions used to establish links to data sources commonly used within Kellogg.
#'
#' @section klink functions:
#' * klink_sql (for SQL connections)
#'
#' * klink_s3R (for our foreign s3 bucket connections)
#'
#'  See vignette or function documentation (?klink_sql or ?klink_s3R) for more information and examples.
#'
#' @section zoltar function:
#' The klink functions are esssentially wrappers that utilize zoltar under the hood to make the user experience as lightweight as possible.
#'
#' When a wish/alias of a known value is passed to this function our internal zoltar API returns the requested value. The Connect API key required in the user setup allows us to secure this functionality while also centrally managing our shared service account credentials. In addition to reduced upkeep for users this also limits the exposure to the underlying secrets associated with these account.
#'
#' If there is a service account that isn't for SQL, s3, or similar you may want to try to use zoltar directly. If there are service accounts that are not yet supported by zoltar please reach out to the Kellogg Data Science team to have them added.
#'
#' See vignette or function documentation (?zoltar) for more information and examples.
#'
#' @section Setup:
#' In order to use these functions users must first:
#'
#' 1. Have an RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge)
#'
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#'
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @docType package
#'
#' @name klink
NULL
#> NULL
