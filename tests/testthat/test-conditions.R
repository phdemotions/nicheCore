test_that("niche_abort creates validation errors", {
  expect_error(
    niche_abort("test error"),
    class = "niche_validation_error"
  )

  err <- tryCatch(
    niche_abort("test error", class = "custom_error"),
    error = function(e) e
  )
  expect_s3_class(err, c("custom_error", "niche_validation_error"))
})

test_that("niche_warn creates validation warnings", {
  expect_warning(
    niche_warn("test warning"),
    class = "niche_validation_warning"
  )

  wrn <- tryCatch(
    {
      niche_warn("test warning", class = "custom_warning")
      NULL
    },
    warning = function(w) w
  )
  expect_s3_class(wrn, c("custom_warning", "niche_validation_warning"))
})

test_that("conditions include custom fields", {
  err <- tryCatch(
    niche_abort("test", field = "custom_value"),
    error = function(e) e
  )

  expect_equal(err$field, "custom_value")
})
