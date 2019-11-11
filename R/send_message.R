#' @title Methods for sending messages.
#' 
#' @description TODO
#' 
#' @param client TODO
#' @param message TODO
#' @param destination TODO
#' @param verbose TODO
#' @param ... TODO
#' 
#' @export
send_message <- function(client, message, destination, verbose = FALSE, ...) {
    if (is.character(client)) {
        client <- create_client(service_name = client, ...)
        return(send_message(client, message, destination, verbose, ...))
    }
    
    assert(is.client_notifieR(client), "could not execute send_method:",
           not_a_client("client", "notifieR"))
    
    # TODO: message & destination assertions
    UseMethod("send_message")
}
