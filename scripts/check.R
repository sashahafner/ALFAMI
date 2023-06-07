# Check for input problems

if (any(duplicated(app[, app.descrip]))) {
  stop('Duplicated Name column in application data.')
}
