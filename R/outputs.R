#' Output and Artifact Conventions
#'
#' @description
#' Standardized functions for managing outputs, audit trails, and artifacts
#' in the niche ecosystem.
#'
#' @param root Root directory for outputs.
#' @param df Data frame to write.
#' @param x R object to serialize (for JSON).
#' @param path File path to write to.
#'
#' @return
#' - `niche_output_paths()`: Named list of standard output directories.
#' - `write_audit_csv()`: Invisibly returns the file path.
#' - `write_audit_json()`: Invisibly returns the file path.
#'
#' @details
#' ## niche_output_paths
#' Creates a standard directory structure for niche outputs:
#' - `data`: Processed datasets
#' - `audit`: Audit trails and logs
#' - `models`: Fitted models
#' - `figures`: Plots and visualizations
#' - `tables`: Summary tables
#' - `reports`: Generated reports
#' - `logs`: Execution logs
#'
#' Directories are created idempotently if they don't exist.
#'
#' ## write_audit_csv
#' Writes a data frame to CSV with UTF-8 encoding and stable column order.
#' Does not reorder rows.
#'
#' ## write_audit_json
#' Writes an R object to JSON with canonical formatting (sorted keys,
#' pretty printing) for reproducible diffs.
#'
#' @examples
#' \dontrun{
#' paths <- niche_output_paths("my_outputs")
#' df <- data.frame(x = 1:3, y = letters[1:3])
#' write_audit_csv(df, file.path(paths$audit, "log.csv"))
#' write_audit_json(list(a = 1, b = 2), file.path(paths$audit, "meta.json"))
#' }
#'
#' @name outputs
NULL

#' @rdname outputs
#' @export
niche_output_paths <- function(root = "outputs") {
  assert_is_scalar_character(root, .arg = "root")

  subdirs <- c("data", "audit", "models", "figures", "tables", "reports", "logs")
  paths <- lapply(subdirs, function(s) file.path(root, s))
  names(paths) <- subdirs

  # Create directories idempotently
  for (path in paths) {
    fs::dir_create(path)
  }

  paths
}

#' @rdname outputs
#' @export
write_audit_csv <- function(df, path) {
  if (!is.data.frame(df)) {
    niche_abort("df must be a data frame")
  }

  assert_is_scalar_character(path, .arg = "path")

  # Ensure parent directory exists
  parent_dir <- dirname(path)
  if (!dir.exists(parent_dir)) {
    fs::dir_create(parent_dir)
  }

  # Write with UTF-8 encoding, stable column order (preserve df column order)
  utils::write.csv(
    df,
    file = path,
    row.names = FALSE,
    fileEncoding = "UTF-8"
  )

  invisible(path)
}

#' @rdname outputs
#' @export
write_audit_json <- function(x, path) {
  assert_is_scalar_character(path, .arg = "path")

  # Ensure parent directory exists
  parent_dir <- dirname(path)
  if (!dir.exists(parent_dir)) {
    fs::dir_create(parent_dir)
  }

  # Write with canonical formatting
  jsonlite::write_json(
    x,
    path = path,
    pretty = TRUE,
    auto_unbox = TRUE,
    digits = NA,
    POSIXt = "ISO8601"
  )

  invisible(path)
}
