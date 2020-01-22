#' @title sendeR txtProgressBar
#' 
#' @description This function is a wrapper for \code{\link{txtProgressBar}}.
#'  In addition to standard \code{txtProgressBar} functionality this function
#'  will send message using \code{\link{send_message}} method of the
#'  \code{client} argument. Parameters other than \code{client} and \code{...}
#'  have the same use-case as in the \code{txtProgressBar} (description of these
#'  parameters was taken from \code{txtProgressBar} documentation).
#'  
#' @param client the client which will send the message.
#' @param min,max (finite) numeric values for the extremes of the progress bar.
#'  Must have \code{min} < \code{max}.
#' @param initial initial or new value for the progress bar. See ‘Details’
#'  in \code{\link{txtProgressBar}} for what happens with invalid values.
#' @param char the character (or character string) to form the progress bar.
#' @param width the width of the progress bar, as a multiple of the width of
#'  char. If NA, the default, the number of characters is that which fits into
#'  \code{getOption("width")}.
#' @param style	the ‘style’ of the bar – see ‘Details’ in
#'  \code{\link{txtProgressBar}}.
#' @param file an open connection object or "" which indicates the console:
#'  stderr() might be useful here.
#' @param title,label ignored, for compatibility with other progress bars.
#' @param ... additional parameters to be passed to the \code{\link{send_message}}
#'  method (including \code{message} and \code{destination}).
#'  
#' @details \strong{Note:} If the \code{client} has no fields set then the
#'  \code{message} and \code{destination} have to be passed through the ellipsis
#'  (\code{...}).
#'  
#' @return A progress bar object on which every method normally used on
#'  \code{txtProgressBar} can be used.
#' 
#' @seealso \code{\link{getTxtProgressBar}}, \code{\link{setTxtProgressBar}}
#'  
#' @importFrom utils txtProgressBar
#' 
#' @examples 
#' client <- client_slack("my_webhook")
#' pb <- sendeR_txtProgressBar(client, message = "Progress bar has finished!")
#' \dontrun{
#'      for (i in 1:10) {
#'          Sys.sleep(0.5)
#'          setTxtProgressBar(pb, i / 10)
#'      }
#' }
#' 
#' @export
sendeR_txtProgressBar <- function(client, min = 0, max = 1, initial = 0, 
                                  char = "=", width = NA, title, label,
                                  style = 1, file = "", ...) {
    
    pb <- txtProgressBar(min, max, initial, char, width, title, label, style,
                         file)
    
    # Saving original up function.
    orig_up <- pb$up
    
    # Replacing up function with the one which will send message after reaching
    # max on progress bar.
    pb$up <- function(value) {
        orig_up(value)
    
        if (value == max) {
            invisible(
                do.call(function(...) send_message(client, ...), list(...))
            )
        }
    }
    
    pb
}
