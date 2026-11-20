test_that("RemoveSeasonal 正确去季节", {
  res <- RemoveSeasonal(1:4, c(101, 101, 102, 102))
  expect_equal(res$mu, c(1.5, 3.5))
  expect_equal(res$anomaly, c(-0.5, 0.5, -0.5, 0.5))
})

test_that("LS_OneBreak 单断点拟合正确", {
  x <- 1:10
  y <- c(1:5, 11:15)
  res <- LS_OneBreak(y, x, 5)
  expect_length(res$fitted, 10)
  expect_equal(res$fitted, y)
  expect_true(is.numeric(res$SSE))
})

test_that("LS_MultiBreaks 多断点拟合正确", {
  x <- 1:10
  y <- c(1:5, 11:15)
  res <- LS_MultiBreaks(y, x, c(5, 10))
  expect_length(res$fitted, 10)
  expect_equal(res$fitted, y)
})