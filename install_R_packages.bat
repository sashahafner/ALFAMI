REM: Install necessary R packages

echo 'Installing R packages that are needed to use the ALFAMI software tool.'
echo 'This batch file needs to be run only *once*.'

Rscript.exe -e "install.packages('mc2d', repos='http://cran.us.r-project.org'); install.packages('devtools', repos='http://cran.us.r-project.org'); install.packages('openxlsx', repos='http://cran.us.r-project.org'); devtools::install_github('sashahafner/ALFAM2', ref = 'dev'); print(getwd())"
