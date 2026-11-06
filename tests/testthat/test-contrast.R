# Ported from fp-project-report/testing/check_brand_visuals.R (check 5).

test_that("white on navy passes WCAG AA; white on orange does not", {
  expect_gt(contrast_ratio(ftm_colors[["navy"]], "white"), 4.5)
  expect_lt(contrast_ratio(ftm_colors[["orange"]], "white"), 4.5)
})

test_that("in-fill labels meet 4.5:1 on every categorical palette size", {
  skip_if_not_installed("Polychrome")
  for (n in c(4, 8, 12, 16)) {
    pal <- ftm_cat_pal(n)
    expect_true(all(contrast_ratio(pal, contrast_text(pal)) >= 4.5))
  }
})

test_that("contrast_text picks the higher-contrast candidate", {
  pal <- c(ftm_fills, ftm_series)
  chosen <- contrast_text(pal)
  best <- pmax(contrast_ratio(pal, "#000000"), contrast_ratio(pal, "white"))
  expect_equal(unname(contrast_ratio(pal, chosen)), unname(best))
})

test_that("dark series lines meet 3:1 against the dark background", {
  bg <- ftm_colors[["dark_gray"]]
  expect_true(all(contrast_ratio(ftm_pal(4, dark = TRUE), bg) >= 3))
  # And the reason it exists: navy on the dark background fails.
  expect_lt(contrast_ratio(ftm_colors[["navy"]], bg), 3)
})
