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
send_message.client_gmail <- function(client, message, destination, verbose=FALSE,
                                         ...) {
  assert(is.client_gmail(client),
         "could not execute send_message.client_gmail method:",
         not_a_client("client", "gmail"))

  
  create_message <- function(message, destination, subject){
        header <- 'Content-Type: text/plain;charset="utf-8";'
        mime_type <- 'MIME-Version: 1.0'
        from <- paste0('from: ', client$email)
        to <- paste0('to: ', destination)
        subj <- paste0('subject: ', subject)
        msg <- paste0('\n', message)
        
        paste(header,mime_type,from,to,subj,msg,
              sep = '\n')
      }
  msg <- create_message(message, destination, 'NotifyR notification')
  
  # Send message
  response <- httr::POST(url = gmail_path(client$email),
             client$google_token,
             #class = 'gmail_message',
             query = list(uploadType = 'multipart'),
             body = jsonlite::toJSON(auto_unbox=TRUE, 
                                     null = "null",
                                     c(threadId = NULL, list(raw = base64url_encode(as.character(msg))))),
             httr::add_headers("Content-Type" = "application/json")
  )
  
  return_response(response, verbose)
}