#' @title sendeR lapply
#' 
#' @description Function is a wrapper for standard \code{\link{lapply}}. The
#'  \code{sendeR_lapply} after performing the regular \code{lapply} executes
#'  \code{client} argument's \code{\link{send_message}} method thus notifying 
#'  the user that \code{lapply} has finished.
#' 
#' @param client the sendeR client which will send a message at end of the
#'  regular \code{lapply} execution.
#' @param X a vector (atomic or list) to apply \code{FUN} to each element. See
#'  \code{\link{lapply}} for more details.
#' @param FUN the function to be applied to each element of \code{X}. See
#'  \code{\link{lapply}} for more details.
#' @param ... named arguments will be passed to the \code{send_message}
#'  function. Unnamed arguments will be passed as \code{...} to \code{lapply}
#'  ultimately being the \code{FUN} functions' arguments.
#'  
#' @examples 
#'  # Using regular client
#'  client <- client_telegram("my_token")
#'  \dontrun{
#'      my_func <- function(x, text) { print(paste(text, x)); Sys.sleep(x) }
#'      sendeR_lapply(client, 1:10, my_func, "Sleeping:", destination = 12345,
#'                    message = "sendeR_lapply done!")
#'  }
#'  
#'  # Using client with set fields
#'  client_with_fields <- set_fields(client, message = "sendeR_lapply is done!",
#'                                   destination = 12345)
#'  \dontrun{
#'      sendeR_lapply(client_with_fields, 1:10, my_func, "Sys.sleep:")
#'  }
#' 
#' @export
sendeR_lapply <- function(client, X, FUN, ...) {
    assert(is.client_sendeR(client), not_a_client("client", "sendeR"))
    
    args <- split_args(...)
    lapply_args <- args$Unnamed
    msg_args <- args$Named
    
    res <- do.call(function(...) lapply(X, FUN, ...), lapply_args) 
    do.call(function(...) send_message(client, ...), msg_args)
    
    res
}


split_args <- function(...) {
    args <- list(...)   
    named_args_indexes <- which(names(args) != "")
    
    named_args <- list()
    unnamed_args <- list()
    
    if (length(args) > 0) {
        named_args <- args[named_args_indexes]
        unnamed_args <- args[-named_args_indexes]
        
    
        if (length(named_args_indexes) == 0) {
            named_args <- list()
            unnamed_args <- args
        }
        
        if (length(named_args_indexes) == length(args)) {
            named_args <- args
            unnamed_args <- list()
        }
    }
    
    list("Named" = named_args, "Unnamed" = unnamed_args)
}
