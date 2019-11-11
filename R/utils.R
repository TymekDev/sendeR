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