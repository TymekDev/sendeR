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


# Generic method for internal default_fields methods.
default_fields <- function(client) {
    UseMethod("default_fields")
}


# Function encodes text message for POST request body.
encode_body <- function(msg) {
    text_enc <- openssl::base64_encode(as.character(msg))
    text_enc_url <- sub("=+$", "", chartr("+/", "-_", text_enc))
    body_enc <- sprintf('{"raw": "%s"}', text_enc_url)
    
    body_raw <- charToRaw(paste(body_enc, collapse = "\n"))
    list(
        post = TRUE,
        postfieldsize = length(body_raw),
        postfields = body_raw)
}


# Function creates a string representation of names and values of given fields
# within provided client.
format_fields <- function(client, field_names) {
    paste(
        sapply(field_names, function(f)
            tryCatch(sprintf(" - %s: %s", f, client[[f]]),
                     error = function(e) sprintf(" - %s: <could not print>", f))),
            collapse = "\n"
        )
}


# Function for creating standard error thrown during the notifieR_client type
# assertion.
not_a_client <- function(argument_name, service_name) {
    sprintf("provided <%s> argument is either incomplete or not a %s client.",
            argument_name, service_name)
}


# Wraper for curl response return.
return_response <- function(response, verbose) {
    if (verbose) {
        return(response)
    }
    response$status_code
}


# Function escapes URL special (reserved) characters in given text.
# This function is based on implementation of it's counterpart in Go language.
# Source: https://golang.org/pkg/net/url/#QueryEscape
url_escape_text <- function(text) {
    text_chars <- unlist(strsplit(text, ""))
    
    if (!any(sapply(text_chars, function(b) should_escape(b) && b != " "))) {
        return(text)
    }
    
    i <- 1
    res <- c()
    dict <- c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F")
    for (char in text_chars) {
        if (char == " ") {
            res[i] <- "+"
            i <- i + 1
            next
        }
        
        if (should_escape(char)) {
            res[i] <- "%"
            res[i+1] <- dict[bitwShiftR(to_byte(char), 4) + 1]
            res[i+2] <- dict[bitwAnd(to_byte(char), 15) + 1]
            i <- i + 3
            next
        }
        
        res[i] <- char
        i <- i + 1
    }
    
    paste(res, collapse = "")
}

# Function checks whether given character should be escaped.
should_escape <- function(character) {
    b <- to_byte(character)
    
    # §2.3 Unreserved characters (alphanum)
    if (is_between(b, "a", "z") || is_between(b, "A", "Z") || is_between(b, "0", "9")) {
        return(FALSE)
    }
    
    # §2.3 Unreserved characters (mark)
    if (is_any(b, c("-", "_", ".", "~"))) {
        return(FALSE)
    }
    
    TRUE
}

is_between <- function(b, lower, upper) {
    to_byte(lower) <= b && b <= to_byte(upper)
}

is_any <- function(b, characters) {
    b %in% sapply(characters, to_byte)
}

to_byte <- function(character) {
    as.numeric(charToRaw(character))
}