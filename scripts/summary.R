# Calculate total emission

# Final values
dat.final <- dat.out[dat.out$time.hr == max(dat.out$time.hr), ]

dat.final <- dat.final[order(dat.final$input.row.app), ]

# Total NH3 emission
dat.final$emis.n <- dat.final$app.tan * dat.final$er

# Summary by location, manure type, application date, month, states, . . .
# Total. . .
summ.year <- aggregate2(dat.final, c('app.tan', 'emis.n'), by = 'app.year', FUN = list(min = min, max = max, tot = sum, n = length))
summ.year$ef <- summ.year$emis.n.tot / summ.year$app.tan.tot
summ.year <- merge(summ.year, summ.uc, by = 'app.year')

# By location and year
summ.loc.year <- aggregate2(dat.final, c('app.tan', 'emis.n'), by = c('loc.key', 'app.year'), FUN = list(min = min, max = max, tot = sum))
summ.loc.year$ef <- summ.loc.year$emis.n.tot / summ.loc.year$app.tan.tot

# By aggregation groups
summ.agg1.year <- aggregate2(dat.final, c('app.tan', 'emis.n'), by = c('loc.agg1', 'app.year'), FUN = list(min = min, max = max, tot = sum))
summ.agg1.year$ef <- summ.agg1.year$emis.n.tot / summ.agg1.year$app.tan.tot

