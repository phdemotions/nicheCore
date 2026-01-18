test_that("new_niche_spec creates spec objects", {
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

  expect_s3_class(spec, "niche_spec")
  expect_true(is_niche_spec(spec))
})

test_that("is_niche_spec works correctly", {
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

  expect_true(is_niche_spec(spec))
  expect_false(is_niche_spec(list()))
  expect_false(is_niche_spec("not a spec"))
})

test_that("validate_niche_spec requires all fields", {
  # Valid spec
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

  expect_invisible(validate_niche_spec(spec))

  # Missing field
  bad_spec <- new_niche_spec(list(
    meta = list(),
    data = list()
  ))

  expect_error(
    validate_niche_spec(bad_spec),
    "spec\\$vars is missing"
  )
})

test_that("validate_niche_spec checks field types", {
  # Non-list meta
  spec <- new_niche_spec(list(
    meta = "not a list",
    data = list(),
    vars = list(),
    rules = list(),
    scales = list(),
    models = list(),
    outputs = list(),
    schema_version = "1.0.0",
    source = "test"
  ))

  expect_error(
    validate_niche_spec(spec),
    "spec\\$meta is not a list"
  )

  # Non-character schema_version
  spec <- new_niche_spec(list(
    meta = list(),
    data = list(),
    vars = list(),
    rules = list(),
    scales = list(),
    models = list(),
    outputs = list(),
    schema_version = 1.0,
    source = "test"
  ))

  expect_error(
    validate_niche_spec(spec),
    "spec\\$schema_version is missing or not character\\(1\\)"
  )

  # Non-scalar source
  spec <- new_niche_spec(list(
    meta = list(),
    data = list(),
    vars = list(),
    rules = list(),
    scales = list(),
    models = list(),
    outputs = list(),
    schema_version = "1.0.0",
    source = c("test1", "test2")
  ))

  expect_error(
    validate_niche_spec(spec),
    "spec\\$source is missing or not character\\(1\\)"
  )
})

test_that("validate_niche_spec rejects non-spec objects", {
  expect_error(
    validate_niche_spec(list()),
    "Object is not a niche_spec"
  )
})

test_that("validate_niche_spec allows extra fields for downstream extensibility", {
  # Downstream packages may add custom fields
  spec <- new_niche_spec(list(
    meta = list(),
    data = list(),
    vars = list(),
    rules = list(),
    scales = list(),
    models = list(),
    outputs = list(),
    schema_version = "1.0.0",
    source = "test",
    # Extra fields that downstream packages might add
    custom_metadata = list(author = "vision", version = "2.0"),
    extra_config = list(foo = "bar"),
    future_field = "some_value"
  ))

  # Should not error on extra fields
  expect_invisible(validate_niche_spec(spec))

  # Extra fields should be preserved
  expect_equal(spec$custom_metadata$author, "vision")
  expect_equal(spec$extra_config$foo, "bar")
  expect_equal(spec$future_field, "some_value")
})
