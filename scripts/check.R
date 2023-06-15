# Check for input problems

# First echo some info
message('\n')
message(paste('Running ALFAMI tool v0.1 with', length(unique(dat.in$app.key.year)), 'unique applications\nover', length(unique(dat.in$app.year)), 'years.')) 
message('Par set...')
message('Uncertainty...')
message('Other messages. . . copied to log file')
message('\n')

if (any(duplicated(dat.in$app.key.year))) {
  stop('Duplicated application key x year combinations in application data.')
}
