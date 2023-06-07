# Prepare inputs for ALFAM2

# Merge in weather data
dat.in <- merge(app, wthr, by = c('loc.key', 'wthr.year', 'wthr.month', 'wthr.day'), allow.cartesian = TRUE)

# Merge in location info (for aggregation)
dat.in <- merge(dat.in, locations, by = 'loc.key')

# Check change in size
dim(app)
dim(dat.in)
# NTS: warnings etc.

# Add time
dat.in[, emis.dur := as.numeric(defaults['emis.dur'])]
dat.in[, time.hr := emis.dur]

# Unique key
dat.in[, app.key.year := paste(app.key, app.year)]

# Add manure composition
dat.in <- merge(dat.in, comp, by = 'man.key')

# Calculate some more variables
# If app.man is missing, get it from app.tan
dat.in[, app.man := as.numeric(app.man)]
dat.in[is.na(app.man), app.man := app.tan / man.tan * 1000]
# If app.rate is missing, get from defaults
dat.in[, app.rate := as.numeric(app.rate)]
dat.in[is.na(app.rate), app.rate := as.numeric(defaults['app.rate'])]
# TAN application rate
dat.in[, tan.rate := man.tan * app.rate]

## Time
##dat.in[, date.time := as.POSIXct(paste(date, '09:00'))]
#dat.in[, ct := as.numeric(difftime(date.time, min(date.time), units = 'hours')) + 24, by = .(app.key, app.year)]
