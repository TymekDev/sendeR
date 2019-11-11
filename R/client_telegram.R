#' @title Telegram client
#' 
#' @description Client extending a \link{client_notifieR} for Telegram service.
#' In addition to any fields in the \link{client_notifieR} this one contains
#' \code{telegram_token} which is needed to send a message via Telegram API.
#' 
#' @param telegram_token TODO
#' 
#' @rdname client_telegram
#' 
#' @export
client_telegram <- function(telegram_token) {
    client <- client_notifieR("telegram")
    client$telegram_token <- telegram_token
    
    add_class(client, "client_telegram")
}


# Function returns names of fields in client_telegram object.
default_fields.client_telegram <- function(client) {
    "telegram_token"   
}


#' @description \code{is.client_telegram} checks if a provided object is of 
#' the \code{client_telegram} class, whether it has all the fields
#' a \code{client_telegram} should have and if it is a \link{client_notifieR}.
#'
#' @rdname client_telegram
#' 
#' @export
is.client_telegram <- function(x) {
    is.client_notifieR(x) &&
        inherits(x, "client_telegram") &&
        all(default_fields.client_telegram(x) %in% names(x))   
}


#' @description \link{send_message} method for \code{client_telegram}. TODO
#'
#' @inheritParams send_message
#' 
#' @importFrom curl curl_escape new_handle handle_setopt curl_fetch_memory
#'
#' @rdname client_telegram
#' 
#' @export
send_message.client_telegram <- function(client, message, destination,
                                         verbose = FALSE,
                                         decode_response = TRUE, ...) {
    assert(is.client_telegram(client),
           "could not execute send_message.client_telegram method:",
           not_a_client("client", "telegram"))
    # TODO: assert that destination is a chat id
    url <- sprintf("https://api.telegram.org/bot%s/sendMessage?text=%s&chat_id=%s",
                   client$telegram_token, curl_escape(message), destination)
    
    h <- new_handle()
    handle_setopt(h, customrequest = "GET")
    response <- curl_fetch_memory(url, h)
    
    return_response(response, verbose, decode_response)
}
