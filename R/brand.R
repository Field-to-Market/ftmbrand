#' Path to the canonical brand file and its assets
#'
#' `inst/brand/_brand.yml` is the single source of truth for Field to Market's
#' colors, fonts and logos. Every function in this package reads it, and Quarto
#' projects or Shiny apps can point at it directly, e.g.
#' `bslib::bs_theme(brand = ftm_brand_path())`.
#'
#' @param ... Optional path components inside `inst/brand/`, e.g. `"logos"`.
#'   Empty returns the path to `_brand.yml` itself.
#' @return An absolute file path (character).
#' @export
#' @examples
#' ftm_brand_path()
#' ftm_brand_path("logos")
ftm_brand_path <- function(...) {
  parts <- c(...)
  if (length(parts) == 0) {
    parts <- "_brand.yml"
  }
  path <- system.file("brand", package = "ftmbrand", mustWork = TRUE)
  out <- fs::path(path, parts)
  if (!fs::file_exists(out)) {
    cli::cli_abort("{.path {out}} is not part of the {.pkg ftmbrand} brand.")
  }
  as.character(out)
}

#' Read the brand file
#'
#' Parsed once per session and cached.
#'
#' @return The parsed `_brand.yml` as a nested list.
#' @export
#' @examples
#' names(ftm_brand())
ftm_brand <- function() {
  if (is.null(.ftm_cache$brand)) {
    .ftm_cache$brand <- yaml::read_yaml(ftm_brand_path())
  }
  .ftm_cache$brand
}

# Session cache for the parsed brand file and generated palettes.
.ftm_cache <- new.env(parent = emptyenv())

#' Brand palette as a named color vector
#'
#' Turns `color.palette` from the brand file into a named character vector,
#' converting hyphenated keys to snake_case (`sky-drift` -> `sky_drift`).
#'
#' @param brand A parsed brand list, as from [ftm_brand()].
#' @return Named character vector of lowercase hex colors.
#' @noRd
brand_palette <- function(brand) {
  pal <- unlist(brand$color$palette)
  names(pal) <- gsub("-", "_", names(pal), fixed = TRUE)
  tolower(pal)
}
