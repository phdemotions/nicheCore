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

test_that("assert_is_existing_dir works correctly", {
  tmp_dir <- tempdir()
  expect_invisible(assert_is_existing_dir(tmp_dir))

  # Non-existent directory
  expect_error(
    assert_is_existing_dir(file.path(tempdir(), "nonexistent")),
    "path does not exist"
  )

  # Non-character path
  expect_error(
    assert_is_existing_dir(123),
    "path must be a scalar character path"
  )
})

test_that("assert_unique_id works correctly", {
  df <- data.frame(id = 1:3, value = letters[1:3])

  expect_invisible(assert_unique_id(df, "id"))

  # Duplicate IDs
  df_dup <- data.frame(id = c(1, 2, 2, 3), value = letters[1:4])
  expect_error(
    assert_unique_id(df_dup, "id"),
    "Expected unique IDs in column 'id'; found duplicates: 2"
  )

  # Missing column
  expect_error(
    assert_unique_id(df, "missing_col"),
    "id_col 'missing_col' not found in df"
  )

  # Non-data frame
  expect_error(
    assert_unique_id(list(), "id"),
    "df must be a data frame"
  )
})

test_that("assert_unique_id handles multiple duplicates", {
  df <- data.frame(id = c(1, 2, 2, 3, 3, 3), value = 1:6)

  expect_error(
    assert_unique_id(df, "id"),
    "duplicates: 2, 3"
  )
})
