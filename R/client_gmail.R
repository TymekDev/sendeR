#' @title Gmail client
#'
#' @description Client extending a \link{notifieR_client} for Gmail service.
#' In addition to any fields in the \link{notifieR_client} this one contains
#' \code{email},\code{key},\code{secret} which is needed to send a message via Gmail Send API.
#'
#' @param email, key, secret
#'
#' @rdname client_gmail
#'
#' @export
client_gmail <- function(email, key, secret) {
  scope_list <- c("https://www.googleapis.com/auth/gmail.send")
  gmail_send_app <- httr::oauth_app("google",
                                    key = key,
                                    secret = secret)

  google_token <-httr::oauth2.0_token(httr::oauth_endpoints("google"),
                                      gmail_send_app,
                                      scope = scope_list)

  client <- notifieR_client("gmail")
  client$email <- email
  client$key <- key
  client$secret <- secret
  client$google_token <- google_token

  add_class(client, "client_gmail")
}


# Function returns names of fields in client_gmail object.
default_fields.client_gmail <- function(client) {
  # Logowanie po raz kolejny - zapisane credsy - czytanie z pliku
  c("email", "key", "secret")
}


#' @description \code{is.client_gmail} checks if a provided object is of
#' the \code{client_gmail} class, whether it has all the fields
#' a \code{client_gmail} should have and if it is a \link{notifieR_client}.
#'
#' @rdname client_gmail
#'
#' @export
is.client_gmail <- function(x) {
  is.notifieR_client(x) &&
    inherits(x, "client_gmail") &&
    all(default_fields.client_gmail(x) %in% names(x))
}


#' @description \link{send_message} method for \code{client_gmail}. <ToDo>
#'
#' @rdname client_gmail
#'
#' @export
send_message.client_gmail <- function(client, message, destination, verbose = FALSE,
                                      decode_response = TRUE, subject = "notifieR notification", ...) {
  
    assert(is.client_gmail(client),
           "could not execute send_message.client_gmail method:",
           not_a_client("client", "gmail"))
    
    post_url <- sprintf("https://www.googleapis.com/gmail/v1/users/%s/messages/send", client$email)
    msg_body <- create_mime_message(client$email, destination, subject, message)
    
    headers <- c("Content-Type" = "application/json",
                 "Authorization" = sprintf("Bearer %s", client$google_token$credentials$access_token))
    options <- encode_body(msg_body)
    
    h <- curl::new_handle()
    curl::handle_setopt(h, .list = options)
    curl::handle_setheaders(h, .list = headers)
    on.exit(curl::handle_reset(h))
    
    resp <- curl::curl_fetch_memory(post_url, h)
    
    return_response(resp, verbose, decode_response)
}