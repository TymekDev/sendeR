## notifieR
<!-- badges: start -->
  [![Travis build status](https://travis-ci.com/tmakowski/notifieR.svg?token=8VGPqiksfsHBtQHPsi4w&branch=master)](https://travis-ci.com/tmakowski/notifieR)
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->


### Overview
notifieR is a package whose premise is sending messages to various messaging and/or mailing services using a simple unified interface with as little dependencies as possible.

Package originated as a project for an Advanced R course at a Faculty of Mathematics and Information Science at the Warsaw University of Technology.


### Supported services
Note: services requiring OAuth2.0 require `httr` and `openssl` (`httr` dependency) packages installed.

 - [Gmail](https://gmail.com) **(OAuth2.0)**
 - [Slack](https://slack.com)
 - [Telegram](https://telegram.org/)


### Usage
1. Create a client for one of the supported services. For details on how to get access to the service's API please refer to given client's documentation.
1. Use `send_message` method on the created client.

```{r}
library("notifieR")
my_telegram_client <- client_telegram(<my_bot_token>)
send_message(my_telegram_client, "Hello world!", <chat_id>)
```


### How to contribute?
*Coming soon...*


### Planned features
- `quick_send_message` - method for sending notifications in one line (client creation not required). Note: only for clients not requiring OAuth.
- Searching system environment for required parameters during clients' construction if they are missing.
