# Get parameter set

pars <- eval(str2lang(paste0('ALFAM2::', settings[['parset']])))

if (grepl('03', settings[['parset']])) {
  parsvar <- ALFAM2::alfam2pars03var 
}
