# ALFAMI
The ALFAMI tool for estimation ammonia volatilization from field-applied animal slurry.
This tool is under development at present (v0.1), and is expected to undergo some significant changes in the coming months (summer and autumn 2023).
See below for usage instructions and see releases (to right) for releases.

# Overview
The ALFAMI inventory tool is not yet a proper software package, but the following:

* A spreadsheet input file
* A set of R scripts
* A batch file or shell script that runs everything

To run the ALFAMI tool, edit the input settings in the file `inputs/inputs.xlsx` using Microsoft Excel, LibreOffice Calc or similar, and run the batch file `run_ALFAMI.bat` or shell script `run_ALFAMI.sh`.
See below for details.

# Setting things up
There are a few things that need to be done once.

## R
The ALFAMI tool runs in R, but users do not need to open R or look at an R script or function to use it.
(U
But users must have R installed of course.
To install R, pick the closest site from [this list](https://cran.r-project.org/mirrors.html), then the appropriate download link 

![image](https://github.com/sashahafner/ALFAMI/assets/35272876/1362e398-cb82-400a-83cd-7c54c4068633)

follow the instructions, double-click the downloaded exe file, and accept default options to install it.
Pay attention to where R is installed, because you will need that path for the next step.

## Set the PATH Environment variable
To run ALFAMI from a batch file in Windows, you will need to add the path to the newly installed Rscript.exe executable file to an environment variable called PATH.
To do that, first find and copy the path to Rscript.exe, and then follow the steps below.

1. Hit the Windows key and type environment. Select this option:
![image](https://github.com/sashahafner/ALFAMI/assets/35272876/684cbc8e-e437-48ff-bd78-a1ac941667d1)
3. Under the "Advanced" tab select "Environment variables" from the lower right  :
![image](https://github.com/sashahafner/ALFAMI/assets/35272876/9a29aba1-c083-4ba8-9ffe-baa17b794d54)
4. Click "Path" and then "Edit":
![image](https://github.com/sashahafner/ALFAMI/assets/35272876/592219fc-aa4b-4958-b2fc-c8032f6bd31b)
5. Select "New", then paste the path to Rscript.exe in the appropriate field:
![image](https://github.com/sashahafner/ALFAMI/assets/35272876/6bbbba7b-11eb-437f-adf1-f47a26febfac)
6. Click OK, OK, OK.
7. Restart the computer.

## Install some R packages
The ALFAMI tool requires some R packages.
To install these, simply run the batch file `install_packages.bat`.

In case you are interested, this file calls R and installs:

* devtools, needed for installion of the ALFAM2 package
* ALFAM2, for the ALFAM2 model
* openxlsx, for reading from the input file

Unfortunately, there are several things that could go wrong when trying to run this batch file.
If it doesn't work (check the messages for errors), users will have to open R (look for the latest version of "R" under "Programs") and enter these three commands:

```
install.packages('devtools')
install.packages('openxlsx')
devtools::install_github('sashahafner/ALFAM2', ref = 'dev')
```

If even that does not work because of some problem with ALFAM2, you might have to try to install an older version. 
You can do that with this command in R:

```
devtools::install_github('sashahafner/ALFAM2@v2.0')
```

## Download ALFAMI files

Click the green "Code" button to the right and then select "Download ZIP".
Once the compressed file has downloaded, extract the contents to a logical place that you can find again.

# Using ALFAMI
To use ALFAMI:

1. Save a copy of the blank template file `inputs_template.xlsx` named `inputs.xlsx` and enter input data. See `inputs/example_inputs.xlsx` for an example.
2. Run the batch file `run_ALFAMI.bat` (Windows) or `run_ALFAMI.sh` (Mac OS or Linux).
3. Check the output and logs directories for results.




