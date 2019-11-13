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
#' @seealso \link{is.client_slack}, \link{send_message}, 
#' 
#' @rdname client_slack
#' @export
client_slack <- function(slack_webhook) {
    assert(is_character_len1(slack_webhook), msg_character_len1(slack_webhook))

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


#' @importFrom curl curl_escape new_handle handle_setheaders handle_setopt curl_fetch_memory handle_reset
#'
#' @describeIn send_message \code{description} is a ... TODO(TK)
#' @export
send_message.client_slack <- function(client, message, destination = NULL,
                                      verbose = FALSE, ...) {
    assert(is.client_slack(client), not_a_client("client", "slack"))
    assert(is_character_len1(message), msg_character_len1("message"))
    assert(is_character_len1(destination) || is.null(destination),
           paste(msg_char_num_len1("destination"), "or a NULL"))
    assert(is_logical_not_NA(verbose), msg_logical_not_NA("verbose"))
  
    channel <- if (is.null(destination)) "#general" else destination # TODO(TK): Picking a channel (destination)
    username <- "notifieR"
    # TODO(TK): initial value:
    # icon_emoji <- sprintf(', "icon_emoji": "%s"', icon_emoji)
    icon_emoji <- ""

    headers <- list("Content-Type" = "application/json")
    options <- list(
      "post" = TRUE,
      "postfields" = sprintf(
          '{"channel": "%s", "username": "%s", "text": "```%s```"%s}',
          channel, username, curl_escape(message), icon_emoji))

    h <- new_handle()
    handle_setheaders(h, .list = headers)
    handle_setopt(h, .list = options)
    on.exit(handle_reset(h))

    response <- curl_fetch_memory(client$slack_webhook, h)

    return_response(response, verbose)
}
