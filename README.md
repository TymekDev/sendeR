# notifieR

## Usage
It is possible to send a message with a one-liner command as shown in the example below.
```{r}
notifieR::send_message("telegram", "Hello world!", <chat_id>, telegram_token = <my_bot_token>)
```

Additionaly it is possible to create a client beforehand and then send messages with it.
```{r}
my_client <- notifieR::client_telegram(<my_bot_token>)
send_message(my_client, "Hello world!", <chat_id>)
```

## Task list
 - [ ] Update documentation:
     - [ ] Creation of custom client.
     - [ ] Available clients.
     - [ ] `send_message`.
 - [ ] Add Travis.
 - [ ] Check for connection during `notifieR_client` creation.
 - [ ] Create tutorial for each service on how to obtain credentials for given API.
 - [ ] Reading credentials from environment variables.
 - [ ] Describe development requirements for additional services (the schema in the package).


## Useful information (for development)
 - [C libcurl API documentation](https://curl.haxx.se/libcurl/c/curl_easy_setopt.html) - `curl` package is only a wrapper for this lib and the documentation contains all options one can set via `curl::handle_setopt`.
 - Package creation infomration:
    - [Package description](http://r-pkgs.had.co.nz/description.html)
    - [roxygen2 object documentation](http://r-pkgs.had.co.nz/man.html)
