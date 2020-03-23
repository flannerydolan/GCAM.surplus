#' This function takes as inputs the unlimited scenario price, supply, and demand, and the
#' corresponding constrained scenario price, supply, and demand and calculates the change in surplus
#'The parameter values are obtained from the supply and demand curves outputted by GCAM
#'
#'@author Robert Link
#'
#' @param cprice the shadow price of water in the unlimited water scenario
#' @param csup the supply of water in the unlimited scenario
#' @param cdmnd the demand of water in the unlimited scenario
#' @param eprice the shadow price of water in the constrained water scenario
#' @param esup the supply of water in the constrained water scenario
#' @param edmnd the demand of water in the constrained water scenario
#' 
#' @return the change in total surplus
#' 
calc_net_surplus<-function(cprice, csup, cdmnd, eprice, esup, edmnd)
{
  
  assertthat::assert_that(length(cprice)==length(cdmnd))
  assertthat::assert_that(length(eprice)==length(edmnd))
  assertthat::assert_that(length(cprice)==length(csup))
  assertthat::assert_that(length(eprice)==length(esup))
  
  ## Envelope is the min of supply and demand quantities
  cqty <- pmin(csup, cdmnd)
  eqty <- pmin(esup, edmnd)
  
  ## Establish the price bounds
  p0 <- pmax(min(cprice), min(eprice))  # higher of the two lower bounds
  p1 <- pmin(max(cprice), max(eprice))  # lower of the two upper bounds
  message('Valid price range: ', p0, ' -- ', p1)
  
  ## Constuct a piecewise linear interpolating function
  fc <- stats::approxfun(cprice, cqty, rule=2)
  fe <- stats::approxfun(eprice, eqty, rule=2)
  
  csurplus <- integrate(fc, p0, p1)
  esurplus <- integrate(fe, p0, p1)
  
  esurplus$value - csurplus$value
}