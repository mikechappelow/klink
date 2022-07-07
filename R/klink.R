#' klink provides helpful functions to easily forming connections to internal data sources.
#'
#' The klink functions are a general group of functions used to establish links to data sources commonly used within Kellogg.
#'
#' @section klink functions:
#' * klink_sql (for SQL connections)
#' * klink_s3 (for Kortex bucket connection)
#' * klink_s3R (for POC bucket connection)
#'
#'  See vignette or function documentation (?klink_sql or ?klink_s3R) for more information and examples.
#'
#' @section zoltar functions:
#' TThe klink functions are wrappers that utilize zoltar in order to simplify the user experience. This is achieved by leveraging the zoltar API and making assumptions about the connection that should be formed based on the user inputs.
#'
#' When a wish/alias of a known value is passed to this function our internal zoltar API returns the requested value. The Connect API key required in the user setup allows us to secure this functionality while also centrally managing our shared service account credentials. In addition to reduced upkeep for users this also limits the exposure to the underlying secrets associated with these account.
#'
#' If you would like to avoid these assumptions while leveraging the underlying functionality you can do so by specifying your own connection settings and using the zoltar function directly in your connection call.
#'
#' You can also use the zoltar_list() function to return a list of permitted requests based on your credentials.
#'
#' #' See vignette or function documentation (?zoltar and ?zoltar_list) for more information and examples.
#'
#' @section Setup:
#' In order to use these functions users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge)
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @docType package
#'
#' @name klink
NULL
#> NULL
