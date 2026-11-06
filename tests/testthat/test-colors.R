# The ten brand colors as printed in FTM_Brand Guidelines_011626.pdf, p.14.
# This is the one place hexes are typed by hand: it pins _brand.yml to the
# guide, so an accidental edit to the brand file fails here.
guide_hexes <- c(
  navy = "#10427c", # Deep Current
  orange = "#f46c09", # Ember Glow
  green = "#00b14c", # Meadow Pulse
  sky_drift = "#0d9ac6", # Sky Drift
  purple = "#462668", # Twilight Bloom
  yellow = "#ffd103", # Solar Bloom
  white = "#ffffff", # Pure Horizon
  light_gray = "#ebebeb", # Mist Veil
  iron = "#58595b", # Iron Whisper
  dark_gray = "#212121" # Night Spark
)

test_that("brand file matches the brand guide", {
  expect_equal(ftm_colors[names(guide_hexes)], guide_hexes)
})

test_that("ftm_colors is read from _brand.yml, not retyped", {
  raw <- yaml::read_yaml(ftm_brand_path())$color$palette
  expect_equal(unname(ftm_colors), tolower(unname(unlist(raw))))
  expect_equal(names(ftm_colors), gsub("-", "_", names(raw), fixed = TRUE))
})

test_that("series leads with orange then navy", {
  expect_equal(ftm_series[1:2], unname(guide_hexes[c("orange", "navy")]))
  expect_length(ftm_series, 6)
})

test_that("softening keeps names and changes the colors", {
  expect_named(
    ftm_fills,
    c("orange", "navy", "sky_drift", "green", "purple", "yellow")
  )
  expect_false(any(ftm_fills == ftm_colors[names(ftm_fills)]))
})

test_that("plot font comes from the brand file", {
  expect_equal(ftm_font, "Source Sans 3")
})

test_that("CSS font families needing quotes are quoted in the brand file", {
  # Quarto copies these into CSS verbatim; an unquoted name with a word that
  # starts with a digit (e.g. "Source Sans 3") is invalid CSS and the browser
  # silently falls back to a default font.
  typo <- ftm_brand()$typography
  families <- c(
    typo$base$family,
    typo$headings$family,
    typo$monospace$family
  )
  needs_quotes <- grepl("(^|\\s)[0-9]", families)
  quoted <- grepl("^(['\"]).*\\1$", families)
  expect_true(all(quoted[needs_quotes]), info = families[needs_quotes])
})
