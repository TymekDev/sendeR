#' An S4 class representing Telegram client.
#' 
#' Class extending a \code{\link{notifieR_client-class}} class for Telegram
#' client. In addition to any fields in the \code{\link{notifieR_client-class}}
#' class this one contains `telegram_token` which is needed to send a message
#' via Telegram API.
#' 
#' @slot telegram_token A telegram bot API token.
#'
#' @include notifieR_client.R
setClass("client_telegram",
         slots = c("telegram_token" = "character"),
         prototype = list("telegram_token" = NA_character_),
         contains = "notifieR_client")


#' Telegram client's constructor.
#' 
#' This function takes `telegram_token` and returns an object of class
#' \code{\link{client_telegram-class}}.
#' 
#' @param telegram_token <ToDo>
#' 
#' @export
client_telegram <- function(telegram_token) {
    client <- methods::new("client_telegram")
    client@type <- "Telegram"
    client@telegram_token <- telegram_token
    
    client
}


client_telegram.send_message <- function(client, message, destination, ...) {
    # <ToDo: assert that destination is a chat id>
    # <ToDo: url query escape the message>
    url <- sprintf("https://api.telegram.org/bot%s/sendMessage?text=%s&chat_id=%d",
                   client@telegram_token, message, destination)
    
    h <- curl::new_handle()
    curl::handle_setopt(h, customrequest = "GET")
    
    curl::curl_fetch_memory(url, h) # <ToDo: limit the return to minimum>
    NULL
}


#' <ToDo: title>
#' 
#' <ToDo: desc>
#' 
#' @rdname send_message
#'
#' @include send_message.R
setMethod("send_message", "client_telegram", client_telegram.send_message)