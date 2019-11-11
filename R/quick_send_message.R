# TODO(Feature):
quick_send_message <- function(client, message, destination, verbose = FALSE,
                               ...) {
    assert(is.character(client) || is.client_notifieR(client),
           "only character and notifieR client's are supported") # TODO: update assert

    if (is.character(client)) {
        client <- create_client(service_name = client, ...)
    }

    return(send_message(client, message, destination, verbose, ...))
}


# Generalized constructor. Creates a client based on a service's name and
# arguments passed in an ellipsis.
create_client <- function(service_name, ...) {
    service <- clients_dict()[[tolower(service_name)]]
    assert(!is.null(service), "could not create client:",
           "client for service", service_name, "is not implemented.",
           "See ?available_clients") # TODO: update assert

    # TODO(Feature): reading arguments from a system environment.
    arguments <- list(...)
    defaults <- service$default_fields(NULL)
    assert(all(defaults %in% names(arguments)), "could not create a ",
           service_name, "client: insufficient arguments provided.",
           sprintf("See ?client_%s for details.", service_name))

    do.call(service$constructor, arguments[defaults])
}


# A list-based dictionary translating a service name to a corresponding client.
# Note: Only clients viable for quick_send_message (not requiring authorization)
#   are stored in the dict.
clients_dict <- function() {
    list(
        "notifier" = list(
            "constructor" = client_notifieR,
            "default_fields" = default_fields.client_notifieR),
        "slack" = list(
            "constructor" = client_slack,
            "default_fields" = default_fields.client_slack),
        "telegram" = list(
            "constructor" = client_telegram,
            "default_fields" = default_fields.client_telegram)
    )
}
