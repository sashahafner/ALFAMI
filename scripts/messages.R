# Echo some info

message('\n')
message(paste('Running ALFAMI tool v0.1 with', nrow(unique(dat.in[, .(app.key, app.year)])), 'unique applications\nover', length(unique(dat.in[, app.year])), 'years.')) 
message('Other messages. . . copied to log file')
message('\n')
