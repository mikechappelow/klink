#' zoltar
#' @description Allows internal users with Connect API keys to reference zoltar API and retrieve secrets
#'
#' In order to use these tools users must first:
#'
#' 1. Have a RStudio Connect account (you likely have one already if you're using RStudio Workbench, if not you can request access through Digital Concierge, instructions can be found here: <https://rstudioconnect.analytics.kellogg.com/RStudio_Knowledge_Library/>
#' 2. Create a local RStudio Connect API key <https://docs.rstudio.com/connect/user/api-keys>
#' 3. Create an .Renviron file in your Home folder assigning your API key value to the name CONNECT_API_KEY <https://rstats.wtf/r-startup.html>
#'
#' @param token character string containing the exact name of secret to be retrieved (if passing value directly must be wrapped in quotation marks to be interpreted as character string)
#' @param solution_name character string identifying the name of the solution where this logic is being used, for recording to logs
#'
#' @usage zoltar(token, solution_name = NULL)
#'
#' @return If name is found, a string containing the secret value else a string stating that zoltar is unable to grant your wish
#' @export
#'
#' @examples
#' zoltar("s3BucketName")
#' zoltar("MS_SQL_ANALYTICS_DEV_server")

zoltar <- function(token#, solution_name = NULL
                   ){
  
  # solution <- NA # temp, need to add optional argument in zoltar
  # # Capture request
  # log_entry <- cbind(
  #   data.frame(req_time = Sys.time(),
  #              request = token,
  #              solution_nm = ifelse(!is.null(solution_name), solution_name, NA)),
  #   klink::zuul()
  #   )
  #
  # # Write log !!! should be absolute path in mounted drive, defined in/retrieved from zoltar
  
  # Define core function
  get_fun <- function(URL){
    httr::content(httr::GET(url = URL,
                          query = list(wish=token),
                          httr::add_headers(Authorization =
                                              paste0("Key ", Sys.getenv("CONNECT_API_KEY")))),
                as = "parsed")[[1]]
    }
  
  # Get url
  nodename <- Sys.info()['nodename']
  hostname <- system2(command = "hostname", stdout  = TRUE)
  
  kortex_dev <- "usaws3320|usaws3321|usaws3322|usaws3323"
  kortex_prod <- "usaws1320|usaws1321|usaws1322|usaws1323"
  # keystone_dev <- "usaws3170|usaws3171|usaws3172|usaws3173"
  keystone_prod <- "usaws1170|usaws1171|usaws1172|usaws1173|usaws1174|usaws1175"
  
  checker_fun <- function(env){grepl(env, hostname, ignore.case = TRUE) | grepl(env, nodename, ignore.case = TRUE)}
  
  zoltar_url <- if(checker_fun(kortex_prod)){'URL_TBD'
    } else if(checker_fun(kortex_dev)) {'https://dev.positconnect.analytics.kellogg.com/zoltar/wish'
    } else if(checker_fun(keystone_prod)) {'https://rstudioconnect.analytics.kellogg.com/zoltar/wish'
    } else {"undefined"}
  
  # Return result
  zoltar_speaks <- get_fun(zoltar_url)

  # Error handling
  if(!is.integer(zoltar_speaks)){
    return(zoltar_speaks)
  } else if(zoltar_url == "undefined") {
    return("Error: Unknown working environment")
  } else {
    if(zoltar_speaks == 1) {return("Error: An internal failure occurred.")
    } else if(zoltar_speaks == 2) {return("Error: The requested method or endpoint is not supported.")
    } else if(zoltar_speaks == 3) {return("Error: The requested object ID is invalid.")
    } else if(zoltar_speaks == 4) {return("Error: The requested object does not exist.")
    } else if(zoltar_speaks == 5) {return("Error: Application name must be between 3 and 64 alphanumeric characters, dashes, and underscores.")
    } else if(zoltar_speaks == 6) {return("Error: The password is not strong enough. Please try again.")
    } else if(zoltar_speaks == 7) {return("Error: The requested username is not permitted.")
    } else if(zoltar_speaks == 8) {return("Error: The requested username is already in use. Usernames are case sensitive. Please ensure you are using the correct case.")
    } else if(zoltar_speaks == 9) {return("Error: The requested user could not be found.")
    } else if(zoltar_speaks == 10) {return("Error: The requested object doesn't belong to you.")
    } else if(zoltar_speaks == 11) {return("Error: The requested filter could not be applied.")
    } else if(zoltar_speaks == 12) {return("Error: A required parameter is missing.")
    } else if(zoltar_speaks == 13) {return("Error: The requested range is invalid.")
    } else if(zoltar_speaks == 14) {return("Error: Group name must be between 3 and 64 alphanumeric characters.")
    } else if(zoltar_speaks == 15) {return("Error: The requested group name is already in use.")
    } else if(zoltar_speaks == 16) {return("Error: The user is already a member of the group.")
    } else if(zoltar_speaks == 17) {return("Error: The requested item could not be removed because it does not exist.")
    } else if(zoltar_speaks == 18) {return("Error: The requested item could not be changed because it does not exist.")
    } else if(zoltar_speaks == 19) {return("Error: You don't have permission to access this item.")
    } else if(zoltar_speaks == 20) {return("Error: You don't have permission to remove this item.")
    } else if(zoltar_speaks == 21) {return("Error: You don't have permission to change this item.")
    } else if(zoltar_speaks == 22) {return("Error: You don't have permission to perform this operation.")
    } else if(zoltar_speaks == 23) {return("Error: You don't have permission to give the user this role.")
    } else if(zoltar_speaks == 24) {return("Error: The requested operation requires authentication.")
    } else if(zoltar_speaks == 25) {return("Error: The parameter is invalid.")
    } else if(zoltar_speaks == 26) {return("Error: An object with that name already exists.")
    } else if(zoltar_speaks == 27) {return("Error: This version of R is in use and cannot be deleted.")
    } else if(zoltar_speaks == 28) {return("Error: No application bundle to deploy.")
    } else if(zoltar_speaks == 29) {return("Error: The token is expired. Authentication tokens must be claimed within one hour.")
    } else if(zoltar_speaks == 30) {return("Error: We couldn't log you in with the provided credentials. Have you set up your CONNECT_API_KEY value in your .Renviron file and reset your session?")
    } else if(zoltar_speaks == 31) {return("Error: Password change prohibited.")
    } else if(zoltar_speaks == 32) {return("Error: The requested filter is not valid.")
    } else if(zoltar_speaks == 33) {return("Error: This user cannot be added as a collaborator because they don't have permission to publish content.")
    } else if(zoltar_speaks == 34) {return("Error: The application's owner cannot be added as a collaborator or viewer.")
    } else if(zoltar_speaks == 35) {return("Error: Cannot delete object as it is being used elsewhere.")
    } else if(zoltar_speaks == 36) {return("Error: This user's username has already been set and cannot be changed.")
    } else if(zoltar_speaks == 37) {return("Error: Schedules must have a start time and it must be after 1/1/2010.")
    } else if(zoltar_speaks == 38) {return("Error: The application's manifest is invalid or missing.")
    } else if(zoltar_speaks == 39) {return("Error: The application does not support this action.")
    } else if(zoltar_speaks == 40) {return("Error: The current user has not been confirmed.")
    } else if(zoltar_speaks == 41) {return("Error: The initial user must specify a password; it cannot be generated.")
    } else if(zoltar_speaks == 42) {return("Error: The user has already been confirmed.")
    } else if(zoltar_speaks == 43) {return("Error: This system has not been configured to send email. Please contact your administrator.")
    } else if(zoltar_speaks == 44) {return("Error: The current user does not have an email address.")
    } else if(zoltar_speaks == 45) {return("Error: Invalid MinProcesses setting. The MinProcesses setting may not exceed the Scheduler.MinProcessesLimit setting.")
    } else if(zoltar_speaks == 46) {return("Error: Internal user fields cannot be changed via API.")
    } else if(zoltar_speaks == 47) {return("Error: Creation of new users is disabled.")
    } else if(zoltar_speaks == 48) {return("Error: You cannot change the type of application once deployed. Try deploying this as a new application instead of updating an existing one.")
    } else if(zoltar_speaks == 49) {return("Error: You don't have permission to lock/unlock this user.")
    } else if(zoltar_speaks == 50) {return("Error: This user is locked.")
    } else if(zoltar_speaks == 51) {return("Error: Vanity path conflicts with one or more already in use.")
    } else if(zoltar_speaks == 52) {return("Error: Vanity path is not permitted.")
    } else if(zoltar_speaks == 53) {return("Error: Immutable field cannot be changed.")
    } else if(zoltar_speaks == 54) {return("Error: You cannot set this content to run as the current user")
    } else if(zoltar_speaks == 55) {return("Error: Custom RunAs settings are prohibited for static content.")
    } else if(zoltar_speaks == 56) {return("Error: The RunAs setting references a prohibited Unix account.")
    } else if(zoltar_speaks == 57) {return("Error: The RunAs setting does not reference a valid Unix account.")
    } else if(zoltar_speaks == 58) {return("Error: The RunAs setting references a Unix account that does not have the correct group membership.")
    } else if(zoltar_speaks == 59) {return("Error: There is no rendering available.")
    } else if(zoltar_speaks == 60) {return("Error: This email address is not allowed to login to this server.")
    } else if(zoltar_speaks == 61) {return("Error: You cannot change the role of the only remaining administrator.")
    } else if(zoltar_speaks == 62) {return("Error: An API key name must not be blank.")
    } else if(zoltar_speaks == 63) {return("Error: There was a problem communicating with the LDAP authentication server. Please contact your administrator.")
    } else if(zoltar_speaks == 64) {return("Error: The number of users permitted by this license has been exceeded. Please contact your administrator.")
    } else if(zoltar_speaks == 65) {return("Error: API applications are not permitted by your license.")
    } else if(zoltar_speaks == 66) {return("Error: You cannot assign ownership to another user.")
    } else if(zoltar_speaks == 67) {return("Error: You must provide the source_key for an existing variant")
    } else if(zoltar_speaks == 68) {return("Error: You cannot promote a variant without a valid rendering")
    } else if(zoltar_speaks == 69) {return("Error: The bundle ID of the source and target variants must match")
    } else if(zoltar_speaks == 70) {return("Error: Target rendering is more recent than source rendering")
    } else if(zoltar_speaks == 71) {return("Error: Only parameterized documents support promoting output")
    } else if(zoltar_speaks == 72) {return("Error: Not allowed to create schedule with different application association than its variant")
    } else if(zoltar_speaks == 73) {return("Error: You may not schedule ad-hoc variants")
    } else if(zoltar_speaks == 74) {return("Error: The requested report name is not permitted")
    } else if(zoltar_speaks == 75) {return("Error: You may not delete the active bundle for an application")
    } else if(zoltar_speaks == 76) {return("Error: A user using the same Unique ID already exists")
    } else if(zoltar_speaks == 77) {return("Error: A tag name cannot be more than 255 characters")
    } else if(zoltar_speaks == 78) {return("Error: A tag must have a name")
    } else if(zoltar_speaks == 79) {return("Error: Cannot assign a category to an app")
    } else if(zoltar_speaks == 80) {return("Error: The target object does not match the provided version.")
    } else if(zoltar_speaks == 81) {return("Error: Duplicate names are not permitted; a sibling tag or category already has this name")
    } else if(zoltar_speaks == 82) {return("Error: The bundle for deployment must belong to the target application.")
    } else if(zoltar_speaks == 83) {return("Error: Too many search results. Be more specific.")
    } else if(zoltar_speaks == 84) {return("Error: The token has already been claimed. Tokens can only be claimed once.")
    } else if(zoltar_speaks == 85) {return("Error: A token using the same token key already exists")
    } else if(zoltar_speaks == 86) {return("Error: A new token MUST contain a public_key and token in the json body.")
    } else if(zoltar_speaks == 87) {return("Error: The request body cannot be parsed")
    } else if(zoltar_speaks == 88) {return("Error: Cannot apply the requested change because it would make the target object an ancestor of itself.")
    } else if(zoltar_speaks == 89) {return("Error: Unable to send email. Please contact your administrator.")
    } else if(zoltar_speaks == 90) {return("Error: User self-registration is disabled")
    } else if(zoltar_speaks == 91) {return("Error: The external authentication provider did not provide a valid username.")
    } else if(zoltar_speaks == 92) {return("Error: XSRF token mismatch")
    } else if(zoltar_speaks == 93) {return("Error: Private variants cannot be configured to email users other than the owner")
    } else if(zoltar_speaks == 94) {return("Error: You can only request a permissions upgrade once per 24-hour period.")
    } else if(zoltar_speaks == 95) {return("Error: This API does not allow the current authentication type.")
    } else if(zoltar_speaks == 96) {return("Error: Incorrect current password.")
    } else if(zoltar_speaks == 97) {return("Error: Changing host or scheme in redirect is forbidden.")
    } else if(zoltar_speaks == 98) {return("Error: We couldn't log you in with the provided credentials. Please ask your administrator for assistance.")
    } else if(zoltar_speaks == 99) {return("Error: Please re-supply your credentials.")
    } else if(zoltar_speaks == 100) {return("Error: Unable to remove item. It is being processed.")
    } else if(zoltar_speaks == 101) {return("Error: The provided password change token is invalid.")
    } else if(zoltar_speaks == 102) {return("Error: A schedule for this variant already exists.")
    } else if(zoltar_speaks == 103) {return("Error: This system has not been configured to send email. Please contact your administrator.")
    } else if(zoltar_speaks == 104) {return("Error: The content checksum header and body MD5 sum are not equal.")
    } else if(zoltar_speaks == 105) {return("Error: TensorFlow Model APIs are not permitted by your license.")
    } else if(zoltar_speaks == 106) {return("Error: Unable to update environment variables because they were changed while you were editing them.")
    } else if(zoltar_speaks == 107) {return("Error: That username is not allowed because it is prohibited by policy.")
    } else if(zoltar_speaks == 108) {return("Error: Environment changes contain a prohibited variable")
    } else if(zoltar_speaks == 109) {return("Error: This type of content is not allowed because it is prohibited by policy.")
    } else if(zoltar_speaks == 110) {return("Error: You cannot change the categorization of content once deployed. Try deploying this as a new application instead of updating an existing one.")
    } else if(zoltar_speaks == 111) {return("Error: You cannot change if an app is parameterized once deployed. Try deploying this as a new application instead of updating an existing one.")
    } else if(zoltar_speaks == 112) {return("Error: The provided user role is not recognized.")
    } else if(zoltar_speaks == 113) {return("Error: Invalid MaxProcesses setting. The MaxProcesses setting may not exceed the Scheduler.MaxProcessesLimit setting.")
    } else if(zoltar_speaks == 114) {return("Error: Invalid MinProcesses setting. The MinProcesses setting may not exceed the MaxProcesses setting.")
    } else if(zoltar_speaks == 115) {return("Error: The provided status is not recognized.")
    } else if(zoltar_speaks == 116) {return("Error: The requested rendering does not match the variant.")
    } else if(zoltar_speaks == 117) {return("Error: Unknown access type.")
    } else if(zoltar_speaks == 118) {return("Error: This access type is not allowed because it is prohibited by policy.")
    } else if(zoltar_speaks == 119) {return("Error: The authentication provider does not support creating records from a retrieved ticket. POST new content instead.")
    } else if(zoltar_speaks == 120) {return("Error: The authentication provider does not support creating records from POST content. PUT a retrieved ticket instead.")
    } else if(zoltar_speaks == 121) {return("Error: The request JSON is invalid.")
    } else if(zoltar_speaks == 122) {return("Error: Application title must be between 3 and 1024 characters.")
    } else if(zoltar_speaks == 123) {return("Error: Application description must be 4096 characters or less.")
    } else if(zoltar_speaks == 124) {return("Error: No administrator has a configured email address.")
    } else if(zoltar_speaks == 125) {return("Error: Content-Length cannot be 0.")
    } else if(zoltar_speaks == 126) {return("Error: Request Content-Length did not match the number of bytes received.")
    } else if(zoltar_speaks == 127) {return("Error: The temp_ticket is invalid.")
    } else if(zoltar_speaks == 128) {return("Error: The email address cannot be blank.")
    } else if(zoltar_speaks == 129) {return("Error: The user unique ID cannot be blank.")
    } else if(zoltar_speaks == 130) {return("Error: The group unique ID cannot be blank.")
    } else if(zoltar_speaks == 131) {return("Error: A group using the same unique ID already exists.")
    } else if(zoltar_speaks == 132) {return("Error: The configured provider cannot access this endpoint.")
    } else if(zoltar_speaks == 133) {return("Error: The source variant belongs to a different app.")
    } else if(zoltar_speaks == 134) {return("Error: Unable to write bundle to disk.")
    } else if(zoltar_speaks == 135) {return("Error: Unable to extract the bundle.")
    } else if(zoltar_speaks == 136) {return("Error: Time values must be in RFC3339 format.")
    } else if(zoltar_speaks == 137) {return("Error: The start of the time interval cannot be in the past, or more than 5 years in the future.")
    } else if(zoltar_speaks == 138) {return("Error: The end of the time interval cannot be earlier than the start time.")
    } else if(zoltar_speaks == 139) {return("Error: The length of the time interval cannot be more than 1 year.")
    } else if(zoltar_speaks == 140) {return("Error: The time interval must have both start and end times.")
    } else if(zoltar_speaks == 141) {return("Error: Task lookup failures can indicate that a load balancer is not using sticky sessions or a client is not including the session cookie. Details: https://docs.rstudio.com/connect/admin/load-balancing/")
    } else if(zoltar_speaks == 142) {return("Error: The app is already managed by git.")
    } else if(zoltar_speaks == 143) {return("Error: The app is not managed by git.")
    } else if(zoltar_speaks == 144) {return("Error: Uploading a content bundle is not allowed for this application since it is managed by git.")
    } else if(zoltar_speaks == 145) {return("Error: Cannot deploy this content because git is not enabled.")
    } else if(zoltar_speaks == 146) {return("Error: Git urls with usernames are not supported.")
    } else if(zoltar_speaks == 147) {return("Error: The specified app mode does not use worker processes.")
    } else if(zoltar_speaks == 148) {return("Error: The specified app mode is not valid.")
    } else if(zoltar_speaks == 149) {return("Error: Environment changes contain a duplicated variable name.")
    } else if(zoltar_speaks == 150) {return("Error: The load factor must be between 0.0 and 1.0.")
    } else if(zoltar_speaks == 151) {return("Error: The timeout must be between 0 and 2592000 seconds.")
    } else if(zoltar_speaks == 152) {return("Error: The principal type must be 'user' or 'group'.")
    } else if(zoltar_speaks == 153) {return("Error: The requested group could not be found.")
    } else if(zoltar_speaks == 154) {return("Error: The requested user is already in the content permission list.")
    } else if(zoltar_speaks == 155) {return("Error: The requested group is already in the content permission list.")
    } else if(zoltar_speaks == 156) {return("Error: This user cannot be assigned as the owner because they don't have permission to publish content.")
    } else if(zoltar_speaks == 157) {return("Error: The requested parent tag does not exist")
    } else if(zoltar_speaks == 158) {return("Error: The requested tag does not exist")
    } else if(zoltar_speaks == 159) {return("Error: The permission request submitted already exists.")
    } else if(zoltar_speaks == 160) {return("Error: The email notification for a permission request cannot be delivered due to missing or invalid email address.")
    } else if(zoltar_speaks == 161) {return("Error: The include option specified is not valid")
    } else if(zoltar_speaks == 162) {return("Error: The specified hostname is not an active Connect host")
    } else {return(zoltar_speaks)}
  }
}
