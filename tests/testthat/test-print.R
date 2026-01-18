test_that("print.niche_spec works correctly", {
  spec <- new_niche_spec(list(
    meta = list(),
    data = list(),
    vars = list(age = list(), income = list()),
    rules = list(rule1 = list()),
    scales = list(),
    models = list(model1 = list(), model2 = list()),
    outputs = list(root = "outputs"),
    schema_version = "1.0.0",
    source = "manual"
  ))

  # Verify print runs without error and returns invisibly
  expect_no_error(print(spec))
  result <- withVisible(print(spec))
  expect_false(result$visible)
  expect_equal(result$value, spec)

  # Verify structure
  expect_equal(spec$schema_version, "1.0.0")
  expect_equal(spec$source, "manual")
  expect_equal(length(spec$vars), 2)
  expect_equal(length(spec$rules), 1)
})

test_that("print.niche_recipe works correctly", {
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123def456",
    defaults_applied = TRUE,
    steps = list(step1 = list(), step2 = list()),
    outputs = list(root = "outputs"),
    created = as.POSIXct("2024-01-01 12:00:00", tz = "UTC")
  ))

  # Verify print runs without error and returns invisibly
  expect_no_error(print(recipe))
  result <- withVisible(print(recipe))
  expect_false(result$visible)
  expect_equal(result$value, recipe)

  # Verify structure
  expect_equal(recipe$schema_version, "1.0.0")
  expect_true(grepl("abc123", recipe$spec_hash))
  expect_equal(recipe$defaults_applied, TRUE)
})

test_that("print.niche_result works correctly", {
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123",
    defaults_applied = TRUE,
    steps = list(),
    outputs = list(root = "outputs"),
    created = Sys.time()
  ))

  result <- new_niche_result(list(
    recipe = recipe,
    outputs = list(data1 = list(), data2 = list()),
    artifacts = list(plot1 = "path/to/plot.png"),
    session_info = sessionInfo(),
    warnings = c("warning1", "warning2"),
    created = as.POSIXct("2024-01-01 12:00:00", tz = "UTC")
  ))

  # Verify print runs without error and returns invisibly
  expect_no_error(print(result))
  print_result <- withVisible(print(result))
  expect_false(print_result$visible)
  expect_equal(print_result$value, result)

  # Verify structure
  expect_equal(result$recipe$schema_version, "1.0.0")
  expect_equal(length(result$outputs), 2)
  expect_equal(length(result$warnings), 2)
})

test_that("print methods return invisibly", {
  spec <- new_niche_spec(list(
    meta = list(),
    data = list(),
    vars = list(),
    rules = list(),
    scales = list(),
    models = list(),
    outputs = list(),
    schema_version = "1.0.0",
    source = "test"
  ))

  result <- withVisible(print(spec))
  expect_false(result$visible)
  expect_equal(result$value, spec)
})

test_that("print methods include key information", {
  spec <- new_niche_spec(list(
    meta = list(),
    data = list(),
    vars = list(age = list(), income = list()),
    rules = list(rule1 = list()),
    scales = list(),
    models = list(model1 = list(), model2 = list()),
    outputs = list(root = "outputs"),
    schema_version = "1.0.0",
    source = "manual"
  ))

  # Just verify print runs without error
  expect_no_error(print(spec))

  # Verify structure is correct
  expect_equal(spec$schema_version, "1.0.0")
  expect_equal(spec$source, "manual")
  expect_equal(length(spec$vars), 2)
  expect_equal(length(spec$rules), 1)
  expect_equal(length(spec$models), 2)
})

test_that("print methods handle partial objects gracefully", {
  # Partial spec (e.g., during debugging)
  partial_spec <- new_niche_spec(list(
    meta = list(),
    schema_version = "1.0.0"
  ))

  # Should not error even though many fields are missing
  expect_no_error(print(partial_spec))

  # Partial recipe
  partial_recipe <- new_niche_recipe(list(
    schema_version = "1.0.0"
  ))

  expect_no_error(print(partial_recipe))

  # Partial result (with minimal recipe)
  minimal_recipe <- new_niche_recipe(list(schema_version = "1.0.0"))
  partial_result <- new_niche_result(list(
    recipe = minimal_recipe
  ))

  expect_no_error(print(partial_result))
})
