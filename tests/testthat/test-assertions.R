test_that("assert_has_names works correctly", {
  x <- list(a = 1, b = 2, c = 3)

  expect_invisible(assert_has_names(x, c("a", "b")))
  expect_invisible(assert_has_names(x, c("a", "b", "c")))

  expect_error(
    assert_has_names(x, c("a", "d")),
    "x is missing required names: d"
  )

  expect_error(
    assert_has_names(x, c("a", "d", "e"), .arg = "my_list"),
    "my_list is missing required names: d, e"
  )
})

test_that("assert_is_scalar_character works correctly", {
  expect_invisible(assert_is_scalar_character("test"))

  expect_error(
    assert_is_scalar_character(c("a", "b")),
    "x must be a scalar character"
  )

  expect_error(
    assert_is_scalar_character(123),
    "x must be a scalar character"
  )

  expect_error(
    assert_is_scalar_character(character(0)),
    "x must be a scalar character"
  )

  expect_error(
    assert_is_scalar_character(123, .arg = "my_var"),
    "my_var must be a scalar character"
  )
})

test_that("assert_is_scalar_logical works correctly", {
  expect_invisible(assert_is_scalar_logical(TRUE))
  expect_invisible(assert_is_scalar_logical(FALSE))

  expect_error(
    assert_is_scalar_logical(c(TRUE, FALSE)),
    "x must be a scalar logical"
  )

  expect_error(
    assert_is_scalar_logical("yes"),
    "x must be a scalar logical"
  )

  expect_error(
    assert_is_scalar_logical(1, .arg = "my_flag"),
    "my_flag must be a scalar logical"
  )
})

test_that("assert_is_existing_file works correctly", {
  # Create a temporary file
  tmp_file <- tempfile()
  writeLines("test", tmp_file)
  on.exit(unlink(tmp_file))

  expect_invisible(assert_is_existing_file(tmp_file))

  # Non-existent file
  expect_error(
    assert_is_existing_file(tempfile()),
    "path does not exist"
  )

  # Directory instead of file
  tmp_dir <- tempdir()
  expect_error(
    assert_is_existing_file(tmp_dir),
    "path is not a file"
  )

  # Non-character path
  expect_error(
    assert_is_existing_file(123),
    "path must be a scalar character path"
  )
})

