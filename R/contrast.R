#' WCAG relative luminance
#'
#' @param col Character vector of colors.
#' @return Numeric vector of relative luminance, 0 (black) to 1 (white).
#' @noRd
relative_luminance <- function(col) {
  channels <- grDevices::col2rgb(col) / 255
  linear <- ifelse(
    channels <= 0.04045,
    channels / 12.92,
    ((channels + 0.055) / 1.055)^2.4
  )
  0.2126 * linear[1, ] + 0.7152 * linear[2, ] + 0.0722 * linear[3, ]
}

#' WCAG contrast ratio between two colors
#'
#' @param a,b Character vectors of colors (recycled).
#' @return Numeric vector of contrast ratios, 1 to 21.
#' @export
#' @examples
#' contrast_ratio(ftm_colors[["navy"]], "white")
contrast_ratio <- function(a, b) {
  la <- relative_luminance(a)
  lb <- relative_luminance(b)
  (pmax(la, lb) + 0.05) / (pmin(la, lb) + 0.05)
}

#' Readable text color for a given background
#'
#' Returns whichever of `dark` or `light` has more contrast against each
#' background. Use it for labels drawn inside bars or tiles, where one fixed
#' color disappears on part of any categorical palette.
#'
#' It compares both contrast ratios rather than using a luminance threshold,
#' because a threshold is only correct when `dark` is pure black. `dark`
#' defaults to pure black rather than Night Spark (`#212121`) on purpose: Night
#' Spark caps the worst case near 4.0:1, below the 4.5:1 WCAG AA bar. The
#' brand's text color is specified for text on white, not for arbitrary fills.
#'
#' @param bg Character vector of background colors (names are preserved).
#' @param dark,light Candidate text colors.
#' @return Character vector of text colors, same length and names as `bg`.
#' @export
#' @examples
#' contrast_text(ftm_colors[c("orange", "navy", "yellow")])
contrast_text <- function(bg, dark = "#000000", light = ftm_colors[["white"]]) {
  out <- ifelse(
    contrast_ratio(bg, dark) >= contrast_ratio(bg, light),
    dark,
    light
  )
  names(out) <- names(bg)
  out
}
