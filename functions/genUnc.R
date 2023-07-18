# Generate uncertainty

genUnc <- function(x, xnm, dist.type, s, mn, mx, cmn, cmx, shape, rel) {
  dist.type <- tolower(dist.type)

  # NTS: shape currently not used!
  if (is.na(shape)) {
    shape <- 4
  }

  if (dist.type == 'normal') {
    e <- rnorm(1, mean = 0, sd = s)
    if (rel) {
      y <- x * (1 + e)
    } else {
      y <- x +  e
    }
  } else if (dist.type %in% c('uniform', 'pert', 'triangular')) {
    dfunc <- list(uniform = runif, pert = mc2d::rpert, triangular = mc2d::rtriang)[[dist.type]]
    if (all(!is.na(c(mn, mx)))) {
      if (rel) {
        if (any(mn > 0 | mx < 0)) {
          mssg <- 'For relative Uniform, PERT, or Triangular distribution, min-max range must include 0 but does not.' 
          logmssg(mssg, logfile = logfn)
          stop(mssg)
        }
        if (dist.type == 'uniform') {
          e <- runif(1, min = mn, max = mx)
        } else {
          e <- dfunc(1, min = mn, mode = 0, max = mx)
        }
        y <- x * (1 + e)
      } else {
        # Check for mode outside range
        if (any(x < mn | x > mx)) {
          mssg <- paste0('For Uniform, PERT, or Triangular distribution, given mode is outside min-max range for variable ', xnm, '.\nDid you intend to use relative uncertainty?')
          logmssg(mssg, logfile = logfn)
          stop(mssg)
        }
        if (dist.type == 'uniform') {
          e <- runif(1, min = mn,  max = mx)
        } else {
          e <- dfunc(length(x), min = mn, mode = x, max = mx)
        }
        y <- e
      }
    } else if (all(!is.na(c(cmn, cmx)))) {
      if (rel) {
          mssg <- paste0('You selected Uniform, PERT, or Triangular distribution with relative uncertainty and centered min and max for variable ', xnm, '.\n   This combination does not make sense and is not available.') 
          logmssg(mssg, logfile = logfn)
          stop(mssg)
      } else {
        # Check for mode outside range
        if (any(cmn > 0 | cmx < 0)) {
          mssg <- 'For Uniform, PERT, or Triangular distribution, given min-max range must include 0.' 
          logmssg(mssg, logfile = logfn)
          stop(mssg)
        }
        if (dist.type == 'uniform') {
          e <- runif(1, min = cmn,  max = cmx)
        } else {
          e <- dfunc(length(x), min = cmn, mode = 0, max = cmx)
        }
        y <- x + e
      }
    } else {
      mssg <- paste0('Not enough uncertainty inputs for ', xnm, '.') 
      logmssg(mssg, logfile = logfn)
      stop(mssg)
    }
  } else {
    mssg <- 'Distribution type must be one of the following:\n   normal, uniform, pert, triangular.' 
    logmssg(mssg, logfile = logfn)
    stop(mssg)
  }
}
