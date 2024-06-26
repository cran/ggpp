% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ggpp-legend-draw.R
\name{ggpp_draw_key}
\alias{ggpp_draw_key}
\alias{draw_key_text_s}
\alias{draw_key_label_s}
\title{Key glyphs for legends}
\usage{
draw_key_text_s(data, params, size)

draw_key_label_s(data, params, size)
}
\arguments{
\item{data}{A single row data frame containing the scaled aesthetics to
display in this key}

\item{params}{A list of additional parameters supplied to the geom.}

\item{size}{Width and height of key in mm.}
}
\value{
A grid grob.
}
\description{
Each geom has an associated function that draws the key when the geom needs
to be displayed in a legend. These functions are called `draw_key_*()`, where
`*` stands for the name of the respective key glyph. The key glyphs can be
customized for individual geoms by providing a geom with the `key_glyph`
argument (see [`layer()`] or examples below.)
}
\examples{
p <- ggplot(economics, aes(date, psavert, color = "savings rate"))
# key glyphs can be specified by their name
p + geom_line(key_glyph = "timeseries")

# key glyphs can be specified via their drawing function
p + geom_line(key_glyph = draw_key_rect)

}
\keyword{internal}
