# Uncertainty

ns <- nrow(dat.in)
nu <- settings[['nu']]

summ.uc <- data.frame()

set.seed(settings[['seedu']])

#settings[['paruncertain']] <- 'Yes'

for (i in 1:nu) {

  # Create data
  dat.uc <- dat.in
  for (j in 1:length(uncert)) {
    v <- uncert.var[j]
    e <- runif(1, min = -1, max = 1) * uncert[j]
    if (uncert.type[j] == 'abs') {
      dat.uc[, v] <- dat.in[, v] + e
    } else if (uncert.type[j] == 'rel') {
      dat.uc[, v] <- dat.in[, v] +  dat.in[, v] * e
    }
  }

  ip <- sample(1:nrow(ALFAM2::alfam2pars03var), 1)
  if (settings[['paruncertain']] == 'Yes') {
    parsuc <- ALFAM2::alfam2pars03var[ip, ]
  } else {
    parsuc <- ALFAM2::alfam2pars03
  }
  emis <- alfam2(dat.uc, pars = parsuc, app.name = 'tan.rate', time.name = 'time.hr', time.incorp = 'incorp.time', prep = TRUE, group = 'app.key.year', warn = FALSE)
  # 

  dat.out <- cbind(dat.uc, emis[, c('e', 'er')])
  dat.out$emis.n <- dat.out$app.tan * dat.out$er
  summ.uc <- rbind(summ.uc, tapply(dat.out$emis.n, dat.out$app.year, sum))
}

cl <- settings[['cl']]
names(summ.uc) <- unique(dat.in$app.year)
x <- apply(summ.uc, 2, quantile, c((1 - cl) / 2, 0.5 + cl / 2))
print(x)

print((x[2, ] - x[1, ])/ ((x[1, ] + x[2, ]) / 2) / 2)
