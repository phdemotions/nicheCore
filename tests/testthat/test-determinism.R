test_that("stable_order sorts deterministically", {
  df <- data.frame(
    x = c(3, 1, NA, 2, NA),
    y = c("a", "b", "c", "d", "e"),
    stringsAsFactors = FALSE
  )

  sorted <- stable_order(df, "x")

  # NAs should be at the end
  expect_equal(sorted$x[1:3], c(1, 2, 3))
  expect_true(all(is.na(sorted$x[4:5])))

  # Check corresponding y values
  expect_equal(sorted$y[1:3], c("b", "d", "a"))
})

test_that("stable_order handles multiple columns", {
  df <- data.frame(
    x = c(1, 1, 2, 2),
    y = c("b", "a", "d", "c"),
    stringsAsFactors = FALSE
  )

  sorted <- stable_order(df, c("x", "y"))

  expect_equal(sorted$x, c(1, 1, 2, 2))
  expect_equal(sorted$y, c("a", "b", "c", "d"))
})

test_that("stable_order errors on missing columns", {
  df <- data.frame(x = 1:3, y = letters[1:3])

  expect_error(
    stable_order(df, c("x", "z")),
    "Columns not found in df: z"
  )
})

test_that("stable_order errors on non-data.frame", {
  expect_error(
    stable_order(list(x = 1:3), "x"),
    "df must be a data frame"
  )
})

test_that("stable_order handles factors correctly", {
  df <- data.frame(
    x = factor(c("b", "a", "c", "a"), levels = c("c", "b", "a")),
    y = 1:4,
    stringsAsFactors = FALSE
  )

  sorted <- stable_order(df, "x")

  # Factors should be sorted by level order, not alphabetically
  expect_equal(as.character(sorted$x), c("c", "b", "a", "a"))
  expect_equal(sorted$y, c(3, 1, 2, 4))
})

test_that("hash_object produces stable hashes", {
  obj1 <- list(a = 1, b = 2, c = 3)
  obj2 <- list(a = 1, b = 2, c = 3)

  hash1 <- hash_object(obj1)
  hash2 <- hash_object(obj2)

  expect_equal(hash1, hash2)
  expect_type(hash1, "character")
  expect_equal(nchar(hash1), 64) # SHA-256 hex digest length
})

test_that("hash_object distinguishes different objects", {
  obj1 <- list(a = 1, b = 2)
  obj2 <- list(a = 1, b = 3)

  hash1 <- hash_object(obj1)
  hash2 <- hash_object(obj2)

  expect_false(hash1 == hash2)
})

test_that("hash_file produces stable hashes", {
  tmp_file <- tempfile()
  writeLines(c("line1", "line2", "line3"), tmp_file)
  on.exit(unlink(tmp_file))

  hash1 <- hash_file(tmp_file)
  hash2 <- hash_file(tmp_file)

  expect_equal(hash1, hash2)
  expect_type(hash1, "character")
  expect_equal(nchar(hash1), 64)
})

test_that("hash_file distinguishes different files", {
  tmp_file1 <- tempfile()
  tmp_file2 <- tempfile()
  writeLines("content1", tmp_file1)
  writeLines("content2", tmp_file2)
  on.exit(unlink(c(tmp_file1, tmp_file2)))

  hash1 <- hash_file(tmp_file1)
  hash2 <- hash_file(tmp_file2)

  expect_false(hash1 == hash2)
})

test_that("hash_file errors on non-existent file", {
  expect_error(
    hash_file(tempfile()),
    "path does not exist"
  )
})

test_that("with_seed sets and restores RNG state", {
  # Get initial state
  set.seed(999)
  val_before <- runif(1)

  # Use with_seed
  val_in_seed <- with_seed(123, runif(1))

  # Check that RNG state was restored
  val_after <- runif(1)

  # The value after should continue from before (not from seed 123)
  set.seed(999)
  expected_before <- runif(1)
  expected_after <- runif(1)

  expect_equal(val_before, expected_before)
  expect_equal(val_after, expected_after)

  # The value inside with_seed should match seed 123
  set.seed(123)
  expected_in_seed <- runif(1)
  expect_equal(val_in_seed, expected_in_seed)
})

test_that("with_seed restores state even on error", {
  set.seed(999)
  runif(1)

  expect_error(
    with_seed(123, stop("error!")),
    "error!"
  )

  # RNG state should still be restored
  val_after_error <- runif(1)

  set.seed(999)
  runif(1)
  expected <- runif(1)

  expect_equal(val_after_error, expected)
})

test_that("with_seed validates seed argument", {
  expect_error(
    with_seed("not a number", runif(1)),
    "seed must be a scalar numeric"
  )

  expect_error(
    with_seed(c(1, 2), runif(1)),
    "seed must be a scalar numeric"
  )
})

test_that("with_seed handles no prior seed state", {
  # Remove any existing seed
  if (exists(".Random.seed", envir = .GlobalEnv)) {
    old_seed <- get(".Random.seed", envir = .GlobalEnv)
    rm(".Random.seed", envir = .GlobalEnv)
    on.exit(assign(".Random.seed", old_seed, envir = .GlobalEnv))
  }

  # Should work without error
  val <- with_seed(123, runif(1))
  expect_type(val, "double")

  # After with_seed, .Random.seed should not exist (restored to NULL state)
  expect_false(exists(".Random.seed", envir = .GlobalEnv))
})
