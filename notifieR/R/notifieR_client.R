#' A main S4 class of notifieR package.
#' 
#' <ToDo: description>
#' 
#' @slot type A type (name) of service whose class is wrapping \code{notifieR_client-class}.
setClass("notifieR_client",
         slots = c("type" = "character"),
         prototype = list("type" = NA_character_))


#' Print function for notifieR client.
#' 
#' <ToDo: description>
#' 
#' @param x <ToDo>
#' @param ... <ToDo>
#' 
#' @exportMethod print
setMethod("print", "notifieR_client", function(x, ...) {
    cat(sprintf("notifieR client (%s)\n", x@type))
})