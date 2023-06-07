# Load inputs from single xlsx file

# Convert sheets to csv
system('xlsx2csv ../inputs/inputs.xlsx -s 1 > ../inputs/csv/locations.csv')
system('xlsx2csv ../inputs/inputs.xlsx -s 2 > ../inputs/csv/comp.csv')
system('xlsx2csv ../inputs/inputs.xlsx -s 3 > ../inputs/csv/application.csv')
system('xlsx2csv ../inputs/inputs.xlsx -s 4 > ../inputs/csv/defaults.csv')
system('xlsx2csv ../inputs/inputs.xlsx -s 6 > ../inputs/csv/defaults.csv')
system('xlsx2csv ../inputs/inputs.xlsx -s 8 > ../inputs/csv/names.csv')
system('xlsx2csv ../inputs/inputs.xlsx -s 9 > ../inputs/csv/dirs.csv')

# Get var names
col.names <- fread('../inputs/csv/names.csv', skip = 1)
col.names[col.names == ''] <- NA
loc.names <- as.character(na.omit(unlist(col.names[2], use.names = FALSE)))
comp.names <- as.character(na.omit(unlist(col.names[5], use.names = FALSE)))
app.names <- as.character(na.omit(unlist(col.names[8], use.names = FALSE)))
defaults.names <- as.character(na.omit(unlist(col.names[10:13, 2], use.names = FALSE)))

# Load, drop stupid blank columns, and name columns
locations <- fread('../inputs/csv/locations.csv', skip = 1, header = FALSE)
locations <- locations[, 1:length(loc.names)]
locations[locations == ''] <- NA
names(locations) <- loc.names
locations <- locations[!is.na(loc.key)]

comp <- fread('../inputs/csv/comp.csv', skip = 2, header = FALSE)
comp <- comp[, 1:length(comp.names)]
names(comp) <- comp.names

app <- fread('../inputs/csv/application.csv', skip = 2, header = FALSE)
app <- app[, 1:length(app.names)]
names(app) <- app.names

# NTS: figure out class of elements or convert to vector instead
defaults <- fread('../inputs/csv/defaults.csv', skip = 1, header = FALSE)
defaults <- as.list(unlist(defaults[, 3]))
names(defaults) <- defaults.names

# Directories
dirs <- fread('../inputs/csv/dirs.csv', skip = 1, header = FALSE)
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
