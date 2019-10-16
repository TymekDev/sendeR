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
