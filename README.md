# ALFAMI
The ALFAMI tool for estimation ammonia volatilization from field-applied animal slurry.
This tool is under development at present (v0.4), and is expected to undergo some significant changes in the coming months (summer and autumn 2023).
See below for usage instructions and look to the right for releases (or use this [link](https://github.com/sashahafner/ALFAMI/releases).

# Overview
The ALFAMI inventory tool is not yet a proper software package, but a set of files:

* A spreadsheet input file
* A set of R scripts
* A batch file or shell script that runs everything

To run the ALFAMI tool, edit the input settings in the file `inputs/inputs.xlsx` using Microsoft Excel, LibreOffice Calc or similar, and run the batch file `run_ALFAMI.bat` (on Windows) or shell script `run_ALFAMI.sh` (Linux and MacOS).
See below for details.

# Setting things up
There are a few things that need to be done once.

## R
The ALFAMI tool runs in R, but users do not need to so much as open R or look at an R script or function to use it.
But users must have R installed of course.
To install R, pick the closest site from [this list](https://cran.r-project.org/mirrors.html), then the appropriate download link, follow the instructions, double-click the downloaded exe file, and accept default options to install it.
Pay attention to where R is installed, because you will need that path for the next step.

## Set the PATH Environment variable
To run R from a batch file in Windows, you will need to add the path to the newly installed Rscript.exe executable file to an environment variable called PATH.
To do that, first find and copy the path to Rscript.exe, and then follow the steps below.

1. Hit the Windows key and type environment. Select this option:
![image](https://github.com/sashahafner/ALFAMI/assets/35272876/db4d2151-dd70-4e62-9887-8054e6b45d51)
3. Under the "Advanced" tab select "Environment variables" from the lower right.
4. Click "Path" and then "Edit".
5. Select "New", then paste the path to Rscript.exe in the appropriate field:
![image](https://github.com/sashahafner/ALFAMI/assets/35272876/c98f73ae-8f92-4bc5-b28e-1cc6f0b575b9)
7. Click OK, OK, and again OK.
8. Restart the computer.

## Install some R packages
The ALFAMI tool requires some R packages.
To install these, simply run the batch file `install_R_packages.bat`.

In case you are interested, this file calls R and installs:

* devtools, needed for installion of the ALFAM2 package
* ALFAM2, for the ALFAM2 model
* openxlsx, for reading from the input file
* mc2d, for distributions needed for uncertainty calculations

Unfortunately, there are several things that could go wrong when trying to run this batch file.
If it doesn't work (check the messages for errors), users will have to open R (look for the latest version of "R" under "Programs") and enter these three commands:

```
install.packages('devtools')
install.packages('openxlsx')
install.packages('mc2d')
devtools::install_github('sashahafner/ALFAM2', ref = 'dev')
```

If even that does not work because of some problem with ALFAM2, you might have to try to install an older version. 
You can do that with this command in R:

```
devtools::install_github('sashahafner/ALFAM2@v2.0')
```

## Download ALFAMI files

Click the green "Code" button to the right and then select "Download ZIP".
Once the compressed file has downloaded, extract the (don't just double-click the ZIP file, but right-click and select an extract option) contents to a logical place that you can find again.

# Using ALFAMI
To use ALFAMI:

1. Save a copy of the blank template file `inputs_template.xlsx` named `inputs.xlsx` and enter input data in it. See `inputs/example_inputs.xlsx` for an example.
2. On Windows, run the batch file `run_ALFAMI.bat` either by double-clicking it or calling it in Command Prompt or anothe rconsole, or for Mac OS or Linux use `run_ALFAMI.sh`.
3. Check the output and logs directories for results. If there is a problem, copy the messages that print to the console or take a look at the (more detailed) log file.




