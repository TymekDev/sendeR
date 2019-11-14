test_that("creates only with correct argument type", {
    expect_error(client_telegram(NA), "argument has to be a character vector of length 1.")
    expect_error(client_telegram(NULL), "argument has to be a character vector of length 1.")
    expect_error(client_telegram(12), "argument has to be a character vector of length 1.")
    expect_error(client_telegram(c("a", "b")), "argument has to be a character vector of length 1.")
})
