# Draw on ragg, as real figure output should: base devices (pdf, png) ignore
# fonts registered through systemfonts and warn on every text grob.
local_ragg <- function(env = parent.frame()) {
  path <- tempfile(fileext = ".png")
  ragg::agg_png(path)
  dev <- grDevices::dev.cur()
  withr::defer(
    {
      grDevices::dev.off(dev)
      fs::file_delete(path)
    },
    envir = env
  )
}
