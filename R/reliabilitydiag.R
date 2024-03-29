#' Reliability diagram object
#'
#' Documentation of the \code{'reliabilitydiag'} object, and its constructors.
#'
#' \code{reliabilitydiag} constructs and returns an object inheriting from the
#' class \code{'reliabilitydiag'}.
#' Each object passed via \code{...} is
#' coerced by the methods described in \code{\link{as.reliabilitydiag}},
#' and then concatenated by \code{\link{c.reliabilitydiag}}.
#'
#' \code{reliabilitydiag0} constructs an empty \code{'reliabilitydiag'} object
#' from the response values.
#'
#' If any of the arguments \code{region.level}, \code{region.method},
#' or \code{region.position} is \code{NA}, then the uncertainty quantification
#' in terms of consistency/confidence regions is skipped.
#'
#' Consistency regions are determined under the assumption of calibration of
#' the original predictions, that is, perfectly reliable forecasts such that
#' \eqn{P(Y = 1|X) = X}.
#' Consistency regions are therefore positioned around values on the diagonal
#' (set \code{region.position} to \code{"diagonal"}).
#'
#' For confidence regions, calibration is enforced by using the PAV-recalibrated
#' predictions for uncertainty quantification, that is, it is assumed that
#' \eqn{P(Y = 1|X) = PAV(X)}.
#' Confidence regions are therefore positioned around the estimated
#' conditional exceedence probability (CEP) line
#' (set \code{region.position} to \code{"estimate"}).
#'
#' When \code{region.method} is \code{"resampling"}, then the original
#' forecast-observations pairs are bootstrapped \code{n.boot} times.
#' For each bootstrap sample, new observations are drawn under the respective
#' assumption (consistency or confidence).
#' Then PAV-recalibration with those new observations is performed on each
#' bootstrap sample, and pointwise
#' lower and upper bounds are calculated across the resulting CEP lines.
#'
#' When \code{region.method} is \code{"discrete_asymptotics"} and
#' \code{region.position} is \code{"diagonal"},
#' a Gaussian
#' approximation is used assuming \eqn{\sqrt{n} * (EST(x) - x)} has variance
#' \eqn{x(1-x)}, where
#' \eqn{x} is an original prediction value,
#' \eqn{n} is the observed number of predictions with value \eqn{x},
#' and \eqn{EST(x)} is the estimated CEP value at \eqn{x}.
#'
#' When \code{region.method} is \code{"continuous_asymptotics"} and
#' \code{region.position} is \code{"diagonal"},
#' a Chernoff approximation is used for
#' \eqn{(n * f(x) / (4 * x * (1- x)))^{(1/3)} * (EST(x) - x)},
#' where \eqn{x} is an original prediction value,
#' \eqn{n} is the total number of observations,
#' \eqn{EST(x)} is the estimated CEP value at \eqn{x},
#' and \eqn{f(x)} is the estimated value of the density of the
#' original prediction values.
#' This density is estimated using the \code{bde} package: We use Chen's
#' beta kernel density estimator (see \code{\link[bde]{bde}}).
#'
#' @param ... objects to be coerced to \code{'reliabilitydiag'} and concatenated
#' @inheritParams as.reliabilitydiag
#'
#' @return
#'  \code{reliabilitydiag} returns a \code{'reliabilitydiag'} object,
#'  which is a named list-type vector class with the attribute
#'  \code{y} containing the values supplied to the input argument \code{y},
#'  that is, the numeric vector of response values to be predicted.
#'  The length is given by the number of prediction methods detected from the
#'  supplied objects.
#'
#'  \code{reliabilitydiag0} returns an empty \code{'reliabilitydiag'} object
#'  with attribute \code{y}.
#'
#'  Each entry of a \code{'reliabilitydiag'} object
#'  (corresponding to a single prediction method)
#'  is itself a list with the following entries
#'  \tabular{ll}{
#'    \code{cases} \tab a tibble of all predictions and observations.\cr
#'    \code{bins} \tab a tibble of the characteristics of the PAV induced bins.
#'      \cr
#'    \code{regions} \tab a tibble with lower and upper bounds of the pointwise
#'      consistency/confidence regions.\cr
#'    \code{xinfo} \tab a list of characteristics of \code{x}.
#'  }
#'
#'  Each \code{cases} tibble comprises the forecast-observation pairs of the
#'  given prediction method. It is arranged in increasing order of
#'  \code{x} and has columns
#'  \tabular{ll}{
#'    \code{case_id} \tab an ID based on the original order of the predictions
#'      and observations.\cr
#'    \code{x} \tab an original prediction (increasing order).\cr
#'    \code{y} \tab an observation, corresponding to \code{x}.\cr
#'    \code{bin_id} \tab an ID for the PAV-recalibration induced bins.\cr
#'    \code{CEP_pav} \tab the unique PAV-recalibrated prediction
#'      corresponding to \code{bin_id}.
#'  }
#'
#'  Each \code{bins} tibble contains PAV-recalibration information, and has
#'  columns
#'  \tabular{ll}{
#'    \code{bin_id} \tab as in \code{cases}, with any ID only appearing
#'      once.\cr
#'    \code{n} \tab the number of predictions with a given \code{bin_id}.\cr
#'    \code{x_min} \tab the smallest value of the predictions with the given
#'      \code{bin_id}.\cr
#'    \code{x_max} \tab the largest value of the predictions with the given
#'      \code{bin_id}.\cr
#'    \code{CEP_pav} \tab the unique PAV-recalibrated prediction
#'      corresponding to \code{bin_id}.
#'  }
#'
#'  Each \code{regions} tibble contains the uncertainty quantification
#'  information, and has columns
#'  \tabular{ll}{
#'    \code{x} \tab an original prediction, with any value only appearing
#'      once.\cr
#'    \code{lower} \tab the lower bound of the consistency/confidence
#'      region at \code{x}.\cr
#'    \code{upper} \tab the upper bound of the consistency/confidence
#'      region \code{x}.\cr
#'    \code{n} \tab the number of predictions with a value of \code{x}.\cr
#'    \code{level} \tab the level of the consistency/confidence regions. \cr
#'    \code{method} \tab the method used to calculate the
#'      consistency/confidence region.\cr
#'    \code{position} \tab \code{"diagonal"} for a consistency region, and
#'      \code{"estimate"} for a confidence region.
#'  }
#'
#'  Each \code{xinfo} list has entries
#'  \tabular{ll}{
#'    \code{type} \tab the type of predictions, either \code{"discrete"}
#'        or \code{"continuous"}.\cr
#'    \code{values} \tab the values supplied to \code{xvalues}.
#'  }
#'
#'
#' @seealso
#'  \code{\link{c.reliabilitydiag}},
#'  \code{\link{[.reliabilitydiag}},
#'  \code{\link{plot.reliabilitydiag}}.
#'
#'  See \code{\link{summary.reliabilitydiag}} for a decomposition of
#'  predictive performance into miscalibration,
#'  discrimination, and uncertainty.
#'
#' @examples
#' data("precip_Niamey_2016", package = "reliabilitydiag")
#'
#' # standard use with a data.frame
#' r <- reliabilitydiag(precip_Niamey_2016["EMOS"], y = precip_Niamey_2016$obs)
#' r
#'
#' # no consistency/confidence regions
#' X <- precip_Niamey_2016$EMOS
#' Y <- precip_Niamey_2016$obs
#' r1 <- reliabilitydiag(X = X, y = Y, region.level = NA)
#' r1
#'
#' # specify predictions via existing reliabilitydiag
#' r0 <- reliabilitydiag0(Y)
#' identical(r1, reliabilitydiag(X = X, r = r0, region.level = NA))
#'
#' # only observation information is used from existing reliabilitydiag
#' X2 <- precip_Niamey_2016$ENS
#' r2 <- reliabilitydiag(X2 = X2, r = r, region.level = NA)
#' r3 <- reliabilitydiag(X2 = X2, r = r0, region.level = NA)
#' identical(r2, r3)
#'
#' @name reliabilitydiag
NULL

#' @rdname reliabilitydiag
#'
#' @export
reliabilitydiag <- function(...,
                            y = NULL,
                            r = NULL,
                            tol = sqrt(.Machine$double.eps),
                            xtype = NULL,
                            xvalues = NULL,
                            region.level = 0.9,
                            region.method = NULL,
                            region.position = "diagonal",
                            n.boot = 100) {

  if (!is.null(y) && !is.null(r)) {
    stop("specify 'y' or 'r', but not both")
  }
  if (is.null(r)) r <- reliabilitydiag0(y)
  stopifnot(is.reliabilitydiag(r))

  if (!is.list(xtype)) xtype <- list(xtype)
  if (!is.list(xvalues)) xvalues <- list(xvalues)

  list(
    x = list(...),
    xtype = xtype,
    xvalues = xvalues
  ) %>%
    purrr::pmap(
      .f = as.reliabilitydiag,
      r = r,
      tol = tol,
      .name_repair = "minimal",
      region.level = region.level,
      region.method = region.method,
      region.position = region.position,
      n.boot = n.boot
    ) %>%
    do.call(c, .)
}

#' @rdname reliabilitydiag
#'
#' @export
reliabilitydiag0 <- function(y) {
  stopifnot(length(y) > 0L)
  stopifnot(is.numeric(y))
  stopifnot(isTRUE(all(y == 0 | y == 1)))

  r <- structure(list(), names = character(0))
  attr(r, "y") <- y
  class(r) <- "reliabilitydiag"
  r
}
