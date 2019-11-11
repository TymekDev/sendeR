#' @title Telegram client
#' 
#' @description Client extending a \link{client_notifieR} for the Telegram
#' service. In addition to any fields in the \link{client_notifieR} this one
#' contains \code{telegram_token} which is needed to send a message via
#' the Telegram Bot API. For additional information on how to get required
#' \code{telegram_token} see details.
#' 
#' @details To create your own telegram bot refer to
#' \url{https://core.telegram.org/bots#6-botfather}.
#' 
#' @param telegram_token a bot token given by the Botfather.
#' 
#' @seealso \link{is.client_telegram}, \link{send_message}
#' 
#' @rdname client_telegram
#' @export
client_telegram <- function(telegram_token) {
    client <- client_notifieR("telegram")
    client$telegram_token <- telegram_token
    
    add_class(client, "client_telegram")
}


# Function returns field names in the client_telegram object.
default_fields.client_telegram <- function(client) {
    "telegram_token"   
}


#' @rdname is.client_notifieR
#' @export
is.client_telegram <- function(x) {
    is.client_notifieR(x) &&
        inherits(x, "client_telegram") &&
        all(default_fields.client_telegram(x) %in% names(x))   
}


#' @importFrom curl curl_escape new_handle handle_setopt curl_fetch_memory handle_reset
#'
#' @describeIn send_message \code{destination} is a recipient's chat id.
#' @export
send_message.client_telegram <- function(client, message, destination,
                                         verbose = FALSE, ...) {
    assert(is.client_telegram(client),
           "could not execute send_message.client_telegram method:",
           not_a_client("client", "telegram"))
    # TODO(TM): assert that destination is a chat id
    url <- sprintf("https://api.telegram.org/bot%s/sendMessage?text=%s&chat_id=%s",
                   client$telegram_token, curl_escape(message), destination)
    
    h <- new_handle()
    handle_setopt(h, customrequest = "GET")
    response <- curl_fetch_memory(url, h)
    on.exit(handle_reset(h))
    
    return_response(response, verbose)
}
