# The Quarto extension carries a copy of inst/brand/ (quarto add installs only
# _extensions/). These fail when the copy is stale: run tools/sync-extension.R.
# Skipped where the repo isn't present (e.g. R CMD check on a built package).

repo <- fs::path(testthat::test_path(), "..", "..")
ext <- fs::path(repo, "_extensions", "ftmbrand")
src <- fs::path(repo, "inst", "brand")

test_that("extension brand.yml is identical to inst/brand/_brand.yml", {
  skip_if_not(fs::dir_exists(ext) && fs::dir_exists(src))
  expect_identical(
    unname(tools::md5sum(fs::path(ext, "brand.yml"))),
    unname(tools::md5sum(fs::path(src, "_brand.yml")))
  )
})

test_that("extension logos are identical to inst/brand/logos", {
  skip_if_not(fs::dir_exists(ext) && fs::dir_exists(src))
  src_logos <- fs::dir_ls(fs::path(src, "logos"))
  ext_logos <- fs::path(ext, "logos", fs::path_file(src_logos))
  expect_true(all(fs::file_exists(ext_logos)))
  expect_identical(
    unname(tools::md5sum(ext_logos)),
    unname(tools::md5sum(src_logos))
  )
})
