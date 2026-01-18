#' Niche Result Class
#'
#' @description
#' The `niche_result` class defines the canonical structure for niche
#' results. Only nicheCore may define required fields and validation
#' logic for this class.
#'
#' @param x A list containing result fields.
#'
#' @return
#' - `new_niche_result()`: A `niche_result` object (no validation).
#' - `is_niche_result()`: Logical indicating whether object has class `niche_result`.
#' - `validate_niche_result()`: The validated result (invisibly), or an error.
#'
#' @details
#' Required fields:
#' - `recipe`: niche_recipe object
#' - `outputs`: list with output data
#' - `artifacts`: list with artifact paths
#' - `session_info`: session information object
#' - `warnings`: character vector of warnings
#' - `created`: POSIXct timestamp
#'
#' @examples
#' \dontrun{
#' result <- new_niche_result(list(
#'   recipe = new_niche_recipe(list(
#'     schema_version = "1.0.0",
#'     spec_hash = "abc",
#'     defaults_applied = TRUE,
#'     steps = list(),
#'     outputs = list(),
#'     created = Sys.time()
#'   )),
#'   outputs = list(),
#'   artifacts = list(),
#'   session_info = sessionInfo(),
#'   warnings = character(0),
#'   created = Sys.time()
#' ))
#' is_niche_result(result)
#' validate_niche_result(result)
#' }
#'
#' @name niche_result
NULL

#' @rdname niche_result
#' @export
new_niche_result <- function(x) {
  stopifnot(is.list(x))
  structure(x, class = "niche_result")
}

#' @rdname niche_result
#' @export
is_niche_result <- function(x) {
  inherits(x, "niche_result")
}

#' @rdname niche_result
#' @export
validate_niche_result <- function(x) {
  if (!is_niche_result(x)) {
    niche_abort("Object is not a niche_result")
  }

  required_fields <- c("recipe", "outputs", "artifacts",
                       "session_info", "warnings", "created")

  for (field in required_fields) {
    if (!field %in% names(x)) {
      niche_abort(sprintf("result$%s is missing", field))
    }
  }

  # Validate recipe field
  if (!is_niche_recipe(x$recipe)) {
    niche_abort("result$recipe is not a niche_recipe object")
  }

  # Validate list fields
  if (!is.list(x$outputs)) {
    niche_abort("result$outputs is not a list")
  }

  if (!is.list(x$artifacts)) {
    niche_abort("result$artifacts is not a list")
  }

  # Validate warnings
  if (!is.character(x$warnings)) {
    niche_abort("result$warnings is not a character vector")
  }

  # Validate timestamp
  if (!inherits(x$created, "POSIXct")) {
    niche_abort("result$created is missing or not POSIXct")
  }

  invisible(x)
}
