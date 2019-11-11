#' @title Slack client
#' 
#' @description Client extending the \link{client_notifieR} for the Slack
#' service. In addition to any fields in the \link{client_notifieR} this one
#' contains \code{slack_webhook} which is needed to send a message via the Slack
#' Webhook API. For additional information on how to create a webhook see details.
#' 
#' @details To create your own webhook head to
#' \url{https://api.slack.com/messaging/webhooks}.
#' \strong{Note}: Webhooks are permamently connected to one channel.
#' 
#' @param slack_webhook a webhook obtained from the Slack API settings.
#' 
#' @seealso \link{available_clients}, \link{send_message}, \link{is.client_slack}
#' 
#' @rdname client_slack
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


#' @importFrom curl curl_escape
#' @importFrom httr POST add_headers
#'
#' @rdname send_message
#' @export
send_message.client_slack <- function(client, message, destination = NULL,
                                      verbose = FALSE, decode_response = TRUE,
                                      ...) {
    assert(is.client_slack(client),
           "could not execute send_message.client_slack method:",
           not_a_client("client", "slack"))
  
    icon_emoji <- sprintf(', "icon_emoji": "%s"', icon_emoji) # TODO(TK): initial value
    username <- "notifieR"
    output <- curl_escape(message)
  
    # TODO(TK): Picking a channel (destination)
    channel <- if (is.null(destination)) "#general" else destination
  
    response <- POST(
        url = client$slack_webhook,
        encode = "form",
        add_headers(
            `Content-Type` = "application/x-www-form-urlencoded",
            Accept = "*/*"),
        body = curl_escape(
          sprintf('payload={"channel": "%s", "username": "%s", "text": "```%s```"%s}',
                  channel, username, output, icon_emoji)))

    return_response(response, verbose, decode_response)
}
