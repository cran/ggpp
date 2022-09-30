#' @title Filter observations by local 1D density
#'
#' @description \code{stat_dens1d_filter} Filters-out/filters-in observations in
#'   regions of a plot panel with high density of observations, based on the
#'   values mapped to one of \code{x} and \code{y} aesthetics.
#'   \code{stat_dens1d_filter_g} does the same filtering by group instead of by
#'   panel. This second stat is useful for highlighting observations, while the
#'   first one tends to be most useful when the aim is to prevent clashes among
#'   text labels.
#'
#' @param mapping The aesthetic mapping, usually constructed with
#'   \code{\link[ggplot2]{aes}} or \code{\link[ggplot2]{aes_}}. Only needs to be
#'   set at the layer level if you are overriding the plot defaults.
#' @param data A layer specific dataset - only needed if you want to override
#'   the plot defaults.
#' @param geom The geometric object to use display the data.
#' @param keep.fraction numeric [0..1]. The fraction of the observations (or
#'   rows) in \code{data} to be retained.
#' @param keep.number integer Set the maximum number of observations to retain,
#'   effective only if obeying \code{keep.fraction} would result in a larger
#'   number.
#' @param keep.sparse logical If \code{TRUE}, the default, observations from the
#'   more sparse regions are retained, if \code{FALSE} those from the densest
#'   regions.
#' @param invert.selection logical If \code{TRUE}, the complement of the
#'   selected rows are returned.
#' @param bw numeric or character The smoothing bandwidth to be used. If
#'   numeric, the standard deviation of the smoothing kernel. If character, a
#'   rule to choose the bandwidth, as listed in \code{\link[stats]{bw.nrd}}.
#' @param adjust numeric A multiplicative bandwidth adjustment. This makes it
#'   possible to adjust the bandwidth while still using the a bandwidth
#'   estimator through an argument passed to \code{bw}. The larger the value
#'   passed to \code{adjust} the stronger the smoothing, hence decreasing
#'   sensitivity to local changes in density.
#' @param kernel character See \code{\link{density}} for details.
#' @param n numeric Number of equally spaced points at which the density is to
#'   be estimated for applying the cut point. See \code{\link{density}} for
#'   details.
#' @param orientation	character The aesthetic along which density is computed.
#'   Given explicitly by setting orientation to either \code{"x"} or \code{"y"}.
#' @param position The position adjustment to use for overlapping points on this
#'   layer
#' @param show.legend logical. Should this layer be included in the legends?
#'   \code{NA}, the default, includes if any aesthetics are mapped. \code{FALSE}
#'   never includes, and \code{TRUE} always includes.
#' @param inherit.aes If \code{FALSE}, overrides the default aesthetics, rather
#'   than combining with them. This is most useful for helper functions that
#'   define both data and aesthetics and shouldn't inherit behaviour from the
#'   default plot specification, e.g. \code{\link[ggplot2]{borders}}.
#' @param ... other arguments passed on to \code{\link[ggplot2]{layer}}. This
#'   can include aesthetics whose values you want to set, not map. See
#'   \code{\link[ggplot2]{layer}} for more details.
#' @param na.rm	a logical value indicating whether \code{NA} values should be
#'   stripped before the computation proceeds.
#'
#' @return A plot layer instance. Using as output \code{data} a subset of the
#'   rows in input \code{data} retained based on a 1D filtering criterion.
#'
#' @seealso \code{\link[stats]{density}} used internally.
#'
#' @family statistics returning a subset of data
#'
#' @examples
#'
#' random_string <-
#'   function(len = 6) {
#'     paste(sample(letters, len, replace = TRUE), collapse = "")
#'   }
#'
#' # Make random data.
#' set.seed(1001)
#' d <- tibble::tibble(
#'   x = rnorm(100),
#'   y = rnorm(100),
#'   group = rep(c("A", "B"), c(50, 50)),
#'   lab = replicate(100, { random_string() })
#' )
#' d$xg <- d$x
#' d$xg[51:100] <- d$xg[51:100] + 1
#'
#' # highlight the 1/10 of observations in sparsest regions of the plot
#' ggplot(data = d, aes(x, y)) +
#'   geom_point() +
#'   geom_rug(sides = "b") +
#'   stat_dens1d_filter(colour = "red") +
#'   stat_dens1d_filter(geom = "rug", colour = "red", sides = "b")
#'
#' # highlight the 1/4 of observations in densest regions of the plot
#' ggplot(data = d, aes(x, y)) +
#'   geom_point() +
#'   geom_rug(sides = "b") +
#'   stat_dens1d_filter(colour = "blue",
#'                      keep.fraction = 1/4, keep.sparse = FALSE) +
#'   stat_dens1d_filter(geom = "rug", colour = "blue",
#'                      keep.fraction = 1/4, keep.sparse = FALSE,
#'                      sides = "b")
#'
#' # switching axes
#' ggplot(data = d, aes(x, y)) +
#'   geom_point() +
#'   geom_rug(sides = "l") +
#'   stat_dens1d_filter(colour = "red", orientation = "y") +
#'   stat_dens1d_filter(geom = "rug", colour = "red", orientation = "y",
#'                      sides = "l")
#'
#' # highlight 1/10 plus 1/10 observations in high and low density regions
#' ggplot(data = d, aes(x, y)) +
#'   geom_point() +
#'   geom_rug(sides = "b") +
#'   stat_dens1d_filter(colour = "red") +
#'   stat_dens1d_filter(geom = "rug", colour = "red", sides = "b") +
#'   stat_dens1d_filter(colour = "blue", keep.sparse = FALSE) +
#'   stat_dens1d_filter(geom = "rug",
#'                      colour = "blue", keep.sparse = FALSE, sides = "b")
#'
#' # selecting the 1/10 observations in sparsest regions and their complement
#' ggplot(data = d, aes(x, y)) +
#'   stat_dens1d_filter(colour = "red") +
#'   stat_dens1d_filter(geom = "rug", colour = "red", sides = "b") +
#'   stat_dens1d_filter(colour = "blue", invert.selection = TRUE) +
#'   stat_dens1d_filter(geom = "rug",
#'                      colour = "blue", invert.selection = TRUE, sides = "b")
#'
#' # density filtering done jointly across groups
#' ggplot(data = d, aes(xg, y, colour = group)) +
#'   geom_point() +
#'   geom_rug(sides = "b", colour = "black") +
#'   stat_dens1d_filter(shape = 1, size = 3, keep.fraction = 1/4, adjust = 2)
#'
#' # density filtering done independently for each group
#' ggplot(data = d, aes(xg, y, colour = group)) +
#'   geom_point() +
#'   geom_rug(sides = "b") +
#'   stat_dens1d_filter_g(shape = 1, size = 3, keep.fraction = 1/4, adjust = 2)
#'
#' # density filtering done jointly across groups by overriding grouping
#' ggplot(data = d, aes(xg, y, colour = group)) +
#'   geom_point() +
#'   geom_rug(sides = "b") +
#'   stat_dens1d_filter_g(colour = "black",
#'                        shape = 1, size = 3, keep.fraction = 1/4, adjust = 2)
#'
#' # label observations
#' ggplot(data = d, aes(x, y, label = lab, colour = group)) +
#'   geom_point() +
#'   stat_dens1d_filter(geom = "text", hjust = "outward")
#'
#' # repulsive labels with ggrepel::geom_text_repel()
#' ggrepel.installed <- requireNamespace("ggrepel", quietly = TRUE)
#' if (ggrepel.installed) {
#'   library(ggrepel)
#'
#'   ggplot(data = d, aes(x, y, label = lab, colour = group)) +
#'     geom_point() +
#'     stat_dens1d_filter(geom = "text_repel")
#' }
#'
#' @export
#'
stat_dens1d_filter <-
  function(mapping = NULL,
           data = NULL,
           geom = "point",
           position = "identity",
           ...,
           keep.fraction = 0.10,
           keep.number = Inf,
           keep.sparse = TRUE,
           invert.selection = FALSE,
           bw = "SJ",
           kernel = "gaussian",
           adjust = 1,
           n = 512,
           orientation = "x",
           na.rm = TRUE,
           show.legend = FALSE,
           inherit.aes = TRUE) {
    ggplot2::layer(
      stat = StatDens1dFilter, data = data, mapping = mapping, geom = geom,
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(na.rm = na.rm,
                    keep.fraction = keep.fraction,
                    keep.number = keep.number,
                    keep.sparse = keep.sparse,
                    invert.selection = invert.selection,
                    bw = bw,
                    adjust = adjust,
                    kernel = kernel,
                    n = n,
                    orientation = orientation,
                    ...)
    )
  }

#' @rdname stat_dens1d_filter
#'
#' @export
#'
stat_dens1d_filter_g <-
  function(mapping = NULL, data = NULL,
           geom = "point", position = "identity",
           keep.fraction = 0.10,
           keep.number = Inf,
           keep.sparse = TRUE,
           invert.selection = FALSE,
           na.rm = TRUE, show.legend = FALSE,
           inherit.aes = TRUE,
           bw = "SJ",
           adjust = 1,
           kernel = "gaussian",
           n = 512,
           orientation = "x",
           ...) {
    ggplot2::layer(
      stat = StatDens1dFilterG, data = data, mapping = mapping, geom = geom,
      position = position, show.legend = show.legend, inherit.aes = inherit.aes,
      params = list(na.rm = na.rm,
                    keep.fraction = keep.fraction,
                    keep.number = keep.number,
                    keep.sparse = keep.sparse,
                    invert.selection = invert.selection,
                    bw = bw,
                    kernel = kernel,
                    adjust = adjust,
                    n = n,
                    orientation = orientation,
                    ...)
    )
  }

dens1d_flt_compute_fun <-
  function(data,
           scales,
           keep.fraction,
           keep.number,
           keep.sparse,
           invert.selection,
           bw,
           kernel,
           adjust,
           n,
           orientation) {

    if (is.na(keep.fraction) || keep.fraction < 0 || keep.fraction > 1) {
      stop("Out of range or missing value for 'keep.fraction': ", keep.fraction)
    }
    if (is.na(keep.number) || keep.number < 0) {
      stop("Out of range or missing value for 'keep.number': ", keep.number)
    }

    force(data)
    if (nrow(data) * keep.fraction > keep.number) {
      keep.fraction <- keep.number / nrow(data)
    }

    if (keep.fraction == 1) {
      keep <- TRUE
    } else if (keep.fraction == 0) {
      keep <- FALSE
    } else {
      dens <-
        stats::density(data[[orientation]],
                       bw = bw, kernel = kernel, adjust = adjust, n = n,
                       from = scales[[orientation]]$dimension()[1],
                       to = scales[[orientation]]$dimension()[2])

      fdens <- stats::splinefun(dens$x, dens$y)
      dens <- fdens(data[[orientation]])

      if (keep.sparse) {
        keep <- dens < stats::quantile(dens, keep.fraction, names = FALSE)
      } else {
        keep <- dens >= stats::quantile(dens, 1 - keep.fraction, names = FALSE)
      }
    }
    if (invert.selection){
      data[!keep, ]
    } else {
      data[keep, ]
    }
  }

#' @rdname ggpp-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatDens1dFilter <-
  ggplot2::ggproto(
    "StatDens1dFilter",
    ggplot2::Stat,
    compute_panel =
      dens1d_flt_compute_fun,
    required_aes = "x|y" # c("x", "y")
  )

#' @rdname ggpp-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatDens1dFilterG <-
  ggplot2::ggproto(
    "StatDens1dFilterG",
    ggplot2::Stat,
    compute_group =
      dens1d_flt_compute_fun,
    required_aes = "x|y" # c("x", "y")
  )
