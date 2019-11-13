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


# Internal httr package function licensed by Hadley Wickham and RStudio under
# MIT license (details: https://cran.r-project.org/web/packages/httr/).
# Source: httr package version 1.4.1
base64url <- function (x) {
    assert(package_installed("openssl"),
           "openssl package is required for performing base64 encoding")
    
    if (is.character(x)) {
        x <- charToRaw(x)
    }
    out <- chartr("+/", "-_", openssl::base64_encode(x))
    gsub("=+$", "", out)
}


# Function creates a simple MIME text message.
create_mime_message <- function(from, to, subject, message) {
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


# Function checks whether a package with given name exists.
package_installed <- function(package_name) {
    system.file(package = package_name) != ""
}


# Wraper for curl response return.
return_response <- function(response, verbose) {
    if (verbose) {
        return(response)
    }
    response$status_code
}
