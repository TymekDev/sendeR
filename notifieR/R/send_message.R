#' A main method for sending messages.
#' 
#' <ToDo>
#' 
#' @param client <ToDo>
#' @param message <ToDo>
#' @param destination <ToDo>
#' @param ...  <ToDo>
#' 
#' @rdname send_message
#' 
#' @export
setGeneric("send_message", function(client, message, destination, ...) {
    # <ToDo> assert is.character(client)
    # <ToDo> create service client - eval(sprintf("new('client_%s')", client))
    # <ToDo> check for connection, stop with warning if it is not present
    # send_message(client, message, destination, ...)
})