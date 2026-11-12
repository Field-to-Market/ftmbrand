# ftmbrand (development version)

* Code is now MIT licensed. The Field to Market name and logos are excluded;
  see `TRADEMARKS.md`. The repository is public, so `pak::pak()` and
  `quarto add Field-to-Market/ftmbrand` no longer need a token or local clone.

# ftmbrand 0.2.0

* Web fonts are bundled instead of loaded from Google Fonts, so Quarto sites
  and `embed-resources` reports render offline with no external font
  requests. `inst/fonts/` moved to `inst/brand/fonts/`, which now also holds
  Source Sans 3 Semibold, Bebas Neue and Fira Code (all SIL Open Font
  License). The same files register for R plots.

# ftmbrand 0.1.0

* First version. Canonical `_brand.yml` (Jan 2026 brand guide colors), logos,
  bundled Source Sans 3; `theme_ftm()`, discrete/diverging/sequential scales,
  `ftm_pal()`, `ftm_cat_pal()`, `ftm_soften()`, `contrast_text()`,
  `add_logo()`; Quarto brand extension in `_extensions/ftmbrand/`.
* Seeded from `methods/_brand.yml`, `fp-project-report/src/R/ftm_themes.R` and
  `mango-tango/R/theme_ftm.R` + `add_logo.R`.
* `ftm_cdl_colors()`, `scale_fill_cdl()`, `scale_colour_cdl()`: USDA Cropland
  Data Layer colors for 134 CDL classes (provisional provenance; see docs).
* Dark-background series: `ftm_pal()`, `scale_*_ftm()` and
  `set_ftm_defaults()` gain `dark = TRUE`, which drops navy and purple.
