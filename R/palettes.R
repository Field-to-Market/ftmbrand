#' Brand palette for n discrete levels
#'
#' Returns the first `n` colors of [ftm_series], interpolating past the end
#' rather than running out. `scale_*_manual()` errors on the first level past
#' its values, which matters when the scale is wired in as the global default
#' (see [set_ftm_defaults()]) and the number of levels is whatever the data has.
#'
#' With `dark = TRUE` the series drops navy and purple, which measure under the
#' 3:1 minimum for lines against the dark background, leaving orange, sky,
#' green and yellow, all full-strength brand colors.
#'
#' @param n Number of levels.
#' @param dark Use the dark-background series (pair with
#'   `theme_ftm(dark = TRUE)`).
#' @return Character vector of `n` hex colors.
#' @export
#' @examples
#' ftm_pal(3)
#' ftm_pal(3, dark = TRUE)
ftm_pal <- function(n, dark = FALSE) {
  series <- if (dark) unname(ftm_colors[series_keys_dark]) else ftm_series
  if (n <= length(series)) {
    series[seq_len(n)]
  } else {
    grDevices::colorRampPalette(series)(n)
  }
}

#' Categorical palette for many categories
#'
#' A palette for charts with many categories (stacked breakdowns and the like).
#' Up to four categories it is the softened brand colors (orange, navy, sky,
#' green). Beyond that it grows outward from those four with
#' `Polychrome::createPalette()`, so later categories stay distinguishable.
#' Results are softened with [ftm_soften()].
#'
#' Two details keep it reproducible:
#' - `createPalette()` draws on the random number generator. The seed is pinned
#'   and the generator is put back exactly as it was found, so `geom_jitter()`
#'   elsewhere in the session is unaffected.
#' - Results are cached per argument set, so two charts with the same number of
#'   categories agree.
#'
#' Ported from fp-project-report (#228, #230). Requires the optional
#' Polychrome package when `n > 4`.
#'
#' @param n Number of categories.
#' @param seed Fixed seed, so a re-render reproduces the same colors.
#' @inheritParams ftm_soften
#' @return Character vector of `n` hex colors.
#' @export
#' @examples
#' ftm_cat_pal(4)
ftm_cat_pal <- function(
  n,
  seed = 228,
  soften = soften_default,
  lift = lift_default
) {
  seeds <- unname(ftm_colors[c("orange", "navy", "sky_drift", "green")])

  key <- paste("cat", n, seed, soften, lift, sep = "_")
  cached <- .ftm_cache[[key]]
  if (!is.null(cached)) {
    return(cached)
  }

  # createPalette() must generate at least as many colors as it is seeded with;
  # at or below that, take the brand colors directly.
  if (n <= length(seeds)) {
    pal <- seeds[seq_len(n)]
  } else {
    if (!requireNamespace("Polychrome", quietly = TRUE)) {
      cli::cli_abort(c(
        "{.fn ftm_cat_pal} needs {.pkg Polychrome} for more than \\
        {length(seeds)} categories.",
        i = "Install it with {.code install.packages(\"Polychrome\")}."
      ))
    }
    if (exists(".Random.seed", envir = globalenv())) {
      old_seed <- get(".Random.seed", envir = globalenv())
      on.exit(assign(".Random.seed", old_seed, envir = globalenv()), add = TRUE)
    } else {
      on.exit(rm(".Random.seed", envir = globalenv()), add = TRUE)
    }
    set.seed(seed)
    pal <- unname(Polychrome::createPalette(
      n,
      seedcolors = seeds,
      range = c(35, 80),
      M = 5000
    ))
  }

  pal <- ftm_soften(pal, soften, lift)
  .ftm_cache[[key]] <- pal
  pal
}
