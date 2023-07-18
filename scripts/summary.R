# Calculate total emission

# Final emission values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dat.final <- dat.out[dat.out$time.hr == max(dat.out$time.hr), ]

dat.final <- dat.final[order(dat.final$input.row.app), ]

# Total NH3 emission
dat.final$emis.n <- dat.final$app.tan * dat.final$er

# Summary by location, manure type, application date, month, states, . . .
# Total. . .
summ.yr <- aggregate2(dat.final, c('app.tan', 'emis.n'), by = 'app.year', FUN = list(min = min, max = max, tot = sum, n = length))
summ.yr$ef <- summ.yr$emis.n.tot / summ.yr$app.tan.tot

# Year and livestock type
summ.yr.lv <- aggregate2(dat.final, c('app.tan', 'emis.n'), by = c('app.year', 'livestock.group'), FUN = list(min = min, max = max, tot = sum, n = length))
summ.yr.lv$ef <- summ.yr.lv$emis.n.tot / summ.yr.lv$app.tan.tot

# Year and aggregation group 1
summ.yr.la1 <- aggregate2(dat.final, c('app.tan', 'emis.n'), by = c('app.year', 'loc.agg1'), FUN = list(min = min, max = max, tot = sum, n = length))
summ.yr.la1$ef <- summ.yr.la1$emis.n.tot / summ.yr.la1$app.tan.tot

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
summ.yr <- merge(summ.yr, summ.uc.yr, by = 'app.year')
summ.yr.lv <- merge(summ.yr.lv, summ.uc.yr.lv, by = c('app.year', 'livestock.group'))
