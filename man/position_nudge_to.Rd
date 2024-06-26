% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/position-nudge-to.R
\name{position_nudge_to}
\alias{position_nudge_to}
\title{Nudge labels to new positions}
\usage{
position_nudge_to(
  x = NULL,
  y = NULL,
  x.action = c("none", "spread"),
  y.action = c("none", "spread"),
  x.distance = "equal",
  y.distance = "equal",
  x.expansion = 0,
  y.expansion = 0,
  kept.origin = c("original", "none")
)
}
\arguments{
\item{x, y}{Coordinates of the destination position. A vector of mode
\code{numeric}, that is extended if needed, to the same length as rows
there are in \code{data}. The default, \code{NULL}, leaves the original
coordinates unchanged.}

\item{x.action, y.action}{character string, one of \code{"none"}, or
\code{"spread"}. With \code{"spread"} distributing the positions
within the range of argument \code{x} or \code{y}, if non-null, or the
range the variable mapped to \emph{x} or \code{y}, otherwise.}

\item{x.distance, y.distance}{character or numeric Currently only \code{"equal"} is
implemented.}

\item{x.expansion, y.expansion}{numeric vectors of length 1 or 2, as a
fraction of width of the range.}

\item{kept.origin}{One of \code{"original"} or \code{"none"}.}
}
\value{
A \code{"Position"} object.
}
\description{
\code{position_nudge_to()} is generally useful for adjusting the position of
labels or text, both on a discrete or continuous scale.
\code{position_nudge_to()} differs from \code{\link[ggplot2]{position_nudge}}
in that the coordinates of the new position are given directly, rather than
as a displacement from the original location. It optionally sets an even
distance among positions. As other position functions in this package, it
preserves the original position to allow the text to be linked back to its
original position with a segment or arrow.
}
\details{
The nudged to \code{x} and/or \code{y} values replace the original ones in
  \code{data}, while the original coordinates are returned in \code{x_orig}
  and \code{y_orig}. Values supported are those of \emph{mode} numeric,
  thus including dates and times.

  If the length of \code{x} and/or \code{y} is more than one but less than
  rows are present in the data, the vector is both recycled and reordered so
  that the nudges are applied sequentially based on the data values. If their
  length matches the number of rows in data, they are assumed to be already
  in data order.
}
\note{
Irrespective of the action, the ordering of rows in \code{data} is
  preserved.
}
\examples{
df <- data.frame(
  x = c(1,3,2,5,4,2.5),
  y = c(2, 1, 2.5, 1.8, 2.8, 1.5),
  label = c("abc","cd","d","c","bcd","a")
)

# default does nothing
ggplot(df, aes(x, y, label = label)) +
  geom_point() +
  geom_text(position = position_nudge_to())

# a single y (or x) value nudges all observations to this data value
ggplot(df, aes(x, y, label = label)) +
  geom_point() +
  geom_text(position = position_nudge_to(y = 3))

# with a suitable geom, segments or arrows can be added
ggplot(df, aes(x, y, label = label)) +
  geom_point() +
  geom_text_s(position = position_nudge_to(y = 3))

# alternating in y value order because y has fewer values than rows in data
ggplot(df, aes(x, y, label = label)) +
  geom_point() +
  geom_text_s(position = position_nudge_to(y = c(3, 0)))

ggplot(df, aes(x, y, label = label)) +
  geom_point() +
  geom_text_s(position = position_nudge_to(y = c(0, 3)))

# in data row order because y has as many values as rows in data
ggplot(df, aes(x, y, label = label)) +
  geom_point() +
  geom_text_s(position = position_nudge_to(y = rep_len(c(0, 3), 6)))

# spread the values at equal distance within the available space
ggplot(df, aes(x, y, label = label)) +
  geom_point() +
  geom_text_s(position =
    position_nudge_to(y = 3, x.action = "spread"))

# spread the values at equal distance within the expanded available space
ggplot(df, aes(x, y, label = label)) +
  geom_point() +
  geom_text_s(position =
    position_nudge_to(y = 3, x.action = "spread", x.expansion = 0.1))

# spread the values at equal distance within the contracted available space
ggplot(df, aes(x, y, label = label)) +
  geom_point() +
  geom_text_s(position =
    position_nudge_to(y = 3, x.action = "spread", x.expansion = -0.1))

# spread the values at equal distance within the range given by x
ggplot(df, aes(x, y, label = label)) +
  geom_point() +
  geom_text_s(position =
    position_nudge_to(y = 3, x = c(2,4), x.action = "spread"),
    hjust = "center")

ggplot(df, aes(x, y, label = label)) +
  geom_point() +
  geom_text_s(position =
    position_nudge_to(y = 3, x = c(0,6), x.action = "spread"),
    hjust = "center")

}
\seealso{
\code{\link[ggplot2]{position_nudge}},
  \code{\link[ggrepel]{position_nudge_repel}}.

Other position adjustments: 
\code{\link{position_dodgenudge}()},
\code{\link{position_jitternudge}()},
\code{\link{position_nudge_center}()},
\code{\link{position_nudge_keep}()},
\code{\link{position_nudge_line}()},
\code{\link{position_stacknudge}()}
}
\concept{position adjustments}
