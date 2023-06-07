
ggplot(summ.loc.year, aes(app.year, emis.n, colour = loc.key)) +
  geom_line() 
