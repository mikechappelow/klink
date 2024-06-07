#' bumper
#' @description trigger rendering of markdown jobs/reports and their variants hosted in Connect
#'
#' The bumper function is intended to be called when you want to trigger an existing Connect job or report to run as a result of another process.
#'
#' In order to use these tools users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge, instructions can be found here: <https://rstudioconnect.analytics.kellogg.com/RStudio_Knowledge_Library/>
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @param GUID character string the GUID of the content to trigger. You can find this value in the URL of your content, it should looks something like this: "b824db78-07b8-4205-b29e-0dbea32b4d8a"
#' @param variant optional numeric value of parameterized content to render. These are the numbers following the last / in the url of the content variant in Connect. If no value is specified the default variant will be rendered (for non-parameterized content the default is the only variant so there would be no need to use this argument).
#'
#' @usage bumper(GUID, variant = NULL)
#'
#' @return returns message with details if error or confirmation of success
#' @export
#'
#' @examples
#' bumper(GUID = "6dd37913-30fd-4c89-9c1d-4afd9dbfc6fe", variant = 595)
#' bumper(GUID = "6dd37913-30fd-4c89-9c1d-4afd9dbfc6fe")

bumper <- function(GUID, variant = NULL){
  suppressWarnings(
    # tryCatch 1
    tryCatch({
      # Check current env
      current_env <- klink::env_checker()
      
      if(current_env == "kortex_prod"){
        client <- connectapi::connect(server = klink::zoltar("CONNECT_PROD_url"),
                                      api_key = Sys.getenv("CONNECT_API_KEY"))
      }
      if(current_env == "kortex_dev"){
        client <- connectapi::connect(server = klink::zoltar("CONNECT_DEV_url"),
                                      api_key = Sys.getenv("CONNECT_API_KEY"))
      }
      if(current_env == "keystone_prod"){
        client <- connectapi::connect(server = "https://rstudioconnect.analytics.kellogg.com",
                                      api_key = Sys.getenv("CONNECT_API_KEY"))
      }
      
      # tryCatch 2
      tryCatch({
        rmd_content <- connectapi::content_item(client, GUID)

        # tryCatch 3
        tryCatch({
          # Default
          if(is.null(variant)){
            # Retrieve Connect variant data
            rmd_content_variant <- connectapi::get_variant_default(rmd_content)
            # Trigger rendering of default
            my_rendering <- connectapi::variant_render(rmd_content_variant)
            # poll_task(my_rendering)
            # get_variant_renderings(rmd_content_variant)
            message("klink::bumper successfully triggered rendering of: '", my_rendering$content$name, "' @ ", Sys.time())
          } else {
            # Retrieve Connect variants list
            rmd_content_variants <- connectapi::get_variants(rmd_content)
            # Find correct Connect variant key
            rmd_content_variant_key <- rmd_content_variants[rmd_content_variants$id == variant, ]$key
            # Retrieve Connect variant data
            # rmd_content_variant <- connectapi::get_variant_default(rmd_content)
            rmd_content_variant <- connectapi::get_variant(rmd_content, rmd_content_variant_key)
            # Trigger rendering of variant
            my_rendering <- connectapi::variant_render(rmd_content_variant)
            # poll_task(my_rendering)
            # get_variant_renderings(rmd_content_variant)
            message("klink::bumper successfully triggered rendering of: '", my_rendering$content$name, "' variant: ", variant, " @ ", Sys.time())
          }
        },
        error = function(e) {
          conditionMessage(e)
        }
        ) # /tryCatch 3

      },
      error = function(e) {
        conditionMessage(e)
      }
      ) # /tryCatch 2

    },
    error = function(e) {
      conditionMessage(e)
    }
    ) # /tryCatch 1
  ) # /suppressWarnings
}
