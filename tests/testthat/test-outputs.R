test_that("niche_output_paths creates standard directories", {
  tmp_root <- tempfile()
  on.exit(unlink(tmp_root, recursive = TRUE))

  paths <- niche_output_paths(tmp_root)

  # Check structure
  expect_type(paths, "list")
  expect_named(
    paths,
    c("data", "audit", "models", "figures", "tables", "reports", "logs")
  )

  # Check directories were created
  for (path in paths) {
    expect_true(dir.exists(path))
  }

  # Check paths are correct
  expect_equal(paths$data, file.path(tmp_root, "data"))
  expect_equal(paths$audit, file.path(tmp_root, "audit"))
})

test_that("niche_output_paths is idempotent", {
  tmp_root <- tempfile()
  on.exit(unlink(tmp_root, recursive = TRUE))

  paths1 <- niche_output_paths(tmp_root)
  paths2 <- niche_output_paths(tmp_root)

  expect_equal(paths1, paths2)

  # Directories should still exist
  for (path in paths2) {
    expect_true(dir.exists(path))
  }
})

test_that("niche_output_paths validates root argument", {
  expect_error(
    niche_output_paths(123),
    "root must be a scalar character"
  )

  expect_error(
    niche_output_paths(c("a", "b")),
    "root must be a scalar character"
  )
})

test_that("write_audit_csv writes CSV correctly", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  df <- data.frame(
    x = 1:3,
    y = letters[1:3],
    stringsAsFactors = FALSE
  )

  csv_path <- file.path(tmp_dir, "test.csv")
  result <- write_audit_csv(df, csv_path)

  # Returns path invisibly
  expect_equal(result, csv_path)

  # File exists
  expect_true(file.exists(csv_path))

  # Can read back
  df_read <- read.csv(csv_path, stringsAsFactors = FALSE)
  expect_equal(df_read, df)
})

test_that("write_audit_csv creates parent directory", {
  tmp_dir <- tempfile()
  on.exit(unlink(tmp_dir, recursive = TRUE))

  df <- data.frame(x = 1:3)

  csv_path <- file.path(tmp_dir, "subdir", "test.csv")
  write_audit_csv(df, csv_path)

  expect_true(file.exists(csv_path))
})

test_that("write_audit_csv validates inputs", {
  expect_error(
    write_audit_csv(list(x = 1), "test.csv"),
    "df must be a data frame"
  )

  expect_error(
    write_audit_csv(data.frame(x = 1), 123),
    "path must be a scalar character"
  )
})

test_that("write_audit_json writes JSON correctly", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  obj <- list(a = 1, b = "test", c = TRUE)

  json_path <- file.path(tmp_dir, "test.json")
  result <- write_audit_json(obj, json_path)

  # Returns path invisibly
  expect_equal(result, json_path)

  # File exists
  expect_true(file.exists(json_path))

  # Can read back
  obj_read <- jsonlite::read_json(json_path)
  expect_equal(obj_read$a, 1)
  expect_equal(obj_read$b, "test")
  expect_equal(obj_read$c, TRUE)
})

test_that("write_audit_json creates parent directory", {
  tmp_dir <- tempfile()
  on.exit(unlink(tmp_dir, recursive = TRUE))

  obj <- list(x = 1)

  json_path <- file.path(tmp_dir, "subdir", "test.json")
  write_audit_json(obj, json_path)

  expect_true(file.exists(json_path))
})

test_that("write_audit_json validates inputs", {
  expect_error(
    write_audit_json(list(x = 1), 123),
    "path must be a scalar character"
  )
})

test_that("write_audit_json handles timestamps", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  obj <- list(timestamp = Sys.time())

  json_path <- file.path(tmp_dir, "test.json")
  write_audit_json(obj, json_path)

  # Read as text to check ISO8601 format
  content <- readLines(json_path)
  expect_true(any(grepl("\\d{4}-\\d{2}-\\d{2}T", content)))
})

test_that("write_audit_csv preserves column order", {
  tmp_dir <- tempfile()
  dir.create(tmp_dir)
  on.exit(unlink(tmp_dir, recursive = TRUE))

  df <- data.frame(
    z = 1:3,
    a = 4:6,
    m = 7:9
  )

  csv_path <- file.path(tmp_dir, "test.csv")
  write_audit_csv(df, csv_path)

  df_read <- read.csv(csv_path)
  expect_equal(names(df_read), c("z", "a", "m"))
})
