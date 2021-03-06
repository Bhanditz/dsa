#' Invert taking logs and differences of  a time series
#' 
#' For a series that has been logged and/or differences, this function reverses these transformations.
#' @param x time series
#' @param y time series used as benchmark
#' @param Diff number of differences to be taken
#' @param Sdiff number of seasonal differences to be taken
#' @param Log Should time series be logarithmised
#' @param Lag Lag for Sdiff can be specified
#' @details The time series used as a benchmark (y) is necessary, if regular or seasonal differences have to be inversed, because the first values of this series is used to reconstruct the original values or benchmark the new series.
#' @author Daniel Ollech
#' @examples a = ts(rnorm(100, 100, 10), start=c(2015,1), frequency=12)
#' b = Scaler(a, Diff=1, Log=TRUE)
#' Descaler(b,a, Diff=1, Log=TRUE)
#' @export




Descaler <- function(x, y=NA, Diff=0, Sdiff=0, Log=FALSE, Lag=NA) {
  
  .diffinv_xts <- function(x, y, lag=1, differences=1, stepsize="days", ...) {
    if (all(class(y) != "xts")) {stop("The time series y needs to be an xts")}
    values = stats::diffinv(x[stats::complete.cases(x)], xi=y[1:(lag*differences)], lag=lag, differences=differences, ...)
    series = xts::xts(values, order.by=seq.Date(from=as.Date(stats::start(y)), by=stepsize, length.out=length(values)))
    return(series)
  }
  
  if (any(class(x)=="ts") & is.na(Lag) & Sdiff > 0) {Lag = stats::frequency(x)} else {
  if (is.na(Lag) & Sdiff > 0) {Lag = freq_xts(x)}
  }
  
  if (Log) {ysave=y; y = log(y)}
  if (Sdiff>0 & Diff > 0) {
    if (any(class(x)=="ts")) {
      x=stats::diffinv(x,lag=Lag, differences=Sdiff, xi=stats::na.omit(diff(y, differences=Diff))[1:(Lag*Sdiff)])
      x = stats::diffinv(x, differences=Diff, xi=stats::na.omit(diff(y, differences=Diff))[1:(1*Diff)])
    } else {
    x=.diffinv_xts(x,stats::na.omit(diff(y, differences=Diff)),lag=Lag, differences=Sdiff)
    x = .diffinv_xts(x,y, differences=Diff)} }
  if (Sdiff>0 & Diff == 0) {  
    if (any(class(x)=="ts")) {x = stats::diffinv(x,differences=Sdiff, lag=Lag, xi=y[1:(Lag*Sdiff)])
    } else {x = .diffinv_xts(x,y, differences=Sdiff, lag=Lag) }     }
  if (Sdiff==0 & Diff > 0) { if (any(class(x)=="ts")) {x <- stats::diffinv(x,differences=Diff, xi=y[1:(1*Diff)]) } else {
    x <- .diffinv_xts(x,y, differences=Diff) 
  } }
  if (Log) x = exp(x)
  if (any(class(x)=="numeric")) {x <- xts::xts(x, order.by=seq.Date(from=as.Date(stats::start(y)), by="days", length.out=length(x)))}
  return(x)
}

