#' @title Slack client
#' 
#' @description Client extending a \link{client_notifieR} for Slack service.
#' In addition to any fields in the \link{client_notifieR} this one contains
#' \code{slack webhook} which is needed to send a message via Slack Webhook API.
#' 
#' Just go to: \code{https://api.slack.com/messaging/webhooks} and create Your own webhook to send messages.
#' Webhooks are permamently connected to one channel!
#' 
#' @param slack_webhook Webhook obtained from Slack API settings
#' 
#' @rdname client_slack
#' 
#' @export
client_slack <- function(slack_webhook) {
  client <- client_notifieR("slack")
  client$slack_webhook <- slack_webhook
  
  add_class(client, "client_slack")
}


# Function returns names of fields in client_slack object.
default_fields.client_slack <- function(client) {
  "slack_webhook"   
}


#' @rdname is.client_notifieR
#' @export
is.client_slack <- function(x) {
  is.client_notifieR(x) &&
    inherits(x, "client_slack") &&
    all(default_fields.client_slack(x) %in% names(x))   
}


#' @description \link{send_message} method for \code{client_slack}. TODO
#'
#' @inheritParams send_message
#' 
#' @importFrom curl curl_escape
#' @importFrom httr POST add_headers
#'
#' @rdname client_slack
#' 
#' @export
send_message.client_slack <- function(client, message, destination = NA,
                                         verbose = FALSE,
                                         decode_response = TRUE, ...) {
  assert(is.client_slack(client),
         "could not execute send_message.client_slack method:",
         not_a_client("client", "slack"))
  
  icon_emoji <- sprintf(', "icon_emoji": "%s"', icon_emoji)
  username <- 'notifyr'
  output <- curl_escape(message)
  
  # TODO Picking a channel (destination)
  channel <- ifelse(is.na(destination),'#general',destination)
  
  response <- POST(url = client$slack_webhook, 
       encode = "form",
       add_headers(`Content-Type` = "application/x-www-form-urlencoded",
                   Accept = "*/*"), body = curl_escape(sprintf("payload={\"channel\": \"%s\", \"username\": \"%s\", \"text\": \"```%s```\"%s}",
                                                             channel, username, output, icon_emoji)))
  return_response(response, verbose, decode_response)
}
