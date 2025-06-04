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
  
  posit_dev_list <- klink::zoltar("posit_dev_list")
  
  posit_prod_list <- klink::zoltar("posit_prod_list")
  
  identify_env <- function(env) {grepl(env, hostname, ignore.case = TRUE) | grepl(env, nodename, ignore.case = TRUE)}
  
  env_out <- if(identify_env(posit_prod_list)) {"prod"
    } else if(identify_env(posit_dev_list)) {"dev"
    } else {"unknown_environment"}
  
  return(env_out)
}