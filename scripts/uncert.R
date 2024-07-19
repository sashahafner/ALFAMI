# Uncertainty

if (settings[['uncert']] == 'Yes' | settings[['paruncert']] == 'Yes') {


  ns <- nrow(dat.in)
  nu <- settings[['nu']]
  cl <- settings[['cl']]
  
  dat.uc.out <- data.frame()
  
  logmssg(paste0('Starting ', nu, ' uncertainty iterations . . .'), logfile = logfn)

  if (settings[['paruncert']] == 'Yes') {
    logmssg('Including ALFAM2 model parameter uncertainty.', logfile = logfn)
  } else {
    logmssg('*Not* including ALFAM2 model parameter uncertainty.', logfile = logfn)
  }

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
        if (any(!is.na(uncert[j, 3:8]))) {
          xnm <- rownames(uncert)[j]
          ii <- is.finite(dat.uc[, xnm])
          dat.uc[ii, xnm] <- genUnc(x = dat.uc[ii, xnm], xnm = xnm, dist.type = uncert$dist.type[j], 
                                    s = uncert$sd[j], mn = uncert$min[j], mx = uncert$max[j], 
                                    cmn = uncert$cmin[j], cmx = uncert$cmax[j], 
                                    shape = uncert$shape[j], rel = uncert$rel[j] == 'Relative')

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
                   time.incorp = 'incorp.time', group = 'app.key.yr', warn = FALSE)
  
    # Combine emission predictions with inputs for summarizing
    dd <- cbind(dat.uc, emis[, c('e', 'er')])

    # Get emission
    dd$emis.n <- dd$app.tan * dd$er
    dd$ucit <- i

    dat.uc.out <- rbind(dat.uc.out, dd)
  }

  logmssg('Done\n', logfile = logfn)

} else {
  dat.uc.out <- dat.in
  dat.uc.out$ucit <- 0
}
