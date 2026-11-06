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
dir_create(path(dest, "logos"))
logos <- dir_ls(path(src, "logos"))
file_copy(logos, path(dest, "logos", path_file(logos)), overwrite = TRUE)

cli::cli_bullets(c(
  v = "Synced {.path {src}} -> {.path {dest}}",
  i = "{length(logos)} logo file{?s} and brand.yml"
))
