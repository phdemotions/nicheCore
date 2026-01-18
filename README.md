# nicheCore

<!-- badges: start -->
<!-- badges: end -->

`nicheCore` is the shared foundation for the niche ecosystem. It provides standardized S3 classes, validation logic, deterministic helpers, and output conventions that all niche packages build upon.

## Installation

You can install the development version of nicheCore from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("phdemotions/nicheCore")
```

## Core Features

### Standardized S3 Classes

`nicheCore` defines three core classes representing the analysis lifecycle:

- **`niche_spec`**: Analysis specification with metadata, data config, variables, rules, scales, models, and outputs
- **`niche_recipe`**: Processed recipe with applied defaults and execution steps
- **`niche_result`**: Results containing outputs, artifacts, and session information

Each class has constructors (`new_*`), predicates (`is_*`), and validators (`validate_*`).

```r
library(nicheCore)

# Create and validate a spec
spec <- new_niche_spec(list(
  meta = list(title = "My Analysis"),
  data = list(),
  vars = list(age = list(), income = list()),
  rules = list(),
  scales = list(),
  models = list(),
  outputs = list(root = "outputs"),
  schema_version = "1.0.0",
  source = "manual"
))

validate_niche_spec(spec)
print(spec)
```

### Deterministic Helpers

Ensure reproducible results across platforms and sessions:

```r
# Stable sorting with consistent NA handling
df <- data.frame(x = c(3, 1, NA, 2), y = letters[1:4])
stable_order(df, "x")

# Reproducible hashing
hash_object(list(a = 1, b = 2))
hash_file("mydata.csv")

# Temporary seed with automatic restoration
with_seed(123, rnorm(5))
```

### Output Management

Standardized directory structure and audit trails:

```r
# Create standard output directories
paths <- niche_output_paths("outputs")
# Creates: data, audit, models, figures, tables, reports, logs

# Write audit trails
df <- data.frame(action = "load", status = "success")
write_audit_csv(df, file.path(paths$audit, "log.csv"))

meta <- list(version = "1.0.0", created = Sys.time())
write_audit_json(meta, file.path(paths$audit, "metadata.json"))
```

### Validation and Assertions

Fail-fast validation with actionable error messages:

```r
# Validate object structure
assert_has_names(obj, c("required", "fields"))

# Type validation
assert_is_scalar_character("test")
assert_is_scalar_logical(TRUE)

# Data validation
df <- data.frame(id = 1:10, value = rnorm(10))
assert_unique_id(df, "id")

# Path validation
assert_is_existing_file("data.csv")
assert_is_existing_dir("outputs")
```

### Standardized Conditions

Structured error and warning handling:

```r
# Raise validation errors
niche_abort("Invalid spec structure", class = "invalid_spec")

# Raise warnings
niche_warn("Deprecated field used", class = "deprecated_field")
```

## Architecture

`nicheCore` is the **sole authority** for:

- The structure of `niche_spec`, `niche_recipe`, and `niche_result`
- Required fields for these classes
- Validation logic for these objects

Downstream packages may read and populate these objects but must **not** redefine their structure or validation. Any generally useful logic across packages must live in `nicheCore`.

## Design Principles

- **Fail-fast validation**: No silent coercions
- **Deterministic behavior**: Stable ordering, stable hashes, reproducible outputs
- **Minimal dependencies**: Core functionality only
- **CRAN-ready**: Comprehensive documentation and tests

## Development

Run local checks:

```r
# Generate documentation
devtools::document()

# Run tests
devtools::test()

# Full package check
devtools::check()
```

## License

MIT License. See LICENSE file for details.
