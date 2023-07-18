# Export results

# Create output directory if it doesn't exist
od <- paste0('../', dirs['output'])

if (!dir.exists(od)) {
  dir.create(od)
}

# Rounding
ndig <- settings[['ndig']]
dat.final <- rounddf(dat.final, func = signif, digits = ndig)
dat.out <- rounddf(dat.out, func = signif, digits = ndig)
summ.yr <- rounddf(summ.yr, func = signif, digits = ndig)

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
            wthr.file = 'Weather file', e = 'Emission', er = 'Emission factor')
onames <- c(onames, mnames)

# New names
nnames <- onames[donames]
names(dat.final.named) <- nnames

# New names for annual summary
nnames <- c(app.year = 'Application year', 
            app.tan.n = '# TAN applications', emis.n.n = '# NH3-N emissions', 
            app.tan.min = 'Min. applied TAN', app.tan.max = 'Max. applied TAN', app.tan.tot = 'Total applied TAN',
            emis.n.min = 'Min. NH3-N emission', emis.n.max = 'Max. NH3-N emission', emis.n.tot = 'Total NH3-N emission', 
            ef = 'Effective emission factor',
            emis.n.lwr = 'Lower total NH3-N emission', emis.n.upr = 'Upper total NH3-N emission', 
            app.tan.lwr = 'Lower total TAN application', app.tan.upr = 'Upper total TAN application', 
            ef.lwr = 'Lower effective emission factor', ef.upr = 'Upper effective emission factor' 
)

# First change order
summ.yr.named <- summ.yr[, names(nnames)]
# Then names
names(summ.yr.named) <- nnames[names(summ.yr.named)]

nnames <- c(livestock.group = 'Livestock category', nnames)
summ.yr.lv.named <- summ.yr.lv[, names(nnames)]
names(summ.yr.lv.named) <- nnames[names(summ.yr.lv.named)]

# CSV files
# Names
dat.final.named.fn <- paste0(od, '/emis_final_named.csv')
dat.final.fn <- paste0(od, '/emis_final.csv')
dat.out.fn <- paste0(od, '/emis_out.csv')
summ.yr.fn <- paste0(od, '/summ_year.csv')
summ.yr.named.fn <- paste0(od, '/summ_year_named.csv')
summ.yr.lv.fn <- paste0(od, '/summ_year_livestock.csv')
summ.yr.lv.named.fn <- paste0(od, '/summ_year_livestock_named.csv')
unitz.fn <- paste0(od, '/units.csv')

if (grepl('CSV2', settings$otype)) {
  write.csv2(dat.final, dat.final.fn, row.names = FALSE)
  write.csv2(dat.final.named, dat.final.named.fn, row.names = FALSE)
  write.csv2(dat.out, dat.out.fn, row.names = FALSE)
  write.csv2(summ.yr, summ.yr.fn, row.names = FALSE)
  write.csv2(summ.yr.named, summ.yr.named.fn, row.names = FALSE)
  write.csv2(summ.yr.lv, summ.yr.lv.fn, row.names = FALSE)
  write.csv2(summ.yr.lv.named, summ.yr.lv.named.fn, row.names = FALSE)
  write.csv2(unitz, unitz.fn, row.names = FALSE)
} 

if (grepl('CSV$|CSV ', settings$otype)) {
  write.csv(dat.final, dat.final.fn, row.names = FALSE)
  write.csv(dat.final.named, dat.final.named.fn, row.names = FALSE)
  write.csv(dat.out, dat.out.fn, row.names = FALSE)
  write.csv(summ.yr, summ.yr.fn, row.names = FALSE)
  write.csv(summ.yr.named, summ.yr.named.fn, row.names = FALSE)
  write.csv(summ.yr.lv, summ.yr.lv.fn, row.names = FALSE)
  write.csv(summ.yr.lv.named, summ.yr.lv.named.fn, row.names = FALSE)
  write.csv(unitz, unitz.fn, row.names = FALSE)
} 

if (grepl('xlsx', settings$otype)) {
  write.xlsx(list(`By year` = summ.yr.named, `By year, livestock cat.` = summ.yr.lv.named, `By application` = dat.final.named, Units = unitz),
             paste0(od, '/', settings$ofile, '.xlsx'), overwrite = settings$overwrite == 'Yes')
}
