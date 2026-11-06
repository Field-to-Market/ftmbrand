#' @keywords internal
"_PACKAGE"

# Populate the exported brand objects from _brand.yml at load time. Reading the
# file here (rather than retyping hexes in R) is what keeps R and HTML in step.
.onLoad <- function(libname, pkgname) {
  ns <- topenv()
  brand <- ftm_brand()
  colors <- brand_palette(brand)

  assign("ftm_colors", colors, envir = ns)
  assign("ftm_series", unname(colors[series_keys]), envir = ns)
  assign("ftm_fills", ftm_soften(colors[series_keys]), envir = ns)
  # The yml quotes the family for CSS ("'Source Sans 3'"); R wants it bare.
  font <- gsub("^['\"]|['\"]$", "", brand$typography$base$family)
  assign("ftm_font", font, envir = ns)

  ftm_register_fonts()
}
