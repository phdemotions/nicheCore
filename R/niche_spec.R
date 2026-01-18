#' Niche Spec Class
#'
#' @description
#' The `niche_spec` class defines the canonical structure for niche
#' specifications. Only nicheCore may define required fields and validation
#' logic for this class.
#'
#' @param x A list containing spec fields.
#'
#' @return
#' - `new_niche_spec()`: A `niche_spec` object (no validation).
#' - `is_niche_spec()`: Logical indicating whether object has class `niche_spec`.
#' - `validate_niche_spec()`: The validated spec (invisibly), or an error.
#'
#' @details
#' Required fields:
#' - `meta`: list with metadata
#' - `data`: list with data configuration
#' - `vars`: list with variable definitions
#' - `rules`: list with business rules
#' - `scales`: list with scaling configuration
#' - `models`: list with model specifications
#' - `outputs`: list with output configuration
#' - `schema_version`: character(1) version string
#' - `source`: character(1) source identifier
#'
#' @examples
#' spec <- new_niche_spec(list(
#'   meta = list(),
#'   data = list(),
#'   vars = list(),
#'   rules = list(),
#'   scales = list(),
#'   models = list(),
#'   outputs = list(),
#'   schema_version = "1.0.0",
#'   source = "manual"
#' ))
#' is_niche_spec(spec)
#' validate_niche_spec(spec)
#'
#' @name niche_spec
NULL

#' @rdname niche_spec
#' @export
new_niche_spec <- function(x) {
  stopifnot(is.list(x))
  structure(x, class = "niche_spec")
}

#' @rdname niche_spec
#' @export
is_niche_spec <- function(x) {
  inherits(x, "niche_spec")
}

#' @rdname niche_spec
#' @export
validate_niche_spec <- function(x) {
  if (!is_niche_spec(x)) {
    niche_abort("Object is not a niche_spec")
  }

  required_fields <- c("meta", "data", "vars", "rules", "scales",
                       "models", "outputs", "schema_version", "source")

  for (field in required_fields) {
    if (!field %in% names(x)) {
      niche_abort(sprintf("spec$%s is missing", field))
    }
  }

  # Validate list fields
  list_fields <- c("meta", "data", "vars", "rules", "scales", "models", "outputs")
  for (field in list_fields) {
    if (!is.list(x[[field]])) {
      niche_abort(sprintf("spec$%s is not a list", field))
    }
  }

  # Validate scalar character fields
  if (!is.character(x$schema_version) || length(x$schema_version) != 1) {
    niche_abort("spec$schema_version is missing or not character(1)")
  }

  if (!is.character(x$source) || length(x$source) != 1) {
    niche_abort("spec$source is missing or not character(1)")
  }

  invisible(x)
}
