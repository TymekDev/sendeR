test_that("creates only with correct argument type", {
  expect_error(client_gmail(NA), "argument has to be a character vector of length 1.")
  expect_error(client_gmail(NULL), "argument has to be a character vector of length 1.")
  expect_error(client_gmail(12), "argument has to be a character vector of length 1.")
  expect_error(client_gmail(c("a", "b")), "argument has to be a character vector of length 1.")
  
  expect_error(client_gmail(email = 'abc@gmail.com', NA), "argument has to be a character vector of length 1.")
  expect_error(client_gmail(email = 'abc@gmail.com', NULL), "argument has to be a character vector of length 1.")
  expect_error(client_gmail(email = 'abc@gmail.com', 12), "argument has to be a character vector of length 1.")
  expect_error(client_gmail(email = 'abc@gmail.com', c("a", "b")), "argument has to be a character vector of length 1.")
})
