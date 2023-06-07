# Export results

# Create output directory if it doesn't exist
od <- paste0('../', dirs['output'])

if (!dir.exists(od)) {
  dir.create(od)
}

fwrite(dat.final, '../output/emis_final.csv')
fwrite(dat.out, '../output/emis_dynamics.csv')

fwrite(summ.year, '../output/total_year.csv')
fwrite(summ.loc.year, '../output/total_loc_year.csv')
fwrite(summ.agg1.year, '../output/total_agg_year.csv')
