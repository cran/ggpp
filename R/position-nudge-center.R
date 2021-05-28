#' Nudge labels away from a central point
#'
#' `position_nudge_center()` is generally useful for adjusting the position of
#' labels or text, both on a discrete or continuous scale. In contrast to
#' [ggplot2::position_nudge], `position_nudge_center()` returns in `data` both
#' the original coordinates and the nudged coordinates.
#'
#' This position function is backwards compatible with [ggplot2::position_nudge]
#' but extends it by adding support for nudging that varies across the plotting
#' region, either in opposite directions or radially from a virtual _center
#' point_.
#'
#' The wrapper `position_nudge_keep()` with exactly the same signature and
#' behaviour as [ggplot2::position_nudge] provides an easier to remember name
#' when the desire is only to have access to both the original and nudged
#' coordinates.
#'
#' @family position adjustments
#'
#' @param x,y Amount of vertical and horizontal distance to move. A numeric
#'   vector of length 1, or of the same length as rows there are in `data`,
#' @param center_x,center_y The coordinates of the virtual origin out from which
#'   nudging radiates or splits in opposite directions. A numeric vector of
#'   length 1 or of the same length as rows there are in `data`, or a function
#'   returning either of these vectors computed from the variables in data
#'   mapped to `x` or `y`, respectively.
#' @param direction One of "none", "radial", or "split". A value of "none"
#'   replicates the behavior of [ggplot2::position_nudge]. Which of these three
#'   values is the default depends on the values passed to the other parameters.
#' @param obey_grouping A logical flag indicating whether to obey or not groupings
#'   of the observations. By default, grouping is obeyed when both of the
#'   variables mapped to _x_ and _y_ are continuous numeric and ignored
#'   otherwise.
#'
#' @details Positive values as arguments to `x` and `y` are added to the
#'   original position along either axis. If no arguments are passed to
#'   `center_x`, `center_y` or `direction`, the nudging is applied as is, as is
#'   the case if `direction = "none"`. If non-`NULL` arguments are passed to
#'   both `center_x` and `center_y`, `direction = "radial"` is assumed. In this
#'   case, if `x` and/or `y` positive nudging is applied radially outwards from
#'   the center, while if negative, inwards towards the center. When a
#'   non-`NULL` argument is passed only to one of `center_x` or `center_y`,
#'   `direction = "split"` is assumed. In this case when the initial location of
#'   the point is to the left of `center_x`, `-x` is used instead of `x` for
#'   nudging, and when the initial location of the point is to the below of
#'   `center_y`, `-y` is used instead of `y` for nudging. If non-`NULL` arguments
#'   are passed to both `center_x` and `center_y`, and `direction` is passed
#'   `"split"` as argument, then the split as described above is applied to
#'   both _x_ and _y_ coordinates.
#'
#' @note Some situations are handled as special cases. When `direction =
#'   "split"` or `direction = "radial"`, observations at exactly the _center_
#'   are nudged using `x` and `y` unchanged. When `direction = "split"`, and
#'   both `center_x` and `center_y` have been supplied, segments are drawn at
#'   eight different possible angles. When segments are exactly horizontal or
#'   vertical they would be shorter than when drawn at the other four angles, in
#'   which case `x` or `y` are extended to ensure these segments are of the same
#'   lengths as those at other angles.
#'
#'   This position is most useful when labeling points forming a cloud or
#'   along vertical or horizontal lines or "divides".
#'
#' @seealso [ggplot2::position_nudge()], [ggrepel::position_nudge_repel()].
#'
#' @return A \code{"Position"} object.
#'
#' @export
#'
#' @examples
#' df <- data.frame(
#'   x = c(1,3,2,5,4,2.5),
#'   y = c("abc","cd","d","c","bcd","a")
#' )
#'
#' # Plain nudging, same as with ggplot2::position_nudge()
#'
#' ggplot(df, aes(x, y, label = y)) +
#'   geom_point() +
#'   geom_text(hjust = 0, vjust = 0,
#'             position = position_nudge(x = 0.05, y = 0.07)
#'   )
#'
#' ggplot(df, aes(x, y, label = y)) +
#'   geom_point() +
#'   geom_text(hjust = 0, vjust = 0,
#'             position = position_nudge_center(x = 0.05, y = 0.07)
#'   )
#'
#' # "split" nudging
#'
#' ggplot(df, aes(x, y)) +
#'   geom_point() +
#'   geom_text(aes(label = y),
#'             hjust = "outward", vjust = "outward",
#'             position = position_nudge_center(x = 0.05,
#'                                              y = 0.07,
#'                                              direction = "split"))
#'
#' ggplot(df, aes(x, y)) +
#'   geom_point() +
#'   geom_text(aes(label = y),
#'             hjust = "outward",
#'             position = position_nudge_center(x = 0.08,
#'                                              direction = "split"))
#'
#' ggplot(df, aes(x, y)) +
#'   geom_point() +
#'   geom_text(aes(label = y),
#'             vjust = "outward",
#'             position = position_nudge_center(y = 0.1,
#'                                              direction = "split"))
#'
#' ggplot(df, aes(x, y)) +
#'   geom_point() +
#'   geom_text(aes(label = y),
#'             vjust = "outward", hjust = "outward",
#'             position = position_nudge_center(x = 0.06,
#'                                              y = 0.08,
#'                                              center_y = 2,
#'                                              center_x = 1.5,
#'                                              direction = "split"))
#'
#' ggplot(df, aes(x, y)) +
#'   geom_point() +
#'   geom_text(aes(label = y),
#'             vjust = "outward", hjust = "outward",
#'             position = position_nudge_center(x = 0.06,
#'                                              y = 0.08,
#'                                              center_y = 2))
#'
#' ggplot(df, aes(x, y)) +
#'   geom_point() +
#'   geom_text(aes(label = y),
#'             vjust = "outward", hjust = "outward",
#'             position = position_nudge_center(x = 0.1,
#'                                              center_x = 2.5))
#'
#' ggplot(df, aes(x, y)) +
#'   geom_point() +
#'   geom_text(aes(label = y),
#'             vjust = "outward", hjust = "outward",
#'             position = position_nudge_center(x = 0.06,
#'                                              y = 0.08,
#'                                              center_x = median,
#'                                              center_y = median,
#'                                              direction = "split"))
#'
#' # "Radial" nudging
#'
#' ggplot(df, aes(x, y)) +
#'   geom_point() +
#'   geom_text(aes(label = y),
#'             vjust = "outward", hjust = "outward",
#'             position = position_nudge_center(x = 0.1,
#'                                              y = 0.2,
#'                                              direction = "radial"))
#'
#' ggplot(df, aes(x, y)) +
#'   geom_point() +
#'   geom_text(aes(label = y),
#'             vjust = "inward", hjust = "inward",
#'             position = position_nudge_center(x = -0.1,
#'                                              y = -0.1,
#'                                              direction = "radial"))
#'
#' df <- data.frame(
#'   x = -10:10,
#'   z = (-10:10)^2,
#'   y = letters[1:21],
#'   group = rep(c("a", "b"), rep(c(11, 10)))
#' )
#'
#' ggplot(df, aes(x, z)) +
#'   geom_point() +
#'   geom_line() +
#'   geom_text(aes(label = y),
#'             vjust = "inward", hjust = "inward",
#'             position = position_nudge_center(x = -0.9,
#'                                              y = -2.7,
#'                                              center_x = mean,
#'                                              center_y = max))
#'
#' ggplot(df, aes(x, z)) +
#'   geom_point() +
#'   geom_line() +
#'   geom_text(aes(label = y),
#'             vjust = "outward", hjust = "outward",
#'             position = position_nudge_center(x = 0.9,
#'                                              y = 2.7,
#'                                              center_x = mean,
#'                                              center_y = max))
#'
#' above_max <- function(x) {1.2 * max(x)}
#' ggplot(df, aes(x, z)) +
#'   geom_point() +
#'   geom_line() +
#'   geom_text(aes(label = y),
#'             vjust = "inward", hjust = "inward",
#'             position = position_nudge_center(x = -1.2,
#'                                              y = -3,
#'                                              center_x = mean,
#'                                              center_y = above_max))
#'
#' ggplot(df, aes(x, z, color = group)) +
#'   geom_point() +
#'   geom_line(color = "black", linetype = "dotted") +
#'   geom_text(aes(label = y),
#'             vjust = "inward", hjust = "inward",
#'             position = position_nudge_center(x = -0.9,
#'                                              y = -2.7,
#'                                              center_x = mean,
#'                                              center_y = max))
#'
#' ggplot(df, aes(x, z, color = group)) +
#'   geom_point() +
#'   geom_line(color = "black", linetype = "dotted") +
#'   geom_text(aes(label = y),
#'             vjust = "inward", hjust = "inward",
#'             position = position_nudge_center(x = -0.9,
#'                                              y = -2.7,
#'                                              center_x = mean,
#'                                              center_y = max,
#'                                              obey_grouping = FALSE))
#'
position_nudge_center <-
  function(x = 0,
           y = 0,
           center_x = NULL,
           center_y = NULL,
           direction = NULL,
           obey_grouping = NULL) {

    if (is.null(direction)) {
      # Set default for 'direction' based on other arguments
      if (is.null(center_x) && is.null(center_y)) {
        direction <- "none"
      } else if (xor(is.null(center_x), is.null(center_y))) {
        direction <- "split"
      } else {
        direction <- "radial"
      }
    }

    if (direction != "none") {
      # Set center if is missing and direction requires it
      if (is.null(center_x)) {
        center_x <- mean
      }
      if (is.null(center_y)) {
        center_y <- mean
      }
    }

    if (is.null(obey_grouping)) {
      # default needs to be set in panel_fucntion when we have access to data
      obey_grouping <- NA
    }

    ggplot2::ggproto(NULL, PositionNudgeCenter,
                     x = x,
                     y = y,
                     center_x = center_x,
                     center_y = center_y,
                     direction = direction,
                     obey_grouping = obey_grouping
    )
  }

#' @rdname ggpp-ggproto
#' @format NULL
#' @usage NULL
#' @export
PositionNudgeCenter <-
  ggplot2::ggproto(
    "PositionNudgeCenter",
    ggplot2::Position,
    x = 0,
    y = 0,
    center_x = mean,
    center_y = mean,
    direction = "none",
    obey_grouping = NA,

    setup_params = function(self, data) {

      list(x = self$x,
           y = self$y,
           center_x = self$center_x,
           center_y = self$center_y,
           direction = self$direction,
           obey_grouping = self$obey_grouping)
    },

    compute_panel = function(self, data, params, scales) {

      x_orig <- data$x
      y_orig <- data$y
      # we handle grouping by ourselves
      if (is.na(params$obey_grouping)) {
        if (inherits(data$x, "mapped_discrete") ||
            inherits(data$y, "mapped_discrete") ||
            params$direction == "none") {
          # we ignore grouping as position_nudge() does
          params$obey_grouping <- FALSE
        } else {
          # we respect groups
          params$obey_grouping <- TRUE
        }
      }

      if (params$obey_grouping) {
        # one group at a time
        groups <- unique(data$group)
      } else {
        # all at once
        groups <- 1
      }
      # Based on the value of 'direction' we adjust the nudge for each point
      x_nudge <- y_nudge <- numeric(nrow(data))
      for (group in groups) {
        if (params$obey_grouping) {
          # selector for rows in current group
          in.grp <- data$group == group
        } else {
          # selector for all rows
          in.grp <- TRUE
        }
        # compute focal center by group
        if (is.function(params$center_x)) {
          x_ctr <- params$center_x(as.numeric(data[in.grp, "x"]))
        } else if(is.numeric(params$center_x)) {
          x_ctr <- params$center_x[1]
        } else {
          x_ctr <- -Inf # ensure all observations are to the right
        }
        if (is.function(params$center_y)) {
          y_ctr <- params$center_y(as.numeric(data[in.grp, "y"]))
        } else if(is.numeric(params$center_y)) {
          y_ctr <- params$center_y[1]
        } else {
          y_ctr <- -Inf # ensure all observations are above
        }

        if (params$direction == "radial") {
          # compute x and y nudge for each point
          x_dist <- as.numeric(data[in.grp, "x"]) - x_ctr
          y_dist <- as.numeric(data[in.grp, "y"]) - y_ctr
          angle <- atan2(y_dist, x_dist) + pi / 2
          if (params$x == 0) {
            angle <- ifelse(cos(angle) == 0, 0, angle)
          }
          if (params$y == 0) {
            angle <- ifelse(sin(angle) == 0, pi / 2, angle)
          }
          x_nudge[in.grp] <- params$x * sin(angle)
          y_nudge[in.grp] <- -params$y * cos(angle)
        } else if (params$direction == "split") {
          if (length(params$x) == 1L && length(params$y) == 1L) {
            # ensure horizontal and vertical segments have same length as others
            segment_length <- sqrt(params$x^2 + params$y^2)
            xx <- rep(params$x, nrow(data[in.grp, ]))
            xx <- ifelse(data[in.grp, "y"] == y_ctr,
                         segment_length * sign(xx),
                         xx)
            yy <- rep(params$y, nrow(data[in.grp, ]))
            yy <- ifelse(data[in.grp, "x"] == x_ctr,
                         segment_length * sign(yy),
                         yy)
          }
          x_nudge[in.grp] <- xx * sign(as.numeric(data[in.grp, "x"]) - x_ctr)
          y_nudge[in.grp] <- yy * sign(as.numeric(data[in.grp, "y"]) - y_ctr)
        } else {
          if (params$direction != "none") {
            warning("Ignoring unrecognized direction \"",
                    params$direction, "\".")
          }
          x_nudge[in.grp] <- params$x
          y_nudge[in.grp] <- params$y
        }
      }
      # transform only the dimensions for which new coordinates exist
      if (any(params$x != 0)) {
        if (any(params$y != 0)) {
          data <- transform_position(data, function(x) x + x_nudge, function(y) y + y_nudge)
        } else {
          data <- transform_position(data, function(x) x + x_nudge, NULL)
        }
      } else if (any(params$y != 0)) {
        data <- transform_position(data, NULL, function(y) y + y_nudge)
      }
      # add original position
      data$x_orig <- x_orig
      data$y_orig <- y_orig
      data
    }
  )

#' @rdname position_nudge_center
#'
#' @export
#'
position_nudge_centre <- position_nudge_center

#' @rdname position_nudge_center
#'
#' @export
#'
position_nudge_keep <- function(x = 0, y = 0) {
  position_nudge_center(x = x,
                        y = y,
                        center_x = NULL,
                        center_y = NULL,
                        direction = NULL,
                        obey_grouping = NULL)
}