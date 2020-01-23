#' @title Slack client
#' 
#' @description Client extending the \code{\link{client_sendeR}} for the Slack
#' service. In addition to any fields in the \code{\link{client_sendeR}} this one
#' contains \code{slack_webhook} which is needed to send a message via the Slack
#' Webhook API. For additional information on how to create a webhook see details.
#' 
#' @details To create your own webhook head to
#' \url{https://api.slack.com/messaging/webhooks}.
#' \strong{Note}: Webhooks are permanently connected to one channel.
#' 
#' @param slack_webhook a webhook obtained from the Slack API settings.
#' @param ... named arguments with additional fields which will be passed to
#'  \code{\link{set_fields}} during client creation.
#' 
#' @seealso \code{\link{is.client_slack}}, \code{\link{send_message}}
#'
#' @examples 
#' client <- client_slack("my_webhook")
#' 
#' # Variant with default parameters set
#' client2 <- client_slack("my_webhook", message = "Default message template")
#' 
#' @rdname client_slack
#' @export
client_slack <- function(slack_webhook, ...) {
    assert(is_character_len1(slack_webhook), msg_character_len1("slack_webhook"))

    client <- client_sendeR("slack", ...)
    client$slack_webhook <- slack_webhook
  
    add_class(client, "client_slack")
}


# Function returns names of fields in client_slack object.
default_fields.client_slack <- function(client) {
    "slack_webhook"
}


#' @rdname is.client_sendeR
#' @export
is.client_slack <- function(x) {
    is.client_sendeR(x) &&
      inherits(x, "client_slack") &&
      all(default_fields.client_slack(x) %in% names(x))
}


#' @importFrom curl curl_escape new_handle handle_setheaders handle_setopt curl_fetch_memory handle_reset
#'
#' @describeIn send_message \code{destination} is not used because the Slack
#' webhook is tied to a single channel.
#' @export
send_message.client_slack <- function(client, message, destination = NULL,
                                      verbose = FALSE, ...) {
    assert(is.client_slack(client), not_a_client("client", "slack"))
    assert(is_character_len1(message), msg_character_len1("message"))
    assert(is_character_len1(destination) || is.null(destination),
           paste(msg_char_num_len1("destination"), "or a NULL"))
    assert(is_logical_not_NA(verbose), msg_logical_not_NA("verbose"))
  
    headers <- list("Content-Type" = "application/json")
    options <- list(
      "post" = TRUE,
      "postfields" = sprintf('{"text": "```%s```"}', curl_escape(message)))

    h <- new_handle()
    handle_setheaders(h, .list = headers)
    handle_setopt(h, .list = options)
    on.exit(handle_reset(h))

    response <- curl_fetch_memory(client$slack_webhook, h)

    return_response(response, verbose)
}
