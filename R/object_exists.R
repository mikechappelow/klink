#' object_exists
#' @description checks for existence of object when name passed without quotes
#'
#' @param object_name name of object (without quotation marks)
#'
#' @usage object_exists(object_name)
#'
#' @return If object exists will return TRUE else FALSE
#' @export
#'
#' @examples
#' object_exists(test)
#' object_exists(test2)

object_exists <- function(object_name){
  exists(as.character(substitute(object_name)))
}
