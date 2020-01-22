#' @title Set fields inside a sendeR client
#' 
#' @description This function is intended to set default parameters such as 
#'  \code{message} or \code{destination} inside a client as additional fields.
#'  After setting default values the clients will be able to send messages
#'  without passing additional arguments to the \code{\link{send_message}}
#'  function.
#' 
#' @return Updated client.
#' 
#' @details Standard fields utilized in the package include:
#'  \itemize{
#'      \item \code{message}
#'      \item \code{destination} (apart from Slack service client)
#'      \item \code{verbose}
#'  }
#'  any other set defaults won't have any effect.
#' 
#'  \strong{Note:} arguments to \code{\link{send_message}} function are always
#'  prioritized over the client fields.
#' 
#' @param client the client which will have default values set.
#' @param ... named arguments to set inside the client (non-named arguments will
#'  be ignored).
#' 
#' @examples 
#'  client <- client_telegram("my_token")
#'  client <- set_fields(client, message = "Hello world!", destination = 12345)
#'  
#'  \dontrun{
#'      send_message(client)
#'  }
#' 
#' @export
set_fields <- function(client, ...) {
    assert(is.client_sendeR(client), not_a_client("client", "sendeR"))
    
    args <- list(...)
    for (argName in names(args)) {
        if (argName != "") {
            client[[argName]] <- args[[argName]]
        }
    }
    
    add_class(client, fields_class_name())
}

#' @details \strong{Note:} arguments to \code{\link{send_message}} function are
#'  always prioritized over the client fields.
#' 
#' @rdname send_message 
#' @export
send_message.client_with_fields <- function(client, message, destination,
                                            verbose = FALSE, ...) {
    
    msg_field <- get_field(client, "message")
    if (!is.null(msg_field) && missing(message)) {
        message <- msg_field
    }
    
    dest_field <- get_field(client, "destination")
    if (!is.null(dest_field) && missing(destination)) {
        destination <- dest_field
    }
    
    verbose_field <- get_field(client, "verbose")
    if (!is.null(verbose_field)) {
        verbose <- verbose_field
    }
    
    # Removing fields_class_name() from client to perform regular send_message.
    client_classes <- class(client)
    fields_class_idx <- which(client_classes == fields_class_name())
    class(client) <- client_classes[-fields_class_idx]
    
    send_message(client, message, destination, verbose, ...)
}


fields_class_name <- function() {
    "client_with_fields"
}


has_fields <- function(client) {
    fields_class_name() %in% class(client)
}


get_field <- function(client, field_name) {
    if (has_fields(client)) return(client[[field_name]])
}