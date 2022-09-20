#' bumper
#' @description trigger markdown jobs hosted in Connect to render
#'
#' The bumper function is intended to be called when you want to trigger an existing Connect job to run at the end of another process.
#'
#' In order to use these tools users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge, instructions can be found here: <https://rstudioconnect.analytics.kellogg.com/RStudio_Knowledge_Library/>
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @param GUID character string the GUID of the content to trigger. You can find this value in the URL of your content, it should looks something like this: "b824db78-07b8-4205-b29e-0dbea32b4d8a"
#' @param environment character string designating target environment. Default is "PROD".
#'
#' @usage bumper(GUID, environment = "PROD")
#'
#' @return returns message with details if error or confirmation of success
#' @export
#'
#' @examples
#' bumper("b824db78-07b8-4205-b29e-0dbea32b4d8a")

bumper <- function(GUID, environment = "PROD"){
  # tryCatch 1
  tryCatch({
    if(environment == "PROD"){client <- connectapi::connect(host = klink::zoltar("CONNECT_PROD_url"),
                                  api_key = Sys.getenv("CONNECT_API_KEY"))
    }
    # tryCatch 2
    tryCatch({
      rmd_content <- connectapi::content_item(client, GUID)

      # tryCatch 3
      tryCatch({
        rmd_content_variant <- connectapi::get_variant_default(rmd_content)
        my_rendering <- connectapi::variant_render(rmd_content_variant)
        # poll_task(my_rendering)
        # get_variant_renderings(rmd_content_variant)
        message("bumper triggered successfully")
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
}
