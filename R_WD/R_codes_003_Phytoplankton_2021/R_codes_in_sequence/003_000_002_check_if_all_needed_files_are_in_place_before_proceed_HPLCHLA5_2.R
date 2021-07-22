#check_if_all_needed_files_are_in_place_before_proceed

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021


start_time <- Sys.time()
print(paste0("start_time = ", start_time))



setwd("C:/R_WD")
getwd()


# #install.packages("reader")
# 
library("reader")
library("dplyr")
library("tidyr")
library("stringr")
library("R.utils")
library("readxl")
library("fs")
library("qdapRegex")
library("tcltk2")

############

#create the folder where the 002 code below writes reports
dir.create(file.path("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/"), showWarnings = FALSE, recursive = TRUE)


#check filter diameter value

if (exists("filter_diameter") == FALSE){
  
  print(paste0("ERROR: The filter_diameter is not defined. Please check"))
  stop()
  
}else{
  
  print(paste0("The filter_diameter = ", filter_diameter, "mm; is this okay?"))
  
}





############
#check if there are at least one particulate and one detritus txt files in the cruise folder selected for processing

#search_by_file_extension_txt

file_list_txt_d6 <- list.files(pattern = "\\d{6}.txt$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
file_list_txt_d6_df <- data.frame(file_list_txt_d6)
file_list_txt_d6_df$dirname <- dirname(file_list_txt_d6_df[,1])
file_list_txt_d6_df$filename_ext_d6 <- sub('.*/', '', file_list_txt_d6_df$file_list_txt_d6)
file_list_txt_d6_df$filename_d6 <- sub('\\.txt$', '', file_list_txt_d6_df$filename_ext_d6)
file_list_txt_d6_df$file <- file_list_txt_d6_df$filename_d6
file_list_txt_d6_df$folder_name <- sub('\\..*$', '', basename(dirname(file_list_txt_d6_df[,1])))

nrows_file_list_txt_d6_df <- nrow(file_list_txt_d6_df)
write.csv(file_list_txt_d6_df, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", coded_cruise_name_entered, "_Absorbance_Particulate_file_list_txt_d6_df_", nrows_file_list_txt_d6_df, "_rows.csv"), row.names = FALSE)


file_list_txt_d6p <- list.files(pattern = "\\d{6}p.txt$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
file_list_txt_d6p_df <- data.frame(file_list_txt_d6p)
file_list_txt_d6p_df$dirname <- dirname(file_list_txt_d6p_df[,1])
file_list_txt_d6p_df$filename_ext_d6p <- sub('.*/', '', file_list_txt_d6p_df$file_list_txt_d6p)
file_list_txt_d6p_df$filename_d6p <- sub('\\.txt$', '', file_list_txt_d6p_df$filename_ext_d6p)
file_list_txt_d6p_df$filename_d6p_no_p <- sub('p', '', file_list_txt_d6p_df$filename_d6p)
file_list_txt_d6p_df$file <- file_list_txt_d6p_df$filename_d6p_no_p
file_list_txt_d6p_df$folder_name <- sub('\\..*$', '', basename(dirname(file_list_txt_d6p_df[,1])))

nrows_file_list_txt_d6p_df <- nrow(file_list_txt_d6p_df)
write.csv(file_list_txt_d6p_df, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", coded_cruise_name_entered, "_Absorbance_Detritus_file_list_txt_d6p_df_", nrows_file_list_txt_d6p_df, "_rows.csv"), row.names = FALSE)



file_list_txt_d6rS <- list.files(pattern = "\\d{6}r\\S*.txt$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
file_list_txt_d6rS_list <- paste(basename(file_list_txt_d6rS), collapse = " ")

file_list_txt_d6_and_d6p <- append(file_list_txt_d6, file_list_txt_d6p)
nrows_file_list_txt_d6_and_d6p <- length(file_list_txt_d6_and_d6p)
write.csv(file_list_txt_d6_and_d6p, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", coded_cruise_name_entered, "_Absorbance_Particulate_plus_Detritus_file_list_txt_d6_and_d6p_", nrows_file_list_txt_d6_and_d6p, "_rows.csv"), row.names = FALSE)


if (length(file_list_txt_d6_and_d6p) == 0){
  print(paste0("ERROR: There are no Absorbance Sample ID's Particulate = 123456.txt, Detritus = 123456p.txt in the cruise folder selected ", input_folder_to_read_files, " . The program cannot continue. Please select the 'OK' button to quit and close the R Session. The R Workspace WILL NOT be saved."))
  
  quit_R_Session_nodata <- paste0("ERROR: There are no Absorbance Sample ID's Particulate = 123456.txt, Detritus = 123456p.txt in the cruise folder selected ", input_folder_to_read_files, " . The program cannot continue. Please select the 'OK' button to quit and close the R Session. The R Workspace WILL NOT be saved.")
  
  msgBox_data <- tk_messageBox(type = c("ok"), quit_R_Session_nodata, caption = "Continue with closing the R Session?", default = "", icon = "error")
  msgBoxCharacter_data <- as.character(msgBox_data)
  
  if(msgBoxCharacter_data == "ok"){
    quit(save="no")
  }
}





if (length(file_list_txt_d6rS) > 0){
  
  print(paste0("WARNING: ", length(file_list_txt_d6rS), " raw Particulate txt files with the letter 'r' have been found in the folder '", input_folder_to_read_files, "' . The files are: ", file_list_txt_d6rS_list, " . The program will continue but these 'r' files will NOT be processed. To be processed remove the 'r' letter from the file name and ensure they are Absorbance data files misnamed. Continue with testing?"))
  
  nrows_file_list_txt_d6rS <- length(file_list_txt_d6rS)
  write.csv(file_list_txt_d6rS, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", coded_cruise_name_entered, "_files_with_r_in_filename_file_list_txt_d6rS_", nrows_file_list_txt_d6rS, "_rows.csv"), row.names = FALSE)
  
  
  continue_message1 <- paste0("WARNING: ", length(file_list_txt_d6rS), " raw Particulate txt files with the letter 'r' have been found in the folder '", input_folder_to_read_files, "' . The files are: ", file_list_txt_d6rS_list, " . The csv file 'cruise_name_files_with_r_in_filename_file_list_txt_d6rS.csv' has been written in 'C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/' for the record.  The program will continue but these 'r' files will NOT be processed. To be processed remove the 'r' letter from the file name and ensure they are Absorbance data files misnamed. Continue with testing?")
  
  msgBox <- tk_messageBox(type = c("ok"), continue_message1, caption = "Continue with testing? OK!", default = "", icon = "warning")


    
}  



if (length(file_list_txt_d6) < 1){
  
  print(paste0("ERROR: There are no particulate files '123456.txt' in the cruise folder selected ", input_folder_to_read_files))
  stop()
  
}else{
  
  print(paste0("There are ", length(file_list_txt_d6), " particulate files '123456.txt' in the cruise folder selected ", input_folder_to_read_files))
  
}




if (length(file_list_txt_d6p) < 1){
  
  print(paste0("ERROR: There are no detritus files '123456p.txt' in the cruise folder selected ", input_folder_to_read_files))
  stop()
  
}else{
  
  print(paste0("There are ", length(file_list_txt_d6p), " detritus files '123456p.txt' in the cruise folder selected ", input_folder_to_read_files))
  
}




############
#check if folder_name_to_coded_cruise_name_table.csv exists



cruise_name_table_location <- "C:/R_WD/folder_name_to_coded_cruise_name_table.csv"

if (file.exists(cruise_name_table_location) == FALSE){
  
print(paste0("The file ", cruise_name_table_location, " does not exists. The program cannot continue"))
stop()
  
}else{

cruise_name_table <- read.table(cruise_name_table_location, skip = 0, sep = ",", header = TRUE)
cruise_name_table_df <- data.frame(cruise_name_table)

}



#if nrow_cruise_name_table < 1
if (nrow(cruise_name_table_df) < 1){
  
  print(paste0("ERROR: The file ", cruise_name_table_location, " is empty. It must contain: "))
  
  print(paste0("header: on line 1 column A(1) = folder_name, on line 1 column B(2) = coded_cruise_name"))
  
  print(paste0("data: on line 2 column A(1) = the exact cruise folder name that have been selected to be processed, on line 2 column B(2) = the coded_cruise_name known as cruise name for the selected cruise folder to be processed"))

  stop()
    
  # end if nrow_cruise_name_table < 1  
}else if (nrow(cruise_name_table_df) == 1){
  




if (colnames(cruise_name_table_df)[1] != ("folder_name")){
  
  print(paste0("ERROR: The file ", cruise_name_table_location, " does not have the first column name = folder_name but ", colnames(cruise_name_table_df)[1]))
  
  stop()
}


if (colnames(cruise_name_table_df)[2] != ("coded_cruise_name")){
  
  print(paste0("ERROR: The file ", cruise_name_table_location, " does not have the second column name = coded_cruise_name but ", colnames(cruise_name_table_df)[2]))
  
  stop()
}




if (basename(input_folder_to_read_files) != cruise_name_table_df$folder_name[1]){
  
  print(paste0("ERROR: The file ", cruise_name_table_location, " does not have on line 2 column A(1) the cruise folder_name that have been selected to be processed = ", basename(input_folder_to_read_files), " , but ", cruise_name_table_df$folder_name[1]))
  
  stop()
  
}else{
  
  print(paste0("The file ", cruise_name_table_location, " it does have on line 2 column A(1) the cruise folder_name that have been selected to be processed = ", basename(input_folder_to_read_files)))
  
  print(paste0("For instance, the file ", cruise_name_table_location, " must have on line 2 column B(2) the cruise name (coded_cruise_name) that have been selected to be processed = ", basename(input_folder_to_read_files)))
  
  print(paste0("An example: for 'folder_name = AMU2019-001 Lab sea' the 'coded_cruise_name = AMU2019001'"))
  
  print(paste0("In the file ", cruise_name_table_location, " for the selected folder_name to be processed = ", basename(input_folder_to_read_files), " the coded_cruise_name = ", cruise_name_table_df$coded_cruise_name[1]))
  
  print(paste0("Please check if the above is the right cruise name assigned to the folder that have been selected to be processed"))
  
  }



  
# end else if  for if nrow_cruise_name_table == 1    
}else if (nrow(cruise_name_table_df) > 1){
  
  print(paste0("ERROR: There are more than one cruise defined in ", cruise_name_table_location, " . Please keep only the one selected for processing"))
  
  stop()
}







############
#check if Metadata_per_cruise exists

input_metadata_folder_name <- "C:/R_WD/Metadata_per_cruise"


if (dir.exists(paste0(input_metadata_folder_name, "/", basename(input_folder_to_read_files))) == FALSE){
  
  print(paste0("ERROR: The 'Metadata_per_cruise' folder ", input_metadata_folder_name, "/", basename(input_folder_to_read_files), " with the cruise folder name containing the HPLC, QAT and ODF files does not exists"))
  
  print(paste0("Please create 'C:/R_WD/Metadata_per_cruise/YOUR_CRUISE_NAME_FOLDER/' and place 1 HPLC, 1 QAT and 1 ODF files within"))
  
  print(paste0("Example: 'C:/R_WD/Metadata_per_cruise/AMU2019-001 Lab sea/"))
  
  
  print(paste0("For BEDFORD BASIN - QAT and ODF files the link is: 'S:/SRC/BBMP/COMPASS'"))
  print(paste0("For BEDFORD BASIN - HPLC files the link is: 'S:/SRC/BBMP/RAW SOURCE DATA'"))
  print(paste0("For most HPLC, QAT and ODF files the link is: 'S:/SRC'"))
  print(paste0("For ctd ODF files the link is: 'S:/ARC/Archive/ctd'"))
  
  print(paste0("All forward slash '/' must be changed to backslash if the link it is pasted into Windows Explorer"))

  stop()
  
#end if (dir.exists(input_metadata_folder_name) == FALSE){  
}else{

  
#only xlsx or xls, not csv  
all_HPLC_xlsx_files<- list.files(pattern = "\\HPLC*.*xls*"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)

#xlsx, xls or csv
all_QAT_xlsx_files<- list.files(pattern = "\\_QAT*.*"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)

#only .ODF
all_ODF_files<- list.files(pattern = "\\^*.ODF$"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)


  
if (length(all_HPLC_xlsx_files) < 1){
  
  print(paste0("ERROR: There is no HPLC file in folder ", input_metadata_folder_name, "/", basename(input_folder_to_read_files), "/"))
  
  stop()
  
}else if (length(all_HPLC_xlsx_files) == 1){
  
  print(paste0("The HPLC file is ", all_HPLC_xlsx_files))
  
}else if (length(all_HPLC_xlsx_files) > 1){
  
  print(paste0("ERROR: There are more than 1 HPLC files in ", input_metadata_folder_name, "/", basename(input_folder_to_read_files), "/"))
  
  print(paste0("Please keep just one from the ones listed below: "))
  
  print(paste0(all_HPLC_xlsx_files))
  
  stop()
  
}
  
  
  
  
if (length(all_QAT_xlsx_files) < 1){
  
  print(paste0("There is no QAT file in folder ", input_metadata_folder_name, "/", basename(input_folder_to_read_files), "/"))
  
  stop()
  
}else if (length(all_QAT_xlsx_files) == 1){
  
  print(paste0("The QAT file is ", all_QAT_xlsx_files))
  
}else if (length(all_QAT_xlsx_files) > 1){
  
  print(paste0("ERROR: There are more than 1 QAT files in ", input_metadata_folder_name, "/", basename(input_folder_to_read_files), "/"))
  
  print(paste0("Please keep just one from the ones listed below: "))
  
  print(paste0(all_QAT_xlsx_files))
  
  stop()
  
}

  
if (length(all_ODF_files) < 1){
  
  print(paste0("ERROR: There is no ODF file in folder ", input_metadata_folder_name, "/", basename(input_folder_to_read_files), "/"))
  
  stop()
  
}else if (length(all_ODF_files) == 1){
  
  print(paste0("The ODF file is ", all_ODF_files))
  
}else if (length(all_ODF_files) > 1){
  
  print(paste0("ERROR: There are more than 1 ODF files in ", input_metadata_folder_name, "/", basename(input_folder_to_read_files), "/"))
  
  print(paste0("Please keep just one from the ones listed below: "))
  
  print(paste0(all_ODF_files))
  
  stop()
  
}

###end else if dir exist metadata per folder
###}

all_tables_joined_by_folder_name <- data.frame(all_HPLC_xlsx_files, all_QAT_xlsx_files, all_ODF_files)

all_tables_joined_by_folder_name$HPLC_file_name <- basename(all_HPLC_xlsx_files)
all_tables_joined_by_folder_name$QAT_file_name <- basename(all_QAT_xlsx_files)
all_tables_joined_by_folder_name$ODF_file_name <- basename(all_ODF_files)
all_tables_joined_by_folder_name$folder_name <- basename(input_folder_to_read_files)

all_tables_joined_by_folder_name2 <- inner_join(all_tables_joined_by_folder_name, cruise_name_table_df, by = c("folder_name"))



all_tables_joined_by_folder_name$coded_cruise_name <- all_tables_joined_by_folder_name2$coded_cruise_name


if (nrow(all_tables_joined_by_folder_name) != 1){
  
  print(paste0("ERROR: In the folder ", input_metadata_folder_name, "/", basename(input_folder_to_read_files), " must be 1 HPLC, 1 _QAT and 1 .ODF file."))
  
  print(paste0("The file that are in the folder are listed below: "))
  
  print(paste0(all_tables_joined_by_folder_name$all_HPLC_xlsx_files))
  print(paste0(all_tables_joined_by_folder_name$all_QAT_xlsx_files))
  print(paste0(all_tables_joined_by_folder_name$all_ODF_files))
  
  stop()
  
  
}else{



#######START writing the needed HPLC csv

#HPLC data

HPLC_file <- data.frame()
HPLC_file2 <- data.frame()
HPLC_column_names_ERROR <- data.frame()

for(i in 1:nrow(all_tables_joined_by_folder_name)){
  
  #i <- 2
  #i <- 9
  
  #write all HPLC xlsx files as csv in "C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/"
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
    
    
    #less than 27 cols or != 27? for all HPLC extensions
    
    colnames_HPLC_file2 <- colnames(HPLC_file2)
    
    if (length(colnames_HPLC_file2) != 27){
      
      print(paste0("ERROR: The HPLC file selected ", basename(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i]), " must have 27 columns with names assigned but it has ", length(colnames_HPLC_file2), ". The HPLC file must have exactly 27 columns and the columns 1(A),2(B),19(S),27(AA) must be named 'ID', 'DEPTH', 'HPLCHLA', 'ABS. VOL(L)'. The other columns can have any name or an empty cell instead of a name. The program cannot continue. Please fix the HPLC file columns and run the R scripts again."))
      
      quit_R_Session_message_HPLC1 <- paste0("ERROR: The HPLC file selected ", basename(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i]), " must have 27 columns with names assigned but it has ", length(colnames_HPLC_file2), ". The HPLC file must have exactly 27 columns and the columns 1(A),2(B),19(S),27(AA) must be named 'ID', 'DEPTH', 'HPLCHLA', 'ABS. VOL(L)'. The other columns can have any name or an empty cell instead of a name. The program cannot continue. Please fix the HPLC file columns and run the R scripts again. The R Session will exit without saving the workspace.")
      
      msgBox <- tk_messageBox(type = c("ok"), quit_R_Session_message_HPLC1, caption = "Continue with closing the R Session?", default = "", icon = "error")
      msgBoxCharacter <- as.character(msgBox)
      
      if(msgBoxCharacter == "ok"){
        quit(save="no")
      }
      
    }
    
    
    
    
    
    HPLC_file2 <- subset(HPLC_file2, select=c(
      1,2,19,27
    ))
    
    colnames_HPLC <- colnames(HPLC_file2)
    defined_HPLC_column_names <- c("ID", "DEPTH", "HPLCHLA", "ABS. VOL(L)")
    
    #change HPLC first column name if it is "SAMPLEID" in "ID"
    if (colnames_HPLC[1]=="SAMPLEID"){
      names(HPLC_file2)[1] <- "ID"}
    
    
    
    
    colnames_HPLC_list <- paste(colnames_HPLC, collapse = "', '")
    
    if (colnames_HPLC[1] != defined_HPLC_column_names[1] | colnames_HPLC[2] != defined_HPLC_column_names[2] | colnames_HPLC[3] != defined_HPLC_column_names[3] | colnames_HPLC[4] != defined_HPLC_column_names[4]){
      
      #rewrite error for column names error
      print(paste0("ERROR: The HPLC file selected ", basename(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i]), " does not have the defined column names for at least one of the 4 needed columns from 27. The needed columns 1(A),2(B),19(S),27(AA) must be named 'ID', 'DEPTH', 'HPLCHLA', 'ABS. VOL(L)' but their names are '", colnames_HPLC_list, "'. The csv file 'HPLC_column_names_error_table.csv' has been written in 'C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/' for a better visualization. The program cannot continue. Please fix the HPLC file column names and run the R script again."))
      
      
      HPLC_column_names_error_table1 <- data.frame("NumCol", "1", "2", "3", "4")
      names(HPLC_column_names_error_table1) <- c("0", "1", "2", "3", "4")
      
      HPLC_column_names_error_table2 <- data.frame("ColNum", "1(A)", "2(B)", "19(S)", "27(AA)")
      names(HPLC_column_names_error_table2) <- c("0", "1", "2", "3", "4")
      
      HPLC_column_names_error_table3 <- data.frame("ColNameDefined", "ID", "DEPTH", "HPLCHLA", "ABS. VOL(L)")
      names(HPLC_column_names_error_table3) <- c("0", "1", "2", "3", "4")
      
      HPLC_column_names_error_table4 <- data.frame(t(append("HPLC_ColName", colnames_HPLC)))
      names(HPLC_column_names_error_table4) <- c("0", "1", "2", "3", "4")
      
      
      HPLC_column_names_error_table <- rbind(HPLC_column_names_error_table1, HPLC_column_names_error_table2)
      HPLC_column_names_error_table <- rbind(HPLC_column_names_error_table, HPLC_column_names_error_table3)
      HPLC_column_names_error_table <- rbind(HPLC_column_names_error_table, HPLC_column_names_error_table4)
      
      write.csv(HPLC_column_names_error_table, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", "HPLC_column_names_error_table_for_file_", basename(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i]), "_.csv"), row.names = FALSE)
      
      
      quit_R_Session_message_HPLC2 <- paste0("ERROR: The HPLC file selected ", basename(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i]), " does not have the defined column names for at least one of the 4 needed columns from 27. The needed columns 1(A),2(B),19(S),27(AA) must be named 'ID', 'DEPTH', 'HPLCHLA', 'ABS. VOL(L)' but their names are '", colnames_HPLC_list, "'. The csv file 'HPLC_column_names_error_table.csv' has been written in 'C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/' for a better visualization. The program cannot continue. Please fix the HPLC file column names and run the R scripts again. The R Session will exit without saving the workspace.")
      
      msgBox <- tk_messageBox(type = c("ok"), quit_R_Session_message_HPLC2, caption = "Continue with closing the R Session?", default = "", icon = "error")
      msgBoxCharacter <- as.character(msgBox)
      
      if(msgBoxCharacter == "ok"){
        quit(save="no")
      }
      
    }
    
      
     

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
          
          write.table(HPLC_file_for_print, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", "HPLC_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
          write.table(HPLC_column_names_ERROR, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", "HPLC_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
          
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
    
    dir.create(file.path(paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
    write.table(HPLC_file2, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/", HPLC_filename_for_CSV, ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = T)
    
    # file_written <- list.files(pattern = "\\HPLC-final_JB.csv$", path = paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    # file_written <- list.files(pattern = "\\HPLC*.csv$", path = paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    file_written <- list.files(pattern = "\\HPLC*", path = paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    
    
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
    
    #less than 27 cols or != 27? for all HPLC extensions
    
    colnames_HPLC_file2 <- colnames(HPLC_file2)
    
    if (length(colnames_HPLC_file2) != 27){
      
      print(paste0("ERROR: The HPLC file selected ", basename(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i]), " must have 27 columns with names assigned but it has ", length(colnames_HPLC_file2), ". The HPLC file must have exactly 27 columns and the columns 1(A),2(B),19(S),27(AA) must be named 'ID', 'DEPTH', 'HPLCHLA', 'ABS. VOL(L)'. The other columns can have any name or an empty cell instead of a name. The program cannot continue. Please fix the HPLC file columns and run the R scripts again."))
      
      quit_R_Session_message_HPLC1 <- paste0("ERROR: The HPLC file selected ", basename(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i]), " must have 27 columns with names assigned but it has ", length(colnames_HPLC_file2), ". The HPLC file must have exactly 27 columns and the columns 1(A),2(B),19(S),27(AA) must be named 'ID', 'DEPTH', 'HPLCHLA', 'ABS. VOL(L)'. The other columns can have any name or an empty cell instead of a name. The program cannot continue. Please fix the HPLC file columns and run the R scripts again. The R Session will exit without saving the workspace.")
      
      msgBox <- tk_messageBox(type = c("ok"), quit_R_Session_message_HPLC1, caption = "Continue with closing the R Session?", default = "", icon = "error")
      msgBoxCharacter <- as.character(msgBox)
      
      if(msgBoxCharacter == "ok"){
        quit(save="no")
      }
      
    }
    
    
    
    
    
    HPLC_file2 <- subset(HPLC_file2, select=c(
      1,2,19,27
    ))
    
    colnames_HPLC <- colnames(HPLC_file2)
    defined_HPLC_column_names <- c("ID", "DEPTH", "HPLCHLA", "ABS. VOL(L)")
    
    #change HPLC first column name if it is "SAMPLEID" in "ID"
    if (colnames_HPLC[1]=="SAMPLEID"){
      names(HPLC_file2)[1] <- "ID"}
    
    
    
    
    colnames_HPLC_list <- paste(colnames_HPLC, collapse = "', '")
    
    if (colnames_HPLC[1] != defined_HPLC_column_names[1] | colnames_HPLC[2] != defined_HPLC_column_names[2] | colnames_HPLC[3] != defined_HPLC_column_names[3] | colnames_HPLC[4] != defined_HPLC_column_names[4]){
      
      #rewrite error for column names error
      print(paste0("ERROR: The HPLC file selected ", basename(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i]), " does not have the defined column names for at least one of the 4 needed columns from 27. The needed columns 1(A),2(B),19(S),27(AA) must be named 'ID', 'DEPTH', 'HPLCHLA', 'ABS. VOL(L)' but their names are '", colnames_HPLC_list, "'. The csv file 'HPLC_column_names_error_table.csv' has been written in 'C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/' for a better visualization. The program cannot continue. Please fix the HPLC file column names and run the R script again."))
      
      
      HPLC_column_names_error_table1 <- data.frame("NumCol", "1", "2", "3", "4")
      names(HPLC_column_names_error_table1) <- c("0", "1", "2", "3", "4")
      
      HPLC_column_names_error_table2 <- data.frame("ColNum", "1(A)", "2(B)", "19(S)", "27(AA)")
      names(HPLC_column_names_error_table2) <- c("0", "1", "2", "3", "4")
      
      HPLC_column_names_error_table3 <- data.frame("ColNameDefined", "ID", "DEPTH", "HPLCHLA", "ABS. VOL(L)")
      names(HPLC_column_names_error_table3) <- c("0", "1", "2", "3", "4")
      
      HPLC_column_names_error_table4 <- data.frame(t(append("HPLC_ColName", colnames_HPLC)))
      names(HPLC_column_names_error_table4) <- c("0", "1", "2", "3", "4")
      
      
      HPLC_column_names_error_table <- rbind(HPLC_column_names_error_table1, HPLC_column_names_error_table2)
      HPLC_column_names_error_table <- rbind(HPLC_column_names_error_table, HPLC_column_names_error_table3)
      HPLC_column_names_error_table <- rbind(HPLC_column_names_error_table, HPLC_column_names_error_table4)
      
      write.csv(HPLC_column_names_error_table, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", "HPLC_column_names_error_table_for_file_", basename(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i]), "_.csv"), row.names = FALSE)
      
      
    
      quit_R_Session_message_HPLC2 <- paste0("ERROR: The HPLC file selected ", basename(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i]), " does not have the defined column names for at least one of the 4 needed columns from 27. The needed columns 1(A),2(B),19(S),27(AA) must be named 'ID', 'DEPTH', 'HPLCHLA', 'ABS. VOL(L)' but their names are '", colnames_HPLC_list, "'. The csv file 'HPLC_column_names_error_table.csv' has been written in 'C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/' for a better visualization. The program cannot continue. Please fix the HPLC file column names and run the R scripts again. The R Session will exit without saving the workspace.")
      
      msgBox <- tk_messageBox(type = c("ok"), quit_R_Session_message_HPLC2, caption = "Continue with closing the R Session?", default = "", icon = "error")
      msgBoxCharacter <- as.character(msgBox)
      
      if(msgBoxCharacter == "ok"){
        quit(save="no")
      }
      
    }
    
    
    
    
    
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
          
          write.table(HPLC_file_for_print, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", all_tables_joined_by_folder_name$coded_cruise_name[i] , "_HPLC_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
          write.table(HPLC_column_names_ERROR, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/" ,all_tables_joined_by_folder_name$coded_cruise_name[i] , "_HPLC_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
          
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
    
    dir.create(file.path(paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
    write.table(HPLC_file2, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/", HPLC_filename_for_CSV, ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = T)
    
    #file_written <- list.files(pattern = "\\HPLC*.csv$", path = paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    file_written <- list.files(pattern = "\\HPLC*.*csv", path = paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    
    
    
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
    
    
    #write all QAT xlsx files as csv in "C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/"
    QAT_filename_for_CSV <- all_tables_joined_by_folder_name$QAT_file_name[i]
    QAT_filename_for_CSV <- sub('\\..*$', '', basename(QAT_filename_for_CSV))
    
    dir.create(file.path(paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
    
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
    
    
    
    #less than 40 cols or != 40? for all QAT extensions
    
    colnames_QAT_file_ERR <- colnames(QAT_file)
    
    if (length(colnames_QAT_file_ERR) != 40){
      
      print(paste0("ERROR: The QAT file selected ", basename(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i]), " must have 40 columns with names assigned but it has ", length(colnames_QAT_file_ERR), ". The QAT file must have exactly 40 columns and the columns 1(A),2(B),3(C),4(D),5(E),7(F),8(G),16(P) must be named 'filename', 'cruise_number', 'station', 'eventLatitude', 'eventLongitude', 'trip_number', 'sample_id', 'date', 'PrDM'. There are many variations of the _QAT column names that the script can assign and process. These names were used in the last _QAT file and it should work. The other columns can have any name or an empty cell instead of a name. The program cannot continue. Please fix the _QAT file columns and run the R scripts again."))
      
      quit_R_Session_message_QAT1 <- paste0("ERROR: The QAT file selected ", basename(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i]), " must have 40 columns with names assigned but it has ", length(colnames_QAT_file_ERR), ". The QAT file must have exactly 40 columns and the columns 1(A),2(B),3(C),4(D),5(E),7(F),8(G),16(P) must be named 'filename', 'cruise_number', 'station', 'eventLatitude', 'eventLongitude', 'trip_number', 'sample_id', 'date', 'PrDM'. There are many variations of the _QAT column names that the script can assign and process. These names were used in the last _QAT file and it should work. The other columns can have any name or an empty cell instead of a name. The program cannot continue. Please fix the _QAT file columns and run the R scripts again.")
      
      msgBox <- tk_messageBox(type = c("ok"), quit_R_Session_message_QAT1, caption = "Continue with closing the R Session?", default = "", icon = "error")
      msgBoxCharacter <- as.character(msgBox)
      
      if(msgBoxCharacter == "ok"){
        quit(save="no")
      }
      
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
    
    
    colnames_QAT_list <- paste(colnames_QAT, collapse = "', '")
    
    if (colnames(QAT_file2)[1] != defined_QAT_column_names[1] | colnames(QAT_file2)[2] != defined_QAT_column_names[2] | colnames(QAT_file2)[3] != defined_QAT_column_names[3] | colnames(QAT_file2)[4] != defined_QAT_column_names[4] | colnames(QAT_file2)[5] != defined_QAT_column_names[5] | colnames(QAT_file2)[6] != defined_QAT_column_names[6] | colnames(QAT_file2)[7] != defined_QAT_column_names[7] | colnames(QAT_file2)[8] != defined_QAT_column_names[8]){
      
      #rewrite error for column names error
      print(paste0("ERROR: The _QAT file selected ", basename(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i]), " does not have the defined column names for at least one of the 8 needed columns from 40. The needed columns 1(A),2(B),3(C),4(D),5(E),7(F),8(G),16(P) must be named 'filename', 'cruise_number', 'station', 'eventLatitude', 'eventLongitude', 'sample_id', 'date', 'PrDM' but their names are '", colnames_QAT_list, "'. The csv file 'QAT_column_names_error_table.csv' has been written in 'C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/' for a better visualization. There are many variations of the _QAT column names that the script can assign and process. These names were used in the last _QAT file and it should work. The other columns can have any name or an empty cell instead of a name. The program cannot continue. Please fix the _QAT file column names and run the R scripts again."))
      
      QAT_column_names_error_table1 <- data.frame("NumCol", "1", "2", "3", "4", "5", "6", "7", "8")
      names(QAT_column_names_error_table1) <- c("0", "1", "2", "3", "4", "5", "6", "7", "8")
      
      QAT_column_names_error_table2 <- data.frame("ColNum", "1(A)", "2(B)", "3(C)", "4(D)" , "5(E)", "7(G)", "8(H)", "16(P)")
      names(QAT_column_names_error_table2) <- c("0", "1", "2", "3", "4", "5", "6", "7", "8")
      
      QAT_column_names_error_table3 <- data.frame("ColNameDefined", "filename", "cruise_number", "station", "eventLatitude", "eventLongitude", "sample_id", "date", "PrDM")
      names(QAT_column_names_error_table3) <- c("0", "1", "2", "3", "4", "5", "6", "7", "8")
      
      QAT_column_names_error_table4 <- data.frame(t(append("QAT_ColName", colnames_QAT)))
      names(QAT_column_names_error_table4) <- c("0", "1", "2", "3", "4", "5", "6", "7", "8")
      
      
      QAT_column_names_error_table <- rbind(QAT_column_names_error_table1, QAT_column_names_error_table2)
      QAT_column_names_error_table <- rbind(QAT_column_names_error_table, QAT_column_names_error_table3)
      QAT_column_names_error_table <- rbind(QAT_column_names_error_table, QAT_column_names_error_table4)
      
      write.csv(QAT_column_names_error_table, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", "QAT_column_names_error_table_for_file_", basename(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i]), "_.csv"), row.names = FALSE)
      
      
      quit_R_Session_message_QAT2 <- paste0("ERROR: The _QAT file selected ", basename(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i]), " does not have the defined column names for at least one of the 8 needed columns from 40. The needed columns 1(A),2(B),3(C),4(D),5(E),7(F),8(G),16(P) must be named 'filename', 'cruise_number', 'station', 'eventLatitude', 'eventLongitude', 'sample_id', 'date', 'PrDM' but their names are '", colnames_QAT_list, "'. The csv file 'QAT_column_names_error_table.csv' has been written in 'C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/' for a better visualization. There are many variations of the _QAT column names that the script can assign and process. These names were used in the last _QAT file and it should work. The other columns can have any name or an empty cell instead of a name. The program cannot continue. Please fix the _QAT file column names and run the R scripts again. The R Session will exit without saving the workspace.")
      
      msgBox <- tk_messageBox(type = c("ok"), quit_R_Session_message_QAT2, caption = "Continue with closing the R Session?", default = "", icon = "error")
      msgBoxCharacter <- as.character(msgBox)
      
      if(msgBoxCharacter == "ok"){
        quit(save="no")
      }
      
    }
    
    
    
    
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
          
          write.table(QAT_file_for_print, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", "QAT_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
          write.table(QAT_column_names_ERROR, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", "QAT_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
          
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
    
    dir.create(file.path(paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
    write.table(QAT_file2, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/", QAT_filename_for_CSV, ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = T)
    
    file_written <- list.files(pattern = "\\_QAT*.*csv$", path = paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    
    
    if (length(file_written==1)){
      print("The QAT csv file was written.")
      print(file_written)
    }else{
      print(paste0("ERROR: The QAT csv file was not written"))
      stop()
      
    }
    
    
    
    
    
    
    
    #end if1 xlsx, start xls
  }else if (QAT_file_extension == "csv"){
    
    
    
    
    
    
    
    
    #write all QAT xlsx files as csv in "C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/"
    QAT_filename_for_CSV <- all_tables_joined_by_folder_name$QAT_file_name[i]
    QAT_filename_for_CSV <- sub('\\..*$', '', basename(QAT_filename_for_CSV))
    
    dir.create(file.path(paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
    
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
    
    
    #less than 40 cols or != 40? for all QAT extensions
    
    colnames_QAT_file_ERR <- colnames(QAT_file)
    
    if (length(colnames_QAT_file_ERR) != 40){
      
      print(paste0("ERROR: The QAT file selected ", basename(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i]), " must have 40 columns with names assigned but it has ", length(colnames_QAT_file_ERR), ". The QAT file must have exactly 40 columns and the columns 1(A),2(B),3(C),4(D),5(E),7(G),8(H),16(P) must be named 'filename', 'cruise_number', 'station', 'eventLatitude', 'eventLongitude', 'trip_number', 'sample_id', 'date', 'PrDM'. There are many variations of the _QAT column names that the script can assign and process. These names were used in the last _QAT file and it should work. The other columns can have any name or an empty cell instead of a name. The program cannot continue. Please fix the _QAT file columns and run the R scripts again."))
      
      quit_R_Session_message_QAT1 <- paste0("ERROR: The QAT file selected ", basename(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i]), " must have 40 columns with names assigned but it has ", length(colnames_QAT_file_ERR), ". The QAT file must have exactly 40 columns and the columns 1(A),2(B),3(C),4(D),5(E),7(G),8(H),16(P) must be named 'filename', 'cruise_number', 'station', 'eventLatitude', 'eventLongitude', 'trip_number', 'sample_id', 'date', 'PrDM'. There are many variations of the _QAT column names that the script can assign and process. These names were used in the last _QAT file and it should work. The other columns can have any name or an empty cell instead of a name. The program cannot continue. Please fix the _QAT file columns and run the R scripts again.")
      
      msgBox <- tk_messageBox(type = c("ok"), quit_R_Session_message_QAT1, caption = "Continue with closing the R Session?", default = "", icon = "error")
      msgBoxCharacter <- as.character(msgBox)
      
      if(msgBoxCharacter == "ok"){
        quit(save="no")
      }
      
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
    

    
    
    colnames_QAT_list <- paste(colnames_QAT, collapse = "', '")

    if (colnames(QAT_file2)[1] != defined_QAT_column_names[1] | colnames(QAT_file2)[2] != defined_QAT_column_names[2] | colnames(QAT_file2)[3] != defined_QAT_column_names[3] | colnames(QAT_file2)[4] != defined_QAT_column_names[4] | colnames(QAT_file2)[5] != defined_QAT_column_names[5] | colnames(QAT_file2)[6] != defined_QAT_column_names[6] | colnames(QAT_file2)[7] != defined_QAT_column_names[7] | colnames(QAT_file2)[8] != defined_QAT_column_names[8]){
      #rewrite error for column names error
      print(paste0("ERROR: The _QAT file selected ", basename(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i]), " does not have the defined column names for at least one of the 8 needed columns from 40. The needed columns 1(A),2(B),3(C),4(D),5(E),7(G),8(H),16(P) must be named 'filename', 'cruise_number', 'station', 'eventLatitude', 'eventLongitude', 'sample_id', 'date', 'PrDM' but their names are '", colnames_QAT_list, "'. The csv file 'QAT_column_names_error_table.csv' has been written in 'C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/' for a better visualization. There are many variations of the _QAT column names that the script can assign and process. These names were used in the last _QAT file and it should work. The other columns can have any name or an empty cell instead of a name. The program cannot continue. Please fix the _QAT file column names and run the R scripts again."))

      QAT_column_names_error_table1 <- data.frame("NumCol", "1", "2", "3", "4", "5", "6", "7", "8")
      names(QAT_column_names_error_table1) <- c("0", "1", "2", "3", "4", "5", "6", "7", "8")
      
      QAT_column_names_error_table2 <- data.frame("ColNum", "1(A)", "2(B)", "3(C)", "4(D)" , "5(E)", "7(G)", "8(H)", "16(P)")
      names(QAT_column_names_error_table2) <- c("0", "1", "2", "3", "4", "5", "6", "7", "8")
      
      QAT_column_names_error_table3 <- data.frame("ColNameDefined", "filename", "cruise_number", "station", "eventLatitude", "eventLongitude", "sample_id", "date", "PrDM")
      names(QAT_column_names_error_table3) <- c("0", "1", "2", "3", "4", "5", "6", "7", "8")
      
      QAT_column_names_error_table4 <- data.frame(t(append("QAT_ColName", colnames_QAT)))
      names(QAT_column_names_error_table4) <- c("0", "1", "2", "3", "4", "5", "6", "7", "8")
      
      
      QAT_column_names_error_table <- rbind(QAT_column_names_error_table1, QAT_column_names_error_table2)
      QAT_column_names_error_table <- rbind(QAT_column_names_error_table, QAT_column_names_error_table3)
      QAT_column_names_error_table <- rbind(QAT_column_names_error_table, QAT_column_names_error_table4)
      
      write.csv(QAT_column_names_error_table, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", "QAT_column_names_error_table_for_file_", basename(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i]), "_.csv"), row.names = FALSE)
      
      
      quit_R_Session_message_QAT2 <- paste0("ERROR: The _QAT file selected ", basename(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i]), " does not have the defined column names for at least one of the 8 needed columns from 40. The needed columns 1(A),2(B),3(C),4(D),5(E),7(G),8(H),16(P) must be named 'filename', 'cruise_number', 'station', 'eventLatitude', 'eventLongitude', 'sample_id', 'date', 'PrDM' but their names are '", colnames_QAT_list, "'. The csv file 'QAT_column_names_error_table.csv' has been written in 'C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/' for a better visualization. There are many variations of the _QAT column names that the script can assign and process. These names were used in the last _QAT file and it should work. The other columns can have any name or an empty cell instead of a name. The program cannot continue. Please fix the _QAT file column names and run the R scripts again. The R Session will exit without saving the workspace.")

      msgBox <- tk_messageBox(type = c("ok"), quit_R_Session_message_QAT2, caption = "Continue with closing the R Session?", default = "", icon = "error")
      msgBoxCharacter <- as.character(msgBox)

      if(msgBoxCharacter == "ok"){
        quit(save="no")
      }

    }
    
    
    
    
    
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
          
          write.table(QAT_file_for_print, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", "QAT_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
          write.table(QAT_column_names_ERROR, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", "QAT_column_names_ERROR", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
          
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
    
    dir.create(file.path(paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
    write.table(QAT_file2, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/", QAT_filename_for_CSV, ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = T)
    
    file_written <- list.files(pattern = "\\_QAT*.*csv", path = paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
    
    
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
  
  #write all ODF files as csv in "C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/"
  ODF_filename_for_CSV <- all_tables_joined_by_folder_name$ODF_file_name[i]
  ODF_filename_for_CSV <- sub('\\..*$', '', basename(ODF_filename_for_CSV))
  
  dir.create(file.path(paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
  
  
  ODF_file2 <- all_tables_joined_by_folder_name$all_ODF_files[i]
  con <- file(ODF_file2, "r")
  first_12_lines_ODF_file <- readLines(con, n=12)
  close(con)
  
  first_12_lines_ODF_file_df <- data.frame(first_12_lines_ODF_file)
  
  #extract line12 from the ODF file ("RUISE_DESCRIPTION")
  ODF_line12 <- rm_between(first_12_lines_ODF_file_df[12,], 'C', '=', extract=TRUE)  

  
  #exit R if ODF_line12_cruise_description fails on 003_000_002 line 1484   if (ODF_line12=="RUISE_DESCRIPTION"){
  
  if (ODF_line12 != "RUISE_DESCRIPTION"){
    
    ODF_line12_err_message <- paste0("ERROR: ODF file ", ODF_file2, " line 12 IT IS NOT CRUISE_DESCRIPTION but instead *", ODF_line12, ".The program cannot continue. Please fix the ODF file and run the R scripts again. R will exit without saving the workspace.")
    msgBox_ODF_line12_err_message <- tk_messageBox(type = c("ok"),
                                                   ODF_line12_err_message, caption = "Continue with closing the R Session?", default = "", icon = "error")
    msgBoxCharacter_ODF_line12_err_message <- as.character(msgBox_ODF_line12_err_message)
    
    if(msgBoxCharacter_ODF_line12_err_message == "ok"){
      print("Quit R")
      quit(save="no")
      
    }
    
  }
  
    
  
  
  
    
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
  
  
  
  #check if the ODF header has the right number of commas (,) 
  
  #c_occur = str_count(ODF_header10lines_3_12, '[1-9]\\d*')
  #c_occur == c(1, 1, 1, 1, 1, 1, 1, 1, 1, 0)
  c_occur = str_count(ODF_header10lines_3_12, "\\,")
  c_occur2 <- paste(c_occur, collapse = ",")
  
  if ((c_occur2 != "1,1,1,1,1,1,1,1,1,0") == TRUE){
    
    ODF_commas_err_message <- paste0("ERROR: ODF file ", ODF_file2, " DOES NOT have the right number of commas (,) from line 3 to line 12 used as metadata header for the Absorption table. Please edit the .ODF file to remove commas (,) within each of these lines and ensure there are only commas (,) at the end of each line 3 to line 11, line 12 should have no commas (,). The misplaced commas (,) can be removed or repaced with semicolon (;) - otherwise the metadata header of the final Absorption csv tables (C:/R_WD/WORKS7/RESULTS/) will be scrambled. R will exit without saving the workspace.")    
    print(paste0("ERROR: ODF file ", ODF_file2, " DOES NOT have the right number of commas (,) from line 3 to line 12 used as metadata header for the Absorption table. Please edit the .ODF file to remove commas (,) within each of these lines and ensure there are only commas (,) at the end of each line 3 to line 11, line 12 should have no commas (,). The misplaced commas (,) can be removed or repaced with semicolon (;) - otherwise the metadata header of the final Absorption csv tables (C:/R_WD/WORKS7/RESULTS/) will be scrambled. R will exit without saving the workspace."))
    print(paste0("ERROR: ODF file ", ODF_file2, " DOES NOT have the right number of commas (,) from line 3 to line 12 (1 to 10 in our selection as a reference) used as metadata header for the Absorption table. The presence of comma (,) values ONLY at the end of the rows 1:10 (3:12 in the .ODF file) should be '1,1,1,1,1,1,1,1,1,0' (1=TRUE, 0=FALSE), but they are ", c_occur2,". The program cannot continue. Please fix the ODF file and run the R scripts again. Commas (,) must be present always only at the end of the rows 3:11 in the .ODF file (if any comma (,) is missing it must be entered manually). If there are more commas (,) please replace them with semicolon (;) - otherwise the metadata header of the final Absorption csv tables will be scrambled. Comma (,) is a reserved character in csv used only for delimitation. R will exit without saving the workspace."))
    
    msgBox_ODF_commas_err_message <- tk_messageBox(type = c("ok"),
                                                   ODF_commas_err_message, caption = "Continue with closing the R Session?", default = "", icon = "error")
    msgBoxCharacter_ODF_commas_err_message <- as.character(msgBox_ODF_commas_err_message)
    
    if(msgBoxCharacter_ODF_commas_err_message == "ok"){
      print("Quit R")
      quit(save="no")
      
    }
    
  }
  

  
  
  dir.create(file.path(paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
  write.table(ODF_header10lines_3_12, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/", ODF_filename_for_CSV, "_ODF.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
  
  #print(ODF_header10lines_3_12)
  
  file_written <- list.files(pattern = "\\_ODF.csv$", path = paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/METADATA_CSV/", all_tables_joined_by_folder_name$folder_name[i], "/"))
  
  
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



#print(paste0("All data and metadata seems to be okay. Let's proceed with the next step."))


    
#end else in all_tables_joined_by_folder_name != 1  
}  
  
  
#end else for if (dir.exists(input_metadata_folder_name) == FALSE){  
}




Absorbance_Par_and_Det_SampleIDs <- full_join(file_list_txt_d6_df, file_list_txt_d6p_df, by = c("file"))
names(Absorbance_Par_and_Det_SampleIDs)[5] <- "Sample_ID"

nrows_Absorbance_Par_and_Det_SampleIDs <- nrow(Absorbance_Par_and_Det_SampleIDs)
write.csv(Absorbance_Par_and_Det_SampleIDs, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", coded_cruise_name_entered, "_Absorbance_Particulate_and_Detritus_full_join_SampleIDs_", nrows_Absorbance_Par_and_Det_SampleIDs, "_rows.csv"), row.names = FALSE)


Absorbance_Par_and_Det_inner_join_SampleIDs <- inner_join(file_list_txt_d6_df, file_list_txt_d6p_df, by = c("file"))
names(Absorbance_Par_and_Det_inner_join_SampleIDs)[5] <- "Sample_ID"

nrows_Absorbance_Par_and_Det_inner_join_SampleIDs <- nrow(Absorbance_Par_and_Det_inner_join_SampleIDs)
write.csv(Absorbance_Par_and_Det_inner_join_SampleIDs, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", coded_cruise_name_entered, "_Absorbance_Particulate_and_Detritus_inner_join_SampleIDs_", nrows_Absorbance_Par_and_Det_inner_join_SampleIDs, "_rows.csv"), row.names = FALSE)




names(HPLC_file2)[1] <- "Sample_ID"
names(QAT_file2)[6] <- "Sample_ID"


Absorbance_missing_SampleIDs_from_HPLC <- anti_join(Absorbance_Par_and_Det_SampleIDs, HPLC_file2, by = c("Sample_ID"))
Absorbance_missing_SampleIDs_from_QAT <- anti_join(Absorbance_Par_and_Det_SampleIDs, QAT_file2, by = c("Sample_ID"))
the_ODF_header <- ODF_header10lines_3_12

# string <- the_ODF_header
# pattern <- ","
# replacement <- ";"
# the_ODF_header <- str_replace(string, pattern, replacement)


write.table(the_ODF_header, file = paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", coded_cruise_name_entered, "_the_ODF_metadata_header_", length(the_ODF_header), "_rows.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)#i


Absorbance_missing_SampleIDs_from_HPLC2 <- data.frame(Absorbance_missing_SampleIDs_from_HPLC$Sample_ID)
names(Absorbance_missing_SampleIDs_from_HPLC2)[1] <- "Sample_ID"
nrows_Absorbance_missing_SampleIDs_from_HPLC2 <- nrow(Absorbance_missing_SampleIDs_from_HPLC2)
write.csv(Absorbance_missing_SampleIDs_from_HPLC2, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", coded_cruise_name_entered, "_Absorbance_missing_SampleIDs_from_HPLC_", nrows_Absorbance_missing_SampleIDs_from_HPLC2, "_rows.csv"), row.names = FALSE)

Absorbance_missing_SampleIDs_from_QAT2 <- data.frame(Absorbance_missing_SampleIDs_from_QAT$Sample_ID)
names(Absorbance_missing_SampleIDs_from_QAT2)[1] <- "Sample_ID"
nrows_Absorbance_missing_SampleIDs_from_QAT2 <- nrow(Absorbance_missing_SampleIDs_from_QAT2)
write.csv(Absorbance_missing_SampleIDs_from_QAT2, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", coded_cruise_name_entered, "_Absorbance_missing_SampleIDs_from_QAT_", nrows_Absorbance_missing_SampleIDs_from_QAT2, "_rows.csv"), row.names = FALSE)


Absorbance_missing_SampleIDs_from_HPLC_list <- Absorbance_missing_SampleIDs_from_HPLC[["Sample_ID"]]
Absorbance_missing_SampleIDs_from_QAT_list <- Absorbance_missing_SampleIDs_from_QAT[["Sample_ID"]]

test_report_msg1 <- paste0("In the cruise folder '", cruise_name_table_df$folder_name, "' ", cruise_name_table_df$coded_cruise_name, " are ", nrow(Absorbance_Par_and_Det_SampleIDs), " Absorbance Sample_IDs, ", "Particulate = ",nrow(file_list_txt_d6_df), " , Detritus = ",nrow(file_list_txt_d6p_df))
test_report_msg2 <- paste0("From ", nrow(Absorbance_Par_and_Det_SampleIDs), " Absorbance Sample_IDs, ", nrow(Absorbance_missing_SampleIDs_from_HPLC), " are missing from the HPLC file and ", nrow(Absorbance_missing_SampleIDs_from_QAT), " are missing from the QAT file.")
test_report_msg3 <- paste0("The ", nrow(Absorbance_missing_SampleIDs_from_HPLC), " missing Sample_IDs from HPLC are: ")
test_report_msg4 <- paste0(Absorbance_missing_SampleIDs_from_HPLC_list)
test_report_msg5 <- paste0("The ", nrow(Absorbance_missing_SampleIDs_from_QAT), " missing Sample_IDs from QAT are: ")
test_report_msg6 <- paste0(Absorbance_missing_SampleIDs_from_QAT_list)
test_report_msg7 <- paste0("Continue with a preview of the ODF header? OK!")

test_report_msg <- append(test_report_msg1, test_report_msg2)
test_report_msg <- append(test_report_msg, test_report_msg3)
test_report_msg <- append(test_report_msg, test_report_msg4)
test_report_msg <- append(test_report_msg, test_report_msg5)
test_report_msg <- append(test_report_msg, test_report_msg6)
test_report_msg <- append(test_report_msg, test_report_msg7)


tk_messageBox(type = c("ok"),
              test_report_msg, caption = "Continue? OK!", default = "")




the_ODF_header_msg1 <- paste0("This is a preview of the ODF header for cruise folder '", cruise_name_table_df$folder_name, "' ", cruise_name_table_df$coded_cruise_name, " that will be used as metadata for the final Absorption csv tables.")
#the_ODF_header
last_message <- paste0("                                           The csv file '_the_ODF_metadata_header_10_rows.csv have been written in 'C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/'. Continue with testing? OK!")


the_ODF_header_msg <- append(the_ODF_header_msg1, the_ODF_header)
the_ODF_header_msg <- append(the_ODF_header_msg, last_message)

tk_messageBox(type = c("ok"),
              the_ODF_header_msg, caption = "Continue with testing? OK!", default = "")



Absorbance_SampleIDs_that_ARE_in_HPLC <- inner_join(Absorbance_Par_and_Det_SampleIDs, HPLC_file2, by = c("Sample_ID"))
Absorbance_SampleIDs_that_ARE_in_QAT <- inner_join(Absorbance_Par_and_Det_SampleIDs, QAT_file2, by = c("Sample_ID"))




if (nrow(Absorbance_SampleIDs_that_ARE_in_HPLC) == 0){
  print(paste0("ERROR: There are no Absorbance Sample ID's in the HPLC file selected ", basename(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i]), " . If you choose No the program will process and plot only the Absorbance files, but it will exit before the R script sequence labeled with #008 at line 151 '003_004_metadata_for_final_file_34_3_absorbance_to_absorption_8_3_2_no_HPLC_stops_enter_fdia_2.R' where it cannot continue to convert Absorbance to Absorption without the data needed for each Absorbance Sample ID needed from the HPLC file. It is strongly recommended to select the OK button to quit and close the R Session. The R Workspace WILL NOT be saved. Also before the R script sequence will be launched again the directory 'C:/R_WD/WRITE' should be renamed from 'WRITE' to something like 'WRITE_OLD1' or deleted. Continue with closing the R Session? Yes = Recommended"))
  
  quit_R_Session_HPLC3 <- paste0("ERROR: There are no Absorbance Sample ID's in the HPLC file selected ", basename(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[i]), " . If you choose No the program will process and plot only the Absorbance files, but it will exit before the R script sequence labeled with #008 at line 151 '003_004_metadata_for_final_file_34_3_absorbance_to_absorption_8_3_2_no_HPLC_stops_enter_fdia_2.R' where it cannot continue to convert Absorbance to Absorption without the data needed for each Absorbance Sample ID needed from the HPLC file. It is strongly recommended to select the OK button to quit and close the R Session. The R Workspace WILL NOT be saved. Also before the R script sequence will be launched again the directory 'C:/R_WD/WRITE' should be renamed from 'WRITE' to something like 'WRITE_OLD1' or deleted. Continue with closing the R Session? Yes = Recommended")
  
  msgBox_meta <- tk_messageBox(type = c("yesno"), quit_R_Session_HPLC3, caption = "Continue with closing the R Session?", default = "", icon = "error")
  msgBoxCharacter_no_SampleIDs_in_HPLC <- as.character(msgBox_meta)
  
  if(msgBoxCharacter_no_SampleIDs_in_HPLC == "yes"){
    quit(save="no")
  }
}

  
  

if (nrow(Absorbance_SampleIDs_that_ARE_in_QAT) == 0){
  print(paste0("ERROR: There are no Absorbance Sample ID's in the _QAT file selected ", basename(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i]), " . If you choose No the program will process and plot only the Absorbance files, but it will exit before the R script sequence labeled with #008 at line 159 '003_004_metadata_for_final_file_34_3_absorbance_to_absorption_8_3_2_no_HPLC_stops_enter_fdia_2.R' where it cannot continue to convert Absorbance to Absorption without the data needed for each Absorbance Sample ID needed from the _QAT file. It is strongly recommended to select the OK button to quit and close the R Session. The R Workspace WILL NOT be saved. Also before the R script sequence will be launched again the directory 'C:/R_WD/WRITE' should be renamed from 'WRITE' to something like 'WRITE_OLD1' or deleted. Continue with closing the R Session? Yes = Recommended"))
  
  quit_R_Session_QAT3 <- paste0("ERROR: There are no Absorbance Sample ID's in the _QAT file selected ", basename(all_tables_joined_by_folder_name$all_QAT_xlsx_files[i]), " . If you choose No the program will process and plot only the Absorbance files, but it will exit before the R script sequence labeled with #008 at line 159 '003_004_metadata_for_final_file_34_3_absorbance_to_absorption_8_3_2_no_HPLC_stops_enter_fdia_2.R' where it cannot continue to convert Absorbance to Absorption without the data needed for each Absorbance Sample ID needed from the _QAT file. It is strongly recommended to select the OK button to quit and close the R Session. The R Workspace WILL NOT be saved. Also before the R script sequence will be launched again the directory 'C:/R_WD/WRITE' should be renamed from 'WRITE' to something like 'WRITE_OLD1' or deleted. Continue with closing the R Session? Yes = Recommended")
  
  msgBox_meta <- tk_messageBox(type = c("yesno"), quit_R_Session_HPLC3, caption = "Continue with closing the R Session?", default = "", icon = "error")
  msgBoxCharacter_no_SampleIDs_in_QAT <- as.character(msgBox_meta)
  
  if(msgBoxCharacter_no_SampleIDs_in_QAT == "yes"){
    quit(save="no")
  }
}

  

last_test_message <- paste0("All the preliminary testing reports are in 'C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/'; The RESULTS and reports will be in 'C:/R_WD/WRITE/' after the processing is done, which is the next step. Testing is completed. (Yes) = Continue with processing, (No) = Exit R Session without saving the workspace.")

msgBox_last <- tk_messageBox(type = c("yesno"), last_test_message, caption = "Testing processing requirements DONE. Continue?", default = "")
msgBoxCharacter_last <- as.character(msgBox_last)

if(msgBoxCharacter_last == "no"){
  quit(save="no")
}



#####################

end_time <- Sys.time()
start_time
end_time








