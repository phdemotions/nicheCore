#' Assertion Functions
#'
#' @description
#' Fast-fail validation helpers with actionable error messages.
#'
#' @param x Object to validate.
#' @param names Character vector of required names.
#' @param path File path.
#' @param .arg Name of the argument being validated (for error messages).
#'
#' @return Invisibly returns `TRUE` if assertion passes; otherwise errors.
#'
#' @examples
#' \dontrun{
#' assert_has_names(list(a = 1, b = 2), c("a", "b"))
#' assert_is_scalar_character("test")
#' assert_is_scalar_logical(TRUE)
#' }
#'
#' @name assertions
NULL

#' @rdname assertions
#' @export
assert_has_names <- function(x, names, .arg = "x") {
  missing_names <- setdiff(names, names(x))
  if (length(missing_names) > 0) {
    niche_abort(
      sprintf(
        "%s is missing required names: %s. Expected names: %s.",
        .arg,
        paste(missing_names, collapse = ", "),
        paste(names, collapse = ", ")
      )
    )
  }
  invisible(TRUE)
}

#' @rdname assertions
#' @export
assert_is_scalar_character <- function(x, .arg = "x") {
  if (!is.character(x) || length(x) != 1) {
    niche_abort(
      sprintf(
        "%s must be a scalar character. Got: %s of length %s.",
        .arg,
        class(x)[1],
        length(x)
      )
    )
  }
  invisible(TRUE)
}

#' @rdname assertions
#' @export
assert_is_scalar_logical <- function(x, .arg = "x") {
  if (!is.logical(x) || length(x) != 1) {
    niche_abort(
      sprintf(
        "%s must be a scalar logical. Got: %s of length %s.",
        .arg,
        class(x)[1],
        length(x)
      )
    )
  }
  invisible(TRUE)
}

#' @rdname assertions
#' @export
assert_is_existing_file <- function(path, .arg = "path") {
  if (!is.character(path) || length(path) != 1) {
    niche_abort(sprintf("%s must be a scalar character path.", .arg))
  }
  if (!file.exists(path)) {
    niche_abort(
      sprintf(
        "%s does not exist: %s. Check the file path and try again.",
        .arg,
        path
      )
    )
  }
  if (!file.info(path)$isdir == FALSE) {
    niche_abort(
      sprintf(
        "%s is not a file: %s. Expected a file, not a directory.",
        .arg,
        path
      )
    )
  }
  invisible(TRUE)
}

