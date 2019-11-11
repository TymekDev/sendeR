#' @title Gmail client
#'
#' @description Client extending a \link{client_notifieR} for Gmail service.
#' In addition to any fields in the \link{client_notifieR} this one contains
#' \code{email},\code{key},\code{secret} which is needed to send a message via
#' Gmail Send API.
#'
#' @param email Email of reciver of the message.
#' @param key \code{Key} created in Google API application.
#' @param secret \code{Secret Key} created in Google API application
#'
#' @importFrom httr oauth_app oauth2.0_token oauth_endpoints
#' 
#' @rdname client_gmail
#'
#' @export
client_gmail <- function(email, key, secret) {
    scope_list <- c("https://www.googleapis.com/auth/gmail.send")
    gmail_send_app <- oauth_app("google",
                                key = key,
                                secret = secret)
    
    google_token <- oauth2.0_token(oauth_endpoints("google"),
                                   gmail_send_app,
                                   scope = scope_list)
    
    client <- client_notifieR("gmail")
    client$email <- email
    client$key <- key
    client$secret <- secret
    client$google_token <- google_token
    
    add_class(client, "client_gmail")
}


# Function returns names of fields in client_gmail object.
default_fields.client_gmail <- function(client) {
    c("email", "key", "secret")
}


#' @rdname is.client_notifieR
#' @export
is.client_gmail <- function(x) {
    is.client_notifieR(x) &&
        inherits(x, "client_gmail") &&
        all(default_fields.client_gmail(x) %in% names(x))
}


#' @description \link{send_message} method for \code{client_gmail}. TODO
#'
#' @inheritParams send_message
#' @param subject Subject of email message.
#' 
#' @importFrom curl new_handle handle_setopt handle_setheaders handle_reset curl_fetch_memory
#'
#' @rdname client_gmail
#'
#' @export
send_message.client_gmail <- function(client, message, destination,
                                      verbose = FALSE, decode_response = TRUE,
                                      subject = "notifieR notification", ...) {
  
    assert(is.client_gmail(client),
           "could not execute send_message.client_gmail method:",
           not_a_client("client", "gmail"))
    
    post_url <- sprintf("https://www.googleapis.com/gmail/v1/users/%s/messages/send", client$email)
    msg_body <- create_mime_message(client$email, destination, subject, message)
    
    headers <- c("Content-Type" = "application/json",
                 "Authorization" = sprintf("Bearer %s", client$google_token$credentials$access_token))
    options <- encode_body(msg_body)
    
    h <- new_handle()
    handle_setopt(h, .list = options)
    handle_setheaders(h, .list = headers)
    on.exit(handle_reset(h))
    
    resp <- curl_fetch_memory(post_url, h)
    
    return_response(resp, verbose, decode_response)
}
