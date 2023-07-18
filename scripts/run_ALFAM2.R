# Run ALFAM2 model

emis <- alfam2(dat.in, pars = pars, app.name = 'tan.rate', time.name = 'time.hr', time.incorp = 'incorp.time', prep = TRUE, group = 'app.key.yr', warn = FALSE)

dat.out <- cbind(dat.in, emis[, c('e', 'er')])


