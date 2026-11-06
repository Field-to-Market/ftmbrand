test_that("CDL table loads with unique names and valid hexes", {
  pal <- ftm_cdl_colors()
  expect_length(pal, 134)
  expect_false(anyDuplicated(names(pal)) > 0)
  expect_true(all(grepl("^#[0-9a-f]{6}$", pal)))
})

test_that("lookup returns named colors for known classes", {
  out <- ftm_cdl_colors(c("Corn", "Soybeans", "Winter Wheat"))
  expect_named(out, c("Corn", "Soybeans", "Winter Wheat"))
})

test_that("unknown classes abort with their names", {
  expect_error(ftm_cdl_colors(c("Corn", "Corn grain")), "Corn grain")
})

test_that("classes that share a color warn", {
  expect_warning(ftm_cdl_colors(c("Potatoes", "Sweet Potatoes")), "share")
  expect_no_warning(ftm_cdl_colors(c("Corn", "Soybeans")))
})

test_that("scale_fill_cdl colors bars by class", {
  d <- data.frame(crop = c("Corn", "Soybeans"), ha = 2:1)
  p <- ggplot2::ggplot(d, ggplot2::aes(crop, ha, fill = crop)) +
    ggplot2::geom_col() +
    scale_fill_cdl()
  fills <- ggplot2::layer_data(p)$fill
  expect_equal(fills, unname(ftm_cdl_colors(c("Corn", "Soybeans"))))
})
