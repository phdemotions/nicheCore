#' Standardized Condition Handlers
#'
#' @description
#' Functions for raising validation errors and warnings with structured
#' condition classes.
#'
#' @param message Character string describing the error or warning.
#' @param class Optional character vector of additional condition classes.
#' @param ... Additional fields to include in the condition object.
#' @param call The calling environment. Defaults to the parent frame.
#'
#' @return These functions do not return; they signal conditions.
#'
#' @examples
#' \dontrun{
#' niche_abort("Invalid spec structure", class = "invalid_spec")
#' niche_warn("Deprecated field used", class = "deprecated_field")
#' }
#'
#' @name conditions
NULL

#' @rdname conditions
#' @export
niche_abort <- function(message, class = NULL, ..., call = rlang::caller_env()) {
  rlang::abort(
    message = message,
    class = c(class, "niche_validation_error"),
    ...,
    call = call
  )
}

#' @rdname conditions
#' @export
niche_warn <- function(message, class = NULL, ..., call = rlang::caller_env()) {
  rlang::warn(
    message = message,
    class = c(class, "niche_validation_warning"),
    ...,
    call = call
  )
}
