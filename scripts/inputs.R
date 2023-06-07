# Load inputs from single xlsx file

# Get var names
col.names <- as.data.table(read.xlsx('../inputs/inputs.xlsx', 'Names', startRow = 1))
col.names[col.names == ''] <- NA
loc.names <- as.character(na.omit(unlist(col.names[2], use.names = FALSE)))
comp.names <- as.character(na.omit(unlist(col.names[5], use.names = FALSE)))
app.names <- as.character(na.omit(unlist(col.names[8], use.names = FALSE)))
defaults.names <- as.character(na.omit(unlist(col.names[10:13, 2], use.names = FALSE)))

# Load, drop stupid blank columns, and name columns
locations <- as.data.table(read.xlsx('../inputs/inputs.xlsx', 'Locations', startRow = 1))
locations <- locations[, 1:length(loc.names)]
locations[locations == ''] <- NA
names(locations) <- loc.names
locations[, input.row.loc := 1:nrow(locations)]
locations <- locations[!is.na(loc.key)]

comp <- as.data.table(read.xlsx('../inputs/inputs.xlsx', 'Slurry composition', startRow = 2))
comp <- comp[, 1:length(comp.names)]
names(comp) <- comp.names
comp[, input.row.comp := 1:nrow(comp)]

app <- as.data.table(read.xlsx('../inputs/inputs.xlsx', 'Application', startRow = 2))
app[app == ''] <- NA
names(app) <- app.names
app <- app[, 1:length(app.names)]
app[, input.row.app := 1:nrow(app)]
app <- app[!is.na(app.key), ]

# NTS: figure out class of elements or convert to vector instead
defaults <- as.data.table(read.xlsx('../inputs/inputs.xlsx', 'Defaults', startRow = 1))
defaults <- as.list(unlist(defaults[, 3]))
names(defaults) <- defaults.names

# Directories
dirs <- as.data.table(read.xlsx('../inputs/inputs.xlsx', 'Directories', startRow = 1))
nn <- tolower(as.list(unlist(dirs[, 1])))
dirs <- as.list(unlist(dirs[, 2]))
names(dirs) <- nn

# Weather
wd <- paste0('../', dirs['weather'])
wf <- list.files(wd)
wthr <- data.table()
for (i in wf) {
  d <- fread(paste0(wd, '/', i))
  d[, wthr.file := i]
  wthr <- rbind(wthr, d)
}
