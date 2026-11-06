test_that("plot font resolves, not a silent fallback", {
  # The highest-value check from fp-project-report: a missing family falls
  # back to another font with no warning at all.
  expect_true(font_resolves(ftm_font))
})

test_that("theme_ftm builds in light and dark variants", {
  local_ragg()
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  for (dark in c(FALSE, TRUE)) {
    expect_s3_class(theme_ftm(dark = dark), "theme")
    expect_no_error(ggplot2::ggplot_gtable(ggplot2::ggplot_build(
      p + theme_ftm(dark = dark)
    )))
  }
})

test_that("logos exist", {
  for (v in c("horizontal", "horizontal-reverse", "vertical", "favicon")) {
    expect_true(fs::file_exists(ftm_logo(v)))
  }
})

test_that("add_logo returns a patchwork", {
  local_ragg()
  skip_if_not_installed("patchwork")
  skip_if_not_installed("png")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  expect_s3_class(add_logo(p), "patchwork")
})

test_that("ftm_credit carries the year", {
  expect_equal(
    ftm_credit(2026),
    paste0("Created by: Field to Market ", intToUtf8(169), " 2026")
  )
})
