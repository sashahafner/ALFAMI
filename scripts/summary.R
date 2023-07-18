# Calculate total emission

# Final emission values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dat.final <- dat.out[dat.out$time.hr == max(dat.out$time.hr), ]

dat.final <- dat.final[order(dat.final$input.row.app), ]

# Total NH3 emission
dat.final$emis.n <- dat.final$app.tan * dat.final$er

# Summary by location, manure type, application date, month, states, . . .
# Total. . .
summ.year <- aggregate2(dat.final, c('app.tan', 'emis.n'), by = 'app.year', FUN = list(min = min, max = max, tot = sum, n = length))
summ.year$ef <- summ.year$emis.n.tot / summ.year$app.tan.tot

# Uncertainty results ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Get totals by year and livestock category *before* taking quantiles
summ1 <- aggregate2(dat.uc.out, c('app.man', 'app.tan', 'emis.n'), c('ucit', 'app.year', 'livestock.group'), FUN = list(sum))
summ1$ef <- summ1$emis.n / summ1$app.tan 

# And by year
summ2 <- aggregate2(dat.uc.out, c('app.man', 'app.tan', 'emis.n'), c('ucit', 'app.year'), FUN = list(sum))
summ2$ef <- summ2$emis.n / summ2$app.tan 

# Now quantiles 
# By year
summ.uc.yr <- aggregate2(summ2, c('app.man', 'app.tan', 'emis.n', 'ef'), c('app.year'), 
                         FUN = list(lwr = function(x) quantile(x, (1 - cl) / 2), upr = function(x) quantile(x, 0.5 + cl / 2)))

# By year and livestock category
summ.uc.yr.lv <- aggregate2(summ1, c('app.man', 'app.tan', 'emis.n', 'ef'), c('app.year', 'livestock.group'), 
                           FUN = list(lwr = function(x) quantile(x, (1 - cl) / 2), upr = function(x) quantile(x, 0.5 + cl / 2)))


# Combined results ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
summ.year <- merge(summ.year, summ.yr.uc, by = 'app.year')
# Get relative uncertainty
summ.year$rlwr <- (summ.year$emis.n.tot - summ.year$emis.n.lwr) / summ.year$emis.n.tot
summ.year$rupr <- (summ.year$emis.n.upr - summ.year$emis.n.tot) / summ.year$emis.n.tot

# By location and year
summ.loc.year <- aggregate2(dat.final, c('app.tan', 'emis.n'), by = c('loc.key', 'app.year'), FUN = list(min = min, max = max, tot = sum))
summ.loc.year$ef <- summ.loc.year$emis.n.tot / summ.loc.year$app.tan.tot

# By aggregation groups
summ.agg1.year <- aggregate2(dat.final, c('app.tan', 'emis.n'), by = c('loc.agg1', 'app.year'), FUN = list(min = min, max = max, tot = sum))
summ.agg1.year$ef <- summ.agg1.year$emis.n.tot / summ.agg1.year$app.tan.tot


