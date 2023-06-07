# Calculate total emission

dat.out <- cbind(dat.in, emis[, c('e', 'er')])

# Final values
dat.final <- dat.out[time.hr == max(time.hr), ]

dat.final <- dat.final[order(input.row.app), ]

# Total NH3 emission
dat.final[, emis.n := app.tan * er]

# Summary by location, manure type, application date, month, states, . . .
# Total. . .
summ.year <- dat.final[, .(app.tan = sum(app.tan), app.tan.min = min(app.tan), app.tan.max = max(app.tan),
                           emis.n = sum(emis.n), emis.n.min = min(emis.n), emis.n.max = max(emis.n)),
                       by = app.year]
summ.year[, ef := emis.n / app.tan]

# By location and year
summ.loc.year <- dat.final[, .(app.tan = sum(app.tan), app.tan.min = min(app.tan), app.tan.max = max(app.tan),
                           emis.n = sum(emis.n), emis.n.min = min(emis.n), emis.n.max = max(emis.n)),
                       by = .(loc.key, app.year)]
summ.loc.year[, ef := emis.n / app.tan]

# By aggregation groups
summ.agg1.year <- dat.final[, .(app.tan = sum(app.tan), app.tan.min = min(app.tan), app.tan.max = max(app.tan),
                           emis.n = sum(emis.n), emis.n.min = min(emis.n), emis.n.max = max(emis.n)),
                       by = .(loc.agg1, app.year)]
summ.agg1.year[, ef := emis.n / app.tan]


