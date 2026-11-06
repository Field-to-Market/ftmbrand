#' Path to a brand logo
#'
#' @param variant `"horizontal"` (the brand guide's preferred logo, p.5),
#'   `"horizontal-reverse"` (full-color reverse for dark backgrounds, p.8),
#'   `"vertical"` (for narrow or stacked layouts) or `"favicon"`.
#' @return Absolute path to the logo file.
#' @export
#' @examples
#' ftm_logo()
ftm_logo <- function(
  variant = c("horizontal", "horizontal-reverse", "vertical", "favicon")
) {
  variant <- match.arg(variant)
  ftm_brand_path(ftm_brand()$logo$images[[variant]]$path)
}

#' Add the brand logo to a ggplot
#'
#' Insets the logo in a corner of the plot with patchwork, at an absolute size
#' so the brand guide's rules hold at any figure size. The default height is the
#' guide's minimum for the primary logo, 0.5 inch (p.10). Keep clear space
#' around it and never recolor or distort it (pp.10-11).
#'
#' Requires the optional patchwork and png packages.
#'
#' @param plot A ggplot. Defaults to the last plot.
#' @param variant Logo variant, as in [ftm_logo()]. Use
#'   `"horizontal-reverse"` with `theme_ftm(dark = TRUE)`.
#' @param position Corner: `"top-right"`, `"top-left"`, `"bottom-right"` or
#'   `"bottom-left"`.
#' @param height Logo height in inches (number) or a [grid::unit()]. Width
#'   follows from the logo's aspect ratio.
#' @param padding Gap from the figure edge, in inches or a [grid::unit()].
#' @param align_to Passed to [patchwork::inset_element()]: `"full"`, `"plot"`
#'   or `"panel"`.
#' @return A patchwork object.
#' @export
add_logo <- function(
  plot = ggplot2::last_plot(),
  variant = c("horizontal", "horizontal-reverse", "vertical"),
  position = c("top-right", "top-left", "bottom-right", "bottom-left"),
  height = 0.5,
  padding = 0.2,
  align_to = "full"
) {
  for (pkg in c("patchwork", "png")) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      cli::cli_abort(c(
        "{.fn add_logo} needs {.pkg {pkg}}.",
        i = "Install it with {.code install.packages(\"{pkg}\")}."
      ))
    }
  }
  variant <- match.arg(variant)
  position <- match.arg(position)
  as_inches <- function(x) {
    if (grid::is.unit(x)) x else grid::unit(x, "in")
  }
  height <- as_inches(height)
  padding <- as_inches(padding)

  img <- png::readPNG(ftm_logo(variant))
  width <- height * (ncol(img) / nrow(img))
  grob <- grid::rasterGrob(img, interpolate = TRUE)
  # wrap_elements() would otherwise paint a white background and add margins.
  logo <- patchwork::wrap_elements(full = grob) +
    ggplot2::theme(
      plot.background = ggplot2::element_blank(),
      plot.margin = ggplot2::margin(0, 0, 0, 0)
    )

  if (grepl("left", position, fixed = TRUE)) {
    left <- padding
    right <- padding + width
  } else {
    right <- grid::unit(1, "npc") - padding
    left <- right - width
  }
  if (grepl("bottom", position, fixed = TRUE)) {
    bottom <- padding
    top <- padding + height
  } else {
    top <- grid::unit(1, "npc") - padding
    bottom <- top - height
  }

  plot +
    patchwork::inset_element(
      logo,
      left = left,
      bottom = bottom,
      right = right,
      top = top,
      align_to = align_to,
      on_top = TRUE,
      clip = FALSE
    )
}
