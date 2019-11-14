test_that("creates only with correct argument type", {
  expect_error(client_slack(NA), "argument has to be a character vector of length 1.")
  expect_error(client_slack(NULL), "argument has to be a character vector of length 1.")
  expect_error(client_slack(12), "argument has to be a character vector of length 1.")
  expect_error(client_slack(c("a", "b")), "argument has to be a character vector of length 1.")
})
