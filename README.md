# ftmbrand

One source of truth for Field to Market's visual brand: colors, fonts and
logos for R figures, Quarto sites and Shiny apps.

**Install it; never copy its files.** Copies are how the brand drifted before:
the January 2026 rebrand reached only about half of the hand-copied
`theme_ftm.R` / `_brand.yml` files across FTM repositories. A copy can't tell
you it's stale; an installed, versioned package can.

## What's here

| Path | What it is |
|---|---|
| `inst/brand/_brand.yml` | **The source of truth.** Colors, fonts, logos ([brand.yml](https://posit-dev.github.io/brand-yml/) spec) |
| `inst/brand/logos/` | Official logo files (horizontal, horizontal reverse, vertical, favicon) |
| `inst/brand/fonts/` | Source Sans 3, Bebas Neue, Fira Code (SIL Open Font License). Served to sites and reports, and registered for plots on load |
| `R/` | The R package: theme, scales, palettes, logo helpers. All read `_brand.yml` |
| `_extensions/ftmbrand/` | Quarto brand extension: a synced copy of `inst/brand/` |

Brand values follow *FTM_Brand Guidelines_011626.pdf* (Version 1.0, January
2026). The guide is internal, so it isn't committed here.

## R

```r
pak::pak("Field-to-Market/ftmbrand")   # private repo: needs a GITHUB_PAT
library(ftmbrand)
library(ggplot2)

ggplot(mpg, aes(displ, hwy, colour = drv)) +
  geom_point() +
  scale_colour_ftm() +
  labs(title = "Highway mileage", caption = ftm_credit()) +
  theme_ftm()

set_ftm_defaults()            # brand palette for every discrete scale
ftm_colors[["navy"]]          # named brand colors (from _brand.yml)
ftm_fills                     # softened colors for bars and areas
ftm_cat_pal(12)               # many-category palette (needs Polychrome)
contrast_text(ftm_fills)      # black or white label per fill
add_logo(last_plot())         # inset the logo (needs patchwork, png)
```

**Dark backgrounds:** pair `theme_ftm(dark = TRUE)` with
`scale_colour_ftm(dark = TRUE)` (or `set_ftm_defaults(dark = TRUE)`). The
dark series drops navy and purple, which vanish on Night Spark.

**Crop colors:** where color encodes crop, use the USDA Cropland Data Layer
colors so charts match CDL maps: `ftm_cdl_colors("Corn")`, `scale_fill_cdl()`.
Keys are CDL class names ("Winter Wheat", "Sweet Potatoes"). Map your own crop
names to them in your project. Several classes share a color, and the lookup
warns when you request two of them. Provenance is provisional (see
`?ftm_cdl_colors`).

Save figures with ragg (`ggsave(..., device = ragg::agg_png)`) so the font
resolves; base `png()`/`pdf()` devices ignore registered fonts.

**Using color:** orange leads, then navy. The guide's hierarchy is 40% navy,
40% orange, 5% for each secondary, with the bold secondaries "as accents or
small color blocks". So use `ftm_colors` for lines, points and identity
marks, and `ftm_fills` (softened) for anything that fills an area. White text
goes on navy (about 9:1), never on orange (about 3:1).

## Quarto

```bash
quarto add Field-to-Market/ftmbrand
```

This needs a `_quarto.yml` project. The extension contributes `project.brand`, so
the site's colors, fonts and logos come from the shared file. Delete any local
`_brand.yml` copy when you adopt it. Commit `_extensions/ftmbrand/`: other
people then render your project without needing ftmbrand themselves.

Fonts are bundled, so renders need no network and `embed-resources: true`
reports carry their own typography.

**Self-contained reports (`embed-resources: true`):** declare the brand
light-only in `_quarto.yml`. Otherwise Quarto also builds an unused dark
stylesheet and a duplicate light one, and inlines the fonts into all three
(a 2.5 MB test report became 7.6 MB, with no visible difference):

```yaml
brand:
  light: _extensions/ftmbrand/brand.yml
```

The extension can't set this itself (Quarto accepts only a plain path there).
`favicon:` is ignored outside websites; for a single document add
`include-in-header: {text: '<link rel="icon" href="_extensions/ftmbrand/logos/favicon.ico">'}`
and `embed-resources` inlines it.

**Custom SCSS on top of the brand:** `$brand-*` variables are available in a
theme file's `scss:rules` section only; Quarto places a file's
`scss:defaults` ahead of the brand's, where they're undefined.

**While this repo is private**, `quarto add Field-to-Market/ftmbrand` fails
with "Extension not found". Install from a local clone instead, run from the
consuming project's root:

```bash
git -C ../ftmbrand pull          # get the latest brand
quarto add ../ftmbrand           # installs, or overwrites an older copy
```

The same command updates an existing install; `quarto update` won't work while
the repo is private. Then re-render, check the result, and commit the changed
`_extensions/ftmbrand/`.

## Shiny

```r
bslib::page_fluid(theme = bslib::bs_theme(brand = ftmbrand::ftm_brand_path()))
```

## Python

There's no Python package yet. Read `inst/brand/_brand.yml` directly, for
example with Posit's `brand_yml` package. A helper will be added once a Python
project needs one.

## Changing the brand

1. Edit `inst/brand/_brand.yml` (and logos or fonts in `inst/brand/logos/`,
   `inst/brand/fonts/`). Fonts are `.ttf` (for R) plus a `.woff2` web copy;
   after adding or replacing a `.ttf`, rebuild the web copies with
   `uv run --no-project --with fonttools --with brotli python tools/build-woff2.py`.
2. Run `Rscript tools/sync-extension.R` to update the Quarto copy.
3. `devtools::test()`. Tests pin the hexes to the brand guide and fail if the
   extension copy is stale.
4. Bump `Version` in `DESCRIPTION` and `_extensions/ftmbrand/_extension.yml`,
   and add a `NEWS.md` entry.
5. Consumers update with `pak::pak()` for R and, for Quarto, re-run
   `quarto add` (see [Quarto](#quarto)).

Never commit the commercial brand fonts (Trade Gothic Next, Chaparral Pro) or
the brand guide PDF. `.gitignore` blocks both.
