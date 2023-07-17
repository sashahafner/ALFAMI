# Export results

# Create output directory if it doesn't exist
od <- paste0('../', dirs['output'])

if (!dir.exists(od)) {
  dir.create(od)
}

# Rounding
dat.final <- rounddf(dat.final, func = signif, digits = settings[['ndig']])
dat.out <- rounddf(dat.out, func = signif, digits = settings[['ndig']])
summ.year <- rounddf(summ.year, func = signif, digits = settings[['ndig']])
summ.loc.year <- rounddf(summ.loc.year, func = signif, digits = settings[['ndig']])
summ.agg1.year <- rounddf(summ.agg1.year, func = signif, digits = settings[['ndig']])

dat.final <- dat.final[, c('loc.key', 'loc.name', 'loc.agg1', 'loc.agg2', 'input.row.loc', 
                       'app.key', 'app.year', 'app.man', 'app.tan', 'app.area', 'app.rate', 'app.rate.ni', 'app.mthd', 'input.row.app',
                       'man.key', 'man.source', 'man.dm', 'man.tan', 'man.ph',
                       'wthr.year', 'wthr.month', 'wthr.day', 'air.temp', 'air.temp.ave', 'wind.2m', 'rain.rate', 'wthr.file',
                       'e', 'er')]

# Make copy with descriptive names
dat.final.named <- dat.final

onames <- c(app.onames, comp.onames, defaults.onames, loc.onames)
rnames <- c(app.names, comp.names, defaults.names, loc.names)
names(onames) <- rnames
onames <- onames[!duplicated(rnames)]
donames <- names(dat.final.named)
onames <- onames[names(onames) %in% donames]
# Manually add some other names
mnames <- c(input.row.loc = 'Location input row', input.row.app = 'Application input row', app.rate.ni = 'Application rate no injection',
            air.temp = 'Air temperature', air.temp.ave = 'Average air temperature', wind.2m = 'Wind speed', rain.rate = 'Rainfall rate',
            wthr.file = 'Weather file', e = 'Emission', er = 'Relative emission')
onames <- c(onames, mnames)

# New names
nnames <- onames[donames]
names(dat.final.named) <- nnames

# New names for annual summary
nnames <- c(app.year = 'Application year', 
            app.tan.n = '# TAN application', emis.n.n = '# NH3-N emission', 
            app.tan.min = 'Min. applied TAN', app.tan.max = 'Max. applied TAN', app.tan.tot = 'Total applied TAN',
            emis.n.min = 'Min. NH3-N emission', emis.n.max = 'Max. NH3-N emission', emis.n.tot = 'Total NH3-N emission', 
            ef = 'Effective emission factor',
            emis.n.lwr = 'Lower total NH3-N emission', emis.n.upr = 'Upper total NH3-N emission',
            rlwr = 'Relative lower total NH3-N emission', rupr = 'Relative upper total NH3-N emission')

# First change order
summ.year.named <- summ.year[, names(nnames)]
# Then names
names(summ.year.named) <- nnames[names(summ.year.named)]

# CSV files
# Names
dat.final.named.fn <- paste0(od, '/emis_final_named.csv')
dat.final.fn <- paste0(od, '/emis_final.csv')
dat.out.fn <- paste0(od, '/emis_out.csv')
summ.year.fn <- paste0(od, '/summ_year.csv')
summ.loc.year.fn <- paste0(od, '/summ_loc_year.csv')
summ.agg1.year.fn <- paste0(od, '/summ_aggregate.csv')
unitz.fn <- paste0(od, '/units.csv')

if (grepl('CSV2', settings$otype)) {
  write.csv2(dat.final, dat.final.fn, row.names = FALSE)
  write.csv2(dat.final.named, dat.final.named.fn, row.names = FALSE)
  write.csv2(dat.out, dat.out.fn, row.names = FALSE)
  write.csv2(summ.year, summ.year.fn, row.names = FALSE)
  write.csv2(summ.loc.year, summ.loc.year.fn, row.names = FALSE)
  write.csv2(summ.agg1.year, summ.agg1.year.fn, row.names = FALSE)
  write.csv2(unitz, unitz.fn, row.names = FALSE)
} 

if (grepl('CSV$|CSV ', settings$otype)) {
  write.csv(dat.final, dat.final.fn, row.names = FALSE)
  write.csv(dat.final.named, dat.final.named.fn, row.names = FALSE)
  write.csv(dat.out, dat.out.fn, row.names = FALSE)
  write.csv(summ.year, summ.year.fn, row.names = FALSE)
  write.csv(summ.loc.year, summ.loc.year.fn, row.names = FALSE)
  write.csv(summ.agg1.year, summ.agg1.year.fn, row.names = FALSE)
  write.csv(unitz, unitz.fn, row.names = FALSE)
} 

if (grepl('xlsx', settings$otype)) {
  write.xlsx(list(Total = summ.year.named, `By application` = dat.final.named, Units = unitz),
             paste0(od, '/', settings$ofile, '.xlsx'), overwrite = settings$overwrite == 'Yes')
}
