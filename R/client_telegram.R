#' @title Telegram client
#' 
#' @description Client extending a \code{\link{client_sendeR}} for the Telegram
#' service. In addition to any fields in the \code{\link{client_sendeR}} this one
#' contains \code{telegram_token} which is needed to send a message via
#' the Telegram Bot API. For additional information on how to get required
#' \code{telegram_token} see details.
#' 
#' @details To create your own telegram bot refer to
#' \url{https://core.telegram.org/bots#6-botfather}.
#' 
#' @param telegram_token a bot token given by the BotFather.
#' @param ... named arguments with additional fields which will be passed to
#'  \code{\link{set_fields}} during client creation.
#' 
#' @seealso \code{\link{is.client_telegram}}, \code{\link{send_message}}
#' 
#' @examples 
#' client <- client_telegram("my_token")
#' 
#' # Variant with default parameters set
#' client2 <- client_telegram("my_token", message = "Default message template")
#' 
#' @rdname client_telegram
#' @export
client_telegram <- function(telegram_token, ...) {
    assert(is_character_len1(telegram_token), msg_character_len1("telegram_token"))

    client <- client_sendeR("telegram", ...)
    client$telegram_token <- telegram_token

    add_class(client, "client_telegram")
}


# Function returns field names in the client_telegram object.
default_fields.client_telegram <- function(client) {
    "telegram_token"   
}


#' @rdname is.client_sendeR
#' @export
is.client_telegram <- function(x) {
    is.client_sendeR(x) &&
        inherits(x, "client_telegram") &&
        all(default_fields.client_telegram(x) %in% names(x))   
}


#' @importFrom curl curl_escape new_handle handle_setopt curl_fetch_memory handle_reset
#'
#' @describeIn send_message \code{destination} is a recipient's chat id.
#' @export
send_message.client_telegram <- function(client, message, destination,
                                         verbose = FALSE, ...) {
    assert(is.client_telegram(client), not_a_client("client", "telegram"))
    assert(is_character_len1(message), msg_character_len1("message"))
    assert(is_char_num_len1(destination), msg_char_num_len1("destination"))
    assert(is_logical_not_NA(verbose), msg_logical_not_NA("verbose"))

    url <- sprintf(
        "https://api.telegram.org/bot%s/sendMessage?text=%s&chat_id=%s",
        client$telegram_token, curl_escape(message), destination)
    
    h <- new_handle()
    handle_setopt(h, customrequest = "GET")
    response <- curl_fetch_memory(url, h)
    on.exit(handle_reset(h))
    
    return_response(response, verbose)
}
