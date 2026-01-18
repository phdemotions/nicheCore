test_that("new_niche_recipe creates recipe objects", {
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123",
    defaults_applied = TRUE,
    steps = list(),
    outputs = list(),
    created = Sys.time()
  ))

  expect_s3_class(recipe, "niche_recipe")
  expect_true(is_niche_recipe(recipe))
})

test_that("is_niche_recipe works correctly", {
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123",
    defaults_applied = TRUE,
    steps = list(),
    outputs = list(),
    created = Sys.time()
  ))

  expect_true(is_niche_recipe(recipe))
  expect_false(is_niche_recipe(list()))
  expect_false(is_niche_recipe("not a recipe"))
})

test_that("validate_niche_recipe requires all fields", {
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123",
    defaults_applied = TRUE,
    steps = list(),
    outputs = list(),
    created = Sys.time()
  ))

  expect_invisible(validate_niche_recipe(recipe))

  # Missing field
  bad_recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123"
  ))

  expect_error(
    validate_niche_recipe(bad_recipe),
    "recipe\\$defaults_applied is missing"
  )
})

test_that("validate_niche_recipe checks field types", {
  # Non-logical defaults_applied
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123",
    defaults_applied = "yes",
    steps = list(),
    outputs = list(),
    created = Sys.time()
  ))

  expect_error(
    validate_niche_recipe(recipe),
    "recipe\\$defaults_applied is missing or not logical\\(1\\)"
  )

  # Non-POSIXct created
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123",
    defaults_applied = TRUE,
    steps = list(),
    outputs = list(),
    created = "2024-01-01"
  ))

  expect_error(
    validate_niche_recipe(recipe),
    "recipe\\$created is missing or not POSIXct"
  )

  # Non-list steps
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123",
    defaults_applied = TRUE,
    steps = "not a list",
    outputs = list(),
    created = Sys.time()
  ))

  expect_error(
    validate_niche_recipe(recipe),
    "recipe\\$steps is not a list"
  )
})

test_that("validate_niche_recipe rejects non-recipe objects", {
  expect_error(
    validate_niche_recipe(list()),
    "Object is not a niche_recipe"
  )
})

test_that("validate_niche_recipe allows extra fields for downstream extensibility", {
  # Downstream packages may add custom fields
  recipe <- new_niche_recipe(list(
    schema_version = "1.0.0",
    spec_hash = "abc123",
    defaults_applied = TRUE,
    steps = list(),
    outputs = list(),
    created = Sys.time(),
    # Extra fields that downstream packages might add
    execution_metadata = list(worker_id = "worker-01", cluster = "prod"),
    custom_config = list(baz = "qux")
  ))

  # Should not error on extra fields
  expect_invisible(validate_niche_recipe(recipe))

  # Extra fields should be preserved
  expect_equal(recipe$execution_metadata$worker_id, "worker-01")
  expect_equal(recipe$custom_config$baz, "qux")
})
