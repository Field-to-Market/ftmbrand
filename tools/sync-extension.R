# Copy the canonical brand (inst/brand/) into the Quarto extension.
#
# inst/brand/_brand.yml is the source of truth. The Quarto extension in
# _extensions/ftmbrand/ needs its own copy because `quarto add` installs only
# the _extensions/ folder. Run this after any edit to inst/brand/; the test
# suite fails while the two are out of sync.
#
#   Rscript tools/sync-extension.R

library(fs)

src <- path("inst", "brand")
dest <- path("_extensions", "ftmbrand")

if (!dir_exists(src) || !dir_exists(dest)) {
  cli::cli_abort("Run from the repository root.")
}

file_copy(path(src, "_brand.yml"), path(dest, "brand.yml"), overwrite = TRUE)

# Mirror each asset folder: delete then copy, so files removed from
# inst/brand/ don't linger in the extension. Fonts ship only what the web uses
# (.woff2 plus licenses); the .ttf files are for R plots and would just add
# weight to every repo that commits the extension.
web_files <- list(logos = ".", fonts = "[.](woff2|md)$")
for (dir in names(web_files)) {
  if (dir_exists(path(dest, dir))) {
    dir_delete(path(dest, dir))
  }
  dir_create(path(dest, dir))
  files <- dir_ls(path(src, dir), regexp = web_files[[dir]])
  file_copy(files, path(dest, dir, path_file(files)))
}

n_logos <- length(dir_ls(path(dest, "logos")))
n_fonts <- length(dir_ls(path(dest, "fonts")))
cli::cli_bullets(c(
  v = "Synced {.path {src}} -> {.path {dest}}",
  i = "brand.yml, {n_logos} logo file{?s}, {n_fonts} font/license file{?s}"
))
