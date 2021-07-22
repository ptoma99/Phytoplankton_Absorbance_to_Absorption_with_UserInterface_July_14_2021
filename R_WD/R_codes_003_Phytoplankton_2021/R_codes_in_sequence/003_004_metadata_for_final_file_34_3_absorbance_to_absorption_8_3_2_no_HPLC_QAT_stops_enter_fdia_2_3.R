#001_004_metadata_for_final_file_34_3_absorbance_to_absorption_12_with_ODF_header_added_3_farea_vol_CORRECTED_7

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021


# #Absorption calculation used
# vol = volume / 1000 # in m3
# fdia = filter_diameter/1000 # in m
# farea = pi* (fdia/2)^2 # in m2
# ods = 0.679 * absorbance^1.2804
# absorption = log(10) * ods * farea/vol


#for Particulate_Absorbance\NewSpectro_2015_continue
#located in "C:\R_WD\WRITE\WORKS2\RESULTS\Abs_tables_all_3"
#writes results in "C:\R_WD\WRITE\WORKS3\METADATA_CSV\"
#writes reports in "C:\R_WD\WRITE\WORKS3"

#WORKS4
#WORKS5

#Create folder in "C:\R_WD" named "Metadata_per_cruise", keeping the same file subdirectory structure as it is for the input files. 
#Path example for the first cruise with metadata: "C:\R_WD\Metadata_per_cruise\NewSpectro_2015_continue\AZMP Fall 2015"
#each folder must contain 3 files. The 3 files are copied from "\\dcnsbiona01a\BIODataSvc\SRC\2010s\2015\HUD2015030" for the first folder. The files in the first folder are:
#1.Hud2015-030HPLC-final_JB.xlsx for Columns:  DEPTH, ABS. VOL(L)
#2.HUD2015030_QAT.xlsx for Columns:  Station number(change to event number)	Latitude	Longitude	Date   Pressure
#3.D030A001.ODF for header, from line 3 to line 12.
#
#make sure that each file in each folder contains the strings below; rename them if needed:
#1. "HPLC-final_JB.xlsx"
#2. "_QAT.xlsx"
#3. ".ODF"
#
#create in folder "C:\R_WD" the file named "folder_name_to_coded_cruise_name_table.csv" containing 2 columns named:
#1. "folder_name" (example: "AZMP Fall 2015")
#2. "coded_cruise_name" (example: "HUD2015030")
#The code will look inside the input_folder_name for all matches and it will process all that it is defined in the table.


start_time <- Sys.time()
print(paste0("start_time = ", start_time))

setwd("C:/R_WD")
getwd()

library("dplyr")
library("readxl")
library("fs")
library("qdapRegex")
library("stringr")
library("reader")

#filter_diameter <- 16.5

dir.create(file.path("C:/R_WD/WRITE/WORKS3"), showWarnings = FALSE, recursive = TRUE)

#enter folder that contains all the cruises sub folders
input_folder_to_read_files <- "C:/R_WD/WRITE/WORKS2/RESULTS/"
write.csv(input_folder_to_read_files, paste0("C:/R_WD/WRITE/WORKS3/", "input_folder_to_read_files", ".csv"))

input_metadata_folder_name <- "C:/R_WD/Metadata_per_cruise"

cruise_name_table_location <- "C:/R_WD/folder_name_to_coded_cruise_name_table.csv"
cruise_name_table <- read.table(cruise_name_table_location, skip = 0, sep = ",", header = TRUE)
cruise_name_table_df <- data.frame(cruise_name_table)

input_folder_name <- sub('\\..*$', '', basename(input_folder_to_read_files))
search_result_for_project_table  <- list.files(pattern = "\\_project_table.csv$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_search_result_for_project_table <- length(search_result_for_project_table)
write.csv(search_result_for_project_table, paste0("C:/R_WD/WRITE/WORKS3/", "search_result_for_project_table_", nrows_search_result_for_project_table, "_rows.csv"), row.names = FALSE)

distinct_folders_in_search_result_for_project_table <- unique(dirname(search_result_for_project_table))
distinct_folders_in_search_result_for_project_table_df <- data.frame(distinct_folders_in_search_result_for_project_table)
distinct_folders_in_search_result_for_project_table_df$folder_name <- sub('\\..*$', '', basename(distinct_folders_in_search_result_for_project_table))

nrows_distinct_folders_in_search_result_for_project_table_df <- length(distinct_folders_in_search_result_for_project_table_df)
write.csv(distinct_folders_in_search_result_for_project_table_df, paste0("C:/R_WD/WRITE/WORKS3/", "distinct_folders_in_search_result_for_project_table_df_", nrows_distinct_folders_in_search_result_for_project_table_df, "_rows.csv"), row.names = FALSE)


search_result_for_metadata_files <- list.files(pattern = "\\.."  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_search_result_for_metadata_files <- length(search_result_for_metadata_files)
write.csv(search_result_for_metadata_files, paste0("C:/R_WD/WRITE/WORKS3/", "search_result_for_metadata_files_", nrows_search_result_for_metadata_files, "_rows.csv"), row.names = FALSE)

distinct_folders_in_search_result_for_metadata_files <- unique(dirname(search_result_for_metadata_files))
distinct_folders_in_search_result_for_metadata_files_df <- data.frame(distinct_folders_in_search_result_for_metadata_files)
distinct_folders_in_search_result_for_metadata_files_df$folder_name <- sub('\\..*$', '', basename(distinct_folders_in_search_result_for_metadata_files))

nrows_distinct_folders_in_search_result_for_metadata_files_df <- nrow(distinct_folders_in_search_result_for_metadata_files_df)
write.csv(distinct_folders_in_search_result_for_metadata_files_df, paste0("C:/R_WD/WRITE/WORKS3/", "distinct_folders_in_search_result_for_metadata_files_df_", nrows_distinct_folders_in_search_result_for_metadata_files_df, "_rows.csv"), row.names = FALSE)


project_tables_that_DO_have_metadata_folders <- distinct_folders_in_search_result_for_project_table_df %>%
  select(everything()) %>%
  filter(folder_name %in% c(distinct_folders_in_search_result_for_metadata_files_df$folder_name))

nrows_project_tables_that_DO_have_metadata_folders <- nrow(project_tables_that_DO_have_metadata_folders)
write.csv(project_tables_that_DO_have_metadata_folders, paste0("C:/R_WD/WRITE/WORKS3/", "project_tables_that_DO_have_metadata_folders_", nrows_project_tables_that_DO_have_metadata_folders, "_rows.csv"), row.names = FALSE)

#create '%!in%' as reverse condition operator for '%in%'
'%!in%' <- function(x,y)!('%in%'(x,y))

project_tables_that_DO_NOT_have_metadata_folders <- distinct_folders_in_search_result_for_project_table_df %>%
  select(everything()) %>%
  filter(folder_name %!in% c(distinct_folders_in_search_result_for_metadata_files_df$folder_name))

nrows_project_tables_that_DO_NOT_have_metadata_folders <- nrow(project_tables_that_DO_NOT_have_metadata_folders)
write.csv(project_tables_that_DO_NOT_have_metadata_folders, paste0("C:/R_WD/WRITE/WORKS3/", "project_tables_that_DO_NOT_have_metadata_folders_", nrows_project_tables_that_DO_NOT_have_metadata_folders, "_rows.csv"), row.names = FALSE)


##################################################################


#integrity detection

########################

#check if each folder has the 3 metadata needed files

#check if each folder has the 3 final table files that need the metadata
project_tables_to_run <- project_tables_that_DO_have_metadata_folders


# project_tables_to_run[1,2] #folder name
# project_tables_to_run[1,1] #folder filepath
# project_tables_to_run[1,] #both


d6Phytoplankton_project_table_filepaths_df <- data.frame()
d6Particulate_project_table_filepaths_df <- data.frame()
d6Detritus_project_table_filepaths_df <- data.frame()

for (i in 1:(nrow(project_tables_to_run))){
  
  #i <- 1
  
folder_filepath <- project_tables_to_run[i,1] #i1

d6Phytoplankton_project_table_filepath <- list.files(pattern = "\\Phytoplankton_project_table.csv"  , path = folder_filepath, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)

if (length(d6Phytoplankton_project_table_filepath)==1) {
  
  #i2
  print(paste0("The folder named '", project_tables_to_run[i,2], "' ", "has the d6Phytoplankton_project_table.csv table file."))
  } else if (length(d6Phytoplankton_project_table_filepath)<1){
  print(paste0("The folder named '", project_tables_to_run[i,2], "' ","DOES NOT HAVE the d6Phytoplankton_project_table.csv table file. Please check the folder ", project_tables_to_run[i,1])) #i1
    stop()
  }else if (length(d6Phytoplankton_project_table_filepath)>1){
  print(paste0("The folder named '", project_tables_to_run[i,2], "' ","DOES HAVE MORE THAN ONE d6Phytoplankton_project_table.csv table file. Please check the folder ", project_tables_to_run[i,1])) #i1
    stop()
}


d6Phytoplankton_project_table_dirname <- dirname(d6Phytoplankton_project_table_filepath)
d6Phytoplankton_project_table_folder_name <- sub('\\..*$', '', basename(d6Phytoplankton_project_table_dirname))
d6Phytoplankton_project_table_file_name <- sub('.*/', '', basename(d6Phytoplankton_project_table_filepath))

d6Phytoplankton_project_table_filepaths_df1 <- data.frame(d6Phytoplankton_project_table_filepath)
d6Phytoplankton_project_table_filepaths_df1$Phytoplankton_dirname <- d6Phytoplankton_project_table_dirname
d6Phytoplankton_project_table_filepaths_df1$folder_name <- d6Phytoplankton_project_table_folder_name
d6Phytoplankton_project_table_filepaths_df1$Phytoplankton_file_name <- d6Phytoplankton_project_table_file_name

d6Phytoplankton_project_table_filepaths_df <- rbind(d6Phytoplankton_project_table_filepaths_df, d6Phytoplankton_project_table_filepaths_df1)




d6Particulate_project_table_filepath <- list.files(pattern = "\\Particulate_project_table.csv"  , path = folder_filepath, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)

if (length(d6Particulate_project_table_filepath)==1) {
  
  #i2
  print(paste0("The folder named '", project_tables_to_run[i,2], "' ", "has the d6Particulate_project_table.csv table file."))
} else if (length(d6Particulate_project_table_filepath)<1){
  print(paste0("The folder named '", project_tables_to_run[i,2], "' ","DOES NOT HAVE the d6Particulate_project_table.csv table file. Please check the folder ", project_tables_to_run[i,1])) #i1
  stop()
}else if (length(d6Particulate_project_table_filepath)>1){
  print(paste0("The folder named '", project_tables_to_run[i,2], "' ","DOES HAVE MORE THAN ONE d6Particulate_project_table.csv table file. Please check the folder ", project_tables_to_run[i,1])) #i1
  stop()
}


d6Particulate_project_table_dirname <- dirname(d6Particulate_project_table_filepath)
d6Particulate_project_table_folder_name <- sub('\\..*$', '', basename(d6Particulate_project_table_dirname))
d6Particulate_project_table_file_name <- sub('.*/', '', basename(d6Particulate_project_table_filepath))

d6Particulate_project_table_filepaths_df1 <- data.frame(d6Particulate_project_table_filepath)
d6Particulate_project_table_filepaths_df1$Particulate_dirname <- d6Particulate_project_table_dirname
d6Particulate_project_table_filepaths_df1$folder_name <- d6Particulate_project_table_folder_name
d6Particulate_project_table_filepaths_df1$Particulate_file_name <- d6Particulate_project_table_file_name

d6Particulate_project_table_filepaths_df <- rbind(d6Particulate_project_table_filepaths_df, d6Particulate_project_table_filepaths_df1)




d6Detritus_project_table_filepath <- list.files(pattern = "\\Detritus_project_table.csv"  , path = folder_filepath, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)

if (length(d6Detritus_project_table_filepath)==1) {
  
  #i2
  print(paste0("The folder named '", project_tables_to_run[i,2], "' ", "has the d6Detritus_project_table.csv table file."))
} else if (length(d6Detritus_project_table_filepath)<1){
  print(paste0("The folder named '", project_tables_to_run[i,2], "' ","DOES NOT HAVE the d6Detritus_project_table.csv table file. Please check the folder ", project_tables_to_run[i,1])) #i1
  stop()
}else if (length(d6Detritus_project_table_filepath)>1){
  print(paste0("The folder named '", project_tables_to_run[i,2], "' ","DOES HAVE MORE THAN ONE d6Detritus_project_table.csv table file. Please check the folder ", project_tables_to_run[i,1])) #i1
  stop()
}


#d6Detritus_project_table_filepaths_df <- rbind(d6Detritus_project_table_filepaths_df, (data.frame(d6Detritus_project_table_filepath)))
d6Detritus_project_table_dirname <- dirname(d6Detritus_project_table_filepath)
d6Detritus_project_table_folder_name <- sub('\\..*$', '', basename(d6Detritus_project_table_dirname))
d6Detritus_project_table_file_name <- sub('.*/', '', basename(d6Detritus_project_table_filepath))

d6Detritus_project_table_filepaths_df1 <- data.frame(d6Detritus_project_table_filepath)
d6Detritus_project_table_filepaths_df1$Detritus_dirname <- d6Detritus_project_table_dirname
d6Detritus_project_table_filepaths_df1$folder_name <- d6Detritus_project_table_folder_name
d6Detritus_project_table_filepaths_df1$Detritus_file_name <- d6Detritus_project_table_file_name

d6Detritus_project_table_filepaths_df <- rbind(d6Detritus_project_table_filepaths_df, d6Detritus_project_table_filepaths_df1)


#end i  
}

nrows_d6Phytoplankton_project_table_filepaths_df <- nrow(d6Phytoplankton_project_table_filepaths_df)
write.csv(d6Phytoplankton_project_table_filepaths_df, paste0("C:/R_WD/WRITE/WORKS3/", "d6Phytoplankton_project_table_filepaths_df_", nrows_d6Phytoplankton_project_table_filepaths_df, "_rows.csv"), row.names = FALSE)

nrows_d6Particulate_project_table_filepaths_df <- nrow(d6Particulate_project_table_filepaths_df)
write.csv(d6Particulate_project_table_filepaths_df, paste0("C:/R_WD/WRITE/WORKS3/", "d6Particulate_project_table_filepaths_df_", nrows_d6Particulate_project_table_filepaths_df, "_rows.csv"), row.names = FALSE)

nrows_d6Detritus_project_table_filepaths_df <- nrow(d6Detritus_project_table_filepaths_df)
write.csv(d6Detritus_project_table_filepaths_df, paste0("C:/R_WD/WRITE/WORKS3/", "d6Detritus_project_table_filepaths_df_", nrows_d6Detritus_project_table_filepaths_df, "_rows.csv"), row.names = FALSE)



# folder_3_project_tables <- d6Phytoplankton_project_table_filepath
# folder_3_project_tables <- append(folder_3_project_tables, d6Particulate_project_table_filepath)
# folder_3_project_tables <- append(folder_3_project_tables, d6Detritus_project_table_filepath)

########################

#check if each folder with the 3 final files has the 3 metadata files needed in the metadata folder


#check if all needed HPLC-final_JB.xlsx files are in the metadata folders

#all_HPLC_xlsx_files<- list.files(pattern = "\\HPLC-final_JB.xlsx$"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
all_HPLC_xlsx_files<- list.files(pattern = "\\HPLC*.*xls*"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)


all_HPLC_xlsx_files <- grep('~$', all_HPLC_xlsx_files, fixed = TRUE, value = TRUE, invert = TRUE)
all_HPLC_xlsx_files_dirname <- dirname(all_HPLC_xlsx_files)
all_HPLC_xlsx_files_folder_name <- sub('\\..*$', '', basename(all_HPLC_xlsx_files_dirname))
all_HPLC_xlsx_files_file_name <- sub('.*/', '', basename(all_HPLC_xlsx_files))

all_HPLC_xlsx_files_df <- data.frame(all_HPLC_xlsx_files)
all_HPLC_xlsx_files_df$HPLC_dirname <- all_HPLC_xlsx_files_dirname
all_HPLC_xlsx_files_df$folder_name <- all_HPLC_xlsx_files_folder_name
all_HPLC_xlsx_files_df$HPLC_file_name <- all_HPLC_xlsx_files_file_name
nrows_all_HPLC_xlsx_files_df <- nrow(all_HPLC_xlsx_files_df)
write.csv(all_HPLC_xlsx_files_df, paste0("C:/R_WD/WRITE/WORKS3/", "all_HPLC_xlsx_files_df_", nrows_all_HPLC_xlsx_files_df, "_rows.csv"), row.names = FALSE)



for (i in 1:nrow(all_HPLC_xlsx_files_df)){
HPLC_xlsx_file_path <- list.files(pattern = "\\HPLC-final_JB.xlsx$"  , path = all_HPLC_xlsx_files_df$HPLC_dirname[i], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE) #i
HPLC_xlsx_file_path <- grep('~$', HPLC_xlsx_file_path, fixed = TRUE, value = TRUE, invert = TRUE)


if (length(HPLC_xlsx_file_path)==1) {
  
  #i
  print(paste0("The metadata folder named '", all_HPLC_xlsx_files_df$folder_name[i], "' ", "has the HPLC-final_JB.xlsx file ", all_HPLC_xlsx_files_df$file_name[i]))
} else if (length(HPLC_xlsx_file_path)<1){
  print(paste0("The metadata folder named '", all_HPLC_xlsx_files_df$folder_name[i], "' ","DOES NOT HAVE the HPLC-final_JB.xlsx file. Please check the folder ", all_HPLC_xlsx_files_df$dirname[i])) #i
  #stop()
}else if (length(HPLC_xlsx_file_path)>1){
  print(paste0("The metadata folder named '", all_HPLC_xlsx_files_df$folder_name[i], "' ","DOES HAVE MORE THAN ONE HPLC-final_JB.xlsx file. Please check the folder ", all_HPLC_xlsx_files_df$dirname[i])) #i
  #stop()
}


#end i  
}



#check if all needed _QAT.xlsx files are in the metadata folders


#all_QAT_xlsx_files<- list.files(pattern = "\\_QAT.xlsx$"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
all_QAT_xlsx_files<- list.files(pattern = "\\_QAT*.*"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)


all_QAT_xlsx_files <- grep('~$', all_QAT_xlsx_files, fixed = TRUE, value = TRUE, invert = TRUE)
all_QAT_xlsx_files_dirname <- dirname(all_QAT_xlsx_files)
all_QAT_xlsx_files_folder_name <- sub('\\..*$', '', basename(all_QAT_xlsx_files_dirname))
all_QAT_xlsx_files_file_name <- sub('.*/', '', basename(all_QAT_xlsx_files))

all_QAT_xlsx_files_df <- data.frame(all_QAT_xlsx_files)
all_QAT_xlsx_files_df$QAT_dirname <- all_QAT_xlsx_files_dirname
all_QAT_xlsx_files_df$folder_name <- all_QAT_xlsx_files_folder_name
all_QAT_xlsx_files_df$QAT_file_name <- all_QAT_xlsx_files_file_name
nrows_all_QAT_xlsx_files_df <- nrow(all_QAT_xlsx_files_df)
write.csv(all_QAT_xlsx_files_df, paste0("C:/R_WD/WRITE/WORKS3/", "all_QAT_xlsx_files_df_", nrows_all_QAT_xlsx_files_df, "_rows.csv"), row.names = FALSE)



for (i in 1:nrow(all_QAT_xlsx_files_df)){
#QAT_xlsx_file_path <- list.files(pattern = "\\_QAT.xlsx$"  , path = all_QAT_xlsx_files_df$QAT_dirname[i], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE) #i
QAT_xlsx_file_path <- list.files(pattern = "\\_QAT*.*s*$"  , path = all_QAT_xlsx_files_df$QAT_dirname[i], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE) #i

QAT_xlsx_file_path <- grep('~$', QAT_xlsx_file_path, fixed = TRUE, value = TRUE, invert = TRUE)


if (length(QAT_xlsx_file_path)==1) {
  
  #i
  print(paste0("The metadata folder named '", all_QAT_xlsx_files_df$folder_name[i], "' ", "has the _QAT.xlsx file ", all_QAT_xlsx_files_df$file_name[i]))
} else if (length(QAT_xlsx_file_path)<1){
  print(paste0("The metadata folder named '", all_QAT_xlsx_files_df$folder_name[i], "' ","DOES NOT HAVE the _QAT.xlsx file. Please check the folder ", all_QAT_xlsx_files_df$dirname[i])) #i
  stop()
}else if (length(QAT_xlsx_file_path)>1){
  print(paste0("The metadata folder named '", all_QAT_xlsx_files_df$folder_name[i], "' ","DOES HAVE MORE THAN ONE _QAT.xlsx file. Please check the folder ", all_QAT_xlsx_files_df$dirname[i])) #i
  stop()
}


#end i  
}






#check if all needed .ODF files are in the metadata folders


all_ODF_files<- list.files(pattern = "\\^*.ODF$"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
#all_ODF_files <- grep('~$', all_ODF_files, fixed = TRUE, value = TRUE, invert = TRUE)
all_ODF_files_dirname <- dirname(all_ODF_files)
all_ODF_files_folder_name <- sub('\\..*$', '', basename(all_ODF_files_dirname))
all_ODF_files_file_name <- sub('.*/', '', basename(all_ODF_files))

all_ODF_files_df <- data.frame(all_ODF_files)
all_ODF_files_df$ODF_dirname <- all_ODF_files_dirname
all_ODF_files_df$folder_name <- all_ODF_files_folder_name
all_ODF_files_df$ODF_file_name <- all_ODF_files_file_name
nrows_all_ODF_files_df <- nrow(all_ODF_files_df)
write.csv(all_ODF_files_df, paste0("C:/R_WD/WRITE/WORKS3/", "all_ODF_files_df_", nrows_all_ODF_files_df, "_rows.csv"), row.names = FALSE)



for (i in 1:nrow(all_ODF_files_df)){
ODF_file_path <- list.files(pattern = "\\^*.ODF$"  , path = all_ODF_files_df$ODF_dirname[i], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE) #i
#ODF_file_path <- grep('~$', ODF_file_path, fixed = TRUE, value = TRUE, invert = TRUE)


if (length(ODF_file_path)==1) {
  
  #i
  print(paste0("The metadata folder named '", all_ODF_files_df$folder_name[i], "' ", "has the *.ODF file ", all_ODF_files_df$file_name[i]))
} else if (length(ODF_file_path)<1){
  print(paste0("The metadata folder named '", all_ODF_files_df$folder_name[i], "' ","DOES NOT HAVE the *.ODF file. Please check the folder ", all_ODF_files_df$dirname[i])) #i
  stop()
}else if (length(ODF_file_path)>1){
  print(paste0("The metadata folder named '", all_ODF_files_df$folder_name[i], "' ","DOES HAVE MORE THAN ONE *.ODF file. Please check the folder ", all_ODF_files_df$dirname[i])) #i
  stop()
}


#end i  
}


# cruise_name_table_df
# project_tables_that_DO_have_metadata_folders
# d6Phytoplankton_project_table_filepaths_df
# d6Particulate_project_table_filepaths_df
# d6Detritus_project_table_filepaths_df
# all_HPLC_xlsx_files_df
# all_QAT_xlsx_files_df
# all_ODF_files_df


#pairing all the files that need metadata with the metadata they need in one table
all_tables_joined_by_folder_name <- inner_join(cruise_name_table_df, project_tables_that_DO_have_metadata_folders, by = c("folder_name"))
all_tables_joined_by_folder_name <- inner_join(all_tables_joined_by_folder_name, d6Phytoplankton_project_table_filepaths_df, by = c("folder_name"))
all_tables_joined_by_folder_name <- inner_join(all_tables_joined_by_folder_name, d6Particulate_project_table_filepaths_df, by = c("folder_name"))
all_tables_joined_by_folder_name <- inner_join(all_tables_joined_by_folder_name, d6Detritus_project_table_filepaths_df, by = c("folder_name"))
all_tables_joined_by_folder_name <- inner_join(all_tables_joined_by_folder_name, all_HPLC_xlsx_files_df, by = c("folder_name"))
all_tables_joined_by_folder_name <- inner_join(all_tables_joined_by_folder_name, all_QAT_xlsx_files_df, by = c("folder_name"))
all_tables_joined_by_folder_name <- inner_join(all_tables_joined_by_folder_name, all_ODF_files_df, by = c("folder_name"))

nrows_all_tables_joined_by_folder_name <- nrow(all_tables_joined_by_folder_name)
write.csv(all_tables_joined_by_folder_name, paste0("C:/R_WD/WRITE/WORKS3/", "all_tables_joined_by_folder_name_", nrows_all_tables_joined_by_folder_name, "_rows.csv"), row.names = FALSE)



##########################





#######START writing the needed HPLC csv

#HPLC data

HPLC_file <- data.frame()
HPLC_file2 <- data.frame()
HPLC_column_names_ERROR <- data.frame()

for(i in 1:nrow(all_tables_joined_by_folder_name)){
  
  #i <- 2
  #i <- 9
  
  #write all HPLC xlsx files as csv in "C:/R_WD/WRITE/WORKS3/METADATA_CSV/"
  HPLC_filename_for_CSV <- all_tables_joined_by_folder_name$HPLC_file_name[i]
  HPLC_filename_for_CSV <- sub('\\..*$', '', basename(HPLC_filename_for_CSV))
  
  HPLC_file_extension <- get.ext(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i])
  
  #if1 start xlsx
  if (HPLC_file_extension == "xlsx"){
    
    if (exists("HPLC_file")){
      rm(HPLC_file)
    }
    
    #print(paste0("i for HPLC file line 458 is "))  
    
    #existsSheet(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i], JBEDITS)  
    
    HPLC_file <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i], col_names = FALSE)
    #HPLC_file <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i], col_names = FALSE)
    
    #if1
    if (!exists("HPLC_file")){
      
      HPLC_file <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i], sheet = "JBEDITS", col_names = FALSE)
      
      # end if1
    }
    
    
    #if2
    if (!exists("HPLC_file")){
      
      HPLC_file <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i], sheet = "Pigments", col_names = FALSE)
      
      # end if2
    }
    
    
    #if3
    if (!exists("HPLC_file")){
      
      HPLC_file <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i], sheet = "pigments", col_names = FALSE)
      
      # end if3
    }
    
    
    HPLC_cruisename <- HPLC_file[1,1]
    
    #if HPLC name is EN606 change it to EN2017606 to match the right cruise.
    if (HPLC_cruisename=="EN606"){
      HPLC_cruisename <- "EN2017606"
      print(paste0("Cruise name changed in the HPLC file to ", HPLC_cruisename))
    }
    
    
    #check if first line from HPLC has the same cruise name as in the file "C:\R_WD\folder_name_to_coded_cruise_name_table.csv"
    if (HPLC_cruisename==all_tables_joined_by_folder_name$coded_cruise_name[i]){
      print(paste0("HPLC_file first line cruise name ", HPLC_cruisename, " matches the name '", all_tables_joined_by_folder_name$folder_name[i],"' in the file folder_name_to_coded_cruise_name_table.csv"))
    }else{
      print(paste0("ERROR: HPLC_file first line cruise name ", HPLC_cruisename, " DOES NOT matches the name '", all_tables_joined_by_folder_name$folder_name[i],"' in the file folder_name_to_coded_cruise_name_table.csv", " Please check the file ", all_tables_joined_by_folder_name$HPLC_file_name[i], " located in folder ",all_tables_joined_by_folder_name$HPLC_dirname[i]))
      #stop()
    }
    
    
    
    #filter(IRC_DF, !is.na(Reason.Reco) | Reason.Reco != "")
    HPLC_file2 <- filter(HPLC_file, !is.na(HPLC_file[,3]) | HPLC_file[,3] != "")
    
    
    names(HPLC_file2) <- HPLC_file2[1,]
    HPLC_file2 <- HPLC_file2[2:nrow(HPLC_file2),]
    
    HPLC_file2 <- subset(HPLC_file2, select=c(
      1,2,27
    ))
    
    colnames_HPLC <- colnames(HPLC_file2)
    defined_HPLC_column_names <- c("ID", "DEPTH", "ABS. VOL(L)")
    
    #change HPLC first column name if it is "SAMPLEID" in "ID"
    if (colnames_HPLC[1]=="SAMPLEID"){
      names(HPLC_file2)[1] <- "ID"}
    
    
    
    
    
    HPLC_file_for_print <- print(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i])
    
    names_check_func <- function(x,y) {
      for (i in x) {
        if (!(i %in% names(y))) {
          print(paste0("ERROR: The HPLC file has column names error. Please check the file below:"))
          print(HPLC_file_for_print)
          print(paste0("The defined needed column names for the HPLC file are "))
          print(defined_HPLC_column_names)
          print(paste0("The needed column names in the HPLC file are "))
          print(colnames_HPLC)
          
          
          defined_HPLC_column_names_df <- data.frame(t(defined_HPLC_column_names))
          colnames_HPLC_df <- data.frame(t(colnames_HPLC))
          
          HPLC_column_names_ERROR <- rbind(HPLC_column_names_ERROR, defined_HPLC_column_names_df)
          HPLC_column_names_ERROR <- rbind(HPLC_column_names_ERROR, colnames_HPLC_df)
          
          write.table(HPLC_file_for_print, paste0("C:/R_WD/WRITE/WORKS3/", "HPLC_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
          write.table(HPLC_column_names_ERROR, paste0("C:/R_WD/WRITE/WORKS3/", "HPLC_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
          
          stop()
          
        }
        else if(i==tail(names(y),n=1)) {
          print("The HPLC file below has the right defined column names.")
          print(HPLC_file_for_print)
          
        }
      }
    }
    
    
    names_check_func(defined_HPLC_column_names, HPLC_file2)
    
    
    
    # HPLC_file2 <- subset(HPLC_file2, select=c(
    #   1,2,27
    # ))
    
    dir.create(file.path(paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
    write.table(HPLC_file2, paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/", HPLC_filename_for_CSV, ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = T)
    
    # file_written <- list.files(pattern = "\\HPLC-final_JB.csv$", path = paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    # file_written <- list.files(pattern = "\\HPLC*.csv$", path = paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    file_written <- list.files(pattern = "\\HPLC*", path = paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    
    
    if (length(file_written==1)){
      print("The HPLC csv file was written.")
      print(file_written)
    }else{
      print(paste0("ERROR: The HPLC csv file was not written"))
      stop()
      
    }
    
    
    #end i
    #}
    
    
    
    
    #end if1 xlsx, start xls
  }else if (HPLC_file_extension == "xls" | HPLC_file_extension == "xlsm"){
    
    if (exists("HPLC_file")){
      rm(HPLC_file)
    }
    
    
    #HPLC_file <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i], col_names = FALSE)
    HPLC_file <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i], col_names = FALSE)
    
    
    #if1
    if (!exists("HPLC_file")){
      
      HPLC_file <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i], sheet = "pigments", col_names = FALSE)
      
      # end if1
    }
    
    
    #if2
    if (!exists("HPLC_file")){
      
      HPLC_file <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i], sheet = "Pigments", col_names = FALSE)
      
      # end if2
    }
    
    
    #if3
    if (!exists("HPLC_file")){
      
      HPLC_file <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i], sheet = "JBEDITS", col_names = FALSE)
      
      # end if3
    }
    
    
    
    HPLC_cruisename <- HPLC_file[1,1]
    # 
    # #if HPLC name is EN606 change it to EN2017606 to match the right cruise.
    # if (HPLC_cruisename=="EN606"){
    #   HPLC_cruisename <- "EN2017606"
    #   print(paste0("Cruise name changed in the HPLC file to ", HPLC_cruisename))
    # }
    # 
    # 
    # #check if first line from HPLC has the same cruise name as in the file "C:\R_WD\folder_name_to_coded_cruise_name_table.csv"
    # if (HPLC_cruisename==all_tables_joined_by_folder_name$coded_cruise_name[i]){
    #   print(paste0("HPLC_file first line cruise name ", HPLC_cruisename, " matches the name '", all_tables_joined_by_folder_name$folder_name[i],"' in the file folder_name_to_coded_cruise_name_table.csv"))
    # }else{
    #   print(paste0("ERROR: HPLC_file first line cruise name ", HPLC_cruisename, " DOES NOT matches the name '", all_tables_joined_by_folder_name$folder_name[i],"' in the file folder_name_to_coded_cruise_name_table.csv", " Please check the file ", all_tables_joined_by_folder_name$HPLC_file_name[i], " located in folder ",all_tables_joined_by_folder_name$HPLC_dirname[i]))
    #   stop()
    # }
    # 
    
    
    print(paste0("HPLC_file first line cruise name is '", HPLC_cruisename, "' , folder name is '", all_tables_joined_by_folder_name$folder_name[i],"' and the coded cruise name is ", all_tables_joined_by_folder_name$coded_cruise_name[i]))
    
    
    #filter(IRC_DF, !is.na(Reason.Reco) | Reason.Reco != "")
    HPLC_file2 <- filter(HPLC_file, !is.na(HPLC_file[,3]) | HPLC_file[,3] != "")
    
    HPLC_file2 <- data.frame(HPLC_file2)
    
    names(HPLC_file2) <- HPLC_file2[1,]
    HPLC_file2 <- HPLC_file2[2:nrow(HPLC_file2),]
    
    HPLC_file2 <- subset(HPLC_file2, select=c(
      1,2,27
    ))
    
    colnames_HPLC <- colnames(HPLC_file2)
    defined_HPLC_column_names <- c("ID", "DEPTH", "ABS. VOL(L)")
    
    #change HPLC first column name if it is "SAMPLEID" in "ID"
    if (colnames_HPLC[1]=="SAMPLEID"){
      names(HPLC_file2)[1] <- "ID"}
    
    
    
    
    
    HPLC_file_for_print <- print(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i])
    
    names_check_func <- function(x,y) {
      for (i in x) {
        if (!(i %in% names(y))) {
          print(paste0("ERROR: The HPLC file has column names error. Please check the file below:"))
          print(HPLC_file_for_print)
          print(paste0("The defined needed column names for the HPLC file are "))
          print(defined_HPLC_column_names)
          print(paste0("The needed column names in the HPLC file are "))
          print(colnames_HPLC)
          
          
          defined_HPLC_column_names_df <- data.frame(t(defined_HPLC_column_names))
          colnames_HPLC_df <- data.frame(t(colnames_HPLC))
          
          HPLC_column_names_ERROR <- rbind(HPLC_column_names_ERROR, defined_HPLC_column_names_df)
          HPLC_column_names_ERROR <- rbind(HPLC_column_names_ERROR, colnames_HPLC_df)
          
          write.table(HPLC_file_for_print, paste0("C:/R_WD/WRITE/WORKS3/", all_tables_joined_by_folder_name$coded_cruise_name[i] , "_HPLC_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
          write.table(HPLC_column_names_ERROR, paste0("C:/R_WD/WRITE/WORKS3/" ,all_tables_joined_by_folder_name$coded_cruise_name[i] , "_HPLC_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
          
          stop()
          #break()
          
        }
        else if(i==tail(names(y),n=1)) {
          print("The HPLC file below has the right defined column names.")
          print(HPLC_file_for_print)
          
        }
      }
    }
    
    
    names_check_func(defined_HPLC_column_names, HPLC_file2)
    
    
    
    # HPLC_file2 <- subset(HPLC_file2, select=c(
    #   1,2,27
    # ))
    
    dir.create(file.path(paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
    write.table(HPLC_file2, paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/", HPLC_filename_for_CSV, ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = T)
    
    #file_written <- list.files(pattern = "\\HPLC*.csv$", path = paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    file_written <- list.files(pattern = "\\HPLC*.*csv", path = paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    
    
    
    if (length(file_written==1)){
      print(paste0("The HPLC csv file '", HPLC_filename_for_CSV, "' was written."))
      print(file_written)
    }else{
      #print(paste0("ERROR: The HPLC csv file was not written"))
      print(paste0("ERROR: The HPLC csv file '", HPLC_filename_for_CSV, "' was not written."))
      stop()
      
    }
    
    
    #end else if1 xls    
  }
  
  #end i
}  



#######END writing the needed HPLC csv


#######START writing the needed QAT csv

#QAT data

QAT_file <- data.frame()
QAT_file2 <- data.frame()
QAT_column_names_ERROR <- data.frame()

for(i in 1:nrow(all_tables_joined_by_folder_name)){
  
  #i <- 1
  #i <- 9
  
  QAT_file_extension <- get.ext(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i])
  
  #if1 start xlsx
  if (QAT_file_extension == "xlsx"){
    
    
    #write all QAT xlsx files as csv in "C:/R_WD/WRITE/WORKS3/METADATA_CSV/"
    QAT_filename_for_CSV <- all_tables_joined_by_folder_name$QAT_file_name[i]
    QAT_filename_for_CSV <- sub('\\..*$', '', basename(QAT_filename_for_CSV))
    
    dir.create(file.path(paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
    
    QAT_file <- read_excel(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i], col_names = TRUE)
    
    QAT_cruisename <- QAT_file[1,2]
    
    #if QAT name is EN606 change it to EN2017606 to match the right cruise code.
    if (QAT_cruisename=="EN606"){
      QAT_cruisename <- "EN2017606"
      print(paste0("Cruise name changed in the QAT file to ", QAT_cruisename))
    }
    
    
    #check if the first line in the second column [1,2] from QAT has the same cruise name as in the file "C:\R_WD\folder_name_to_coded_cruise_name_table.csv"
    if (QAT_cruisename==all_tables_joined_by_folder_name$coded_cruise_name[i]){
      print(paste0("QAT_file first line second column cruise name ", QAT_cruisename, " matches the name '", all_tables_joined_by_folder_name$folder_name[i],"' in the file folder_name_to_coded_cruise_name_table.csv"))
    }else{
      print(paste0("ERROR: QAT_file first line cruise name ", QAT_cruisename, " DOES NOT matches the name '", all_tables_joined_by_folder_name$folder_name[i],"' in the file folder_name_to_coded_cruise_name_table.csv", " Please check the file ", all_tables_joined_by_folder_name$QAT_file_name[i], " located in folder ",all_tables_joined_by_folder_name$QAT_dirname[i]))
      stop()
    }
    
    
    QAT_file2 <- subset(QAT_file, select=c(
      1,2,3,4,5,7,8,16
    ))
    
    
    colnames_QAT <- colnames(QAT_file2)
    defined_QAT_column_names <- c("Filename", "Cruise number", "Station number", "Latitude...4", "Longitude...5", "Sample id", "Date", "Pressure")
    
    
    
    #change QAT  column nameS if they match the list below
    if (colnames_QAT[1]=="file"){
      names(QAT_file2)[1] <- "Filename"}
    
    if (colnames_QAT[1]=="filename"){
      names(QAT_file2)[1] <- "Filename"}
    
    if (colnames_QAT[1]=="ctd_file"){
      names(QAT_file2)[1] <- "Filename"}
    
    if (colnames_QAT[1]=="CTD_File"){
      names(QAT_file2)[1] <- "Filename"}
    
    if (colnames_QAT[1]=="file.name"){
      names(QAT_file2)[1] <- "Filename"}
    
    
    if (colnames_QAT[2]=="cruise_number"){
      names(QAT_file2)[2] <- "Cruise number"}
    
    if (colnames_QAT[2]=="cruise"){
      names(QAT_file2)[2] <- "Cruise number"}
    
    if (colnames_QAT[2]=="Cruise"){
      names(QAT_file2)[2] <- "Cruise number"}
    
    
    if (colnames_QAT[2]=="Cruise.number"){
      names(QAT_file2)[2] <- "Cruise number"}
    
    
    if (colnames_QAT[3]=="station"){
      names(QAT_file2)[3] <- "Station number"}
    
    if (colnames_QAT[3]=="Station.number"){
      names(QAT_file2)[3] <- "Station number"}
    
    if (colnames_QAT[3]=="event"){
      names(QAT_file2)[3] <- "Station number"}
    
    if (colnames_QAT[3]=="Event"){
      names(QAT_file2)[3] <- "Station number"}
    
    
    
    if (colnames_QAT[4]=="latitude"){
      names(QAT_file2)[4] <- "Latitude...4"}
    
    if (colnames_QAT[4]=="lat"){
      names(QAT_file2)[4] <- "Latitude...4"}
    
    if (colnames_QAT[4]=="Lat"){
      names(QAT_file2)[4] <- "Latitude...4"}
    
    if (colnames_QAT[4]=="Latitude"){
      names(QAT_file2)[4] <- "Latitude...4"}
    
    if (colnames_QAT[4]=="eventLatitude"){
      names(QAT_file2)[4] <- "Latitude...4"}
    
    
    if (colnames_QAT[5]=="longitude"){
      names(QAT_file2)[5] <- "Longitude...5"}
    
    if (colnames_QAT[5]=="Longitude"){
      names(QAT_file2)[5] <- "Longitude...5"}
    
    if (colnames_QAT[5]=="lon"){
      names(QAT_file2)[5] <- "Longitude...5"}
    
    if (colnames_QAT[5]=="Long"){
      names(QAT_file2)[5] <- "Longitude...5"}
    
    if (colnames_QAT[5]=="eventLongitude"){
      names(QAT_file2)[5] <- "Longitude...5"}
    
    
    if (colnames_QAT[6]=="sample_id"){
      names(QAT_file2)[6] <- "Sample id"}
    
    if (colnames_QAT[6]=="Sample.id"){
      names(QAT_file2)[6] <- "Sample id"}
    
    if (colnames_QAT[6]=="id"){
      names(QAT_file2)[6] <- "Sample id"}
    
    if (colnames_QAT[6]=="ID.Label"){
      names(QAT_file2)[6] <- "Sample id"}
    
    #QAT_file$`Sample id` <- as.character(QAT_file$`Sample id`)
    
    if (colnames_QAT[7]=="date"){
      names(QAT_file2)[7] <- "Date"}
    
    
    
    if (colnames_QAT[8]=="PrDM"){
      names(QAT_file2)[8] <- "Pressure"}    
    
    if (colnames_QAT[8]=="PrdM"){
      names(QAT_file2)[8] <- "Pressure"}    
    
    if (colnames_QAT[8]=="pressure"){
      names(QAT_file2)[8] <- "Pressure"}
    
    if (colnames_QAT[8]=="PrSM"){
      names(QAT_file2)[8] <- "Pressure"}
    
    
    
    QAT_file_for_print <- print(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i])
    
    names_check_func <- function(x,y) {
      for (i in x) {
        if (!(i %in% names(y))) {
          print(paste0("ERROR: The QAT file has column names error. Please check the file below:"))
          print(QAT_file_for_print)
          print(paste0("The defined needed column names for the QAT file are "))
          print(defined_QAT_column_names)
          print(paste0("The needed column names in the QAT file are "))
          print(colnames_QAT)
          
          
          defined_QAT_column_names_df <- data.frame(t(defined_QAT_column_names))
          colnames_QAT_df <- data.frame(t(colnames_QAT))
          
          QAT_column_names_ERROR <- rbind(QAT_column_names_ERROR, defined_QAT_column_names_df)
          QAT_column_names_ERROR <- rbind(QAT_column_names_ERROR, colnames_QAT_df)
          
          write.table(QAT_file_for_print, paste0("C:/R_WD/WRITE/WORKS3/", "QAT_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
          write.table(QAT_column_names_ERROR, paste0("C:/R_WD/WRITE/WORKS3/", "QAT_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
          
          stop()
          
        }
        else if(i==tail(names(y),n=1)) {
          print("The QAT file below has the right defined column names.")
          print(QAT_file_for_print)
          
        }
      }
    }
    
    
    names_check_func(defined_QAT_column_names, QAT_file2)
    
    
    #rename QAT columns. DO NOT RENAME IN HERE FOR THE FINAL PHYTOPLANKTON TABLE, IT WON'T CHANGE, THIS IS JUST FOR PROCESSING
    names(QAT_file2)[1] <- "Filename"
    names(QAT_file2)[2] <- "Cruise_number"
    names(QAT_file2)[3] <- "Event_number"
    names(QAT_file2)[4] <- "Latitude"
    names(QAT_file2)[5] <- "Longitude"
    names(QAT_file2)[6] <- "Sample_id"
    names(QAT_file2)[7] <- "Date"
    names(QAT_file2)[8] <- "Pressure"
    
    QAT_file2$Sample_id <- as.character(QAT_file2$Sample_id)
    
    dir.create(file.path(paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
    write.table(QAT_file2, paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/", QAT_filename_for_CSV, ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = T)
    
    file_written <- list.files(pattern = "\\_QAT*.*csv$", path = paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    
    
    if (length(file_written==1)){
      print("The QAT csv file was written.")
      print(file_written)
    }else{
      print(paste0("ERROR: The QAT csv file was not written"))
      stop()
      
    }
    
    
    
    
    
    
    
    #end if1 xlsx, start xls
  }else if (QAT_file_extension == "csv"){
    
    
    
    
    
    
    
    
    #write all QAT xlsx files as csv in "C:/R_WD/WRITE/WORKS3/METADATA_CSV/"
    QAT_filename_for_CSV <- all_tables_joined_by_folder_name$QAT_file_name[i]
    QAT_filename_for_CSV <- sub('\\..*$', '', basename(QAT_filename_for_CSV))
    
    dir.create(file.path(paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
    
    #QAT_file <- read_excel(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i], col_names = TRUE)
    QAT_file <- read.csv(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i])
    
    #QAT_file$id <- as.character(QAT_file$id)
    
    QAT_cruisename <- QAT_file[1,2]
    
    # #if QAT name is EN606 change it to EN2017606 to match the right cruise code.
    # if (QAT_cruisename=="EN606"){
    #   QAT_cruisename <- "EN2017606"
    #   print(paste0("Cruise name changed in the QAT file to ", QAT_cruisename))
    # }
    
    
    #check if the first line in the second column [1,2] from QAT has the same cruise name as in the file "C:\R_WD\folder_name_to_coded_cruise_name_table.csv"
    #if (QAT_cruisename==all_tables_joined_by_folder_name$coded_cruise_name[i]){
    if (QAT_cruisename==paste0(" ",all_tables_joined_by_folder_name$coded_cruise_name[i])){  
      
      print(paste0("QAT_file first line second column cruise name ", QAT_cruisename, " matches the name '", all_tables_joined_by_folder_name$folder_name[i],"' coded cruise name ", all_tables_joined_by_folder_name$coded_cruise_name[i]))
    }else{
      print(paste0("ERROR: QAT_file first line cruise name ", QAT_cruisename, " DOES NOT matches the name '", all_tables_joined_by_folder_name$folder_name[i],"' coded cruise name ", all_tables_joined_by_folder_name$coded_cruise_name[i], " Please check the file ", all_tables_joined_by_folder_name$QAT_file_name[i], " located in folder ",all_tables_joined_by_folder_name$QAT_dirname[i]))
      #stop()
    }
    
    
    QAT_file2 <- subset(QAT_file, select=c(
      1,2,3,4,5,7,8,16
    ))
    
    
    colnames_QAT <- colnames(QAT_file2)
    defined_QAT_column_names <- c("Filename", "Cruise number", "Station number", "Latitude...4", "Longitude...5", "Sample id", "Date", "Pressure")
    
    
    
    #change QAT  column nameS if they match the list below
    if (colnames_QAT[1]=="file"){
      names(QAT_file2)[1] <- "Filename"}
    
    if (colnames_QAT[1]=="filename"){
      names(QAT_file2)[1] <- "Filename"}
    
    if (colnames_QAT[1]=="ctd_file"){
      names(QAT_file2)[1] <- "Filename"}
    
    if (colnames_QAT[1]=="CTD_File"){
      names(QAT_file2)[1] <- "Filename"}
    
    if (colnames_QAT[1]=="file.name"){
      names(QAT_file2)[1] <- "Filename"}
    
    
    if (colnames_QAT[2]=="cruise_number"){
      names(QAT_file2)[2] <- "Cruise number"}
    
    if (colnames_QAT[2]=="cruise"){
      names(QAT_file2)[2] <- "Cruise number"}
    
    if (colnames_QAT[2]=="Cruise"){
      names(QAT_file2)[2] <- "Cruise number"}
    
    
    if (colnames_QAT[2]=="Cruise.number"){
      names(QAT_file2)[2] <- "Cruise number"}
    
    
    if (colnames_QAT[3]=="station"){
      names(QAT_file2)[3] <- "Station number"}
    
    if (colnames_QAT[3]=="Station.number"){
      names(QAT_file2)[3] <- "Station number"}
    
    if (colnames_QAT[3]=="event"){
      names(QAT_file2)[3] <- "Station number"}
    
    if (colnames_QAT[3]=="Event"){
      names(QAT_file2)[3] <- "Station number"}
    
    
    
    if (colnames_QAT[4]=="latitude"){
      names(QAT_file2)[4] <- "Latitude...4"}
    
    if (colnames_QAT[4]=="lat"){
      names(QAT_file2)[4] <- "Latitude...4"}
    
    if (colnames_QAT[4]=="Lat"){
      names(QAT_file2)[4] <- "Latitude...4"}
    
    if (colnames_QAT[4]=="Latitude"){
      names(QAT_file2)[4] <- "Latitude...4"}
    
    if (colnames_QAT[4]=="eventLatitude"){
      names(QAT_file2)[4] <- "Latitude...4"}
    
    
    if (colnames_QAT[5]=="longitude"){
      names(QAT_file2)[5] <- "Longitude...5"}
    
    if (colnames_QAT[5]=="Longitude"){
      names(QAT_file2)[5] <- "Longitude...5"}
    
    if (colnames_QAT[5]=="lon"){
      names(QAT_file2)[5] <- "Longitude...5"}
    
    if (colnames_QAT[5]=="Long"){
      names(QAT_file2)[5] <- "Longitude...5"}
    
    if (colnames_QAT[5]=="eventLongitude"){
      names(QAT_file2)[5] <- "Longitude...5"}
    
    
    if (colnames_QAT[6]=="sample_id"){
      names(QAT_file2)[6] <- "Sample id"}
    
    if (colnames_QAT[6]=="Sample.id"){
      names(QAT_file2)[6] <- "Sample id"}
    
    if (colnames_QAT[6]=="id"){
      names(QAT_file2)[6] <- "Sample id"}
    
    if (colnames_QAT[6]=="ID.Label"){
      names(QAT_file2)[6] <- "Sample id"}
    
    #QAT_file$`Sample id` <- as.character(QAT_file$`Sample id`)
    
    if (colnames_QAT[7]=="date"){
      names(QAT_file2)[7] <- "Date"}
    
    
    
    if (colnames_QAT[8]=="PrDM"){
      names(QAT_file2)[8] <- "Pressure"}    
    
    if (colnames_QAT[8]=="PrdM"){
      names(QAT_file2)[8] <- "Pressure"}    
    
    if (colnames_QAT[8]=="pressure"){
      names(QAT_file2)[8] <- "Pressure"}
    
    if (colnames_QAT[8]=="PrSM"){
      names(QAT_file2)[8] <- "Pressure"}
    
    
    
    
    
    QAT_file_for_print <- print(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i])
    
    names_check_func <- function(x,y) {
      for (i in x) {
        if (!(i %in% names(y))) {
          print(paste0("ERROR: The QAT file has column names error. Please check the file below:"))
          print(QAT_file_for_print)
          print(paste0("The defined needed column names for the QAT file are "))
          print(defined_QAT_column_names)
          print(paste0("The needed column names in the QAT file are "))
          print(colnames_QAT)
          
          
          defined_QAT_column_names_df <- data.frame(t(defined_QAT_column_names))
          colnames_QAT_df <- data.frame(t(colnames_QAT))
          
          QAT_column_names_ERROR <- rbind(QAT_column_names_ERROR, defined_QAT_column_names_df)
          QAT_column_names_ERROR <- rbind(QAT_column_names_ERROR, colnames_QAT_df)
          
          write.table(QAT_file_for_print, paste0("C:/R_WD/WRITE/WORKS3/", "QAT_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
          write.table(QAT_column_names_ERROR, paste0("C:/R_WD/WRITE/WORKS3/", "QAT_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
          
          #stop()
          
        }
        else if(i==tail(names(y),n=1)) {
          print("The QAT file below has the right defined column names.")
          print(QAT_file_for_print)
          
        }
      }
    }
    
    
    names_check_func(defined_QAT_column_names, QAT_file2)
    
    
    #rename QAT columns. DO NOT RENAME IN HERE FOR THE FINAL PHYTOPLANKTON TABLE, IT WON'T CHANGE, THIS IS JUST FOR PROCESSING
    names(QAT_file2)[1] <- "Filename"
    names(QAT_file2)[2] <- "Cruise_number"
    names(QAT_file2)[3] <- "Event_number"
    names(QAT_file2)[4] <- "Latitude"
    names(QAT_file2)[5] <- "Longitude"
    names(QAT_file2)[6] <- "Sample_id"
    names(QAT_file2)[7] <- "Date"
    names(QAT_file2)[8] <- "Pressure"
    
    QAT_file2$Sample_id <- as.character(QAT_file2$Sample_id)
    
    dir.create(file.path(paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
    write.table(QAT_file2, paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/", QAT_filename_for_CSV, ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = T)
    
    file_written <- list.files(pattern = "\\_QAT*.*csv", path = paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    
    
    if (length(file_written==1)){
      print("The QAT csv file was written.")
      print(file_written)
    }else{
      print(paste0("ERROR: The QAT csv file was not written"))
      stop()
      
    }
    
    
    
    
    
    
    
    
    
    
    
    #end else if1 csv
  }
  
  
  #end i
}



#######END writing the needed QAT csv




#######START writing the ODF files



#ODF data
#NO CSV ERROR file it is written for ODF errors, the error message displays on the console

for(i in 1:nrow(all_tables_joined_by_folder_name)){
  
  #write all ODF files as csv in "C:/R_WD/WRITE/WORKS3/METADATA_CSV/"
  ODF_filename_for_CSV <- all_tables_joined_by_folder_name$ODF_file_name[i]
  ODF_filename_for_CSV <- sub('\\..*$', '', basename(ODF_filename_for_CSV))
  
  dir.create(file.path(paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
  
  
  ODF_file2 <- all_tables_joined_by_folder_name$all_ODF_files[i]
  con <- file(ODF_file2, "r")
  first_12_lines_ODF_file <- readLines(con, n=12)
  close(con)
  
  first_12_lines_ODF_file_df <- data.frame(first_12_lines_ODF_file)
  
  #extract line12 from the ODF file ("RUISE_DESCRIPTION")
  ODF_line12 <- rm_between(first_12_lines_ODF_file_df[12,], 'C', '=', extract=TRUE)  
  
  if (ODF_line12=="RUISE_DESCRIPTION"){
    print(paste0("ODF file ", ODF_file2, " line 12 it is CRUISE_DESCRIPTION which is okay."))
  }else{
    print(paste0("ERROR: ODF file ", ODF_file2, " line 12 IT IS NOT CRUISE_DESCRIPTION but instead ", ODF_line12, " Please check the ODF file."))
    stop()
  }
  
  
  #check if cruise name (line 5 of 12) from the ODF file has the same cruise name as in the file "C:\R_WD\folder_name_to_coded_cruise_name_table.csv"    
  #extract cruise name from the ODF file
  # rm_between(x, '"', '"', extract=TRUE)
  ODF_cruise_name <- rm_between(first_12_lines_ODF_file_df[5,], "'", "'", extract=TRUE)
  if (ODF_cruise_name==all_tables_joined_by_folder_name$coded_cruise_name[i]){
    print(paste0("The ODF file cruise name (line 5 of 12) ", ODF_cruise_name, " matches the name '", all_tables_joined_by_folder_name$folder_name[i],"' in the file folder_name_to_coded_cruise_name_table.csv"))
  }else{
    print(paste0("ERROR: The ODF file cruise name (line 5 of 12) ", ODF_cruise_name, " DOES NOT matches the name '", all_tables_joined_by_folder_name$folder_name[i],"' in the file folder_name_to_coded_cruise_name_table.csv", " Please check the file ", all_tables_joined_by_folder_name$ODF_file_name[i], " located in folder ",all_tables_joined_by_folder_name$QAT_dirname[i]))
    stop()
  }
  
  
  ODF_header10lines_3_12 <- first_12_lines_ODF_file[3:length(first_12_lines_ODF_file)]  
  
  
  dir.create(file.path(paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
  write.table(ODF_header10lines_3_12, paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/", ODF_filename_for_CSV, "_ODF.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
  
  #print(ODF_header10lines_3_12)
  
  file_written <- list.files(pattern = "\\_ODF.csv$", path = paste0("C:/R_WD/WRITE/WORKS3/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
  
  
  if (length(file_written==1)){
    print("The ODF csv file HEADER was written.")
    print(file_written)
  }else{
    print(paste0("ERROR: The ODF csv file was not written"))
    stop()
    
  }
  
  
  #end i
}


#############END writing ODF file








###START searching for the written CSV metadata files in "C:\R_WD\WRITE\WORKS3\METADATA_CSV\"


########################

#check if each folder with the 3 final files has the 3 metadata files needed in the metadata folder

input_metadata_csv_folder_name <- "C:/R_WD/WRITE/WORKS3/METADATA_CSV"

#check if all needed HPLC-final_JB.csv files are in the metadata folders

#all_HPLC_csv_files<- list.files(pattern = "\\HPLC-final_JB.csv$"  , path = input_metadata_csv_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
#all_HPLC_csv_files<- list.files(pattern = "\\HPLC*.csv$"  , path = input_metadata_csv_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
all_HPLC_csv_files<- list.files(pattern = "\\HPLC*"  , path = input_metadata_csv_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)


all_HPLC_csv_files <- grep('~$', all_HPLC_csv_files, fixed = TRUE, value = TRUE, invert = TRUE)
all_HPLC_csv_files_dirname <- dirname(all_HPLC_csv_files)
all_HPLC_csv_files_folder_name <- sub('\\..*$', '', basename(all_HPLC_csv_files_dirname))
all_HPLC_csv_files_file_name <- sub('.*/', '', basename(all_HPLC_csv_files))

all_HPLC_csv_files_df <- data.frame(all_HPLC_csv_files)
all_HPLC_csv_files_df$HPLC_dirname <- all_HPLC_csv_files_dirname
all_HPLC_csv_files_df$folder_name <- all_HPLC_csv_files_folder_name
all_HPLC_csv_files_df$HPLC_file_name <- all_HPLC_csv_files_file_name
nrows_all_HPLC_csv_files_df <- nrow(all_HPLC_csv_files_df)
write.csv(all_HPLC_csv_files_df, paste0("C:/R_WD/WRITE/WORKS3/", "all_HPLC_csv_files_df_", nrows_all_HPLC_csv_files_df, "_rows.csv"), row.names = FALSE)



for (i in 1:nrow(all_HPLC_csv_files_df)){
  #HPLC_csv_file_path <- list.files(pattern = "\\HPLC-final_JB.csv$"  , path = all_HPLC_csv_files_df$HPLC_dirname[i], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE) #i
  HPLC_csv_file_path <- list.files(pattern = "\\HPLC*.csv$"  , path = all_HPLC_csv_files_df$HPLC_dirname[i], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE) #i
  
  
  HPLC_csv_file_path <- grep('~$', HPLC_csv_file_path, fixed = TRUE, value = TRUE, invert = TRUE)
  
  
  if (length(HPLC_csv_file_path)==1) {
    
    #i
    print(paste0("The metadata folder named '", all_HPLC_csv_files_df$folder_name[i], "' ", "has the HPLC-final_JB.csv file ", all_HPLC_csv_files_df$file_name[i]))
  } else if (length(HPLC_csv_file_path)<1){
    print(paste0("The metadata folder named '", all_HPLC_csv_files_df$folder_name[i], "' ","DOES NOT HAVE the HPLC-final_JB.csv file. Please check the folder ", all_HPLC_csv_files_df$dirname[i])) #i
    #stop()
  }else if (length(HPLC_csv_file_path)>1){
    print(paste0("The metadata folder named '", all_HPLC_csv_files_df$folder_name[i], "' ","DOES HAVE MORE THAN ONE HPLC-final_JB.csv file. Please check the folder ", all_HPLC_csv_files_df$dirname[i])) #i
    #stop()
  }
  
  
  #end i  
}



#check if all needed _QAT.csv files are in the metadata folders


all_QAT_csv_files<- list.files(pattern = "\\_QAT*.*csv$"  , path = input_metadata_csv_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
all_QAT_csv_files <- grep('~$', all_QAT_csv_files, fixed = TRUE, value = TRUE, invert = TRUE)
all_QAT_csv_files_dirname <- dirname(all_QAT_csv_files)
all_QAT_csv_files_folder_name <- sub('\\..*$', '', basename(all_QAT_csv_files_dirname))
all_QAT_csv_files_file_name <- sub('.*/', '', basename(all_QAT_csv_files))

all_QAT_csv_files_df <- data.frame(all_QAT_csv_files)
all_QAT_csv_files_df$QAT_dirname <- all_QAT_csv_files_dirname
all_QAT_csv_files_df$folder_name <- all_QAT_csv_files_folder_name
all_QAT_csv_files_df$QAT_file_name <- all_QAT_csv_files_file_name
nrows_all_QAT_csv_files_df <- nrow(all_QAT_csv_files_df)
write.csv(all_QAT_csv_files_df, paste0("C:/R_WD/WRITE/WORKS3/", "all_QAT_csv_files_df_", nrows_all_QAT_csv_files_df, "_rows.csv"), row.names = FALSE)



for (i in 1:nrow(all_QAT_csv_files_df)){
  QAT_csv_file_path <- list.files(pattern = "\\_QAT*.*csv$"  , path = all_QAT_csv_files_df$QAT_dirname[i], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE) #i
  QAT_csv_file_path <- grep('~$', QAT_csv_file_path, fixed = TRUE, value = TRUE, invert = TRUE)
  
  
  if (length(QAT_csv_file_path)==1) {
    
    #i
    print(paste0("The metadata folder named '", all_QAT_csv_files_df$folder_name[i], "' ", "has the _QAT.csv file ", all_QAT_csv_files_df$file_name[i]))
  } else if (length(QAT_csv_file_path) < 1){
    print(paste0("The metadata folder named '", all_QAT_csv_files_df$folder_name[i], "' ","DOES NOT HAVE the _QAT.csv file. Please check the folder ", all_QAT_csv_files_df$dirname[i])) #i
    stop()
  }else if (length(QAT_csv_file_path) > 1){
    print(paste0("The metadata folder named '", all_QAT_csv_files_df$folder_name[i], "' ","DOES HAVE MORE THAN ONE _QAT.csv file. Please check the folder ", all_QAT_csv_files_df$dirname[i])) #i
    stop()
  }
  
  
  #end i  
}






#check if all needed ODF.csv files are in the metadata folders


all_ODF_csv_files<- list.files(pattern = "\\^*ODF.csv$"  , path = input_metadata_csv_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
#all_ODF_csv_files <- grep('~$', all_ODF_csv_files, fixed = TRUE, value = TRUE, invert = TRUE)
all_ODF_csv_files_dirname <- dirname(all_ODF_csv_files)
all_ODF_csv_files_folder_name <- sub('\\..*$', '', basename(all_ODF_csv_files_dirname))
all_ODF_csv_files_file_name <- sub('.*/', '', basename(all_ODF_csv_files))

all_ODF_csv_files_df <- data.frame(all_ODF_csv_files)
all_ODF_csv_files_df$ODF_csv_dirname <- all_ODF_csv_files_dirname
all_ODF_csv_files_df$folder_name <- all_ODF_csv_files_folder_name
all_ODF_csv_files_df$ODF_csv_file_name <- all_ODF_csv_files_file_name
nrows_all_ODF_csv_files_df <- nrow(all_ODF_csv_files_df)
write.csv(all_ODF_csv_files_df, paste0("C:/R_WD/WRITE/WORKS3/", "all_ODF_csv_files_df_", nrows_all_ODF_csv_files_df, "_rows.csv"), row.names = FALSE)



for (i in 1:nrow(all_ODF_csv_files_df)){
  ODF_csv_file_path <- list.files(pattern = "\\^*ODF.csv$"  , path = all_ODF_csv_files_df$ODF_csv_dirname[i], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE) #i
  #ODF_csv_file_path <- grep('~$', ODF_csv_file_path, fixed = TRUE, value = TRUE, invert = TRUE)
  
  
  if (length(ODF_csv_file_path)==1) {
    
    #i
    print(paste0("The metadata folder named '", all_ODF_csv_files_df$folder_name[i], "' ", "has the *ODF.csv file ", all_ODF_csv_files_df$file_name[i]))
  } else if (length(ODF_csv_file_path) < 1){
    print(paste0("The metadata folder named '", all_ODF_csv_files_df$folder_name[i], "' ","DOES NOT HAVE the *ODF.csv file. Please check the folder ", all_ODF_csv_files_df$dirname[i])) #i
    stop()
  }else if (length(ODF_csv_file_path) > 1){
    print(paste0("The metadata folder named '", all_ODF_csv_files_df$folder_name[i], "' ","DOES HAVE MORE THAN ONE *ODF.csv file. Please check the folder ", all_ODF_csv_files_df$dirname[i])) #i
    stop()
  }
  
  
  #end i  
}



# cruise_name_table_df
# project_tables_that_DO_have_metadata_folders
# d6Phytoplankton_project_table_filepaths_df
# d6Particulate_project_table_filepaths_df
# d6Detritus_project_table_filepaths_df
# all_HPLC_xlsx_files_df
# all_QAT_xlsx_files_df
# all_ODF_files_df

#all_tables_joined_by_folder_name_12_columns <- all_tables_joined_by_folder_name[,1:12]

#pairing all the files that need metadata with the metadata csv they need in one table
all_tables_joined_by_folder_name_with_csv_metadata <- inner_join(cruise_name_table_df, project_tables_that_DO_have_metadata_folders, by = c("folder_name"))
all_tables_joined_by_folder_name_with_csv_metadata <- inner_join(all_tables_joined_by_folder_name_with_csv_metadata, d6Phytoplankton_project_table_filepaths_df, by = c("folder_name"))
all_tables_joined_by_folder_name_with_csv_metadata <- inner_join(all_tables_joined_by_folder_name_with_csv_metadata, d6Particulate_project_table_filepaths_df, by = c("folder_name"))
all_tables_joined_by_folder_name_with_csv_metadata <- inner_join(all_tables_joined_by_folder_name_with_csv_metadata, d6Detritus_project_table_filepaths_df, by = c("folder_name"))
all_tables_joined_by_folder_name_with_csv_metadata <- inner_join(all_tables_joined_by_folder_name_with_csv_metadata, all_HPLC_csv_files_df, by = c("folder_name"))
all_tables_joined_by_folder_name_with_csv_metadata <- inner_join(all_tables_joined_by_folder_name_with_csv_metadata, all_QAT_csv_files_df, by = c("folder_name"))
all_tables_joined_by_folder_name_with_csv_metadata <- inner_join(all_tables_joined_by_folder_name_with_csv_metadata, all_ODF_csv_files_df, by = c("folder_name"))

nrows_all_tables_joined_by_folder_name_with_csv_metadata <- nrow(all_tables_joined_by_folder_name_with_csv_metadata)
write.csv(all_tables_joined_by_folder_name_with_csv_metadata, paste0("C:/R_WD/WRITE/WORKS3/", "all_tables_joined_by_folder_name_with_csv_metadata_", nrows_all_tables_joined_by_folder_name_with_csv_metadata, "_rows.csv"), row.names = FALSE)



##########################

all_tables_with_csv <- all_tables_joined_by_folder_name_with_csv_metadata


#Phytoplancton final file

for (i in 1:nrow(all_tables_with_csv)){
  
  Phytoplankton_csv_table <- read.table(all_tables_with_csv$d6Phytoplankton_project_table_filepath[i], skip = 0, sep = ",", header = FALSE)#i
  Particulate_csv_table <- read.table(all_tables_with_csv$d6Particulate_project_table_filepath[i], skip = 0, sep = ",", header = FALSE)#i
  Detritus_csv_table <- read.table(all_tables_with_csv$d6Detritus_project_table_filepath[i], skip = 0, sep = ",", header = FALSE)#i
  
  
    
  #rename the cell
  #Phytoplankton_csv_table[1,1] <- "Sample_ID - Wavelength_nm"
  # Phytoplankton_csv_table[1,1] <- NA
  # Particulate_csv_table[1,1] <- NA
  # Detritus_csv_table[1,1] <- NA
  
  Phytoplankton_csv_table[1,1] <- "Phytoplankton.Absorbance"
  Particulate_csv_table[1,1] <- "Particulate.Absorbance"
  Detritus_csv_table[1,1] <- "Detritus.Absorbance"
  
  
  HPLC_csv_file <- read.table(all_tables_with_csv$all_HPLC_csv_files[i], skip = 0, sep = ",", header = FALSE)#i
  
  Phytoplankton_HPLC_DEPTH_ABSVOL <- data.frame(Phytoplankton_csv_table[,1])
  Phytoplankton_HPLC_DEPTH_ABSVOL2 <- data.frame(matrix(ncol = 4, nrow = nrow(Phytoplankton_HPLC_DEPTH_ABSVOL)))
  Phytoplankton_HPLC_DEPTH_ABSVOL3 <- cbind(Phytoplankton_HPLC_DEPTH_ABSVOL, Phytoplankton_HPLC_DEPTH_ABSVOL2)
  
  
  # df <- data.frame(matrix(ncol = 10000, nrow = 0))
  # colnames(df) <- paste0("hello", c(1:10000))
  
  for (j in 2:nrow(Phytoplankton_csv_table)){
    
    #loop with k in HPLC_csv_file!!!
    
        for (k in 2:nrow(HPLC_csv_file)){

    if(Phytoplankton_csv_table[j,1]==HPLC_csv_file[k,1]){
      Phytoplankton_HPLC_DEPTH_ABSVOL1 <- data.frame(Phytoplankton_csv_table[j,1], HPLC_csv_file[k,1], HPLC_csv_file[k,2], HPLC_csv_file[k,3])
      
      if(Phytoplankton_HPLC_DEPTH_ABSVOL[j,1]==Phytoplankton_HPLC_DEPTH_ABSVOL1[1,1]){
        Phytoplankton_HPLC_DEPTH_ABSVOL3[j, 2:5] <- Phytoplankton_HPLC_DEPTH_ABSVOL1[,]
        
      }}}}

  
  #filter(IRC_DF, !is.na(Reason.Reco) | Reason.Reco != "")
  
  HPLC_samples_not_found <- filter(Phytoplankton_HPLC_DEPTH_ABSVOL3, is.na(X1))
  HPLC_samples_not_found_list <- HPLC_samples_not_found[2:nrow(HPLC_samples_not_found),1]
  
  
  if (nrow(HPLC_samples_not_found)>1){
    print(cat(paste0("The samples ID's ", "\n", HPLC_samples_not_found_list, "\n", " from the file ", "\n", all_tables_with_csv$d6Phytoplankton_project_table_filepath[i], "\n", " can't be found in the file ", "\n", all_tables_with_csv$all_HPLC_csv_files[i], " ")))#i for both [1]
  }else{
    print(paste0("All SAMPLE_ID's from the Phytoplancton final table file ", all_tables_with_csv$d6Phytoplankton_project_table_filepath[i], " have been found in the HPLC file ", all_tables_with_csv$all_HPLC_csv_files[i]))  
  }
  
  
  print(cat(paste0("The samples ID ", "\n", HPLC_samples_not_found_list, "\n", " from the file ", all_tables_with_csv$d6Phytoplankton_project_table_filepath[i], " can't be found in the file ", all_tables_with_csv$all_HPLC_csv_files[i], " ")))#i for both [1]
    
  Phytoplankton_HPLC_DEPTH_ABSVOL3_2 <- Phytoplankton_HPLC_DEPTH_ABSVOL3[,4:5]
  names(Phytoplankton_HPLC_DEPTH_ABSVOL3_2)[1:2] <- c("DEPTH", "ABS. VOL(L)") 

  DEPTH_ABSVOL <- Phytoplankton_HPLC_DEPTH_ABSVOL3_2
  
  ####################  

#adding to Phytoplancton final file the QAT needed columns

  QAT_csv_file <- read.table(all_tables_with_csv$all_QAT_csv_files[i], skip = 0, sep = ",", header = FALSE)#i
  
  Phytoplankton_EventNO_LAT_LON_Date_pressure <- data.frame(Phytoplankton_csv_table[,1])
  Phytoplankton_EventNO_LAT_LON_Date_pressure2 <- data.frame(matrix(ncol = 7, nrow = nrow(Phytoplankton_EventNO_LAT_LON_Date_pressure)))
  Phytoplankton_EventNO_LAT_LON_Date_pressure3 <- cbind(Phytoplankton_EventNO_LAT_LON_Date_pressure, Phytoplankton_EventNO_LAT_LON_Date_pressure2)
  
  
  # df <- data.frame(matrix(ncol = 10000, nrow = 0))
  # colnames(df) <- paste0("hello", c(1:10000))
  
  for (j in 2:nrow(Phytoplankton_csv_table)){
    
    #loop with k in HPLC_csv_file!!!
    
    for (k in 2:nrow(QAT_csv_file)){
      
      if(Phytoplankton_csv_table[j,1]==QAT_csv_file[k,6]){
        Phytoplankton_EventNO_LAT_LON_Date_pressure1 <- data.frame(Phytoplankton_csv_table[j,1], QAT_csv_file[k,3], QAT_csv_file[k,4], QAT_csv_file[k,5], QAT_csv_file[k,6], QAT_csv_file[k,7], QAT_csv_file[k,8])
        
        if(Phytoplankton_EventNO_LAT_LON_Date_pressure[j,1]==Phytoplankton_EventNO_LAT_LON_Date_pressure1[1,5]){
          Phytoplankton_EventNO_LAT_LON_Date_pressure3[j, 2:8] <- Phytoplankton_EventNO_LAT_LON_Date_pressure1[,]
          
        }}}}
  

  #filter(IRC_DF, !is.na(Reason.Reco) | Reason.Reco != "")
  
  QAT_samples_not_found <- filter(Phytoplankton_EventNO_LAT_LON_Date_pressure3, is.na(X5))
  QAT_samples_not_found_list <- QAT_samples_not_found[2:nrow(QAT_samples_not_found),1]
  
  
  if (nrow(QAT_samples_not_found)>1){
    print(cat(paste0("The samples ID's ", "\n", QAT_samples_not_found_list, "\n", " from the file ", "\n", all_tables_with_csv$d6Phytoplankton_project_table_filepath[i], "\n", " can't be found in the file ", "\n", all_tables_with_csv$all_QAT_csv_files[i], " ")))#i for both [1]
    }else{
  print(paste0("All SAMPLE_ID's from the Phytoplancton final table file ", all_tables_with_csv$d6Phytoplankton_project_table_filepath[i], " have been found in the QAT file ", all_tables_with_csv$all_QAT_csv_files[i])) #i both [1] 
  }
    
  
  Phytoplankton_EventNO_LAT_LON_Date_pressure3_2 <- cbind(Phytoplankton_EventNO_LAT_LON_Date_pressure3[,3:5], Phytoplankton_EventNO_LAT_LON_Date_pressure3[,7:8])
  
  names(Phytoplankton_EventNO_LAT_LON_Date_pressure3_2)[1:5] <- c("Event number", "Latitude", "Longitude", "Date", "Pressure") 
  
  EventNO_LAT_LON_Date_pressure <- Phytoplankton_EventNO_LAT_LON_Date_pressure3_2
  
######  
  
  HPLC_and_QAT <- cbind(DEPTH_ABSVOL, EventNO_LAT_LON_Date_pressure)
  
  Phytoplankton_csv_table_empty_row <- data.frame(matrix(ncol = ncol(Phytoplankton_csv_table), nrow = 1)) 
  names(Phytoplankton_csv_table_empty_row)[] <- names(Phytoplankton_csv_table)[]
  Phytoplankton_csv_table2 <- rbind(Phytoplankton_csv_table_empty_row, Phytoplankton_csv_table)
  Particulate_csv_table2 <- rbind(Phytoplankton_csv_table_empty_row, Particulate_csv_table)
  Detritus_csv_table2 <- rbind(Phytoplankton_csv_table_empty_row, Detritus_csv_table)
  
  
  HPLC_and_QAT_empty_row <- data.frame(matrix(ncol = ncol(HPLC_and_QAT), nrow = 1)) 
  names(HPLC_and_QAT_empty_row)[] <- names(HPLC_and_QAT)[]
  HPLC_and_QAT2 <- rbind(HPLC_and_QAT_empty_row, HPLC_and_QAT)
  
  HPLC_and_QAT2[1,] <- names(HPLC_and_QAT)[]
  
  #HPLC and QAT columns at the end
  # Phytoplankton_with_HPLC_and_QAT <- cbind(Phytoplankton_csv_table2, HPLC_and_QAT2)
  # Particulate_with_HPLC_and_QAT <- cbind(Particulate_csv_table2, HPLC_and_QAT2)
  # Detritus_with_HPLC_and_QAT <- cbind(Detritus_csv_table2, HPLC_and_QAT2)
  
  
  #HPLC and QAT columns at the beginning
  Phytoplankton_with_HPLC_and_QAT <- cbind(HPLC_and_QAT2, Phytoplankton_csv_table2)
  Particulate_with_HPLC_and_QAT <- cbind(HPLC_and_QAT2, Particulate_csv_table2)
  Detritus_with_HPLC_and_QAT <- cbind(HPLC_and_QAT2, Detritus_csv_table2)
  
  
    
  Phytoplankton_with_HPLC_and_QAT[1,8] <- "Sample ID"
  Phytoplankton_with_HPLC_and_QAT[1,9] <- " Wavelength (nm)"
  
  Particulate_with_HPLC_and_QAT[1,8] <- "Sample ID"
  Particulate_with_HPLC_and_QAT[1,9] <- " Wavelength (nm)"
  
  Detritus_with_HPLC_and_QAT[1,8] <- "Sample ID"
  Detritus_with_HPLC_and_QAT[1,9] <- " Wavelength (nm)"
  
  
  Phytoplankton_with_HPLC_and_QAT_empty_row <- data.frame(matrix(ncol = ncol(Phytoplankton_with_HPLC_and_QAT), nrow = 1)) 
  names(Phytoplankton_with_HPLC_and_QAT_empty_row)[] <- names(Phytoplankton_with_HPLC_and_QAT)[]
  Phytoplankton_with_HPLC_and_QAT_no_header <- rbind(Phytoplankton_with_HPLC_and_QAT_empty_row, Phytoplankton_with_HPLC_and_QAT)
  
  Particulate_with_HPLC_and_QAT_empty_row <- data.frame(matrix(ncol = ncol(Particulate_with_HPLC_and_QAT), nrow = 1)) 
  names(Particulate_with_HPLC_and_QAT_empty_row)[] <- names(Particulate_with_HPLC_and_QAT)[]
  Particulate_with_HPLC_and_QAT_no_header <- rbind(Particulate_with_HPLC_and_QAT_empty_row, Particulate_with_HPLC_and_QAT)
  
  Detritus_with_HPLC_and_QAT_empty_row <- data.frame(matrix(ncol = ncol(Detritus_with_HPLC_and_QAT), nrow = 1)) 
  names(Detritus_with_HPLC_and_QAT_empty_row)[] <- names(Detritus_with_HPLC_and_QAT)[]
  Detritus_with_HPLC_and_QAT_no_header <- rbind(Detritus_with_HPLC_and_QAT_empty_row, Detritus_with_HPLC_and_QAT)
  
  
  
  #move depth, ID, etc column names on the same line as wavelenghts values
  Phytoplankton_with_HPLC_and_QAT_no_header[3, 1:8] <- Phytoplankton_with_HPLC_and_QAT_no_header[2, 1:8]
  Phytoplankton_with_HPLC_and_QAT_no_header[2, 1:8] <- NA
  
  Particulate_with_HPLC_and_QAT_no_header[3, 1:8] <- Particulate_with_HPLC_and_QAT_no_header[2, 1:8]
  Particulate_with_HPLC_and_QAT_no_header[2, 1:8] <- NA
  
  Detritus_with_HPLC_and_QAT_no_header[3, 1:8] <- Detritus_with_HPLC_and_QAT_no_header[2, 1:8]
  Detritus_with_HPLC_and_QAT_no_header[2, 1:8] <- NA
  
  
########################
  
  #write Phytoplankton final table with HPLC and QAT with ODF header
  #in C:\R_WD\WRITE\WORKS4\RESULTS
  
  ODF_header_file <- read.csv(all_tables_with_csv$all_ODF_csv_files[i], skip = 0, sep = ",", header = FALSE)#i
  ODF_header_file <- ODF_header_file[,1]
  
  # filepath_to_write_final_tables <- paste0(all_tables_with_csv$distinct_folders_in_search_result_for_project_table[i], "/")#i
  # string <- filepath_to_write_final_tables            
  # pattern <- "C:/R_WD/WRITE/WORKS2/RESULTS/Abs_tables_all_3"
  # replacement <- "C:/R_WD/WRITE/WORKS4/RESULTS/Absorbance_3tables_with_metadata"
  # filepath_to_write_final_tables <- str_replace(string, pattern, replacement)
  
  
  filepath_to_write_final_tables <- paste0("C:/R_WD/WRITE/WORKS4/RESULTS/Absorbance_3tables_with_metadata/", all_tables_with_csv$folder_name[i], "/")
  
  
  dir.create(file.path(filepath_to_write_final_tables), showWarnings = FALSE, recursive = TRUE)
  
  #write Phytoplankton final table file with metadata
  write.table(ODF_header_file, file = paste0(filepath_to_write_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorbance_Phytoplankton.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)#i
  write.table(Phytoplankton_with_HPLC_and_QAT_no_header,  file = paste0(filepath_to_write_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorbance_Phytoplankton.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, na = "", append = TRUE)#i

  #write Particulate final table file with metadata
  write.table(ODF_header_file, file = paste0(filepath_to_write_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorbance_Particulate.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)#i
  write.table(Particulate_with_HPLC_and_QAT_no_header,  file = paste0(filepath_to_write_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorbance_Particulate.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, na = "", append = TRUE)#i

  #write Detritus final table file with metadata
  write.table(ODF_header_file, file = paste0(filepath_to_write_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorbance_Detritus.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)#i
  write.table(Detritus_with_HPLC_and_QAT_no_header,  file = paste0(filepath_to_write_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorbance_Detritus.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, na = "", append = TRUE)#i

  ################
  
  #convert Absorbance to Absorption
  
  #disable scientific notation in R.
  options(scipen = 999)
  
  
  #####################
  # i 4 to nrow
  # j 9 to ncol
  
  #####################
  
  #for Particulate
  Particulate_with_HPLC_and_QAT_no_header2 <- Particulate_with_HPLC_and_QAT_no_header
  
  for (i2 in 4:nrow(Particulate_with_HPLC_and_QAT_no_header2)){  
    
    volume = as.numeric(Particulate_with_HPLC_and_QAT_no_header2[i2,2])
    
    for (j2 in 9:ncol(Particulate_with_HPLC_and_QAT_no_header2)){   
      
      absorbance = as.numeric(Particulate_with_HPLC_and_QAT_no_header2[i2,j2])
      
      #filter_diameter = 16.5
      
      #if1
      #if (!is.na(volume)){   
      if (!is.na(volume) && Particulate_with_HPLC_and_QAT_no_header2[i2,j2] != -999){     
        
        vol = volume / 1000 # in m3
        fdia = filter_diameter/1000 # in m
        farea = pi* (fdia/2)^2 # in m2
        
        ods = 0.679 * absorbance^1.2804
        
        absorption = log(10) * ods * farea/vol
        
        Particulate_with_HPLC_and_QAT_no_header2[i2,j2] = absorption
        
        #end if1
      }else{
        
        Particulate_with_HPLC_and_QAT_no_header2[i2,j2] = -999
        
      }
      
      #if2
      if (is.na(Particulate_with_HPLC_and_QAT_no_header2[i2,j2])){
      
        Particulate_with_HPLC_and_QAT_no_header2[i2,j2] = 0  
      
      #end if2  
      }
      
      
      
      #end j2
    }
    
    
    #end i2
  }
  
  #Particulate_with_HPLC_and_QAT_no_header2[3,8] <- "Particulate.Absorption"
  #Particulate_with_HPLC_and_QAT_no_header2[3,8] <- ""
  
  
  #create filepath to write for Absorption final tables in "C:/R_WD/WRITE/WORKS5/RESULTS/Absorption_3tables_with_metadata/Particulate_Absorption/"
  # filepath_to_write_Absorption_final_tables <- filepath_to_write_final_tables
  # 
  # string <- filepath_to_write_Absorption_final_tables            
  # pattern <-     "C:/R_WD/WRITE/WORKS4/RESULTS/Absorbance_3tables_with_metadata/Particulate_Absorbance"
  # replacement <- "C:/R_WD/WRITE/WORKS5/RESULTS/Absorption_3tables_with_metadata/Particulate_Absorption"
  # filepath_to_write_Absorption_final_tables <- str_replace(string, pattern, replacement)

  
  
  filepath_to_write_Absorption_final_tables <- paste0("C:/R_WD/WRITE/WORKS5/RESULTS/Absorption_3tables_with_metadata/", all_tables_with_csv$folder_name[i], "/")
  
  
  #ODF_header_file2 <- ODF_header_file
  ODF_header_file_Particulate_1st_row <- "Absorption_Particulate"
  ODF_header_file_last_rows_added <- c("PI = 'Emmanuel Devred'", 
                                       "Reference to method of absorption calculation = 'Stramski D.; R.A. Reynolds; S. Kaczmarek; J. Uitz and G. Zheng; 2015: Correction of pathlength amplification in the filter-pad technique for measurements of particulate absorption coefficient in the visible spectral region. Appl. Opt. 54: 6763?6782.'", 
                                       paste0('"Diameter (mm) = "', filter_diameter),
                                       " Comments: Technical report in progress")
  
  ODF_header_file_Particulate <- append(ODF_header_file_Particulate_1st_row, ODF_header_file)
  ODF_header_file_Particulate <- append(ODF_header_file_Particulate, ODF_header_file_last_rows_added)
  
    
  dir.create(file.path(filepath_to_write_Absorption_final_tables), showWarnings = FALSE, recursive = TRUE)
  
  #write Particulate final table file with metadata
  write.table(ODF_header_file_Particulate, file = paste0(filepath_to_write_Absorption_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorption_Particulate.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)#i
  write.table(Particulate_with_HPLC_and_QAT_no_header2,  file = paste0(filepath_to_write_Absorption_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorption_Particulate.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, na = "", append = TRUE)#i
  
  
  
  #####################
  
  
  #for Detritus
  Detritus_with_HPLC_and_QAT_no_header2 <- Detritus_with_HPLC_and_QAT_no_header
  
  for (i2 in 4:nrow(Detritus_with_HPLC_and_QAT_no_header2)){  
    
    volume = as.numeric(Detritus_with_HPLC_and_QAT_no_header2[i2,2])
    
    for (j2 in 9:ncol(Detritus_with_HPLC_and_QAT_no_header2)){   
      
      absorbance = as.numeric(Detritus_with_HPLC_and_QAT_no_header2[i2,j2])
      
      #filter_diameter = 16.5
      
      #if1
      #if (!is.na(volume)){   
      if (!is.na(volume) && Detritus_with_HPLC_and_QAT_no_header2[i2,j2] != -999){     
        
        vol = volume / 1000 # in m3
        fdia = filter_diameter/1000 # in m
        farea = pi* (fdia/2)^2 # in m2
        
        ods = 0.679 * absorbance^1.2804
        
        absorption = log(10) * ods * farea/vol
        
        Detritus_with_HPLC_and_QAT_no_header2[i2,j2] = absorption
        
        #end if1
      }else{
        
        Detritus_with_HPLC_and_QAT_no_header2[i2,j2] = -999
        
      }
      
      #if2
      if (is.na(Detritus_with_HPLC_and_QAT_no_header2[i2,j2])){
        
        Detritus_with_HPLC_and_QAT_no_header2[i2,j2] = 0  
      
      #end if2    
      }
      
      
      
      #end j2
    }
    
    
    #end i2
  }
  
  #Detritus_with_HPLC_and_QAT_no_header2[3,8] <- "Detritus.Absorption"
  #Detritus_with_HPLC_and_QAT_no_header2[3,8] <- ""
  
  
  
  #ODF_header_file2 <- ODF_header_file
  ODF_header_file_Detritus_1st_row <- "Absorption_Detritus"
  # ODF_header_file_last_rows_added <- c("PI = 'Emmanuel Devred'", 
  #                                      "Reference to method of calculation = 'Stramski, D., R.A. Reynolds, S. Kaczmarek, J. Uitz, and G. Zheng, 2015: Correction of pathlength amplification in the filter-pad technique for measurements of particulate absorption coefficient in the visible spectral region. Appl. Opt., 54: 6763?6782.'", 
  #                                      "Diameter (mm) = 16.5", 
  #                                      "Comments:")
  
  ODF_header_file_Detritus <- append(ODF_header_file_Detritus_1st_row, ODF_header_file)
  ODF_header_file_Detritus <- append(ODF_header_file_Detritus, ODF_header_file_last_rows_added)
  
  
  #write Detritus final table file with metadata
  write.table(ODF_header_file_Detritus, file = paste0(filepath_to_write_Absorption_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorption_Detritus.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)#i
  write.table(Detritus_with_HPLC_and_QAT_no_header2,  file = paste0(filepath_to_write_Absorption_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorption_Detritus.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, na = "", append = TRUE)#i
  
  
  #####################
  
  #for Phytoplankton Absorption subtracting Detritus to Particulate
  
  Phytoplankton_with_HPLC_and_QAT_no_header2 <- Phytoplankton_with_HPLC_and_QAT_no_header
  
  
  
  for (i2 in 4:nrow(Phytoplankton_with_HPLC_and_QAT_no_header2)){  
    
    
    for (j2 in 9:ncol(Phytoplankton_with_HPLC_and_QAT_no_header2)){   
      
      #if1
      if (Particulate_with_HPLC_and_QAT_no_header2[i2,j2] != -999 && Detritus_with_HPLC_and_QAT_no_header2[i2,j2] != -999){  
        
       
        Phytoplankton_with_HPLC_and_QAT_no_header2[i2,j2] <-  as.numeric(Particulate_with_HPLC_and_QAT_no_header2[i2,j2]) - as.numeric(Detritus_with_HPLC_and_QAT_no_header2[i2,j2])
        
        #end if1
      }else{
        
        Phytoplankton_with_HPLC_and_QAT_no_header2[i2,j2] <- -999  
        
      }
      
      # #if2
      # if (Phytoplankton_with_HPLC_and_QAT_no_header2[i2,j2] < 0 && Phytoplankton_with_HPLC_and_QAT_no_header2[i2,j2] > -999){
      #   
      #   #print(paste0("Phytoplankton negative value found = ", Phytoplankton_with_HPLC_and_QAT_no_header2[i2,j2]))
      #   
      #   Phytoplankton_with_HPLC_and_QAT_no_header2[i2,j2] <- 0  
      #   
      # #end if2  
      # }
      
      
      
      
      #end j2
    }
    
    
    #end i2
  }
  
  #Phytoplankton_with_HPLC_and_QAT_no_header2[3,8] <- "Phytoplankton.Absorption"
  #Phytoplankton_with_HPLC_and_QAT_no_header2[3,8] <- ""
  
  
  #ODF_header_file2 <- ODF_header_file
  ODF_header_file_Phytoplankton_1st_row <- "Absorption_Phytoplankton"
  # ODF_header_file_last_rows_added <- c("PI = 'Emmanuel Devred'", 
  #                                      "Reference to method of calculation = 'Stramski, D., R.A. Reynolds, S. Kaczmarek, J. Uitz, and G. Zheng, 2015: Correction of pathlength amplification in the filter-pad technique for measurements of particulate absorption coefficient in the visible spectral region. Appl. Opt., 54: 6763?6782.'", 
  #                                      "Diameter (mm) = 16.5", 
  #                                      "Comments:")
  
  ODF_header_file_Phytoplankton <- append(ODF_header_file_Phytoplankton_1st_row, ODF_header_file)
  ODF_header_file_Phytoplankton <- append(ODF_header_file_Phytoplankton, ODF_header_file_last_rows_added)
  
  
  #write Phytoplankton final table file with metadata
  write.table(ODF_header_file_Phytoplankton, file = paste0(filepath_to_write_Absorption_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorption_Phytoplankton.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)#i
  write.table(Phytoplankton_with_HPLC_and_QAT_no_header2,  file = paste0(filepath_to_write_Absorption_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorption_Phytoplankton.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, na = "", append = TRUE)#i
  

  
  ################
    
  #write Phytoplankton, Particulate and Detritus Absorbance samples ID not found in HPLC and QAT 
  nrows_HPLC_samples_not_found <- nrow(HPLC_samples_not_found)-1
  write.csv(HPLC_samples_not_found, paste0(filepath_to_write_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorbance_samples_ID_not_found_in_HPLC_", nrows_HPLC_samples_not_found, "_rows.csv"), row.names = FALSE)#i
  write.csv(HPLC_samples_not_found, paste0(filepath_to_write_Absorption_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorbance_samples_ID_not_found_in_HPLC_", nrows_HPLC_samples_not_found, "_rows.csv"), row.names = FALSE)#i
  
  
  if (nrow(HPLC_samples_not_found)-1 > 0){
    
    dir.create(file.path("C:/R_WD/WRITE/WORKS4/ALL_samples_ID_not_found_in_HPLC_and_QAT"), showWarnings = FALSE, recursive = TRUE)
    write.csv(HPLC_samples_not_found, paste0("C:/R_WD/WRITE/WORKS4/ALL_samples_ID_not_found_in_HPLC_and_QAT/", all_tables_with_csv$coded_cruise_name[i], "_Absorbance_samples_ID_not_found_in_HPLC_", nrows_HPLC_samples_not_found, "_rows.csv"), row.names = FALSE)#i
    
    dir.create(file.path("C:/R_WD/WRITE/WORKS5/ALL_samples_ID_not_found_in_HPLC_and_QAT"), showWarnings = FALSE, recursive = TRUE)
    write.csv(HPLC_samples_not_found, paste0("C:/R_WD/WRITE/WORKS5/ALL_samples_ID_not_found_in_HPLC_and_QAT/", all_tables_with_csv$coded_cruise_name[i], "_Absorbance_samples_ID_not_found_in_HPLC_", nrows_HPLC_samples_not_found, "_rows.csv"), row.names = FALSE)#i
    
    
  }
  
  
  
  nrows_QAT_samples_not_found <- nrow(QAT_samples_not_found)-1
  write.csv(QAT_samples_not_found, paste0(filepath_to_write_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorbance_samples_ID_not_found_in_QAT_", nrows_QAT_samples_not_found, "_rows.csv"), row.names = FALSE)#i
  write.csv(QAT_samples_not_found, paste0(filepath_to_write_Absorption_final_tables, all_tables_with_csv$coded_cruise_name[i], "_Absorbance_samples_ID_not_found_in_QAT_", nrows_QAT_samples_not_found, "_rows.csv"), row.names = FALSE)#i
  
  
  if (nrow(QAT_samples_not_found)-1 > 0){
    
    dir.create(file.path("C:/R_WD/WRITE/WORKS4/ALL_samples_ID_not_found_in_HPLC_and_QAT"), showWarnings = FALSE, recursive = TRUE)
    write.csv(QAT_samples_not_found, paste0("C:/R_WD/WRITE/WORKS4/ALL_samples_ID_not_found_in_HPLC_and_QAT/", all_tables_with_csv$coded_cruise_name[i], "_Absorbance_samples_ID_not_found_in_QAT_", nrows_QAT_samples_not_found, "_rows.csv"), row.names = FALSE)#i
    
    dir.create(file.path("C:/R_WD/WRITE/WORKS5/ALL_samples_ID_not_found_in_HPLC_and_QAT"), showWarnings = FALSE, recursive = TRUE)
    write.csv(QAT_samples_not_found, paste0("C:/R_WD/WRITE/WORKS5/ALL_samples_ID_not_found_in_HPLC_and_QAT/", all_tables_with_csv$coded_cruise_name[i], "_Absorbance_samples_ID_not_found_in_QAT_", nrows_QAT_samples_not_found, "_rows.csv"), row.names = FALSE)#i
    
    
  }
    
#end i  
}







#####################

end_time <- Sys.time()
start_time
end_time






