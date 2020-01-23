#' @title sendeR client
#' 
#' @description Function \code{client_sendeR} is a constructor for an object
#' of a \code{client_sendeR} class. This object is an underlying structure
#' on which every other client is based.
#' 
#' @param service typically a name of service whose client extends the object.
#' @param ... named arguments with additional fields which will be passed to
#'  \code{\link{set_fields}} during client creation.
#' 
#' @seealso \code{\link{is.client_sendeR}}, \code{\link{send_message}}
#'
#' @examples 
#' client <- client_sendeR("a service name")
#' 
#' # Variant with default parameters set
#' client2 <- client_sendeR("service", message = "Default message template")
#'
#' @rdname client_sendeR
#' @export
client_sendeR <- function(service, ...) {
    assert(is_character_len1(service), msg_character_len1("service"))
    
    client <- list("service" = service)
    client <- add_class(client, "client_sendeR", FALSE)
    
    if (length(list(...)) > 0 ) {
        client <- set_fields(client, ...)
    }
    
    client
}


# Function returns field names in the client_sendeR object.
# Note: field names should be the same as the constructor's arguments.
default_fields.client_sendeR <- function(client) {
    "service"
}


#' @title sendeR clients' verification
#' 
#' @description \code{is.client_sendeR} tests if a provided object is of
#' the \code{client_sendeR} class and whether it has all the fields
#' a \code{client_sendeR} should have.
#' 
#' All other functions check if the provided object extends
#' \code{client_sendeR} (passes \code{is.client_sendeR} test) and whether it
#' has all the fields a given client should have.
#' 
#' @param x an object to be tested.
#' 
#' @rdname is.client_sendeR
#' @export
is.client_sendeR <- function(x) {
    inherits(x, "client_sendeR") &&
        all(default_fields.client_sendeR(x) %in% names(x))
}


#' @description The \code{send_message} method for the \code{client_sendeR}
#' only serves as a placeholder.
#' 
#' @rdname send_message
#' @export
send_message.client_sendeR <- function(client, message, destination,
                                         verbose = FALSE, ...) {
    assert(is.client_sendeR(client), not_a_client("client", "sendeR"))

    warning("client_NotifieR does not support sending messages.")
}


#' @param x an object to print.
#' @param ... argument not used. Required only for overloading purposes.
#'
#' @rdname client_sendeR
#' @export
print.client_sendeR <- function(x, ...) {
    assert(is.client_sendeR(x), not_a_client("x", "sendeR"))
    
    cat(format(x))
}


# Function creates a character string with a relevant information about a given
# client_sendeR. This method is intended to be used only in
# a print.client_sendeR method.
format.client_sendeR <- function(x, ...) {
    assert(is.client_sendeR(x), not_a_client("x", "sendeR"))
    
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
        sprintf("sendeR client (%s)\n", x$service),
        defaults,
        additionals,
        sep = ""
    )
}
