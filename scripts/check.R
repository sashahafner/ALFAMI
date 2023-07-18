# Check for input problems

logfn <- paste0('../', dirs$logs, '/', settings$ofile, '_log.txt')

# Basic info
logmssg('================================================================', logfile = logfn, append = FALSE)
logmssg('Running ALFAMI tool v0.2', logfile = logfn)
logmssg('================================================================', logfile = logfn)

logmssg('See https://github.com/sashahafner/ALFAMI for latest version\n', logfile = logfn)

logmssg(as.character(Sys.time()), logfile = logfn)

logmssg('System info:\n', logfile = logfn, echo = FALSE)
si <- Sys.info()
si <- paste0(names(si), ': ', si)
logmssg(si, logfile = logfn, print.method = print, echo = FALSE)

logmssg('R version info:\n', logfile = logfn, echo = FALSE)
logmssg(sessionInfo(), logfile = logfn, print.method = print, echo = FALSE)

logmssg(paste('Calculating emission for', length(unique(dat.in$app.key.yr)), 'unique application events over', length(unique(dat.in$app.year)), 'years.\n'), logfile = logfn)

# Check for problems
if (any(duplicated(dat.in$app.key.yr))) {
  mssg <- 'Duplicated application key x year combinations in application data.' 
  logmssg(mssg, logfile = logfn)
  stop(mssg)
}

if (any(!app$loc.key %in% locations$loc.key)) {
  mssg <- 'Location key given in application sheet missing in location sheet.' 
  logmssg(mssg, logfile = logfn)
  stop(mssg)
}

