#' Field to Market ggplot2 theme
#'
#' Minimal theme with the brand palette and plot font. Layout follows the NIR
#' (mango-tango) theme: bold navy title, italic subtitle and caption, legend
#' along the top-left, light background panel, no axis ticks.
#'
#' @param base_size Base font size in points.
#' @param base_family Font family; defaults to [ftm_font].
#' @param background_fill If `TRUE`, a very light gray background; if `FALSE`,
#'   white. Ignored when `dark = TRUE`.
#' @param grid_lines Draw major and minor grid lines.
#' @param dark Dark variant (Night Spark background, orange title).
#' @return A ggplot2 theme.
#' @export
#' @examples
#' library(ggplot2)
#' p <- ggplot(mpg, aes(displ, hwy)) +
#'   geom_point(colour = ftm_colors[["orange"]]) +
#'   labs(title = "Highway mileage", caption = ftm_credit()) +
#'   theme_ftm()
theme_ftm <- function(
  base_size = 14,
  base_family = ftm_font,
  background_fill = TRUE,
  grid_lines = TRUE,
  dark = FALSE
) {
  col <- ftm_colors
  bg <- if (dark) {
    col[["dark_gray"]]
  } else if (background_fill) {
    col[["very_light_gray"]]
  } else {
    col[["white"]]
  }
  fg <- if (dark) col[["light_gray"]] else col[["dark_gray"]]
  title <- if (dark) col[["orange"]] else col[["navy"]]
  # Iron, not orange: orange small text on a light background is under 3:1.
  caption <- if (dark) col[["light_gray"]] else col[["iron"]]
  grid <- if (dark) col[["iron"]] else col[["light_gray"]]

  grid_major <- if (grid_lines) {
    ggplot2::element_line(colour = grid, linewidth = 0.3)
  } else {
    ggplot2::element_blank()
  }
  grid_minor <- if (grid_lines) {
    ggplot2::element_line(colour = grid, linewidth = 0.15)
  } else {
    ggplot2::element_blank()
  }

  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      text = ggplot2::element_text(colour = fg),
      plot.title = ggplot2::element_text(
        face = "bold",
        colour = title,
        size = base_size * 1.3,
        margin = ggplot2::margin(b = 10)
      ),
      plot.subtitle = ggplot2::element_text(
        face = "italic",
        colour = fg,
        size = base_size,
        margin = ggplot2::margin(b = 10)
      ),
      plot.caption = ggplot2::element_text(
        face = "italic",
        colour = caption,
        size = base_size * 0.6,
        lineheight = 1.2,
        margin = ggplot2::margin(t = 20)
      ),
      plot.title.position = "plot",
      plot.caption.position = "plot",
      axis.title = ggplot2::element_text(
        face = "bold.italic",
        colour = fg,
        size = base_size
      ),
      axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 8)),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 10)),
      axis.text = ggplot2::element_text(colour = fg, size = base_size * 0.9),
      axis.ticks = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = bg, colour = NA),
      panel.background = ggplot2::element_rect(fill = bg, colour = NA),
      panel.grid.major = grid_major,
      panel.grid.minor = grid_minor,
      legend.position = "top",
      legend.justification = "left",
      legend.direction = "horizontal",
      legend.box.just = "left",
      legend.title = ggplot2::element_text(colour = fg, size = base_size),
      legend.text = ggplot2::element_text(
        colour = fg,
        size = base_size * 0.8
      ),
      legend.key = ggplot2::element_rect(fill = NA, colour = NA),
      strip.text = ggplot2::element_text(
        colour = fg,
        size = base_size * 0.95
      ),
      strip.background = ggplot2::element_rect(fill = grid, colour = NA),
      plot.margin = ggplot2::margin(t = 20, r = 30, b = 20, l = 30)
    )
}

#' Standard credit line for plot captions
#'
#' @param year Copyright year; defaults to the current year.
#' @return A string: "Created by: Field to Market", a copyright sign and `year`.
#' @export
#' @examples
#' ftm_credit()
ftm_credit <- function(year = format(Sys.Date(), "%Y")) {
  # intToUtf8(169) is the copyright sign; R code must stay ASCII.
  paste0("Created by: Field to Market ", intToUtf8(169), " ", year)
}
