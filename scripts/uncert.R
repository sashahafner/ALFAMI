# Uncertainty

if (settings[['uncert']] == 'Yes' | settings[['paruncert']] == 'Yes') {


  ns <- nrow(dat.in)
  nu <- settings[['nu']]
  cl <- settings[['cl']]
  
  dat.tot <- data.frame()
  
  logmssg(paste0('Starting ', nu, ' uncertainty iterations . . .'), logfile = logfn)

  if (!is.na(settings$seedu)) {
    set.seed(settings$seedu)
    logmssg(paste0('With random number seed ', settings$seedu, '.'), logfile = logfn)
  }

  for (i in 1:nu) {

    # Create data with uncertainty in inputs
    dat.uc <- dat.in
    if (settings[['uncert']] == 'Yes' & any(!is.na(uncert[, 3:6])) && any(uncert[, 3:6] > 0)) {
      # Loop through rows (variables) in uncert data frame
      for (j in 1:nrow(uncert)) {
        if (any(!is.na(uncert[j, 3:6]))) {
          xnm <- rownames(uncert)[j]
          ii <- is.finite(dat.uc[, xnm])
          x <- dat.uc[ii, xnm]
          rel <- uncert$rel[j] == 'Relative'
          dist.type <- uncert$dist.type[j]
          s <- uncert$sd[j]
          mn <- uncert$min[j]
          mx <- uncert$max[j]
          shape <- uncert$shape[j]
          if (dist.type == 'Normal') {
            e <- rnorm(1, mean = 0, sd = s)
            if (rel) {
              dat.uc[ii, xnm] <- x * (1 + e)
            } else {
              dat.uc[ii, xnm] <- x +  e
            }
          } else if (dist.type == 'Uniform') {
            e <- runif(1, min = uncert$min[j], max = uncert$max[j])
            if (rel) {
              dat.uc[ii, xnm] <- x * (1 + e)
            } else {
              dat.uc[ii, xnm] <- e
            }
          } else if (dist.type == 'PERT') {
            if (rel) {
              if (any(mn > 0 | mx < 0)) {
                mssg <- 'For relative PERT or triangular distribution, min-max range must include 0 but does not.' 
                logmssg(mssg, logfile = logfn)
                stop(mssg)
              }
              e <- mc2d::rpert(1, min = mn, mode = 0, max = mx)
              dat.uc[ii, xnm] <- x * (1 + e)
            } else {
              # Check for mode outside range
              if (any(x > mn | x < mx)) {
                mssg <- 'For PERT or triangular distribution, given mode is outside min-max range.' 
                logmssg(mssg, logfile = logfn)
                stop(mssg)
              }
              e <- mc2d::rpert(length(x), min = mn, mode = x, max = mx)
              dat.uc[ii, xnm] <- e
            }
          } else if (dist.type == 'Triangular') {
            if (rel) {
              if (any(mn > 0 | mx < 0)) {
                mssg <- 'For relative PERT or triangular distribution, min-max range must include 0 but does not.' 
                logmssg(mssg, logfile = logfn)
                stop(mssg)
              }
              e <- mc2d::rtriang(1, min = mn, mode = 0, max = mx)
              dat.uc[ii, xnm] <- x * (1 + e)
            } else {
              if (any(x < mn | x > mx)) {
                mssg <- 'For PERT or triangular distribution, given mode is outside min-max range.' 
                logmssg(mssg, logfile = logfn)
                stop(mssg)
              }
              e <- mc2d::rtriang(length(x), min = mn, mode = x, max = mx)
              dat.uc[ii, xnm] <- e
            }
          } else {
            mssg <- 'Distribution type must be one of the following:\n   Normal, Uniform, PERT, Triangular.' 
            logmssg(mssg, logfile = logfn)
            stop(mssg)
          }
        }
      }
    } 
  
    # Randomly select parameter values if this source of uncertainty is requested
    if (settings[['paruncert']] == 'Yes') {
      ip <- sample(1:nrow(parsvar), 1)
      parsuc <- parsvar[ip, ]
    } else {
      parsuc <- pars
    }

    # Calculate emission
    emis <- alfam2(dat.uc, pars = parsuc, app.name = 'tan.rate', time.name = 'time.hr', 
                   time.incorp = 'incorp.time', prep = TRUE, group = 'app.key.year', warn = FALSE)
  
    # Combine emission predictions with inputs for summarizing
    dd <- cbind(dat.uc, emis[, c('e', 'er')])
    # Total emission of NH3-N 
    dd$emis.n <- dd$app.tan * dd$er
    dat.tot <- rbind(dat.tot, aggregate(dd[, 'emis.n', drop = FALSE], dd[, 'app.year', drop = FALSE], sum))
  }
  
  summ.uc <- aggregate2(dat.tot, 'emis.n', 'app.year', FUN = list(q = function(x) quantile(x, c((1 - cl) / 2, 0.5 + cl / 2))))
  lwr <- aggregate(dat.tot[, 'emis.n', drop = FALSE], dat.tot[, 'app.year', drop = FALSE], quantile, c((1 - cl) / 2))
  upr <- aggregate(dat.tot[, 'emis.n', drop = FALSE], dat.tot[, 'app.year', drop = FALSE], quantile, c(0.5 + cl / 2))
  summ.uc <- merge(lwr, upr, by = 'app.year')
  names(summ.uc)[2:3] <- c('emis.n.lwr', 'emis.n.upr')

  logmssg('Done\n', logfile = logfn)

} else {
  summ.uc <- data.frame(app.year = sort(unique(dat.in$app.year)), emis.n.lwr = NA, emis.n.upr = NA)
}
