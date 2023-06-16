# Write to CSV file after checking

check.write.csv <- function(x, file, overwrite = TRUE) {

  if (overwrite) {
    write.csv(x, file)
  } else {
    if (file.exists(file)) {
      stop('File', file, 'exists, so not overwriting')
    }
  }

  return(null)

}
