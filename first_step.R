library(httr)

# Temporary - just to create MIME
library(gmailr)

user <- ''
key = ''
secret = ''

# Get token
scope_list <- c("https://www.googleapis.com/auth/gmail.send")
gmail_send_app <- httr::oauth_app("google", 
                                    key = key, 
                                    secret = secret)

google_token <-httr::oauth2.0_token(httr::oauth_endpoints("google"),
                                    gmail_send_app,
                                    scope = scope_list)

# Funkcja pomocnicze
base64url_encode <- function(x) { gsub("/", "_", gsub("\\+", "-", base64enc::base64encode(charToRaw(as.character(x))))) }
gmail_path <- function(user, ...) { paste("https://www.googleapis.com/gmail/v1/users", user, paste0(unlist(list(...)),"messages/send", collapse = "/"), sep = "/") }

#Temporary - just to create MIME
msg <-
  gm_mime() %>%
  gm_to(user) %>%
  gm_from(user) %>%
  gm_subject("notifyR") %>%
  gm_text_body("PUT YOUR OWN TEXT HERE")

# Send message
httr::POST(url = gmail_path(user),
           google_token,
           #class = 'gmail_message',
           query = list(uploadType = 'multipart'),
           body = jsonlite::toJSON(auto_unbox=TRUE, 
                                   null = "null",
                                   c(threadId = NULL, list(raw = base64url_encode(as.character(msg))))),
           httr::add_headers("Content-Type" = "application/json")
           )
