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

# CSV files
write.csv(dat.final, paste0(od, '/emis_final.csv'), row.names = FALSE)
write.csv(dat.out, paste0(od, '/emis_final.csv'), row.names = FALSE)
write.csv(summ.year, paste0(od, '/emis_final.csv'), row.names = FALSE)
write.csv(summ.loc.year, paste0(od, '/emis_final.csv'), row.names = FALSE)
write.csv(summ.agg1.year, paste0(od, '/emis_final.csv'), row.names = FALSE)

# Single xlsx file
write.xlsx(list(Final = dat.final, Out = dat.out, Year = summ.year, `Year location` = summ.loc.year, Aggregated = summ.agg1.year),
           paste0(od, '/', settings$ofile, '.xlsx'), overwrite = settings$overwrite == 'Yes')
