
logmssg <- function(..., logfile = '../logs/log.txt', sep = '\n', append = FALSE, echo = TRUE) {

  mssg <- paste('\n', as.vector(...), collapse = sep)
  if (echo) {
    cat(mssg)
  }
  sink(logfile, append = append)
    cat(mssg)
  sink()

}
