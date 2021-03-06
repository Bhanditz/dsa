% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/day_split.R
\name{day_split}
\alias{day_split}
\title{Forecasts the days of the week}
\usage{
day_split(series = NULL, use = "heur", h = 365)
}
\arguments{
\item{series}{Input time series}

\item{use}{Which method to use. "heur" or "ets".}

\item{h}{Length of the Forecast}
}
\description{
This function splits a time series into the days of the week and forecasts them using the X-11 heuristic or ETS.
}
\details{
This function is used internally in dsa()
}
\examples{
day_split(series=ts(rnorm(730, 100,1), start=c(2001,1), frequency=7), use="ets", h=365)
}
\author{
Daniel Ollech
}
