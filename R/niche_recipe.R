#' Niche Recipe Class
#'
#' @description
#' The `niche_recipe` class defines the canonical structure for niche
#' recipes. Only nicheCore may define required fields and validation
#' logic for this class.
#'
#' @param x A list containing recipe fields.
#'
#' @return
#' - `new_niche_recipe()`: A `niche_recipe` object (no validation).
#' - `is_niche_recipe()`: Logical indicating whether object has class `niche_recipe`.
#' - `validate_niche_recipe()`: The validated recipe (invisibly), or an error.
#'
#' @details
#' Required fields:
#' - `schema_version`: character(1) version string
#' - `spec_hash`: character(1) hash of the spec
#' - `defaults_applied`: logical(1) whether defaults were applied
#' - `steps`: list of processing steps
#' - `outputs`: list with output configuration
#' - `created`: POSIXct timestamp
#'
#' @examples
#' recipe <- new_niche_recipe(list(
#'   schema_version = "1.0.0",
#'   spec_hash = "abc123",
#'   defaults_applied = TRUE,
#'   steps = list(),
#'   outputs = list(),
#'   created = Sys.time()
#' ))
#' is_niche_recipe(recipe)
#' validate_niche_recipe(recipe)
#'
#' @name niche_recipe
NULL

#' @rdname niche_recipe
#' @export
new_niche_recipe <- function(x) {
  stopifnot(is.list(x))
  structure(x, class = "niche_recipe")
}

#' @rdname niche_recipe
#' @export
is_niche_recipe <- function(x) {
  inherits(x, "niche_recipe")
}

#' @rdname niche_recipe
#' @export
validate_niche_recipe <- function(x) {
  if (!is_niche_recipe(x)) {
    niche_abort("Object is not a niche_recipe")
  }

  required_fields <- c("schema_version", "spec_hash", "defaults_applied",
                       "steps", "outputs", "created")

  for (field in required_fields) {
    if (!field %in% names(x)) {
      niche_abort(sprintf("recipe$%s is missing", field))
    }
  }

  # Validate scalar character fields
  if (!is.character(x$schema_version) || length(x$schema_version) != 1) {
    niche_abort("recipe$schema_version is missing or not character(1)")
  }

  if (!is.character(x$spec_hash) || length(x$spec_hash) != 1) {
    niche_abort("recipe$spec_hash is missing or not character(1)")
  }

  # Validate scalar logical
  if (!is.logical(x$defaults_applied) || length(x$defaults_applied) != 1) {
    niche_abort("recipe$defaults_applied is missing or not logical(1)")
  }

  # Validate list fields
  if (!is.list(x$steps)) {
    niche_abort("recipe$steps is not a list")
  }

  if (!is.list(x$outputs)) {
    niche_abort("recipe$outputs is not a list")
  }

  # Validate timestamp
  if (!inherits(x$created, "POSIXct")) {
    niche_abort("recipe$created is missing or not POSIXct")
  }

  invisible(x)
}
