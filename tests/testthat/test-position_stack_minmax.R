context("position_stack_minmax")

test_that("incorrect kept.origin used", {
  expect_error(
    position_stack_minmax(kept.origin = "") #,
    #    "`kept.origin` must be one of \"stacked\", \"original\", or \"none\", not \"\"."
    # rlang arg_match() adds to the error message characters that break expect_error()
  )
})

test_that("correct kept.origin used", {
  position <- position_stack_minmax(kept.origin = "none")
  expect_no_error(position)
})

test_that("correct kept.origin used", {
  position <- position_stack_minmax(kept.origin = "original")
  expect_no_error(position)
})

test_that("incorrect direction used", {
  expect_error(
    position_stack_minmax(direction = "") #,
    #    "`kept.origin` must be one of \"stacked\", \"original\", or \"none\", not \"\"."
    # rlang arg_match() adds to the error message characters that break expect_error()
  )
})

test_that("correct direction used", {
  position <- position_stack_minmax(direction = "none")
  expect_no_error(position)
})

test_that("correct direction used", {
  position <- position_stack_minmax(direction = "split")
  expect_no_error(position)
})

test_that("correct direction used", {
  position <- position_stack_minmax(direction = "split.x")
  expect_no_error(position)
})

test_that("correct direction used", {
  position <- position_stack_minmax(direction = "split.y")
  expect_no_error(position)
})

test_that("test vjust, reverse, x, y and kept.origin arguments", {
position <- position_stack_minmax()
expect_identical(position$vjust, 1)
expect_identical(position$reverse, FALSE)
expect_identical(position$x, 0)
expect_identical(position$y, 0)
expect_identical(position$kept.origin, "stacked")
expect_identical(position$var, "y")
expect_identical(position$fill, FALSE)
})
