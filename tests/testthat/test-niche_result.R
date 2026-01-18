test_that("new_niche_result creates result objects", {
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123",
    defaults_applied = TRUE,
    steps = list(),
    outputs = list(),
    created = Sys.time()
  ))

  result <- new_niche_result(list(
    recipe = recipe,
    outputs = list(),
    artifacts = list(),
    session_info = sessionInfo(),
    warnings = character(0),
    created = Sys.time()
  ))

  expect_s3_class(result, "niche_result")
  expect_true(is_niche_result(result))
})

test_that("is_niche_result works correctly", {
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123",
    defaults_applied = TRUE,
    steps = list(),
    outputs = list(),
    created = Sys.time()
  ))

  result <- new_niche_result(list(
    recipe = recipe,
    outputs = list(),
    artifacts = list(),
    session_info = sessionInfo(),
    warnings = character(0),
    created = Sys.time()
  ))

  expect_true(is_niche_result(result))
  expect_false(is_niche_result(list()))
  expect_false(is_niche_result("not a result"))
})

test_that("validate_niche_result requires all fields", {
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123",
    defaults_applied = TRUE,
    steps = list(),
    outputs = list(),
    created = Sys.time()
  ))

  result <- new_niche_result(list(
    recipe = recipe,
    outputs = list(),
    artifacts = list(),
    session_info = sessionInfo(),
    warnings = character(0),
    created = Sys.time()
  ))

  expect_invisible(validate_niche_result(result))

  # Missing field
  bad_result <- new_niche_result(list(
    recipe = recipe,
    outputs = list()
  ))

  expect_error(
    validate_niche_result(bad_result),
    "result\\$artifacts is missing"
  )
})

test_that("validate_niche_result checks field types", {
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123",
    defaults_applied = TRUE,
    steps = list(),
    outputs = list(),
    created = Sys.time()
  ))

  # Non-recipe recipe
  result <- new_niche_result(list(
    recipe = list(),
    outputs = list(),
    artifacts = list(),
    session_info = sessionInfo(),
    warnings = character(0),
    created = Sys.time()
  ))

  expect_error(
    validate_niche_result(result),
    "result\\$recipe is not a niche_recipe object"
  )

  # Non-character warnings
  result <- new_niche_result(list(
    recipe = recipe,
    outputs = list(),
    artifacts = list(),
    session_info = sessionInfo(),
    warnings = 123,
    created = Sys.time()
  ))

  expect_error(
    validate_niche_result(result),
    "result\\$warnings is not a character vector"
  )

  # Non-POSIXct created
  result <- new_niche_result(list(
    recipe = recipe,
    outputs = list(),
    artifacts = list(),
    session_info = sessionInfo(),
    warnings = character(0),
    created = "2024-01-01"
  ))

  expect_error(
    validate_niche_result(result),
    "result\\$created is missing or not POSIXct"
  )
})

test_that("validate_niche_result rejects non-result objects", {
  expect_error(
    validate_niche_result(list()),
    "Object is not a niche_result"
  )
})

test_that("validate_niche_result allows extra fields for downstream extensibility", {
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123",
    defaults_applied = TRUE,
    steps = list(),
    outputs = list(),
    created = Sys.time()
  ))

  # Downstream packages may add custom fields
  result <- new_niche_result(list(
    recipe = recipe,
    outputs = list(),
    artifacts = list(),
    session_info = sessionInfo(),
    warnings = character(0),
    created = Sys.time(),
    # Extra fields that downstream packages might add
    performance_metrics = list(runtime_seconds = 42.5, memory_mb = 128),
    custom_diagnostics = list(convergence = TRUE)
  ))

  # Should not error on extra fields
  expect_invisible(validate_niche_result(result))

  # Extra fields should be preserved
  expect_equal(result$performance_metrics$runtime_seconds, 42.5)
  expect_equal(result$custom_diagnostics$convergence, TRUE)
})
