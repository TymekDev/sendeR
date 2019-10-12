# notifieR
<ToDo: those fancy things with CRAN version, passing build etc.>

<ToDo: repo schema>

<ToDo: draft of functionality>

## Usage
**(Not yet implemented)** It is possible to send a message with a one-liner command as shown in the example below.
```{r}
notifieR::send_message("telegram", "Hello world!", <chat_id>, telegram_token = <my_bot_token>)
```

Additionaly it is possible to create a client beforehand and then send messages with it.
```{r}
my_client <- notifieR::client_telegram(<my_bot_token>)
send_message(my_client, "Hello world!", <chat_it>)
```

## Implementation details
Each service needs a following set of objects implemented:
 1. It's own S4 class which contains all the required credentials for given service's API.
 1. A constructor function taking the required credentials to create the S4 class object and returning a client object.
 1. A `send_message` method for the S4 class which utilizes the credentials to send a provided message to a given destination.


## Task list
 - [ ] Organize docs: one doc per service instead of three (*class*, *constructor*, and *send_message*).
 - [ ] Add examples.
 - [ ] Verbose option to return whole response from curl.
 - [ ] Message confirming message sent.
 - [ ] Check for connection during `notifieR_client` creation.
 - [ ] Create tutorial for each service on how to obtain credentials for given API.


## Useful information (for development)
 - [C `Libcurl` API documentation](https://curl.haxx.se/libcurl/c/curl_easy_setopt.html) - `curl` package is only a wrapper for this lib and the documentation contains all options one can set via `curl::handle_setopt`.
 - Package creation infomration:
    - [Package description](http://r-pkgs.had.co.nz/description.html)
    - [roxygen2 object documentation](http://r-pkgs.had.co.nz/man.html)


## Questions
 - How to reffer to imported packages and there to put them in the `DESCRIPTION` file? Currently used: `methods`, `curl`.
 
 
## What next?
Here are couple ideas on further improvements of the package:
 - Reading credentials from environment variables at specific service's client level.
 - Set of functions (and a tutorial) for creating a custom service client.
 - Set custom `send_message` function options during client creation and from then on treat them as defaults in `send_message`.
