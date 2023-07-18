# Get parameter set

logmssg(paste0('Using following parameter set: ', settings$parset, '\n'), logfile = logfn) 

pars <- eval(str2lang(paste0('ALFAM2::', settings[['parset']])))

if (grepl('03', settings[['parset']])) {
  parsvar <- ALFAM2::alfam2pars03var 
} else {
  if (settings[['paruncert']] == 'Yes') {
    logmssg('Warning: Parameter uncertainty is only available for ALFAM2pars03, so skipping it.', logfile = logfn)
    settings[['paruncert']] <- 'No'
  }
}

# Write out parameter values, to be extra careful
logmssg('Parameter values:\n', logfile = logfn, echo = FALSE) 
logmssg(pars, print.method = print, logfile = logfn, echo = FALSE)

