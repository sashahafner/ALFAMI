# Run ALFAM2 model

emis <- as.data.table(alfam2(dat.in, app.name = 'tan.rate', time.name = 'time.hr', time.incorp = 'incorp.time', prep = TRUE, group = 'app.key.year'))
