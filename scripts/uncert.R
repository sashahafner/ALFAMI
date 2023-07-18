# Uncertainty

if (settings[['uncert']] == 'Yes' | settings[['paruncert']] == 'Yes') {


  ns <- nrow(dat.in)
  nu <- settings[['nu']]
  cl <- settings[['cl']]
  
  dat.tot <- data.frame()
  
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
