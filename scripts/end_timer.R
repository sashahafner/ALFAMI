
et <- Sys.time()

logmssg(paste0('Time: ', signif(difftime(et, st, units = 'secs'), 3), ' seconds.'), logfile = logfn)

logmssg('\n', logfile = logfn)

logmssg(paste0('See files in ', dirs$output, ' directory for output, and ', dirs$logs, ' directory for logs.'), logfile = logfn)

logmssg('\n', logfile = logfn)
