#' Determinism Helpers
#'
#' @description
#' Functions for ensuring reproducible, deterministic behavior across
#' platforms and sessions.
#'
#' @param df Data frame to sort.
#' @param cols Character vector of column names to sort by.
#' @param x R object to hash.
#' @param path File path to hash.
#' @param seed Random seed (integer).
#' @param expr Expression to evaluate with the seed set.
#'
#' @return
#' - `stable_order()`: The data frame sorted by `cols` with deterministic NA ordering.
#' - `hash_object()`: Character string (hexadecimal digest).
#' - `hash_file()`: Character string (hexadecimal digest).
#' - `with_seed()`: The result of evaluating `expr`.
#'
#' @details
#' ## stable_order
#' Sorts data frame rows by specified columns with consistent NA handling
#' (NAs sorted to end). Ensures reproducible row order across platforms.
#' Supports all R data types including factors and complex numbers.
#'
#' ## hash_object
#' Uses SHA-256 via `digest::digest()` with `serialize = TRUE` and
#' `ascii = TRUE` for cross-platform stability.
#'
#' ## hash_file
#' Uses SHA-256 via `digest::digest()` with `file = TRUE` for consistent
#' file hashing.
#'
#' ## with_seed
#' Temporarily sets RNG seed, evaluates expression, and restores previous
#' RNG state even on error.
#'
#' @examples
#' df <- data.frame(x = c(3, 1, NA, 2), y = c("a", "b", "c", "d"))
#' stable_order(df, "x")
#'
#' hash_object(list(a = 1, b = 2))
#'
#' \dontrun{
#' hash_file("myfile.csv")
#' }
#'
#' with_seed(123, rnorm(5))
#'
#' @name determinism
NULL

#' @rdname determinism
#' @export
stable_order <- function(df, cols) {
  if (!is.data.frame(df)) {
    niche_abort("df must be a data frame")
  }

  missing_cols <- setdiff(cols, names(df))
  if (length(missing_cols) > 0) {
    niche_abort(
      sprintf(
        "Columns not found in df: %s. Available columns: %s.",
        paste(missing_cols, collapse = ", "),
        paste(names(df), collapse = ", ")
      )
    )
  }

  # Build ordering expression: order by columns with na.last = TRUE
  # Note: radix method is faster but doesn't support all types (factors, complex)
  # We use "auto" to let R choose the appropriate method based on data types
  order_args <- lapply(cols, function(col) df[[col]])
  order_args$na.last <- TRUE
  order_args$method <- "auto"

  idx <- do.call(order, order_args)
  df[idx, , drop = FALSE]
}

#' @rdname determinism
#' @export
hash_object <- function(x) {
  digest::digest(x, algo = "sha256", serialize = TRUE, ascii = TRUE)
}

#' @rdname determinism
#' @export
hash_file <- function(path) {
  assert_is_existing_file(path, .arg = "path")
  digest::digest(path, algo = "sha256", file = TRUE)
}

#' @rdname determinism
#' @export
with_seed <- function(seed, expr) {
  if (!is.numeric(seed) || length(seed) != 1) {
    niche_abort("seed must be a scalar numeric")
  }

  # Save current RNG state
  old_seed <- if (exists(".Random.seed", envir = .GlobalEnv)) {
    get(".Random.seed", envir = .GlobalEnv)
  } else {
    NULL
  }

  # Ensure restoration even on error
  on.exit({
    if (is.null(old_seed)) {
      if (exists(".Random.seed", envir = .GlobalEnv)) {
        rm(".Random.seed", envir = .GlobalEnv)
      }
    } else {
      assign(".Random.seed", old_seed, envir = .GlobalEnv)
    }
  })

  set.seed(seed)
  force(expr)
}
