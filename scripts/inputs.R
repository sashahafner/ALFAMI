# Load inputs from single xlsx file

# Get var names
col.names <- read.xlsx('../inputs/inputs.xlsx', 'Names', startRow = 1)
col.names[col.names == ''] <- NA
loc.names <- as.character(na.omit(unlist(col.names[2, ], use.names = FALSE)))
comp.names <- as.character(na.omit(unlist(col.names[5, ], use.names = FALSE)))
app.names <- as.character(na.omit(unlist(col.names[8, ], use.names = FALSE)))
defaults.names <- as.character(na.omit(unlist(col.names[10:13, 2], use.names = FALSE)))

# Load, drop stupid blank columns, and name columns
locations <- read.xlsx('../inputs/inputs.xlsx', 'Locations', startRow = 1)
locations <- locations[, 1:length(loc.names)]
locations[locations == ''] <- NA
names(locations) <- loc.names
locations$input.row.loc <- 1:nrow(locations)
locations <- locations[!is.na(locations$loc.key), ]

comp <- read.xlsx('../inputs/inputs.xlsx', 'Slurry composition', startRow = 2)
comp <- comp[, 1:length(comp.names)]
names(comp) <- comp.names
comp[, 'input.row.comp'] <- 1:nrow(comp)

app <- read.xlsx('../inputs/inputs.xlsx', 'Application', startRow = 2)
app[app == ''] <- NA
names(app) <- app.names
app <- app[, 1:length(app.names)]
app[, 'input.row.app'] <- 1:nrow(app)
app <- app[!is.na(app$app.key), ]

# NTS: figure out class of elements or convert to vector instead
defaults <- read.xlsx('../inputs/inputs.xlsx', 'Defaults', startRow = 1)
defaults <- as.list(unlist(defaults[, 3]))
names(defaults) <- defaults.names

# Directories
dirs <- read.xlsx('../inputs/inputs.xlsx', 'Directories', startRow = 1)
nn <- tolower(as.list(unlist(dirs[, 1])))
dirs <- as.list(unlist(dirs[, 2]))
names(dirs) <- nn

# Weather
wd <- paste0('../', dirs['weather'])
wf <- list.files(wd)
wthr <- data.frame()
for (i in wf) {
  d <- read.csv(paste0(wd, '/', i))
  d$wthr.file <- i
  wthr <- rbind(wthr, d)
}

# Parameters
settings <- read.xlsx('../inputs/inputs.xlsx', 'Settings', startRow = 1)
settings <- as.list(unlist(settings[, 2]))
names(settings) <- c('decsep', 'uncertain', 'parset', 'nu', 'seedu', 'paruncertain', 'cl')
settings[['nu']] <- as.integer(settings[['nu']])
settings[['seedu']] <- as.numeric(settings[['seedu']])
settings[['cl']] <- as.numeric(settings[['cl']])

# Uncertainty
if (settings[['uncertain']] == 'Yes') {
  uncert <- read.xlsx('../inputs/inputs.xlsx', 'Uncertainty', startRow = 1)
  uncert <- as.matrix(uncert)[, c(-1:-2, -7)]
  rownames(uncert) <- c('man.dm', 'man.ph', 'app.rate.ni', 'app.tan', 'incorp.time', 'air.temp', 'wind.2m')
  colnames(uncert) <- c('abs', 'rel', 'lwr', 'upr')
  u <- vn <- tn <- c()
  for (i in 1:nrow(uncert)) {
    vn <- c(vn, rep(rownames(uncert)[i], ncol(uncert)))
    tn <- c(tn, colnames(uncert))
    u <- c(u, uncert[i, ])
  }

  vn <- vn[!is.na(u)]
  tn <- tn[!is.na(u)]
  u <- as.numeric(u[!is.na(u)])

  uncert <- u
  uncert.var <- vn
  uncert.type <- tn
}
