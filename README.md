# notifieR
<!-- badges: start -->
  [![Travis build status](https://travis-ci.com/tmakowski/notifieR.svg?token=8VGPqiksfsHBtQHPsi4w&branch=master)](https://travis-ci.com/tmakowski/notifieR)
<!-- badges: end -->

TODO: update the README.

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

### How to implement a client for new service?
New clients should be well documented and their class should be named accordingly to the convention. Following set of functionalities should be implemented:
 1. Function named `client_<service>` returning an object of a class of the same name. The object should be an extended `notifieR_client` and any field within the object should have the same name as arguments passed to the function.
 1. Method `default_fields.client_<service>` returning vector of field (constructor arguments) names.
 1. Function `is.client_<service>` - preferably checking if: (1) object has all required fields are present, (2) object inherits `client_<service>` and (3) object is a `notifieR_client`.
 1. Method `send_message.client_<service>` returning either a response's status code or whole response if verbose.
