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

test_that("extension carries the repo's trademark notice", {
  trademarks <- fs::path(repo, "TRADEMARKS.md")
  skip_if_not(fs::dir_exists(ext) && fs::file_exists(trademarks))
  expect_identical(
    unname(tools::md5sum(fs::path(ext, "TRADEMARKS.md"))),
    unname(tools::md5sum(trademarks))
  )
})

# Mirrors tools/sync-extension.R: the extension gets web files only.
web_files <- list(logos = ".", fonts = "[.](woff2|md)$")
for (dir in names(web_files)) {
  test_that(paste("extension", dir, "are identical to inst/brand"), {
    skip_if_not(fs::dir_exists(ext) && fs::dir_exists(src))
    src_files <- fs::dir_ls(fs::path(src, dir), regexp = web_files[[dir]])
    ext_files <- fs::dir_ls(fs::path(ext, dir))
    # Same file names both ways: nothing missing, nothing left over.
    expect_setequal(fs::path_file(ext_files), fs::path_file(src_files))
    expect_identical(
      unname(tools::md5sum(fs::path(ext, dir, fs::path_file(src_files)))),
      unname(tools::md5sum(src_files))
    )
  })
}

test_that("every font file the brand references is bundled", {
  skip_if_not(fs::dir_exists(src))
  fonts <- ftm_brand()$typography$fonts
  paths <- unlist(lapply(fonts, \(f) vapply(f$files, \(x) x$path, "")))
  expect_true(all(vapply(fonts, \(f) f$source == "file", TRUE)))
  expect_true(all(fs::file_exists(fs::path(src, paths))), info = paths)
})

test_that("every bundled .ttf has a .woff2 web copy", {
  skip_if_not(fs::dir_exists(src))
  fonts <- fs::path(src, "fonts")
  ttf <- fs::path_ext_remove(fs::path_file(fs::dir_ls(fonts, glob = "*.ttf")))
  woff2 <- fs::path_ext_remove(fs::path_file(fs::dir_ls(
    fonts,
    glob = "*.woff2"
  )))
  # Fails when a .ttf is added without running tools/build-woff2.py.
  expect_setequal(woff2, ttf)
})
