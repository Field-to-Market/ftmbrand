# CLAUDE.md — ftmbrand (repo: Field-to-Market/ftmbrand)

R package + Quarto brand extension holding Field to Market's visual brand.
README.md is the user guide; this file is the working brief.

## Rules

- `inst/brand/_brand.yml` is the single source of truth. R objects
  (`ftm_colors`, `ftm_series`, `ftm_fills`, `ftm_font`) are filled from it in
  `.onLoad` (`R/zzz.R`). Never retype a hex in R code. The only hand-typed
  hexes are in `tests/testthat/test-colors.R`, pinning the yml to the brand
  guide (FTM_Brand Guidelines_011626.pdf, p.14).
- `_extensions/ftmbrand/` is a copy. After editing `inst/brand/`, run
  `Rscript tools/sync-extension.R`; `test-extension.R` fails until you do.
- Never commit the commercial fonts (Trade Gothic Next, Chaparral Pro) or the
  brand guide PDF. Only OFL fonts go in `inst/fonts/`.
- Optional dependencies (Polychrome, patchwork, png) stay in Suggests, with a
  `requireNamespace()` check and a `cli::cli_abort()` install hint.
- Style follows mango-tango: native pipe, `{fs}` not base file functions,
  `{cli}` messages, roxygen on every function, Air + jarl before commit.
- Design rationale for the palette functions came from fp-project-report
  (#228, #230 there); keep its reasoning in the roxygen when changing them.

## Commands

```bash
Rscript -e 'devtools::document(); devtools::test()'
Rscript -e 'devtools::check()'
Rscript tools/sync-extension.R
air format . && jarl check .
```

Rscript full path if needed: `/c/Program Files/R/R-4.6.2/bin/x64/Rscript.exe`.
