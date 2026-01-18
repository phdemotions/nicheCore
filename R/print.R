#' Print Methods for Niche Classes
#'
#' @param x Object to print.
#' @param ... Additional arguments (ignored).
#'
#' @return Invisibly returns `x`.
#'
#' @details
#' Print methods provide concise summaries of niche objects showing:
#' - Schema version
#' - Key counts (variables, rules, steps, etc.)
#' - Output configuration where applicable
#'
#' @examples
#' spec <- new_niche_spec(list(
#'   meta = list(),
#'   data = list(),
#'   vars = list(age = list(), income = list()),
#'   rules = list(rule1 = list()),
#'   scales = list(),
#'   models = list(),
#'   outputs = list(root = "outputs"),
#'   schema_version = "1.0.0",
#'   source = "manual"
#' ))
#' print(spec)
#'
#' @name print
NULL

#' @rdname print
#' @export
print.niche_spec <- function(x, ...) {
  cli::cli_text("{.cls niche_spec}")

  if (!is.null(x$schema_version)) {
    cli::cli_text("Schema version: {.val {x$schema_version}}")
  }

  if (!is.null(x$source)) {
    cli::cli_text("Source: {.val {x$source}}")
  }

  if (!is.null(x$vars)) {
    cli::cli_text("Variables: {.val {length(x$vars)}}")
  }

  if (!is.null(x$rules)) {
    cli::cli_text("Rules: {.val {length(x$rules)}}")
  }

  if (!is.null(x$models)) {
    cli::cli_text("Models: {.val {length(x$models)}}")
  }

  if (!is.null(x$outputs) && !is.null(x$outputs$root)) {
    cli::cli_text("Outputs root: {.path {x$outputs$root}}")
  }

  invisible(x)
}

#' @rdname print
#' @export
print.niche_recipe <- function(x, ...) {
  cli::cli_text("{.cls niche_recipe}")

  if (!is.null(x$schema_version)) {
    cli::cli_text("Schema version: {.val {x$schema_version}}")
  }

  if (!is.null(x$spec_hash)) {
    cli::cli_text("Spec hash: {.val {substr(x$spec_hash, 1, 8)}}...")
  }

  if (!is.null(x$defaults_applied)) {
    cli::cli_text("Defaults applied: {.val {x$defaults_applied}}")
  }

  if (!is.null(x$steps)) {
    cli::cli_text("Steps: {.val {length(x$steps)}}")
  }

  if (!is.null(x$created)) {
    cli::cli_text("Created: {.val {format(x$created, '%Y-%m-%d %H:%M:%S')}}")
  }

  if (!is.null(x$outputs) && !is.null(x$outputs$root)) {
    cli::cli_text("Outputs root: {.path {x$outputs$root}}")
  }

  invisible(x)
}

#' @rdname print
#' @export
print.niche_result <- function(x, ...) {
  cli::cli_text("{.cls niche_result}")

  if (!is.null(x$recipe) && !is.null(x$recipe$schema_version)) {
    cli::cli_text("Recipe schema: {.val {x$recipe$schema_version}}")
  }

  if (!is.null(x$outputs)) {
    cli::cli_text("Outputs: {.val {length(x$outputs)}}")
  }

  if (!is.null(x$artifacts)) {
    cli::cli_text("Artifacts: {.val {length(x$artifacts)}}")
  }

  if (!is.null(x$warnings)) {
    cli::cli_text("Warnings: {.val {length(x$warnings)}}")
  }

  if (!is.null(x$created)) {
    cli::cli_text("Created: {.val {format(x$created, '%Y-%m-%d %H:%M:%S')}}")
  }

  if (!is.null(x$recipe) && !is.null(x$recipe$outputs) && !is.null(x$recipe$outputs$root)) {
    cli::cli_text("Outputs root: {.path {x$recipe$outputs$root}}")
  }

  invisible(x)
}
