# Expand wildcard *

# Weather data first
wthre <- data.table()
for (i in 0:9) {
  d <- copy(wthr)
  d[, wthr.year := gsub('\\*', i, wthr.year)]
  wthre <- rbind(wthre, d)
}

# More? 
