# Get weather data

# Fill in missing day and time
app[, app.day := as.integer(app.day)] 
app[is.na(app.day), 'app.day'] <- defaults[, 'app.day']

app[, app.time := as.character(app.time)] 
app[is.na(app.time), 'app.time'] <- defaults[, 'app.time']

## Get application date with year
#app[, app.date.time := dmy_hm(paste0(app.day, '-', app.month, '-', app.year, ' ', app.time))]
app[, month.day.time := paste(app.month, app.day, app.time)]
app[, app.date.time := dmy_hm(paste(app.day, app.month, app.year, app.time))]

# Find weather files
# 
wthr.path <- '../weather/'
tn.file <- list.files(wthr.path, pattern = 'n-tn_2022', full.names = TRUE)
tx.file <- list.files(wthr.path, pattern = 'n-tx_2022', full.names = TRUE)
ws.file <- list.files(wthr.path, pattern = 'n-ws_2022', full.names = TRUE)

# Merge in location lat lon to application info
app.loc <- merge(app, locations, by = 'loc.key')

wthr <- data.table()

# Get unique weather location x dates
app.date.unq <- unique(app.loc[, .(loc.key, loc.key, lat, lon, app.day, app.month, app.year, app.time, app.date.time, wthr.year)])

# NTS: move
all.years <- 1900:2100

# Read in aligned weather data
# Use next line to check contents and variable names
GlanceNetCDF(tn.file)
i <- 1
for (i in 1:nrow(app.date.unq)) {
  loc.key <- app.date.unq[['loc.key']][i]
  loc <- app.date.unq[['loc.key']][i]
  lat <- app.date.unq[['lat']][i]
  lon <- app.date.unq[['lon']][i]
  app.day <- app.date.unq[['app.day']][i]
  app.month <- app.date.unq[['app.month']][i]
  app.year <- app.date.unq[['app.year']][i]
  app.time <- app.date.unq[['app.time']][i]
  # NTS: do we need all 3 vars above?
  # NTS: maybe so, for years
  app.date.time <- app.date.unq[['app.date.time']][i]

  wthr.year <- app.date.unq[['wthr.year']][i]
  wthr.year <- gsub('\\*', '\\[0-9\\]', wthr.year)
  yrs <- grep(wthr.year, all.years, value = TRUE)

  # NTS: do we need time here??? DOn't think so
  emis.dur <- 0:as.numeric(ceiling(defaults[, 'emis.dur'] / 24))
  dtdat <- expand.grid(day = app.day, month = app.month, year = yrs, time = app.time, emis.dur = emis.dur)
  #date.time <- dmy_hm(paste0(dtdat$day, '-', dtdat$month, '-', dtdat$year, ' ', dtdat$time))
  #date.time <- date.time + dtdat$emis.dur * 86400
  wthr.date <- dmy(paste(dtdat$day, dtdat$month, dtdat$year)) + dtdat$emis.dur
  # NTS: skipping multiple lat/lon for now
  lat <- as.numeric(strsplit(lat, ', ')[[1]][1])
  lon <- as.numeric(strsplit(lon, ', ')[[1]][1])

  # NTS: ReadNetCDF will take closest so will be important to check output
  # NTS: problem with more than 1 input file. . .
  tn <- ReadNetCDF(tn.file, vars = c('tn'), subset = list(lat = lat, lon = lon, time = wthr.date))
  tn[, date := as.Date(time)]

  ws <- ReadNetCDF(ws.file, vars = c('ws'), subset = list(lat = lat, lon = lon, time = wthr.date))
  ws[, date := as.Date(time)]

  tx <- ReadNetCDF(tx.file, vars = c('tx'), subset = list(lat = lat, lon = lon, time = wthr.date))
  tx[, date := as.Date(time)]

  w <- merge(tn, ws, by = c('date', 'lat', 'lon'), suffixes = c('', '.ws'))
  w <- merge(w, tx, by = c('date', 'lat', 'lon'), suffixes = c('.tn', '.tx'))
  w[, `:=` (lat.loc = lat, lon.loc = lon, loc.key = loc, app.date.time = app.date.time)]
  wthr <- rbind(wthr, w)
}

# Adjust/calculate weather inputs
# Adjust wind speed to 2 m etc.
# NTS: Needs to be added
wthr[, `:=` (wind.2m = ws, air.temp = (tn + tx) / 2)]
