# Get parameter set

pars <- eval(str2lang(paste0('ALFAM2::', settings[['parset']])))

if (grepl('03', settings[['parset']])) {
  parsvar <- ALFAM2::alfam2pars03var 
} else {
  if (settings[['paruncert']] == 'Yes') {
    logmssg('Parameter uncertainty is only available for ALFAM2pars03, so skipping it.', logfile = logfn)
    logmssg('\n', logfile = logfn)
    settings[['paruncert']] <- 'No'
  }
}

