# Load inputs from single xlsx file

# Get var names
col.names <- read.xlsx('../inputs/inputs.xlsx', 'Names', startRow = 1)
col.names[col.names == ''] <- NA
loc.onames <- as.character(na.omit(unlist(col.names[1, ], use.names = FALSE)))
loc.names <- as.character(na.omit(unlist(col.names[2, ], use.names = FALSE)))
comp.onames <- as.character(na.omit(unlist(col.names[4, ], use.names = FALSE)))
comp.names <- as.character(na.omit(unlist(col.names[5, ], use.names = FALSE)))
app.onames <- as.character(na.omit(unlist(col.names[7, ], use.names = FALSE)))
app.names <- as.character(na.omit(unlist(col.names[8, ], use.names = FALSE)))
defaults.onames <- as.character(na.omit(unlist(col.names[10:13, 1], use.names = FALSE)))
defaults.names <- as.character(na.omit(unlist(col.names[10:13, 2], use.names = FALSE)))
settings.onames <- as.character(na.omit(unlist(col.names[15:25, 2], use.names = FALSE)))
settings.names <- as.character(na.omit(unlist(col.names[15:25, 2], use.names = FALSE)))

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

# Parameters
settings <- read.xlsx('../inputs/inputs.xlsx', 'Settings', startRow = 1)
settings <- as.list(unlist(settings[, 2]))
names(settings) <- settings.names
settings[['nu']] <- as.integer(settings[['nu']])
settings[['seedu']] <- as.numeric(settings[['seedu']])
settings[['cl']] <- as.numeric(settings[['cl']])
settings[['ndig']] <- as.numeric(settings[['ndig']])

# Uncertainty
if (settings[['uncert']] == 'Yes' | settings[['paruncert']] == 'Yes') {
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
