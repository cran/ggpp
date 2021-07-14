
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggpp <img src="man/figures/logo-ggpp.png" align="right" width="150" />

[![cran
version](https://www.r-pkg.org/badges/version/ggpp)](https://cran.r-project.org/package=ggpp)
[![R build
status](https://github.com/aphalo/ggpp/workflows/R-CMD-check/badge.svg)](https://github.com/aphalo/ggpp/actions)

## Purpose

Package ‘**ggpp**’ provides a set of building blocks that extend the
Grammar of Graphics implemented in package ‘ggplot2’ (&gt;= 3.0.0). New
geoms support insets in plots, marginal marks and the use of native plot
coordinates (npc). Position functions implement new approaches to
nudging usable with any geometry, but especially useful together with
`geom_text_linked()`, `geom_text_repel()` and `geom_label_repel()`.

## Extended Grammar of graphics

### Geometries

Geometries `geom_table()`, `geom_plot()` and `geom_grob()` make it
possible to add inset tables, inset plots, and arbitrary ‘grid’
graphical objects including bitmaps and vector graphics as layers to a
ggplot using native coordinates for `x` and `y`.

Geometries `geom_text_npc()`, `geom_label_npc()`, `geom_table_npc()`,
`geom_plot_npc()` and `geom_grob_npc()`, `geom_text_npc()` and
`geom_label_npc()` are versions of geometries that accept positions on
*x* and *y* axes using aesthetics `npcx` and `npcy` values expressed in
“npc” units.

Geometries `geom_x_margin_arrow()`, `geom_y_margin_arrow()`,
`geom_x_margin_grob()`, `geom_y_margin_grob()`, `geom_x_margin_point()`
and `geom_y_margin_point()` make it possible to add marks along the *x*
and *y* axes. `geom_vhlines()` and `geom_quadrant_lines()` draw vertical
and horizontal reference lines within a single layer.

Geometry `geom_text_linked()` connects text drawn at a nudged position
to the original position, usually that of a point being labelled.

### Aesthetics and scales

Scales `scale_npcx_continuous()` and `scale_npcy_continuous()` and the
corresponding new aesthetics `npcx` and `npcy` make it possible to add
graphic elements and text to plots using coordinates expressed in `npc`
units for the location within the plotting area.

### Statistics

Statistic `stat_fmt_tb()` helps with the formatting of tables to be
plotted with `geom_table()`.

Four statistics, `stat_dens2d_filter()`, `stat_dens2d_label()`,
`stat_dens1d_filter()` and `stat_dens1d_label()`, implement tagging or
selective labelling of observations based on the local 2D density of
observations in a panel. Another two statistics,
`stat_dens1d_filter_g()` and `stat_dens1d_filter_g()` compute the
density by group instead of by plot panel. These six stats are designed
to work well together with `geom_text_repel()` and `geom_label_repel()`
from package ‘ggrepel’.

The statistics `stat_apply_panel()` and `stat_apply_group()` can be
useful for applying arbitrary functions returning numeric vectors. They
are specially useful with functions lime `cumsum()`, `cummax()` and
`diff()`.

## Position functions

New position functions implementing different flavours of nudging are
provided: `position_nudge_keep()`, `position_nudge_to()`,
`position_nudge_center()` and `position_nudge_line()`. These last two
functions make it possible to apply nudging that varies automatically
according to the relative position of points with respect to arbitrary
points or lines, or with respect to a polynomial or smoothing spline
fitted on-the-fly to the the observations. In contrast to
`ggplot2::position_nudge()` all these functions return the repositioned
and original *x* and *y* coordinates.

## History

This package is a “spin-off” from package ‘ggpmisc’ containing
extensions to the grammar originally written for use wihtin ‘ggpmisc’.
As ‘ggpmisc’ has grown in size, spliting it into two packages seems the
best option. For the time being, package ‘ggpmisc’ will import and
re-export visible defintions from ‘ggpp’.

## Examples

``` r
library(ggpp)
library(ggrepel)
library(dplyr)
```

A plot with an inset table.

``` r
mtcars %>%
  group_by(cyl) %>%
  summarize(wt = mean(wt), mpg = mean(mpg)) %>%
  ungroup() %>%
  mutate(wt = sprintf("%.2f", wt),
         mpg = sprintf("%.1f", mpg)) -> tb

df <- tibble(x = 5.45, y = 34, tb = list(tb))

ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
  geom_point() +
  geom_table(data = df, aes(x = x, y = y, label = tb))
```

![](man/figures/README-readme-03-1.png)<!-- -->

A plot with an inset plot. With the inset plot positioned using native
plot coordinates (npc) and using keywords insted of numerical values in
the range 0..1 which are also accepted.

``` r
p <- ggplot(mtcars, aes(factor(cyl), mpg, colour = factor(cyl))) +
  stat_boxplot() +
  labs(y = NULL, x = "Engine cylinders (number)") +
  theme_bw(9) + theme(legend.position = "none")

ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
  geom_point(show.legend = FALSE) +
  annotate("plot_npc", npcx = "left", npcy = "bottom", label = p) +
  expand_limits(y = 0, x = 0)
```

![](man/figures/README-readme-06-1.png)<!-- --> Marginal markings

``` r
data.tb <- mtcars %>%
  group_by(cyl) %>%
  summarise(wt = mean(wt), mpg = mean(mpg))

ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
  geom_x_margin_arrow(data = data.tb,
                      aes(xintercept = wt, color = factor(cyl)),
                      arrow.length = 0.05) +
  geom_y_margin_arrow(data = data.tb,
                      aes(yintercept = mpg, color = factor(cyl)),
                      arrow.length = 0.05) +
  annotate("plot_npc", npcx = "right", npcy = "top", 
           label = p + theme(axis.title.y = element_blank())) +
  expand_limits(y = 10) +
  geom_point(show.legend = FALSE) 
```

![](man/figures/README-unnamed-chunk-1-1.png)<!-- --> \#\# Installation

Installation of the most recent stable version from CRAN:

``` r
install.packages("ggpp")
```

Installation of the current unstable version from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("aphalo/ggpp")
```

## Documentation

HTML documentation for the package, including help pages and the *User
Guide*, is available at (<https://docs.r4photobiology.info/ggpp/>).

News about updates are regularly posted at
(<https://www.r4photobiology.info/>).

Chapter 7 in Aphalo (2020) explains both basic concepts of the gramamr
of graphics as implemented in ‘ggplot2’ as well as extensions to this
grammar including several of those made available by packages ‘ggpp’ and
‘ggpmisc’.

## Contributing

Please report bugs and request new features at
(<https://github.com/aphalo/ggpp/issues>). Pull requests are welcome at
(<https://github.com/aphalo/ggpp>).

## Citation

If you use this package to produce scientific or commercial
publications, please cite according to:

``` r
citation("ggpp")
```

## References

Aphalo, Pedro J. (2020) *Learn R: As a Language.* The R Series. Boca
Raton and London: Chapman and Hall/CRC Press. ISBN: 978-0-367-18253-3.
350 pp.

## License

© 2016-2021 Pedro J. Aphalo (<pedro.aphalo@helsinki.fi>). Released under
the GPL, version 2 or greater. This software carries no warranty of any
kind.
