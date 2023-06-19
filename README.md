# ALFAMI
ALFAMI inventory tool.
Under development!
See below for usage instructions and see releases (to right) for releases.

# Usage
The ALFAMI inventory tool is not yet a proper software package, but the following:

* A spreadsheet input file
* A set of R scripts
* A batch file or shell script that runs everything

To run the ALFAMI tool, edit the input settings in the file `inputs/inputs.xlsx` using Microsoft Excel, LibreOffice Calc or similar, and run the batch file `run_ALFAMI.bat` or shell script `run_ALFAMI.sh`.
See below for details.

# Required software
## R
The ALFAMI tool runs in R, but users never need to open R or look at an R script or function to use it.
But users must install R.
To install R, pick the closest site from [this list](https://cran.r-project.org/mirrors.html), then the appropriate download link 

![image](https://github.com/sashahafner/ALFAMI/assets/35272876/1362e398-cb82-400a-83cd-7c54c4068633)

and follow the instructions.

## Set the PATH Environment variable
To run ALFAMI from a batch file in Windows, you will need to add the path to the newly installed Rscript.exe executable file to an environment variable called PATH.
To do that, first find and copy the path to Rscript.exe (look wherever you expect R to have been installed), and then follow the steps below.

1. Hit the Windows key and type environment. Select this option:
![image](https://github.com/sashahafner/ALFAMI/assets/35272876/9444fc5a-364f-42c0-adcc-f34ba1f55baf)
2. Under the "Advanced" tab select "Environment variables" from the lower left:
![image](https://github.com/sashahafner/ALFAMI/assets/35272876/7184b77d-fe93-49c8-9971-68b1d9b1a9db)
3. Click "Path" and then "Edit":
![image](https://github.com/sashahafner/ALFAMI/assets/35272876/d7777b0e-f31c-463b-b682-88f7af1c80ce)
4. Select "New", then paste the path to Rscript.exe in the appropriate field:
![image](https://github.com/sashahafner/ALFAMI/assets/35272876/020a3270-eb74-466a-a1ac-a10658c34136)
5. Click OK, OK, OK.



