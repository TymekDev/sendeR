#' @title Methods for sending messages.
#' 
#' @param client one of the clients created by the notifieR package.
#' @param message a text body of the message to send. Should be a character
#'  vector of length one.
#' @param destination a destination of the message. Should be a character
#'  vector of length one. For more details see \strong{Methods (by class)}
#'  section below.
#' @param verbose if is set to \code{TRUE} then the function returns whole
#'  response instead of only a status_code.
#' @param ... \code{send_message} passes additional (non-standard) arguments to
#'  respective method. Client specific methods have this argument only for
#'  method overloading purposes.
#' 
#' @export
send_message <- function(client, message, destination, verbose = FALSE, ...) {
    assert(is.client_notifieR(client), not_a_client("client", "notifieR"))
    assert(is_character_len1(message), msg_character_len1("message"))
    assert(is_logical_not_NA(verbose), msg_logical_not_NA("verbose"))
    
    UseMethod("send_message")
}
