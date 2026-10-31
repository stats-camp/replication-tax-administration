# Replication: No Taxation without Administration: Bringing the State Back into the Public Finance of Developing Countries

Anders Jensen and Jonathan Weigel — *Journal of Economic Literature (2026); the authors’ README labels the package 2025*.

This [stats.camp](https://stats.camp) repository preserves official AEA deposit
**237027, version V1**, for replication and engine compatibility testing.
**Status: executed on 2026-10-16 and again on 2026-10-17 with the native stats.camp engine from scratch copies; the package runs end to end.** The analysis do-files retain their original commands, paths, whitespace, encoding, and line endings.

## The study

Studies tax administration and state capacity in developing countries, combining public government-revenue, revenue-administration, governance, and GDP data into country-level comparisons.

## Contents and entry points

The deposit includes raw, intermediate, and final data and reference PDF figures. Native chart-format reference files are maintained with the external validation records; the exported PDF figures remain here. The analysis uses the supplied `VDEM_short.csv`; the separate R script documents how it was selected from the full V-Dem CSV. The final analysis dataset is already supplied.

The original archive contains **38 original files** totaling
**406,857,176 bytes**. The source ZIP is
27,794,252 bytes. Research data and code are retained. Accompanying notes are adapted for stats.camp;
source documentation and preparation records are maintained separately.

Entry points for inspection:

- [replication_package/01_build_data.do](replication_package/01_build_data.do)
- [replication_package/02_figures.do](replication_package/02_figures.do)

Package documentation adapted for stats.camp:

- [replication_package/_readme.txt](replication_package/_readme.txt)

## Setup and current scope

The authors specify the order `01_build_data.do`, then `02_figures.do`. Both scripts assign `global replication_package` internally: the build script has an absolute author path, and the figure script assigns an empty string. Both assignments remain unchanged. Runtime path handling or scratch-only adaptations must be evaluated before executing them.

The 2026-10-16 runs used scratch copies, so the figures, logs and intermediate
datasets in this repository are still the authors' deposited reference material.

Large raw source files are stored with **Git LFS**: `replication_package/data/raw/V-Dem-CY-Full+Others-v14.csv`. After cloning, run `git lfs install --local` and `git lfs pull` to materialize them. GitHub source ZIPs may contain pointers rather than these payloads.

## Inspect in stats.camp

These links open the deposited files for inspection. They do not establish
that the preserved paths, dependencies, or commands are executable in the browser.

- [replication_package/01_build_data.do](https://stats.camp/app?open=https%3A%2F%2Fgithub.com%2Fstats-camp%2Freplication-tax-administration.git&file=replication_package%2F01_build_data.do)
- [replication_package/02_figures.do](https://stats.camp/app?open=https%3A%2F%2Fgithub.com%2Fstats-camp%2Freplication-tax-administration.git&file=replication_package%2F02_figures.do)

## Source integrity and attribution

- [Official deposit](https://www.openicpsr.org/openicpsr/project/237027/version/V1/view)
- [Deposit DOI](https://doi.org/10.3886/E237027V1)

Archive: `237027-V1.zip`. SHA-256:
`66ee08eaa55bae4a87e231028fb477e0f50bd6bd4e388fe736f64028586a3ab9`.

All original file hashes were checked after extraction. `.gitattributes` disables
Git line-ending normalization to preserve deposited bytes. Empty folders are
represented by `.gitkeep` files. The root README and Git attributes are stats-camp additions.

The archive contains no separate LICENSE file. The authors’ rights and provenance statements are retained in the adapted notes; this mirror does not add a license or replace those terms.

The study, code, and data remain credited to Anders Jensen and Jonathan Weigel; stats-camp maintains
this mirror and its preparation documentation.
