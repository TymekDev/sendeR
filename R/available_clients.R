#' @title Available clients
#' 
#' @description TODO
#' 
#' @seealso \link{custom_client}
#' 
#' @rdname available_clients
#' 
#' @export
available_clients <- function() {
    names(clients_dict())
}


# Generalized constructor. Creates a client based on a service's name and
# arguments passed in an ellipsis.
create_client <- function(service_name, ...) {
    service <- clients_dict()[[tolower(service_name)]]
    assert(!is.null(service), "could not create client:",
           "client for service", service_name, "is not implemented.",
           "See ?available_clients")
    
    # TODO: reading from environment
    arguments <- list(...)
    defaults <- service$default_fields(NULL)
    assert(all(defaults %in% names(arguments)), "could not create a ",
           service_name, "client: insufficient arguments provided.",
           sprintf("See ?client_%s for details.", service_name))
    
    do.call(service$constructor, arguments[defaults])
}


# A list-based dictionary translating a service name to a corresponding client
# constructor.
clients_dict <- function() {
    list(
        "notifier" = list(
            "constructor" = client_notifieR,
            "default_fields" = default_fields.client_notifieR),
        "gmail" = list(
            "constructor" = client_gmail,
            "default_fields" = default_fields.client_gmail),
        "telegram" = list(
            "constructor" = client_telegram,
            "default_fields" = default_fields.client_telegram)
    )
}
