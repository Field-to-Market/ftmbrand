# Ported from fp-project-report/testing/check_brand_visuals.R (checks 2-4).

test_that("ftm_pal returns exactly n colors, past the six brand colors", {
  for (n in c(1, 2, 6, 7, 20)) {
    expect_length(ftm_pal(n), n)
  }
})

test_that("ftm_cat_pal up to four needs no Polychrome", {
  expect_length(ftm_cat_pal(4), 4)
})

sizes <- c(1, 2, 3, 4, 5, 7, 9, 12, 16, 24)

test_that("ftm_cat_pal returns n distinct colors, deterministically", {
  skip_if_not_installed("Polychrome")
  for (n in sizes) {
    pal <- ftm_cat_pal(n)
    expect_length(pal, n)
    expect_false(anyDuplicated(pal) > 0)
    expect_identical(pal, ftm_cat_pal(n))
  }
})

test_that("ftm_cat_pal matches fp-project-report's palette", {
  # Same seed colors and parameters as fp-project-report, so its anchor value
  # carries over. If this changes, every report's breakdown colors change.
  skip_if_not_installed("Polychrome")
  expect_identical(ftm_cat_pal(16)[[1]], "#E98462")
})

test_that("ftm_cat_pal leaves the RNG stream untouched", {
  skip_if_not_installed("Polychrome")
  set.seed(7)
  before <- runif(3)
  set.seed(7)
  invisible(ftm_cat_pal(13, seed = 99))
  after <- runif(3)
  expect_equal(before, after)
})

test_that("global default survives more levels than the palette has", {
  local_ragg()
  old <- set_ftm_defaults()
  on.exit(options(old))
  d <- data.frame(x = letters[1:20], y = 1:20)
  p <- ggplot2::ggplot(d, ggplot2::aes(x, y, fill = x)) + ggplot2::geom_col()
  expect_no_error(ggplot2::ggplot_build(p))
})
