# Check for input problems

logfn <- paste0('../', dirs$logs, '/', settings$ofile, '.txt')

# Basic info
logmssg('Running ALFAMI tool v0.1\n')

logmssg(paste('Calculating emission for', length(unique(dat.in$app.key.year)), 'unique application events over', length(unique(dat.in$app.year)), 'years.\n'),
        logfile = logfn)

# Check for problems
if (any(duplicated(dat.in$app.key.year))) {
  mssg <- 'Duplicated application key x year combinations in application data.' 
  logmssg(mssg)
  stop(mssg)
}

if (any(!app$loc.key %in% locations$loc.key)) {
  mssg <- 'Location key given in application sheet missing in location sheet.' 
  logmssg(mssg)
  stop(mssg)
}
