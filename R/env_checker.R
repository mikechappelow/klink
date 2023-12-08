#' env_checker
#' @description Function to check user's current environment
#'
#' @usage env_checker()
#'
#' @return If current env matches known/defined environments, a string containing the name of that environment is returned
#' @export
#'
#' @examples
#' env_checker()

env_checker <- function(){
  nodename <- Sys.info()['nodename']
  hostname <- system2(command = "hostname", stdout  = TRUE)
  
  kortex_dev <- "usaws3320|usaws3321|usaws3322|usaws3323"
  kortex_prod <- "usaws1320|usaws1321|usaws1322|usaws1323"
  # keystone_dev <- "usaws3170|usaws3171|usaws3172|usaws3173"
  keystone_prod <- "usaws1170|usaws1171|usaws1172|usaws1173|usaws1174|usaws1175"
  
  identify_env <- function(env) {grepl(env, hostname, ignore.case = TRUE) | grepl(env, nodename, ignore.case = TRUE)}
  
  env_out <- if(identify_env(kortex_prod)) {"kortex_prod"
    } else if(identify_env(kortex_dev)) {"kortex_dev"
    } else if(identify_env(keystone_prod)) {"keystone_prod"
    } else {"unknown_environment"}
  
  return(env_out)
}