#' Discrete brand color scales
#'
#' Orange, navy, then the four secondaries; interpolates past six levels (see
#' [ftm_pal()]). For many-category fills, prefer
#' `scale_fill_manual(values = ftm_cat_pal(n))`.
#'
#' @param ... Passed to [ggplot2::discrete_scale()].
#' @param dark Use the dark-background series (see [ftm_pal()]); pair with
#'   `theme_ftm(dark = TRUE)`.
#' @return A ggplot2 scale.
#' @export
#' @examples
#' library(ggplot2)
#' p <- ggplot(mpg, aes(displ, hwy, colour = drv)) +
#'   geom_point() +
#'   scale_colour_ftm()
scale_colour_ftm <- function(..., dark = FALSE) {
  ggplot2::discrete_scale(
    "colour",
    palette = function(n) ftm_pal(n, dark = dark),
    ...
  )
}

#' @rdname scale_colour_ftm
#' @export
scale_color_ftm <- scale_colour_ftm

#' @rdname scale_colour_ftm
#' @export
scale_fill_ftm <- function(..., dark = FALSE) {
  ggplot2::discrete_scale(
    "fill",
    palette = function(n) ftm_pal(n, dark = dark),
    ...
  )
}

#' Continuous brand color scales
#'
#' `_div` is diverging: navy below `midpoint`, white at it, orange above. Use it
#' when the sign of the value matters (change from a benchmark, a sink vs a
#' source). `_seq` is sequential from Mist Veil to navy, for magnitudes.
#'
#' @param midpoint Value mapped to white in the diverging scale.
#' @param ... Passed to the underlying ggplot2 gradient scale.
#' @return A ggplot2 scale.
#' @export
#' @examples
#' library(ggplot2)
#' p <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_raster() +
#'   scale_fill_ftm_seq()
scale_fill_ftm_div <- function(midpoint = 0, ...) {
  ggplot2::scale_fill_gradient2(
    low = ftm_colors[["navy"]],
    mid = ftm_colors[["white"]],
    high = ftm_colors[["orange"]],
    midpoint = midpoint,
    ...
  )
}

#' @rdname scale_fill_ftm_div
#' @export
scale_colour_ftm_div <- function(midpoint = 0, ...) {
  ggplot2::scale_colour_gradient2(
    low = ftm_colors[["navy"]],
    mid = ftm_colors[["white"]],
    high = ftm_colors[["orange"]],
    midpoint = midpoint,
    ...
  )
}

#' @rdname scale_fill_ftm_div
#' @export
scale_color_ftm_div <- scale_colour_ftm_div

#' @rdname scale_fill_ftm_div
#' @export
scale_fill_ftm_seq <- function(...) {
  ggplot2::scale_fill_gradient(
    low = ftm_colors[["light_gray"]],
    high = ftm_colors[["navy"]],
    ...
  )
}

#' @rdname scale_fill_ftm_div
#' @export
scale_colour_ftm_seq <- function(...) {
  ggplot2::scale_colour_gradient(
    low = ftm_colors[["light_gray"]],
    high = ftm_colors[["navy"]],
    ...
  )
}

#' @rdname scale_fill_ftm_div
#' @export
scale_color_ftm_seq <- scale_colour_ftm_seq

#' Make the brand palette the default for discrete scales
#'
#' Sets the `ggplot2.discrete.colour` and `ggplot2.discrete.fill` options, so
#' every plot that doesn't set its own scale picks up the brand.
#'
#' @param dark Use the dark-background series (see [ftm_pal()]).
#' @return The previous option values, invisibly, so they can be restored with
#'   `options(old)`.
#' @export
#' @examples
#' old <- set_ftm_defaults()
#' options(old)
set_ftm_defaults <- function(dark = FALSE) {
  invisible(options(
    ggplot2.discrete.colour = function(...) scale_colour_ftm(..., dark = dark),
    ggplot2.discrete.fill = function(...) scale_fill_ftm(..., dark = dark)
  ))
}
