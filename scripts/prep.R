# Prepare inputs for ALFAM2

# Merge in weather data
mergecols <- c('loc.key', 'wthr.year')
morecols <- c('wthr.month', 'wthr.day') 
mergecols <- c(mergecols, morecols[morecols %in% names(wthr)])
dat.in <- merge(app, wthr, by = mergecols)

# Merge in location info (for aggregation)
dat.in <- merge(dat.in, locations, by = 'loc.key')

# Check change in size
dim(app)
dim(dat.in)
# NTS: warnings etc.

# Add time
dat.in$emis.dur <- as.numeric(settings['emis.dur'])
dat.in$time.hr <- dat.in$emis.dur

# Unique key
dat.in$app.key.year <- paste(dat.in$app.key, dat.in$app.year)

# Add manure composition
dat.in <- merge(dat.in, comp, by = 'man.key')

# Calculate some more variables
# If app.man is missing, get it from app.tan
dat.in$app.man <- as.numeric(dat.in$app.man)
dat.in[is.na(dat.in$app.man), 'app.man'] <- (dat.in$app.tan / dat.in$man.tan * 1000)[is.na(dat.in$app.man)]
# If app.rate is missing, get from defaults
dat.in[is.na(dat.in$app.rate), 'app.rate'] <- as.numeric(defaults['app.rate'])
dat.in$app.rate.ni <- as.numeric(dat.in$app.rate) * (dat.in$app.mthd != 'Open slot injection')
# TAN application rate
dat.in$tan.rate <- dat.in$man.tan * dat.in$app.rate
# Average temperature
dat.in$air.temp.ave <- dat.in$air.temp

# Incorp none to avoid warning
dat.in[is.na(dat.in$incorp), 'incorp'] <- 'None'
# And incorp time Inf to avoid problem in uncert.R
dat.in[is.na(dat.in$incorp.time), 'incorp.time'] <- Inf
