# Load inputs from single xlsx file

# Get var names
# onames = output (decriptive) names
col.names <- read.xlsx('../inputs/inputs.xlsx', 'Names', startRow = 1)
col.names[col.names == ''] <- NA
loc.onames <- as.character(na.omit(unlist(col.names[1, ], use.names = FALSE)))
loc.names <- as.character(na.omit(unlist(col.names[2, ], use.names = FALSE)))
comp.onames <- as.character(na.omit(unlist(col.names[4, ], use.names = FALSE)))
comp.names <- as.character(na.omit(unlist(col.names[5, ], use.names = FALSE)))
app.onames <- as.character(na.omit(unlist(col.names[7, ], use.names = FALSE)))
app.names <- as.character(na.omit(unlist(col.names[8, ], use.names = FALSE)))
defaults.onames <- as.character(na.omit(unlist(col.names[10:15, 1], use.names = FALSE)))
defaults.names <- as.character(na.omit(unlist(col.names[10:15, 2], use.names = FALSE)))
settings.onames <- as.character(na.omit(unlist(col.names[17:25, 1], use.names = FALSE)))
settings.names <- as.character(na.omit(unlist(col.names[17:25, 2], use.names = FALSE)))
reprod.onames <- as.character(na.omit(unlist(col.names[27:29, 1], use.names = FALSE)))
reprod.names <- as.character(na.omit(unlist(col.names[27:29, 2], use.names = FALSE)))

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
dd <- as.list(unlist(defaults[, 4]))
defaults <- as.list(unlist(defaults[, 3]))
# Overwrite ALFAMI defaults with user defaults
defaults[is.na(defaults)] <- dd[is.na(defaults)] 
names(defaults) <- defaults.names

# Directories
dirs <- read.xlsx('../inputs/inputs.xlsx', 'Directories', startRow = 1)
nn <- tolower(as.list(unlist(dirs[, 1])))
dirs <- as.list(unlist(dirs[, 2]))
names(dirs) <- nn

# Settings
settings <- read.xlsx('../inputs/inputs.xlsx', 'Settings', startRow = 1)
settings <- as.list(unlist(settings[, 2]))
names(settings) <- settings.names
settings[['nu']] <- as.integer(settings[['nu']])
settings[['cl']] <- as.numeric(settings[['cl']])
settings[['ndig']] <- as.numeric(settings[['ndig']])

# Reproducibility
reprod <- read.xlsx('../inputs/inputs.xlsx', 'Reproducibility', startRow = 1)
reprod <- as.list(unlist(reprod[, 2]))
names(reprod) <- reprod.names
reprod[['seedu']] <- as.numeric(reprod[['seedu']])
reprod[['emis.dur']] <- as.numeric(reprod[['emis.dur']])

# Combine reprod with settings for ease of use
settings <- c(settings, reprod)
settings.names <- c(settings.names, reprod.names)
settings.onames <- c(settings.onames, reprod.onames)

# Uncertainty
if (settings[['uncert']] == 'Yes' | settings[['paruncert']] == 'Yes') {
  uncert <- read.xlsx('../inputs/inputs.xlsx', 'Uncertainty', startRow = 1)
  uncert <- uncert[, c(-1:-2)]
  rownames(uncert) <- c('man.dm', 'man.ph', 'app.rate.ni', 'app.tan', 'incorp.time', 'air.temp', 'wind.2m')
  colnames(uncert) <- c('rel', 'dist.type', 'sd', 'min', 'max', 'cmin', 'cmax', 'shape')
}

# Units
unitz <- read.xlsx('../inputs/inputs.xlsx', 'Units', startRow = 1)
unitz <- unitz[1:2, 1:2]
unitz$Variable <- c('Slurry application', 'TAN application, NH3-N emission')

# Weather
wd <- paste0('../', dirs['weather'])
wf <- list.files(wd)
wthr <- data.frame()
for (i in wf) {
  d <- read.csv(paste0(wd, '/', i))
  d$wthr.file <- i
  wthr <- rbind(wthr, d)
}
