
logmssg <- function(mssg, logfile = '../logs/log.txt', sep = '\n', append = TRUE, echo = TRUE, print.method = cat) {

  if (echo) {
    print.method(mssg)
	cat('\n')
  }
  sink(logfile, append = append)
    print.method(mssg)
	cat('\n')
  sink()

}
