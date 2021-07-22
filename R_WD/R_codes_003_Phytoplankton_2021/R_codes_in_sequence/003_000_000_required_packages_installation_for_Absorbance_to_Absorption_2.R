#003_000_000_required_packages_installation_for_Absorbance_to_Absorption_2

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021

start_time <- Sys.time()
print(paste0("start_time = ", start_time))



setwd("C:/R_WD")
getwd()


# R_version_detected <- getRversion()
# R.Version()$version.string

if ((getRversion() != '4.0.4') == TRUE){

yes_or_no_close_R_wrong_version <- if (interactive())
  askYesNo(paste0("The Phytoplankton Absorbance to Absorption R codes pack was written and tested for R version 4.0.4 (2021-02-15); The current R version running is '", R.Version()$version.string,"'. Some older R versions will return 'Error in dirname(file_list_txt_d6_df[, 1]) : a character vector argument expected'. Would you like to exit R without saving the workspace, install manually 'R version 4.0.4' and try again?. 'NO' or 'Cancel' will just continue. Yes = Recommended"), prompts = getOption("askYesNo", gettext(c("Yes", "No", "Cancel")))) == TRUE

#set Cancel button same as NO
if (is.na(yes_or_no_close_R_wrong_version)){
  yes_or_no_close_R_wrong_version <- FALSE
}


if (yes_or_no_close_R_wrong_version == TRUE){
  quit(save="no")
  print("closeR")
}


if (yes_or_no_close_R_wrong_version == FALSE){
  print("'NO' or 'Cancel' has been selected; The R script will continue")
}
}





#' #update.packages(ask = FALSE)#, instlib = NULL)
#' #Warning in install.packages(update[instlib == l, "Package"], l, repos = repos,  :
#' #'lib = "C:/Program Files/R/R-4.0.2/library"' is not writable
#' #"Would you like to use a personal library instead? YES!



yes_or_no_update_all_packages <- if (interactive())
  askYesNo("Would you like to update now all R installed packages by clicking 'YES'? 'NO' or 'Cancel' will continue without update.  Yes = Recommended", prompts = getOption("askYesNo", gettext(c("Yes", "No", "Cancel")))) == TRUE

#set Cancel button same as NO
if (is.na(yes_or_no_update_all_packages)){
  yes_or_no_update_all_packages <- FALSE
}


if (yes_or_no_update_all_packages == TRUE){
  update.packages(ask = FALSE)
}


if (yes_or_no_update_all_packages == FALSE){
  print("'NO' or 'Cancel' has been selected. R will continue without updating the R packages." )
}






#detect if package is installed and pop up installation dialog only if it is not installed yet
if (!require("tcltk2", character.only = TRUE)){
  
  yes_or_no_install_tcltk2 <- if (interactive())
    askYesNo("The User Interface Dialog requires the command 'tk_messageBox' from the R package 'tcltk2' that the R script detected as not installed. Do you want to install the 'tcltk2' package if it is not installed yet?    Yes = Recommended") == TRUE
  
  #set Cancel button same as NO
  if (is.na(yes_or_no_install_tcltk2)){
    yes_or_no_install_tcltk2 <- FALSE
  }
  
  if (yes_or_no_install_tcltk2 == TRUE){
    if (!require("tcltk2", character.only = TRUE)) install.packages("tcltk2")
  }
}


#installs the required packages from the list below if they are not installed yet
#Packages required: "tcltk2", "DescTools", "reader", "dplyr", "tidyr", "stringr", "R.utils", "readxl", "fs", "qdapRegex", "gdata", "lmodel2", "robustbase", "leaflet", "DescTools", "mapview", "leaflet.providers", "leaflet.extras2", "sf", "rgl", "xfun", "webshot", "webdriver", "phantomjs"(webdriver::install_phantomjs(version = "2.1.1", baseURL = "https://github.com/wch/webshot/releases/download/v0.3.1/")

#detect if packages are installed and pop up installation dialog only if at least one of them it is not installed yet
RequiredPackages <- c(
  "tcltk2",
  "DescTools",
  "reader",
  "dplyr",
  "tidyr",
  "stringr",
  "R.utils",
  "readxl",
  "fs",
  "qdapRegex",
  "gdata",
  "lmodel2",
  "robustbase",
  "leaflet",
  "DescTools",
  "mapview",
  "leaflet.providers",
  "leaflet.extras2",
  "sf",
  "rgl",
  "xfun",
  "webshot",
  "webdriver"
)
for (i in RequiredPackages) { #Installs packages if not yet installed
  if (!require(i, character.only = TRUE)){
    
    yes_or_no_install_required_packages <- if (interactive())
      askYesNo("The Absorbance to Absorption entire sequence of R scripts requires the next R packages listed: 'tcltk2', 'DescTools', 'reader', 'dplyr', 'tidyr', 'stringr', 'R.utils', 'readxl', 'fs', 'qdapRegex', 'gdata', 'lmodel2', 'robustbase', 'leaflet', 'DescTools', 'mapview', 'leaflet.providers', 'leaflet.extras2', 'sf', 'rgl', 'xfun', 'webshot', 'webdriver', 'phantomjs'. One or more needed packages have been detected by the R script as not installed. Do you want to install the missing packages and their dependencies if they are not installed yet? During install, for the packages ('robustbase'), ('later' and 'rgl'), R will ask twice: 'Do you want to install from sources the package(s) which needs compilation?'. Please answer 'YES' on both when prompted if you choose to install.        Yes = Recommended") == TRUE
    
    #set Cancel button same as NO
    if (is.na(yes_or_no_install_required_packages)){
      yes_or_no_install_required_packages <- FALSE
    }
    
    
    if (yes_or_no_install_required_packages == TRUE){
      


#installs only the required packages that are not yet installed from the list below
RequiredPackages <- c(
  "tcltk2",
  "DescTools",
  "reader",
  "dplyr",
  "tidyr",
  "stringr",
  "R.utils",
  "readxl",
  "fs",
  "qdapRegex",
  "gdata",
  "lmodel2",
  "robustbase",
  "leaflet",
  "DescTools",
  "mapview",
  "leaflet.providers",
  "leaflet.extras2",
  "sf",
  "rgl",
  "xfun",
  "webshot",
  "webdriver"
  )
for (i in RequiredPackages) { #Installs packages if not yet installed
  if (!require(i, character.only = TRUE)) install.packages(i)
}

#installs phantomjs if not yet installed. With webshot.
if(webshot::is_phantomjs_installed() == FALSE){

print(paste0("Installing phantomjs from github"))
webdriver::install_phantomjs(version = "2.1.1", baseURL = "https://github.com/wch/webshot/releases/download/v0.3.1/")

}else if(webshot::is_phantomjs_installed() == TRUE){
  
  print(paste0("The package 'phantomjs' is already installed"))
  
}else{
  
  #webdriver::install_phantomjs(version = "2.1.1", baseURL = "https://github.com/wch/webshot/releases/download/v0.3.1/")
  stop("ERROR: Could not check if phantomjs is installed. Please install it manually with the command at line 14 in all_in_one_for_one_folder_R_scripts.R (webdriver::install_phantomjs command)")
  
}
  
  

    }
    
    #end if required at line 72
  }  
  
  #end i required at line 71 
}




#detect if phantomjs is installed and pop up installation dialog only if it is not installed yet
if(webshot::is_phantomjs_installed() == FALSE){
  
  yes_or_no_install_phantomjs <- if (interactive())
    askYesNo("The sequence of R scripts require phantomjs for saving plots and maps as png images and html. With webshot the R script detected phantomjs as not installed. Do you want to install the 'phantomjs' package with webdriver from github if it is not installed yet?                     Yes = Recommended") == TRUE
  
  #set Cancel button same as NO
  if (is.na(yes_or_no_install_phantomjs)){
    yes_or_no_install_phantomjs <- FALSE
  }
  
  
  if (yes_or_no_install_phantomjs == TRUE){
    
    print(paste0("Installing phantomjs from github"))
    webdriver::install_phantomjs(version = "2.1.1", baseURL = "https://github.com/wch/webshot/releases/download/v0.3.1/")
  }
}


  
  
  
#below is the list with the required packages installation syntax if a manual installation is needed
# install.packages("tcltk2", dependencies = TRUE)
# install.packages("DescTools", dependencies = TRUE)
# install.packages("reader", dependencies = TRUE)
# install.packages("dplyr", dependencies = TRUE)
# install.packages("tidyr", dependencies = TRUE)
# install.packages("stringr", dependencies = TRUE)
# install.packages("R.utils", dependencies = TRUE)
# install.packages("readxl", dependencies = TRUE)
# install.packages("fs", dependencies = TRUE)
# install.packages("qdapRegex", dependencies = TRUE)
# install.packages("gdata", dependencies = TRUE)
# install.packages("lmodel2", dependencies = TRUE)
# install.packages("robustbase", dependencies = TRUE)
# install.packages("leaflet", dependencies = TRUE)
# install.packages("DescTools", dependencies = TRUE)
# install.packages("mapview", dependencies = TRUE)
# install.packages("leaflet.providers", dependencies = TRUE)
# install.packages("leaflet.extras2", dependencies = TRUE)
# install.packages("sf", dependencies = TRUE)
# install.packages("rgl", dependencies = TRUE)
# install.packages("xfun", dependencies = TRUE)
# install.packages("webshot", dependencies = TRUE)
# install.packages("webdriver", dependencies = TRUE)
# webdriver::install_phantomjs(version = "2.1.1", baseURL = "https://github.com/wch/webshot/releases/download/v0.3.1/")






#below is the list with the required packages load syntax if a manual package load is needed
# library("tcltk2")
# library("reader")
# library("dplyr")
# library("tidyr")
# library("stringr")
# library("R.utils")
# library("readxl")
# library("fs")
# library("qdapRegex")
# library("gdata")
# library("lmodel2")
# library("robustbase")
# library("leaflet")
# library("DescTools")
# library("mapview")
# library("leaflet.providers")
# library("leaflet.extras2")
# library("sf")
# library("rgl")
# library("webshot")
# library("webdriver")
# library("xfun")








#####################

end_time <- Sys.time()
start_time
end_time





