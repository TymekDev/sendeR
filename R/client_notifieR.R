#' @title notifieR client
#' 
#' @description Function \code{client_notifieR} is a constructor for an object
#' of a \code{client_notifieR} class. This object is an underlying structure
#' on which every other client is based.
#' 
#' @param service typically a name of service whose client extends the object.
#' 
#' @seealso \link{available_clients}, \link{send_message}, \link{is.client_notifieR}
#' 
#' @rdname client_notifieR
#' @export
client_notifieR <- function(service) {
    assert(is.character(service), "could not create a notifieR client:",
           "provided <service> argument is not a character.")
    
    client <- list("service" = service)
    add_class(client, "client_notifieR")
}


# Function returns field names in the client_notifieR object.
# Note: field names should be the same as the constructor's arguments.
default_fields.client_notifieR <- function(client) {
    "service"
}


#' @title notifieR clients' verification
#' 
#' @description \code{is.client_notifieR} tests if a provided object is of
#' the \code{client_notifieR} class and whether it has all the fields
#' a \code{client_notifieR} should have.
#' 
#' All other functions check if the provided object extends
#' \code{client_notifieR} (passes \code{is.client_notifieR} test) and whether it
#' has all the fields a given client should have.
#' 
#' @param x an object to be tested.
#' 
#' @rdname is.client_notifieR
#' @export
is.client_notifieR <- function(x) {
    inherits(x, "client_notifieR") &&
        all(default_fields.client_notifieR(x) %in% names(x))
}


#' @description The \code{send_message} method for the \code{client_notifieR}
#' only serves as a placeholder.
#' 
#' @rdname send_message
#' @export
send_message.client_notifieR <- function(client, message, destination,
                                         verbose = FALSE,
                                         decode_response = TRUE, ...) {
    assert(is.client_notifieR(client),
           "could not execute send_message.client_notifieR:",
           not_a_client("client", "notifieR"))

    warning("Method not implemented. See ?client_notifieR for details.")
}


#' @param x an object to print.
#' @param ... argument not used. Required only for overloading purposes.
#'
#' @rdname client_notifieR
#' @export
print.client_notifieR <- function(x, ...) {
    assert(is.client_notifieR(x), "could not print a notifieR client:",
           not_a_client("x", "notifieR"))
    
    cat(format(x))
}


# Function creates a character string with a relevant information about a given
# client_notifieR. This method is intended to be used only in
# a print.client_notifieR method.
format.client_notifieR <- function(x, ...) {
    assert(is.client_notifieR(x), "could not format a notifieR client:",
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
