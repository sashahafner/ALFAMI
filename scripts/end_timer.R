
et <- Sys.time()

logmssg(paste0('Time: ', signif(difftime(et, st, units = 'secs'), 3), ' seconds.'))

logmssg('')

logmssg(paste0('See files in ', dirs$output, ' directory for output, and ', dirs$logs, ' directory for logs.'))

logmssg('')
