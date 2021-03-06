#' Printing reliability diagram objects
#'
#' Printing methods for \code{'reliabilitydiag'} and
#' \code{'summary.reliabilitydiag'} objects.
#'
#' @param x an object inheriting from the class \code{'reliabilitydiag'}.
#' @param ... further arguments to be passed to or from methods;
#'  in particular, these are passed to \code{\link{autoplot.reliabilitydiag}}
#'  and \code{\link[tibble]{print.tbl_df}}.
#'
#' @details
#' \code{print.reliabilitydiag} always sends a plot to the current graphics
#' device and prints a summary to the console.
#'
#' \code{print.summary.reliabilitydiag} prints the summary output to the console.
#'
#' @return Invisibly returns \code{x}.
#'
#' @seealso
#'   \code{\link{autoplot.reliabilitydiag}},
#'   \code{\link{summary.reliabilitydiag}}
#'
#' @name print.reliabilitydiag
NULL


#' @rdname print.reliabilitydiag
#' @importFrom ggplot2 autoplot
#'
#' @export
print.reliabilitydiag <- function(x, ...) {
  print(autoplot(x, ...))
  print(summary(x, ...))
  invisible(x)
}

#' @rdname print.reliabilitydiag
#'
#' @export
print.summary.reliabilitydiag <- function(x, ...) {
  if (is.character(x)) {
    cat(x)
    return(invisible(x))
  }
  xx <- x
  class(xx) <- class(x)[-1]
  cat(sprintf(
    "'%s' score decomposition (see also ?summary.reliabilitydiag)\n",
    attr(x, "score")$name
  ))
  print(xx, ...)
  invisible(x)
}
