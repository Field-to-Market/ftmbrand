# Rebuild the web font files (.woff2) from the bundled .ttf files.
#
# Why two formats: R (systemfonts/ragg) can only use .ttf, while browsers take
# .woff2, which is the same font compressed to roughly a third of the size.
# Quarto embeds web fonts into every stylesheet copy of an embed-resources
# report, so the smaller format roughly halves the report size versus .ttf.
#
# The conversion is lossless: it repackages the same glyphs and name tables.
# Run it from the repository root whenever a .ttf in inst/brand/fonts/ is added
# or replaced, then run `Rscript tools/sync-extension.R`:
#
#   uv run --no-project --with fonttools --with brotli python tools/build-woff2.py
#
# (fonttools does the conversion; brotli is the compression WOFF2 requires.)

import pathlib
import sys

from fontTools.ttLib import TTFont

# Folder holding the bundled fonts, relative to the repository root.
FONT_DIR = pathlib.Path("inst/brand/fonts")

if not FONT_DIR.is_dir():
    sys.exit("Run from the repository root (inst/brand/fonts/ not found).")

ttfs = sorted(FONT_DIR.glob("*.ttf"))
for ttf in ttfs:
    font = TTFont(ttf)          # open the .ttf
    font.flavor = "woff2"       # ask fonttools to write it out as WOFF2
    out = ttf.with_suffix(".woff2")
    font.save(out)              # writes e.g. SourceSans3-Regular.woff2
    print(f"{ttf.name} ({ttf.stat().st_size // 1024} KB) -> "
          f"{out.name} ({out.stat().st_size // 1024} KB)")

print(f"Converted {len(ttfs)} font file(s). Now run: Rscript tools/sync-extension.R")
