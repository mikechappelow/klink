#' klink_scrub
#' @description removes NaN and Inf values from numeric and character fields, meant to make prevent associated errors in database write operations
#'
#' @param data_to_scrub dataframe to be scrubbed (no quotes)
#'
#' @usage klink_scrub(data_to_scrub)
#'
#' @return Returns original data with NaN and Inf values replaced with NAs (which write to databases as NULL values)
#' @export
#'
#' @examples
#' klink_scrub(my_df)
#' klink_scrub(another_df)

klink_scrub <- function(data_to_scrub){
  # !!! consider adding handler to enable application at vector level
  bad_NaN <- function(x){
    ifelse(is.nan(x), NA, x)
  }

  bad_Inf <- function(x){
    ifelse(is.infinite(x), NA, x)
  }

  # replace NaN with NA
  data_to_scrub <- dplyr::mutate_if(data_to_scrub, is.numeric, bad_NaN)
  data_to_scrub <- dplyr::mutate_if(data_to_scrub, is.character, bad_NaN) # character operations probably not necessary... but whatever

  # replace infinite values
  data_to_scrub <- dplyr::mutate_if(data_to_scrub, is.numeric, bad_Inf)
  data_to_scrub <- dplyr::mutate_if(data_to_scrub, is.character, bad_Inf)
}
