
loadALFAMI <- function(
  inputfile, 
  sheets = c(loc = 1, comp = 2, app = 3, yr = 4),
  wdir = '../weather',
  wpat = c(tmin = 'tn', tmax = 'tx', wind = 'ws', precip = 'pr'),
  ...
  ) {

  # Load
  loc <- openxlsx::read.xlsx(inputfile, sheet = sheets['loc'], startRow = 2) 
  comp <- openxlsx::read.xlsx(inputfile, sheet = sheets['comp'], startRow = 2) 
  app <- openxlsx::read.xlsx(inputfile, sheet = sheets['app'], startRow = 2) 
  yr <- openxlsx::read.xlsx(inputfile, sheet = sheets['yr'], startRow = 2) 

  # Convert to data.table
  loc <- data.table::data.table(loc)
  comp <- data.table::data.table(comp)
  app <- data.table::data.table(app)
  yr <- data.table::data.table(yr)
  
  # Drop blank columns (Problem from using data validation)
  loc <- loc[!is.na(loc.name) & loc.name != '', ]
  comp <- comp[!is.na(man.descrip) & man.descrip != '', ]
  app <- app[!is.na(app.descrip) & app.descrip != '', ]
  yr <- yr[!is.na(app.year) & app.year != '', ]

  # Find weather files
  tn.file <- list.files(wdir, pattern = wpat['tmin'], full.names = TRUE)
  tx.file <- list.files(wdir, pattern = wpat['tmax'], full.names = TRUE)
  ws.file <- list.files(wdir, pattern = wpat['wind'], full.names = TRUE)
  pr.file <- list.files(wdir, pattern = wpat['precip'], full.names = TRUE)

  res <- list(inputfile = inputfile,
              inputdat = list(loc = loc,
                         comp = comp,
                         app = app,
                         yr = yr),
              weatherfiles = list(tmin = tn.file,
                                 tmax = tx.file,
                                 wind = ws.file,
                                 precip = pr.file)
              )

  return(res)

}
