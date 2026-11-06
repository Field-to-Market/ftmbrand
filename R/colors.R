#' Field to Market brand colors
#'
#' Named vector of the brand palette, read from `_brand.yml` when the package
#' loads, so it can never disagree with the HTML side. Names are the brand-file
#' keys in snake_case:
#'
#' | Name | Brand name | Role |
#' |---|---|---|
#' | `orange` | Ember Glow | primary |
#' | `navy` | Deep Current | primary |
#' | `sky_drift` | Sky Drift | secondary |
#' | `green` | Meadow Pulse | secondary |
#' | `purple` | Twilight Bloom | secondary |
#' | `yellow` | Solar Bloom | secondary |
#' | `iron` | Iron Whisper | neutral |
#' | `light_gray` | Mist Veil | neutral |
#' | `dark_gray` | Night Spark | neutral |
#' | `white` | Pure Horizon | neutral |
#' | `very_light_gray`, `heading_underline` | — | utility neutrals |
#'
#' The guide's color hierarchy is 40% navy, 40% orange and 5% for each
#' secondary, which are meant "as accents or small color blocks" (brand guide
#' p.15). Use these full-strength colors for identity and small marks (lines,
#' points, headings, table headers); use [ftm_fills] for anything that fills
#' real estate.
#'
#' Navy carries white text (about 9:1 contrast); orange does not (about 3:1,
#' below WCAG AA), so put structure that needs white text on navy.
#'
#' @format Named character vector.
#' @export
#' @examples
#' ftm_colors[["navy"]]
ftm_colors <- NULL

#' Discrete series order for plots
#'
#' Orange first, then navy, so a single-series plot reads orange and a
#' two-series plot reads as the brand pair; the four bold secondaries follow.
#'
#' @format Unnamed character vector of six hex colors.
#' @export
ftm_series <- NULL

#' Brand colors softened for large plot areas
#'
#' The six chromatic brand colors passed through [ftm_soften()]. Use for bar
#' fills, stacked segments and area shading. Neutrals are absent on purpose:
#' softening a gray is meaningless.
#'
#' @format Named character vector of six hex colors.
#' @export
ftm_fills <- NULL

#' Plot font family
#'
#' The `typography.base.family` from `_brand.yml` ("Source Sans 3"). The
#' package bundles this font (SIL Open Font License) and registers it on load,
#' so it resolves on ragg and svglite devices even where it isn't installed.
#'
#' @format A length-one character vector.
#' @export
ftm_font <- NULL

# Chromatic brand colors, in series order.
series_keys <- c("orange", "navy", "sky_drift", "green", "purple", "yellow")
# Dark-background series: navy and purple drop out (under 3:1 on Night Spark).
series_keys_dark <- c("orange", "sky_drift", "green", "yellow")

# Default softening for large fills. desaturate removes this share of chroma;
# lighten raises luminance by this share. Past about 0.6 the segments of a
# stacked bar stop being distinguishable. Values from fp-project-report (#228).
soften_default <- 0.35
lift_default <- 0.10

#' Soften colors for use as large plot areas
#'
#' Brand colors are specified for identity use (logo, banner, headings), where
#' they cover a small area. A full-height bar or a twelve-segment stack is the
#' opposite, so large fills are softened. `desaturate` and `lighten` work in
#' HCL space and leave the *hue* alone, so the result is a tint of the brand
#' color rather than a different color.
#'
#' @param cols Character vector of colors.
#' @param soften Proportion of chroma to remove (0 = none).
#' @param lift Proportion to raise luminance by (0 = none).
#' @return Character vector of hex colors, names preserved.
#' @export
#' @examples
#' ftm_soften(ftm_colors[c("orange", "navy")])
ftm_soften <- function(cols, soften = soften_default, lift = lift_default) {
  nms <- names(cols)
  if (soften > 0) {
    cols <- colorspace::desaturate(cols, soften)
  }
  if (lift > 0) {
    cols <- colorspace::lighten(cols, lift)
  }
  names(cols) <- nms
  cols
}
