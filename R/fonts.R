#' Register the bundled plot font
#'
#' Registers the bundled Source Sans 3 files (SIL Open Font License) with
#' systemfonts, so `ftm_font` resolves on ragg and svglite devices even where
#' the font isn't installed. Called on package load; call it yourself only if a
#' device reports the font as missing. Skipped when the system already has the
#' font, so an installed copy wins.
#'
#' Base devices (`png()`, `pdf()`) don't consult systemfonts. Save with
#' `ggsave(..., device = ragg::agg_png)` or use ragg as the knitr device.
#'
#' @return `TRUE` invisibly if the bundled font was registered, `FALSE` if the
#'   system font was already available.
#' @export
ftm_register_fonts <- function() {
  family <- ftm_font
  if (font_resolves(family)) {
    return(invisible(FALSE))
  }
  dir <- system.file("fonts", package = "ftmbrand", mustWork = TRUE)
  systemfonts::register_font(
    name = family,
    plain = as.character(fs::path(dir, "SourceSans3-Regular.ttf")),
    bold = as.character(fs::path(dir, "SourceSans3-Bold.ttf")),
    italic = as.character(fs::path(dir, "SourceSans3-It.ttf")),
    bolditalic = as.character(fs::path(dir, "SourceSans3-BoldIt.ttf"))
  )
  invisible(TRUE)
}

#' Does a font family resolve to itself rather than a fallback?
#'
#' systemfonts never errors on a missing family; it silently returns a
#' fallback file. Compare the matched family name instead.
#'
#' @param family Font family name.
#' @return Logical.
#' @noRd
font_resolves <- function(family) {
  if (family %in% systemfonts::registry_fonts()$family) {
    return(TRUE)
  }
  info <- systemfonts::font_info(family = family)
  identical(tolower(info$family[[1]]), tolower(family))
}
