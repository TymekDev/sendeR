# A stop wrapper which stops only if a condition is not met. When stopping
# a message appears with information about: function name where assert failed,
# failed condition and additional details.
assert <- function(condition, details) {
    condition_string <- deparse(substitute(condition))
    parent_func <- as.character(sys.call(-1)[1])
    
    if (!condition) {
        stop(sprintf("%s: Check for <%s> failed:\n  %s.",
                     parent_func, condition_string, details), call. = FALSE)
    }
}


# Common assert condition functions --------------------------------------------
is_character_len1 <- function(x) {
    is.character(x) && length(x) == 1
}


is_char_num_len1 <- function(x) {
    (is.character(x) || is.numeric(x) || is.integer(x) || is.double(x)) &&
        length(x) == 1
}


is_logical_not_NA <- function(x) {
    is.logical(x) && !is.na(x)
}


# Error message functions ------------------------------------------------------
msg_character_len1 <- function(arg_name) {
    paste(arg_name, "argument has to be a character vector of length 1")
}


msg_char_num_len1 <- function(arg_name) {
    paste(arg_name,
          "argument has to be a character or numeric vector of length 1")
}


msg_logical_not_NA <- function(arg_name) {
    paste(arg_name, "argument has to be either TRUE or FALSE")
}


not_a_client <- function(argument_name, service_name) {
    sprintf("provided <%s> argument is either incomplete or not a %s client",
            argument_name, service_name)
}
