#' @title notifieR client
#' 
#' @description Function creates an object of \code{notifieR_client} class with
#' given \code{service} field, typically a name of selected service. This object
#' is an underlying structure from which every other client is created.
#' 
#' @param service a name of a client's serivce.
#' 
#' @seealso \link{available_clients}, \link{custom_client}
#' 
#' @rdname notifieR_client
#'
#' @export
notifieR_client <- function(service) {
    assert(is.character(service), "could not create a notifieR client:",
           "provided <service> argument is not a character.")
    
    client <- list("service" = service)
    add_class(client, "notifieR_client")
}


# Function returns names of fields in object returned by notifieR_client
# function. Note: field names should be the same as the constructor's arguments.
default_fields.notifieR_client <- function(client) {
    "service"
}


#' @description \code{is.notifieR_client} checks if a provided object is of 
#' the \code{notifieR_client} class and whether it has all the fields
#' a \code{notifieR_client} should have.
#'
#' @rdname notifieR_client
#' 
#' @export
is.notifieR_client <- function(x) {
    inherits(x, "notifieR_client") &&
        all(default_fields(x) %in% names(x))
}


#' @description \link{send_message} method for \code{notifieR_client} only
#' serves as a placeholder. For details on how to create a custom client
#' see \link{custom_client}.
#' 
#' @rdname notifieR_client
#' 
#' @export
send_message.notifieR_client <- function(client, message, destination,
                                         verbose = FALSE,
                                         decode_response = TRUE, ...) {
    assert(is.notifieR_client(client),
           "could not execute send_message.notifieR_client:",
           not_a_client("client", "notifieR"))
    
    warning("Method not implemented. See ?notifieR_client for details.")
}


#' @rdname notifieR_client
#'
#' @export
print.notifieR_client <- function(x, ...) {
    assert(is.notifieR_client(x), "could not print a notifieR client:",
           not_a_client("x", "notifieR"))
    
    cat(format(x))
}


# Function creates a character string with relevant information about a given
# notifieR_client. This method is intended to be used in 
format.notifieR_client <- function(x, ...) {
    assert(is.notifieR_client(x), "could not format a notifieR client:",
           not_a_client("x", "notifieR"))
    
    defaults <- setdiff(default_fields(x), "service")
    if (length(defaults) > 0) {
        defaults <- format_fields(x, defaults)   
    }
    
    additionals <- setdiff(names(x), c(default_fields(x), "service"))
    if (length(additionals) > 0) {
        additionals <- sprintf("\n\nAdditional fields:\n%s\n",
                               format_fields(x, additionals))
    }
    
    paste(
        sprintf("notifieR client (%s)\n", x$service),
        defaults,
        additionals,
        sep = ""
    )
}


#' @title Creating custom client with notifieR
#' 
#' @description <ToDo>
#' 
#' @rdname custom_client
#' @name custom_client
NULL
