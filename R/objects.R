# S3 constructors and validators for niche objects

#' Create a niche_spec object
#' @param x List containing specification data
#' @export
new_niche_spec <- function(x = list()) {
  structure(x, class = c("niche_spec", "list"))
}

#' Create a niche_recipe object
#' @param x List containing recipe data
#' @export
new_niche_recipe <- function(x = list()) {
  structure(x, class = c("niche_recipe", "list"))
}

#' Validate a niche_recipe object
#' @param recipe A niche_recipe object
#' @export
validate_niche_recipe <- function(recipe) {
  if (!inherits(recipe, "niche_recipe")) {
    niche_abort("Input must be a niche_recipe object")
  }
  
  required_fields <- c("schema_version", "spec_hash", "defaults_applied", "steps", "outputs", "created")
  for (field in required_fields) {
    if (is.null(recipe[[field]])) {
      niche_abort(paste0("Missing required field: ", field))
    }
  }
  
  recipe
}

#' Hash an object deterministically
#' @param x Object to hash
#' @export
hash_object <- function(x) {
  digest::digest(x, algo = "sha256")
}

#' Create output directory paths
#' @param root Root output directory
#' @export
niche_output_paths <- function(root) {
  paths <- list(
    root = root,
    audit = file.path(root, "audit"),
    data = file.path(root, "data"),
    figures = file.path(root, "figures"),
    tables = file.path(root, "tables"),
    models = file.path(root, "models")
  )
  
  # Create directories
  for (p in paths) {
    if (!dir.exists(p)) {
      dir.create(p, recursive = TRUE, showWarnings = FALSE)
    }
  }
  
  paths
}

#' Write canonical JSON for audit trail
#' @param x Object to write
#' @param path Output path
#' @export
write_audit_json <- function(x, path) {
  jsonlite::write_json(
    x,
    path,
    pretty = TRUE,
    auto_unbox = TRUE,
    digits = NA
  )
  invisible(path)
}

#' Abort with niche-style error
#' @param message Error message
#' @param details Optional list of details
#' @param help Optional help text
#' @export
niche_abort <- function(message, details = NULL, help = NULL) {
  msg <- message
  
  if (!is.null(details)) {
    detail_text <- paste(
      names(details), 
      vapply(details, function(x) paste(deparse(x), collapse = " "), character(1)),
      sep = ": ",
      collapse = "\n"
    )
    msg <- paste0(msg, "\n\nDetails:\n", detail_text)
  }
  
  if (!is.null(help)) {
    msg <- paste0(msg, "\n\nHelp: ", help)
  }
  
  stop(msg, call. = FALSE)
}
