# Uncertainty

if (settings[['uncert']] == 'Yes' | settings[['paruncert']] == 'Yes') {


  ns <- nrow(dat.in)
  nu <- settings[['nu']]
  cl <- settings[['cl']]
  
  dat.tot <- data.frame()
  
  set.seed(settings[['seedu']])
  
  logmssg(paste0('Starting ', nu, ' uncertainty iterations . . .'), logfile = logfn)

  for (i in 1:nu) {

    # Create data with uncertainty in inputs
    dat.uc <- dat.in
    if (settings[['uncert']] == 'Yes' & any(uncert > 0)) {
      for (j in 1:length(uncert)) {
        v <- uncert.var[j]
        e <- runif(1, min = -1, max = 1) * uncert[j]
        if (uncert.type[j] == 'abs') {
          dat.uc[, v] <- dat.in[, v] + e
        } else if (uncert.type[j] == 'rel') {
          dat.uc[, v] <- dat.in[, v] +  dat.in[, v] * e
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
