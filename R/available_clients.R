#' @title Available clients
#' 
#' @description <ToDo> Note to self: provided names are case independent (here and at send_message)
#' 
#' @seealso \link{custom_client}
#' 
#' @rdname available_clients
#' 
#' @export
available_clients <- function() {
    names(clients_dict()) # <ToDo>
}


# Generalized constructor. Creates a client based on a service's name and
# arguments passed in an ellipsis.
create_client <- function(service_name, ...) {
    service <- clients_dict()[[tolower(service_name)]]
    assert(!is.null(service), "could not create client:",
           "client for service", service_name, "is not implemented.",
           "See ?available_clients")
    
    # <ToDo: reading from environment>
    arguments <- list(...)
    defaults <- service$default_fields(NULL)
    assert(all(defaults %in% names(arguments)), "could not create a ",
           service_name, "client: insufficient arguments provided.",
           sprintf("See ?%s_client for details.", service_name))
    
    do.call(service$constructor, arguments[defaults])
}


# A list-based dictionary translating a service name to a corresponding client
# constructor.
clients_dict <- function() {
    list(
        "notifier" = list(
            "constructor" = notifieR_client,
            "default_fields" = default_fields.notifieR_client
        ),
        "telegram" = list(
            "constructor" = client_telegram,
            "default_fields" = default_fields.client_telegram
        )
    )
}
