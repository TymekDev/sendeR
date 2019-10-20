#' A main method for sending messages. <ToDo>
#' 
#' <ToDo: description>
#' 
#' @export
send_message <- function(client, message, destination, verbose = FALSE, ...) {
    if (is.character(client)) {
        client <- create_client(service_name = client, ...)
        return(send_message(client, message, destination, verbose, ...))
    }
    
    assert(is.notifieR_client(client), "could not execute send_method:",
           not_a_client("client", "notifieR"))
    
    # <ToDo: message & destination assertions>
    response <- UseMethod("send_message")
    if (verbose) {
        return(response)
    }
    
    response$status_code
}