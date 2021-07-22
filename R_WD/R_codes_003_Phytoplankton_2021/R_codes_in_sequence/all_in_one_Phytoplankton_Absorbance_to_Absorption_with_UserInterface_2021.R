#all_in_one_Phytoplankton_Absorbance_to_Absorption_with_UserInterface_2021

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, May 6, 2021

#estimated run time: 10 minutes

#the message box appears behind the running app

#printing the start time and end time that it takes for the R code to run
first_start_time <- Sys.time()
print(paste0("first_start_time = ", first_start_time))

#setting R work directory(it cannot be changed)
setwd("C:/R_WD")
getwd()

#shell.exec will open the folder or the file. It can be found below each R sequence indicating the results and the reports written.
#shell.exec("C:/R_WD/")

#set the folder path that contains all the R codes that will run in sequence
R_codes_folder <- "C:/R_WD/R_codes_003_Phytoplankton_2021/R_codes_in_sequence/"
#shell.exec("C:/R_WD/R_codes_003_Phytoplankton_2021/R_codes_in_sequence/")

#The R script contains package detection and installation with User Dialog
#Packages required: "tcltk2", "DescTools", "reader", "dplyr", "tidyr", "stringr", "R.utils", "readxl", "fs", "qdapRegex", "gdata", "lmodel2", "robustbase", "leaflet", "DescTools", "mapview", "leaflet.providers", "leaflet.extras2", "sf", "rgl", "xfun", "webshot", "webdriver", "phantomjs"(webdriver::install_phantomjs(version = "2.1.1", baseURL = "https://github.com/wch/webshot/releases/download/v0.3.1/")
#IF PHANTOMJS INSTALLATION FAILS within the R script 'required_packages_installation_for_Absorbance_to_Absorption.R', PLEASE INSTALL IT MANUALLY WITH THE COMMAND BELOW:
#webdriver::install_phantomjs(version = "2.1.1", baseURL = "https://github.com/wch/webshot/releases/download/v0.3.1/")

#the working directory is set to "C:/R_WD/"
#the HPLC, _QAT sample files for the column names defined are in "C:/R_WD/Sample_files_for_the_defined_column_names/". The files must have all column names defined.
#the .ODF must have at least first 12 rows completed, only the first 12 rows ,the header is needed
#for HPLC, Only the columns "ID", "DEPTH", "HPLCHLA" and "ABS. VOL(L)" must contain data, the other columns can be empty
#for QAT,  names(QAT_file2)[1] <- "Filename", "Cruise_number", "Event_number", "Latitude", "Longitude", "Sample_id", "Date" and "Pressure" must contain data, the other columns can be empty

#INPUT: all by User Interface:
#the cruise name directory (Ex.: "AZMP Fall 2021") containing the Particulate(123456.txt) and the Detritus(123456p.txt) Absorbance raw txt data files
#the coded_cruise_name (known as cruise name or cruise number (Ex.: ABC1234567))
#the HPLC file - must contain "HPLC" in the file name, the file extension must be .xls, .xlsx or .xlsm, not .csv
#the _QAT file - must contain "_QAT" in the file name, the file extension must be .xls, .xlsx or .csv, not .xlsm
#the .ODF file - must have the file extension ".ODF"
#the filter_diameter (Ex.: 16.5)


#OUTPUT: the R code writes all files and reports in "C:/R_WD/WRITE/". It is recommended that the "WRITE" folder to be deleted or renamed if exists every time before running the scripts to avoid file overwriting.
#below are listed only the results that are required for the output. More results and reports are in "C:/R_WD/WRITE/"
#the metadata HPLC, _QAT and .ODF files as csv keeping only the needed columns for Absorption in C:\R_WD\WRITE\METADATA_TEST_BEFORE_PROCEED\. This is the testing part of the code from Line 1 to line 210,  before the processing starts.
#the new Absorbance raw data files formats 123456Particulate.txt, 123456Detritus.txt and 123456Phytoplankton.txt(Particulate minus Detritus) in C:/R_WD/WRITE/WORKS/RESULTS
#the 2d and 3d plots of the Absorbance csv tables for Phytoplankton, Particulate and Detritus in C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL/RESULTS; DOES NOT ACCOUNT FOR VOLUME AND/OR FILTER DIAMETER
#the FINAL ABSORPTION TABLES(Particulate and Detritus) WITH QC COMMENTS(Phytoplankton) "cruise_coded_name_Absorption_Phytoplankton_QC_Comments.csv" in C:/R_WD/WRITE/WORKS7/RESULTS/
#the Absorbance missing sample ID's from HPLC and _QAT in C:/R_WD/WRITE/WORKS5/ALL_samples_ID_not_found_in_HPLC_and_QAT/
#the 2d and 3d plots for Particulate, Detritus and Phytoplankton Absorption tables in C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/RESULTS
#the QC plots in C:/R_WD/WRITE/WORKS_QC/QC_plots
#the Phytoplankton Absorption table plots with QC Comments by QC color in C:/R_WD/WRITE/WORKS_PLOT_Phytoplankton_Absorption_by_QC_flags_Comments/RESULTS/
#the map plots for Phytoplankton Absorption table with QC Comments on leaflet map as png and interactive html map(with metadata) and cruise track animation in C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/RESULTS/


#select from Line 1 to Line 90 for tests only or select all for tests and processing. If all is selected, a confirmation dialog will pop up before proceeding with processing anyway.

#####
#####
#####

#1.
#1. checks if the needed packages are installed and prompts installation with dependencies dialog  
source(paste0(R_codes_folder, "003_000_000_required_packages_installation_for_Absorbance_to_Absorption_2.R"))

#2.
#2. contains all User Input interactive dialog for the variables needed
source(paste0(R_codes_folder, "003_000_001_Absorbance_to_Absorption_User_Input.R"))

##############start tests

#3.
#3. run the data and metadata test before processing
#3. writes in "C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/"
source(paste0(R_codes_folder, "003_000_002_check_if_all_needed_files_are_in_place_before_proceed_HPLCHLA5_2.R"))
#shell.exec("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/")

#4.
#4. R will exit without saving the workspace if dirname(data.frame) fails in 003_001_001
source(paste0(R_codes_folder, "exit_R_if_dirname_df_fails.R"))


##############end tests

############################################################################################Line 90 end selection for tests

##############start processing

#5.
#5. read Absorbance raw data files particulate (123456.txt) and detritus (123456p.txt) from the selected folder
#5. writes the new Absorbance raw data files formats 123456Particulate.txt, 123456Detritus.txt and 123456Phytoplankton.txt(Particulate minus Detritus) in "C:/R_WD/WRITE/WORKS/RESULTS/"
source(paste0(R_codes_folder, "003_001_001_read_txt_files_32_10_Absorbance_5.R"))
#shell.exec("C:/R_WD/WRITE/WORKS/RESULTS/")
#shell.exec("C:/R_WD/WRITE/WORKS/")


#6.
#6. reads new Particulate Absorbance raw data files (123456Phytoplankton.txt) from the folder "C:/R_WD/WRITE/WORKS/RESULTS/
#6. checks each Sample ID on each Wavelength(800) for Par<0, Par<Det, Par>0&Det<0, Par<0, Par<0&Det>0, Par=Det(Phyto=0), Par<0&Det<0, Det<0, Par=0, Det=0, Par=0&Det=0, Par>Det,  sorts by the number of occurences
#6. writes reports in "C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/"
source(paste0(R_codes_folder, "003_001_002_Absorbance_raw_data_files_analysis_for_d6Phytoplankton_txt_dplyr.R"))
#shell.exec("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/")


#7.
#7. reads the new Absorbance raw data files formats 123456Particulate.txt, 123456Detritus.txt in C:/R_WD/WRITE/WORKS/RESULTS
#7. creates the missing pairs in the same folder C:/R_WD/WRITE/WORKS/RESULTS: for Particulate: 123456_-999_Particulate, all values = -999; for Detritus: 123456_-999_Detritus, all values = -999
#7. writes reports in C:/R_WD/WRITE/WORKS/ in folders GENERATE_UNPAIRED_P_D_PHY, FILE_LENGTH_ERROR_THE_PAIR, MISSING_THE_PAIR if any
source(paste0(R_codes_folder, "003_001_003_generate_the_missing_Absorbance_Particulate_nodet_Detritus_nopar_Phy_unpaired_-999_values_wrpath_21.R"))
#shell.exec("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/")
#shell.exec("C:/R_WD/WRITE/WORKS/FILE_LENGTH_ERROR_THE_PAIR/")
#shell.exec("C:/R_WD/WRITE/WORKS/MISSING_THE_PAIR/")


#8.
#8. plots 2d and 3d the Absorbance csv tables from C:/R_WD/WRITE/WORKS2/RESULTS Phytoplankton, Particulate and Detritus writing in C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL/RESULTS; DOES NOT ACCOUNT FOR VOLUME AND/OR FILTER DIAMETER
source(paste0(R_codes_folder, "003_001_005_plot_Phytoplankton_Absorbance_no_vol_all_folders_26_2_one_scale.R"))
#shell.exec("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL/RESULTS/")


#9.
#9. writes the 3 Absorbance csv tables d6Particulate_project_table.csv, d6Detritus_project_table.csv, d6Phytoplankton_project_table.csv in C:/R_WD/WRITE/WORKS2/RESULTS
#9. from 801 (350 to 750 step 0.5) wavelengths keeps only 401 (350 to 749 step 1) matching the oldspectro and excruisedata wavelengths table format
source(paste0(R_codes_folder, "003_002_Create_3_csv_absorbance_801_to_400rows_Files_with_-999_created_3.R"))
#shell.exec("C:/R_WD/WRITE/WORKS2/RESULTS/")



#quit1
#this will quit the R session if any of the HPLC, _QAT and/or .ODF files have not been selected in 003_000_001 from line 250 to line 336 and 'No'(Continue) instead of Yes(Close the R Session) has been selected at line 200
if(exists("msgBoxCharacter_meta")){
  if(msgBoxCharacter_meta == "no"){
    quit(save="no")
  }
}

#quit2
#this will quit the R session if filter_diameter numeric value has not been submitted in 003_000_001 at line 352 and 'No'(Continue) instead of Yes(Close the R Session) has been selected at line 255
if(exists("msgBoxCharacter_fdia")){
  if(msgBoxCharacter_fdia == "no"){
    quit(save="no")
  }
}

#quit3
#this will quit the R session if there are no Absorbance Sample ID's in the HPLC file selected, conditioned in 003_000_002 line 1681 to 1693
if(exists("msgBoxCharacter_no_SampleIDs_in_HPLC")){
  if(msgBoxCharacter_no_SampleIDs_in_HPLC == "no"){
    quit(save="no")
  }
}

#quit4
#this will quit the R session if there are no Absorbance Sample ID's in the _QAT file selected, conditioned in 003_000_001 line 1687 to 1710
if(exists("msgBoxCharacter_no_SampleIDs_in_QAT")){
  if(msgBoxCharacter_no_SampleIDs_in_QAT == "no"){
    quit(save="no")
  }
}

#10.
#10. The "REFERENCE line 13 written in the Phytoplankton Absorption table header is in this script (line 1770) ('Reference to method of absorption calculation'...)
#10. process the metadata HPLC, _QAT and .ODF from C:/R_WD/Metadata_per_cruise/ keeping only the needed columns for each file; writes them as csv in C:/R_WD/WRITE/WORKS3/METADATA_CSV/
#10. writes reports in C:/R_WD/WRITE/WORKS3/
#10. writes the Absorbance missing sample ID's from HPLC and _QAT reports in C:/R_WD/WRITE/WORKS4/ALL_samples_ID_not_found_in_HPLC_and_QAT/; if there are no missing samples a file without data will not be written in here, only in C:/R_WD/WRITE/WORKS4/RESULTS/Absorbance_3tables_with_metadata/
#10. joins the Absorbance data (from C:/R_WD/WRITE/WORKS2) with the metadata (csv from C:/R_WD/WRITE/WORKS3/METADATA_CSV/)writing the Absorbance tables with metadata in C:/R_WD/WRITE/WORKS4/RESULTS/Absorbance_3tables_with_metadata/
#10. converts Absorbance to Absorption writing the Absorption tables for Particulate, Detritus and Phytoplankton in C:/R_WD/WRITE/WORKS5/RESULTS/Absorption_3tables_with_metadata; also creates a copy in C:/R_WD/WRITE/WORKS5/ALL_samples_ID_not_found_in_HPLC_and_QAT for the missing Absorbance sample ID's from HPLC and _QAT previous reports
source(paste0(R_codes_folder, "003_004_metadata_for_final_file_34_3_absorbance_to_absorption_8_3_2_no_HPLC_QAT_stops_enter_fdia_2_3.R"))
#shell.exec("C:/R_WD/WRITE/WORKS3/RESULTS/")
#shell.exec("C:/R_WD/WRITE/WORKS4/RESULTS/")
#shell.exec("C:/R_WD/WRITE/WORKS5/RESULTS/Absorption_3tables_with_metadata/")
#shell.exec("C:/R_WD/WRITE/WORKS5/ALL_samples_ID_not_found_in_HPLC_and_QAT/")


#11.
#11. plots 2d and 3d the Phytoplankton Absorption tables from C:/R_WD/WRITE/WORKS5/RESULTS/Absorption_3tables_with_metadata accounting for VOLUME and filter_diameter writing in C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/RESULTS
source(paste0(R_codes_folder, "003_005_plot_Phytoplankton_Absorption_all_folders5_-999_as_0_7_2_one_scale.R"))
#shell.exec("C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/RESULTS/")


#12.
#12. copies the 3d Absorbance and the 3d Absorption plots in one folder (C:/R_WD/WRITE/Absorbance_vs_Absorption_3dplots_copy) for an easy overview before/after conversion
source(paste0(R_codes_folder, "003_006_create_Absorbance_vs_Absorption_3dplots_copy_plotted.R"))
#shell.exec("C:/R_WD/WRITE/Absorbance_vs_Absorption_3dplots_copy")


#13.
#13. performs the QC tests reading the Phytoplankton Absorption table with metadata from C:/R_WD/WRITE/WORKS5/RESULTS/ and the HPLCHLA column from the HPLC file from C:/R_WD/Metadata_per_cruise/
#13. writes the png QC plots in C:/R_WD/WRITE/WORKS_QC/QC_plots/
#13. writes reports and the QC log file in C:/R_WD/WRITE/WORKS_QC/
#13. writes the Phytoplankton Absorption table with the QC columns in C:/R_WD/WRITE/WORKS6/
source(paste0(R_codes_folder, "003_007_002_QC_abs_3_all_cruises_flags_3_writes_final_table_9.R"))
#shell.exec("C:/R_WD/WRITE/WORKS_QC/")
#shell.exec("C:/R_WD/WRITE/WORKS_QC/QC_plots/")
#shell.exec("C:/R_WD/WRITE/WORKS6/")


#14.
#14. reads the Phytoplankton Absorption table with the QC columns from C:/R_WD/WRITE/WORKS6/, adds the Comments column and writes the FINAL ABSORPTION TABLE WITH QC COMMENTS "cruise_coded_name_Absorption_Phytoplankton_QC_Comments.csv" in C:/R_WD/WRITE/WORKS7/RESULTS/
source(paste0(R_codes_folder, "003_007_003_QC_add_Comments_column_2_2.R"))
#shell.exec("C:/R_WD/WRITE/WORKS7/RESULTS/")

#15.
#15. copies from C:/R_WD/WRITE/WORKS5/RESULTS/ the Particulate Absorption table and the Detritus Absorption table where Phytoplankton Absorption with QC Comments is in C:/R_WD/WRITE/WORKS7/RESULTS/
source(paste0(R_codes_folder, "003_007_004_copy_Particulate_Detritus_with_Phytoplankton_QC_Comments.R"))
#shell.exec("C:/R_WD/WRITE/WORKS7/RESULTS/")


#16.
#16. plots 2d and 3d from C:/R_WD/WRITE/WORKS7/RESULTS/ the Phytoplankton Absorption table with QC Comments by QC color writing in C:/R_WD/WRITE/WORKS_PLOT_Phytoplankton_Absorption_by_QC_flags_Comments/RESULTS/
source(paste0(R_codes_folder, "003_008_001_plot_Phytoplankton_Absorption_final_table_QC_by_QC_flags_Comments_21_3_one_scale.R"))
#shell.exec("C:/R_WD/WRITE/WORKS_PLOT_Phytoplankton_Absorption_by_QC_flags_Comments/RESULTS/")

#17.
#17. plots 2d and 3d from C:/R_WD/WRITE/WORKS7/RESULTS/ the Phytoplankton Absorption table with QC Comments by QC color and from "C:/R_WD/WRITE/WORKS/RESULTS/" the Phytoplankton Absorbance writing in C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/RESULTS/
source(paste0(R_codes_folder, "003_008_002_plot_Phytoplankton_Absorbance_and_Absorption3_one_scale3.R"))
#shell.exec("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/RESULTS/")

#18.
#18. plots the whole cruise reading from C:/R_WD/WRITE/WORKS7/RESULTS/ the Phytoplankton Absorption table with QC Comments on leaflet map as png and interactive html map(with metadata) and cruise track animation writing in C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/RESULTS/
source(paste0(R_codes_folder, "003_009_plot_Phytoplankton_final_QC_Comments_cruises_samples_on_map_14.R"))
#shell.exec("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/RESULTS/")


#19.
#19. creates reports in C:/R_WD/WRITE/WORKS_Metadata_per_cruise_stats/ about the cruise folder name, coded cruise name, metadata file names used or missing in/from the process 
source(paste0(R_codes_folder, "003_010_metadata_per_cruise_files_index2_2.R"))
#shell.exec("C:/R_WD/WRITE/WORKS_Metadata_per_cruise_stats/")


#20.
#20. print "all went well" message box as the last external code in sequence runs and open "C:/R_WD/Absorbance_to_Absorption_R_scripts_output_table_info.xlsx"
source(paste0(R_codes_folder, "003_011_last_message_complete.R"))


#print the times when the R code started and the time when ended
last_end_time <- Sys.time()
first_start_time
last_end_time


#write session info file
sessionInfo() %>% capture.output(file=paste0("C:/R_WD/session_info_", format(Sys.time(),'%Y-%m-%d_%H-%M-%S_'), ".txt"))

#end
