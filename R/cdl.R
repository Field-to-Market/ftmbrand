#' Cropland Data Layer crop colors
#'
#' Colors for the USDA NASS Cropland Data Layer (CDL) classes, so crop maps and
#' crop-specific charts match the colors agricultural readers know from CDL
#' maps. These are not brand colors; use them only where color encodes crop.
#'
#' Keys are CDL class names exactly as NASS writes them ("Corn", "Winter Wheat",
#' "Sweet Potatoes", "Dbl Crop WinWht/Soybeans"). Mapping other crop naming
#' schemes (for example NIR crop names) to CDL classes belongs in the project
#' that owns those names.
#'
#' The table has 134 classes but only 63 distinct colors: double-crop classes
#' take their first crop's color and many vegetables share one. Two classes
#' with the same color can't be told apart in one chart, so this function
#' warns when the requested classes share a color.
#'
#' @section Provenance:
#' Table found online by AP (originally used in platform-api-testing's
#' cropland-history analysis). Checked by eye against CDL maps, not against an
#' official NASS color file. Treat as provisional until verified.
#'
#' @param classes CDL class names to return. `NULL` returns all classes.
#' @return Named character vector of lowercase hex colors. Unknown classes
#'   abort with an error listing them.
#' @export
#' @examples
#' ftm_cdl_colors(c("Corn", "Soybeans", "Winter Wheat"))
ftm_cdl_colors <- function(classes = NULL) {
  if (is.null(.ftm_cache$cdl)) {
    tbl <- utils::read.csv(
      system.file("extdata", "cdl-colors.csv", package = "ftmbrand"),
      stringsAsFactors = FALSE
    )
    .ftm_cache$cdl <- stats::setNames(tolower(tbl$hex), tbl$cdl_class)
  }
  pal <- .ftm_cache$cdl
  if (is.null(classes)) {
    return(pal)
  }

  classes <- unique(as.character(classes))
  unknown <- setdiff(classes, names(pal))
  if (length(unknown) > 0) {
    cli::cli_abort(c(
      "{length(unknown)} class{?es} not in the CDL color table: {.val {unknown}}.",
      i = "Keys are CDL class names as NASS writes them, e.g. {.val Winter Wheat}."
    ))
  }

  out <- pal[classes]
  shared <- out[duplicated(out) | duplicated(out, fromLast = TRUE)]
  if (length(shared) > 0) {
    groups <- vapply(
      split(names(shared), shared),
      paste,
      character(1),
      collapse = " = "
    )
    cli::cli_warn(c(
      "Some CDL classes share a color and can't be told apart:",
      stats::setNames(unname(groups), rep("*", length(groups)))
    ))
  }
  out
}

#' Cropland Data Layer color scales
#'
#' Discrete scales keyed by CDL class name (see [ftm_cdl_colors()]). Levels of
#' the mapped variable must be CDL class names; any that aren't get `na.value`.
#'
#' @param ... Passed to [ggplot2::scale_fill_manual()] or
#'   [ggplot2::scale_colour_manual()].
#' @return A ggplot2 scale.
#' @export
#' @examples
#' library(ggplot2)
#' d <- data.frame(crop = c("Corn", "Soybeans", "Winter Wheat"), ha = 3:1)
#' p <- ggplot(d, aes(crop, ha, fill = crop)) +
#'   geom_col() +
#'   scale_fill_cdl()
scale_fill_cdl <- function(...) {
  ggplot2::scale_fill_manual(values = ftm_cdl_colors(), ...)
}

#' @rdname scale_fill_cdl
#' @export
scale_colour_cdl <- function(...) {
  ggplot2::scale_colour_manual(values = ftm_cdl_colors(), ...)
}

#' @rdname scale_fill_cdl
#' @export
scale_color_cdl <- scale_colour_cdl
