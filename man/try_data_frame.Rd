% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/try-data-frame.R
\name{try_data_frame}
\alias{try_data_frame}
\alias{try_tibble}
\title{Convert an R object into a tibble}
\usage{
try_data_frame(
  x,
  time.resolution = "month",
  as.numeric = FALSE,
  col.names = NULL
)

try_tibble(x, time.resolution = "month", as.numeric = FALSE, col.names = NULL)
}
\arguments{
\item{x}{An R object}

\item{time.resolution}{character The time unit to which the returned time
values will be rounded.}

\item{as.numeric}{logical If TRUE convert time to numeric, expressed as
fractional calendar years.}

\item{col.names}{character vector}
}
\value{
A \code{tibble::tibble} object, derived from \code{data.frame}.
}
\description{
This functions tries to convert any R object into a data.frame object.
If \code{x} is already a data.frame, it is returned as is. If it is
a list or a vector it is converted by means of \code{as.data.frame()}.
If of any other type, a conversion into an object of class \code{xts} is
attempted by means of \code{try.xts()} and if successful the \code{xts}
object is converted into a data frame with a variable \code{time}
containing times as \code{POSIXct} and the remaining data columns with
the time series data. In this conversion row names are stripped.
}
\note{
This function can be used to easily convert time series data into a
  format that can be easily plotted with package \code{ggplot2}.
  \code{try_tibble} is another name for \code{try_data_frame} which tracks
  the separation and re-naming of \code{data_frame} into
  \code{tibble::tibble} in the imported packages.
}
\section{Warning!}{
 The time zone was set to "UTC" by try.xts() in the test
  cases I used. Setting TZ to "UTC" can cause some trouble as several
  frequently used functions have as default the local or system TZ and will
  apply a conversion before printing or plotting time data, which in addition
  is affected by summer/winter time transitions. This should be taken into
  account as even for yearly data when conversion is to POSIXct a day (1st of
  January) will be set, but then shifted some hours if printed on a TZ
  different from "UTC". I recommend reading the documentation of package
  \code{\link[lubridate]{lubridate-package}} where the irregularities of time
  data and the difficulties they cause are very well described. In many cases
  when working with time series with yearly observations it is best to work
  with numeric values for years.
}

\examples{
class(lynx)
try_tibble(lynx)
try_tibble(lynx, as.numeric = TRUE)
try_tibble(lynx, "year")
class(austres)
try_tibble(austres)
try_tibble(austres, as.numeric = TRUE)
try_tibble(austres, "quarter")
class(cars)
try_tibble(cars)

}
