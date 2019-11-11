# Package utils ----------------------------------------------------------------

# Function creates a simple MIME text message.
create_mime_message <- function(from, to, subject, message){
    paste(
        'Content-Type: text/plain;charset="utf-8";',
        "MIME-Version: 1.0",
        paste("from:", from),
        paste("to:", to),
        paste("subject:", subject),
        paste0("\n", message),
        sep = '\n')
}


# Function encodes text message for POST request body.
#' @importFrom openssl base64_encode
encode_body <- function(msg) {
    text_enc <- base64_encode(as.character(msg)) 
    text_enc_url <- sub("=+$", "", chartr("+/", "-_", text_enc))
    body_enc <- sprintf('{"raw": "%s"}', text_enc_url)
    
    body_raw <- charToRaw(paste(body_enc, collapse = "\n"))
    list(
        post = TRUE,
        postfieldsize = length(body_raw),
        postfields = body_raw)
}


# Package utils ----------------------------------------------------------------

# Function adds a new class to a given object.
add_class <- function(object, new_class, as_first = TRUE) {
    if (as_first) {
        classes_new <- c(new_class, class(object))
    } else {
        classes_new <- c(class(object), new_class)
    }
    
    class(object) <- classes_new
    object
}


# A stop wrapper which stops only if a condition is not met and displays
# provided message.
assert <- function(condition, ...) {
    if (!condition) {
        stop(paste(...), call. = FALSE)
    }
}

# Generic method for internal default_fields methods.
default_fields <- function(client) {
    UseMethod("default_fields")
}


# Function creates a string representation of names and values of given fields
# within provided client.
format_fields <- function(client, field_names) {
    paste(
        sapply(field_names, function(f)
            tryCatch(sprintf(" - %s: %s", f, client[[f]]),
                     error = function(e) sprintf(" - %s: <could not format field>", f))),
            collapse = "\n"
        )
}


# Function for creating standard error thrown during the client_notifieR type
# assertion.
not_a_client <- function(argument_name, service_name) {
    sprintf("provided <%s> argument is either incomplete or not a %s client.",
            argument_name, service_name)
}


# Wraper for curl response return.
return_response <- function(response, verbose, decode_response) {
    if (verbose) {
        if (decode_response) {
            response$headers <- rawToChar(response$headers)
            response$content <- rawToChar(response$content)
        }
        return(response)
    }
    response$status_code
}
