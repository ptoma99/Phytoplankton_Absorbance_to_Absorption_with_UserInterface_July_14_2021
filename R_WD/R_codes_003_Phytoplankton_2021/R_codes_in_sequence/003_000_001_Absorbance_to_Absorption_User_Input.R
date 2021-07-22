#003_000_001_Absorbance_to_Absorption_User_Input

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021

start_time <- Sys.time()
print(paste0("start_time = ", start_time))



setwd("C:/R_WD")
getwd()




library("tcltk2")
library("reader")

#001 function for varEntryDialog to input numeric value for filter diameter
source(paste0(R_codes_folder, "enter_num_value_for_fdia_function.R"))

cruise_name_table_location <- "C:/R_WD/folder_name_to_coded_cruise_name_table.csv"


###############
#start UI



first_message_input_table <- "Hello. This R code converts Phytoplankton Absorbance to Absorption per cruise.   The input is listed in 'C:/R_WD/Absorbance_to_Absorption_R_scripts_input_table_info.xlsx'. To open the file now for review ('YES') or ('NO') to continue. NOTE:  1.  This User Dialog window can popup behind R Studio and  R will appear frozen.  2. If fatal errors occur  R will close without saving the workspace; please save your work before proceed."

msgBox_first_message_input_table <- tk_messageBox(type = c("yesno"),
                                                  first_message_input_table, caption = "Continue? YES!", default = "")
msgBoxCharacter_first_message_input_table <- as.character(msgBox_first_message_input_table)

if(msgBoxCharacter_first_message_input_table == "yes"){
  shell.exec("C:/R_WD/Absorbance_to_Absorption_R_scripts_input_table_info.xlsx")
}



second_message <- "If inputs are ready ('OK') to continue or ('Cancel') to close R without saving the workspace?"
msgBox_second_message <- tk_messageBox(type = c("okcancel"),
                                       second_message, caption = "Continue?", default = "")
msgBoxCharacter_second_message <- as.character(msgBox_second_message)

if(msgBoxCharacter_second_message == "cancel"){
  print("Quit R")
  quit(save="no")
  
}




#if you run the code more than one time without clearing the environment you must set again "input_folder_to_read_files" because the variable is recycled within the other scripts

#input_folder_to_read_files <- "C:/R_WD/DATA_READ/Particulate_Absorbance/AMU2019-001 Lab sea" #no "/"

#select the cruise folder that contains the Particulate(123456.txt) and the Detritus(123456p.txt) Absorbance txt files
input_folder_to_read_files <- tk_choose.dir(default = getwd(), caption = "Select the cruise folder that contains the Particulate(123456.txt) and the Detritus(123456p.txt) Absorbance txt raw data files(Example:AMU2019-001 Lab sea):(no files are shown inside the folder)")

#get the folder name of the folder selected from file path
folder_name_selected <- basename(input_folder_to_read_files)


#enter the coded cruise name (cruise name) for the folder selected conditioned to 3 capital letters and 7 numbers
values_list <- varEntryDialog(vars=c('coded_cruise_name'), labels=c(paste0("Enter the coded_cruise_name (10 characters (3 capital letters and 7 integer numbers)) for the folder '", folder_name_selected, "' (Example: for 'AMU2019-001 Lab sea' enter AMU2019001")), fun=c(
  function(x) {
    x <- as.character(x)
    first_three_letters <- sub('\\S{7}$', '', x)
    
    last_seven_numbers <- sub('^\\S{3}', '', x)
    last_seven_numbers <- strsplit(last_seven_numbers, split = "")
    last_seven_numbers <- as.integer(last_seven_numbers[[1]])
    last_seven_numbers <- na.omit(last_seven_numbers)
    last_seven_numbers <- paste(last_seven_numbers, collapse = "")
    
    if (nchar(x) != 10){
      stop(paste0("ERROR: Not 10 characters. Please enter the coded_cruise_name (10 characters (3 capital letters and 7 integer numbers)) for the folder '", folder_name_selected, "' (Example: for 'AMU2019-001 Lab sea' enter AMU2019001"))
    }
    
    if (nchar(first_three_letters) != 3 | grepl("^[[:upper:]]+$", first_three_letters) == FALSE){
      stop(paste0("ERROR: The first 3 characters out of 10 (ship name abbreviation) are not capital letters. Please enter the coded_cruise_name (10 characters (3 capital letters and 7 integer numbers)) for the folder '", folder_name_selected, "' (Example: for 'AMU2019-001 Lab sea' enter AMU2019001"))
    }
    
    
    if (nchar(last_seven_numbers) != 7){
      stop(paste0("ERROR: The last 7 characters out of 10 (4 digits year and 3 digits cruise number after the ship name abbreviation) are not numbers. Please enter the coded_cruise_name (10 characters (3 capital letters and 7 integer numbers)) for the folder '", folder_name_selected, "' (Example: for 'AMU2019-001 Lab sea' enter AMU2019001"))
    }
    
    return(x)
    
  } ))

coded_cruise_name_entered <- values_list[["coded_cruise_name"]]

if (is.na(input_folder_to_read_files) | is.na(folder_name_selected) | is.null(coded_cruise_name_entered)){
  
  print("ERROR: One or more needed values entered trough Graphycal User Interface are/is NA and/or NULL (Cancel button has been selected). Please clear the environment and run the R script from the beginning.")
  
  quit_R_Session_message <- "ERROR: One or more needed values entered trough Graphycal User Interface are/is NA and/or NULL (Cancel button has been selected). The program cannot continue. Please select OK button to quit and close the R Session. The R Workspace WILL NOT be saved."
  
  msgBox <- tk_messageBox(type = c("ok"), quit_R_Session_message, caption = "Continue with closing the R Session?", default = "")
  msgBoxCharacter <- as.character(msgBox)
  
  if(msgBoxCharacter == "ok"){
    quit(save="no")
  }
  
}



#write c:/R_WD/folder_name_to_coded_cruise_name_table.csv from the inputs entered above. overwrite = TRUE. It is needed within most of the scripts.
folder_name_to_coded_cruise_name_table_df <- data.frame(matrix(nrow = 1, ncol = 2))
names(folder_name_to_coded_cruise_name_table_df) <- c("folder_name", "coded_cruise_name")
folder_name_to_coded_cruise_name_table_df$folder_name[1] <- folder_name_selected
folder_name_to_coded_cruise_name_table_df$coded_cruise_name[1] <- coded_cruise_name_entered


#load the file opened check function
source(paste0(R_codes_folder, "file_opened_function.R"))



# file.opened(file_path)
# 
# #close(con) always after FALSE never after TRUE
# close(con)
# 
# #kills unused connections
# showConnections(all=TRUE)


#check if the file folder_name_to_coded_cruise_name_table.csv is open before writing
#if1
if (file.exists("C:/R_WD/folder_name_to_coded_cruise_name_table.csv") == TRUE){
  
  #if2
  if (file.opened(cruise_name_table_location) == FALSE){
    #close(con)
    showConnections(all=TRUE)
    write.csv(folder_name_to_coded_cruise_name_table_df, paste0("C:/R_WD/", "folder_name_to_coded_cruise_name_table.csv"), row.names = FALSE)
  
  #else if2  
  }else if (file.opened(cruise_name_table_location) == TRUE){
    
    csv_open_retry_msg <- "ERROR: The file 'C:/R_WD/folder_name_to_coded_cruise_name_table.csv' is open by another program. Please close the file and click 'Retry'. 'The program cannot continue. Please select 'Retry' to try again or 'Cancel' button to quit and close the R Session. The R Workspace WILL NOT be saved."
    msgBox_rc <- tk_messageBox(type = c("retrycancel"), csv_open_retry_msg, caption = "Retry overwriting the file 'folder_name_to_coded_cruise_name_table.csv'? Yes!", default = "", icon = "error")
    msgBoxCharacter_rc <- as.character(msgBox_rc)

    #if3   
    if(msgBoxCharacter_rc == "retry"){
      if (file.opened(cruise_name_table_location) == FALSE){
        #close(con)
        showConnections(all=TRUE)
        write.csv(folder_name_to_coded_cruise_name_table_df, paste0("C:/R_WD/", "folder_name_to_coded_cruise_name_table.csv"), row.names = FALSE)

        }else if (file.opened(cruise_name_table_location) == TRUE){
        quit_R_Session_message_csv <- "The program cannot continue without overwriting the file 'C:/R_WD/folder_name_to_coded_cruise_name_table.csv'. The file is still open by another program. Please select 'OK' to quit and close the R Session. The R Workspace WILL NOT be saved."
        msgBox1 <- tk_messageBox(type = c("ok"), quit_R_Session_message_csv, caption = "Continue with closing the R Session?", default = "", icon = "error")
        msgBoxCharacter1 <- as.character(msgBox1)
      
        if(msgBoxCharacter1 == "ok"){
        quit(save="no")
        }
        
    #end else if if3    
    }
    
    #end if3  
    }

#if4
if(msgBoxCharacter_rc == "cancel"){
  quit_R_Session_message_csv2 <- "Cancel button has been selected. Please select the 'OK' button to quit and close the R Session. The R Workspace WILL NOT be saved."
  msgBox2 <- tk_messageBox(type = c("ok"), quit_R_Session_message_csv2, caption = "Continue with closing the R Session?", default = "")
  msgBoxCharacter2 <- as.character(msgBox2)
  
  if(msgBoxCharacter2 == "ok"){
    quit(save="no")
  }
  
#end if4   
}

#end else if2
}

#else if1
}else if (file.exists("C:/R_WD/folder_name_to_coded_cruise_name_table.csv") == FALSE){
write.csv(folder_name_to_coded_cruise_name_table_df, paste0("C:/R_WD/", "folder_name_to_coded_cruise_name_table.csv"), row.names = FALSE)

#end else if1
}





#select the metadata (HPLC, _QAT and .ODF files) for the cruise selected and copy them in C:/R_WD/Metadata_per_cruise/"folder_name"

#create the folder where the selected metadata will be copied and used for processing
dir.create(file.path(paste0("C:/R_WD/Metadata_per_cruise/", folder_name_selected)), showWarnings = FALSE, recursive = TRUE)


files_already_in_metadata <- list.files(pattern = "\\."  , path = "C:/R_WD/Metadata_per_cruise", all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)

if (length(files_already_in_metadata) > 0){
  
  
  files_to_del_list <- basename(files_already_in_metadata)
  files_to_del_list <- paste(files_to_del_list, collapse = " ")
  
  print(paste0("The folder C:/R_WD/Metadata_per_cruise/", folder_name_selected, " keeps a copy of the metadata files selected for processing - HPLC, QAT and ODF and calls them during the processing. It should be empty every time before a new set is selected at this moment. The files found within are:", files_to_del_list, ". Delete them? Yes = Recommended"))
  
  del_meta_files_message <- paste0("The folder C:/R_WD/Metadata_per_cruise/", folder_name_selected, " keeps a copy of the metadata files selected for processing - HPLC, QAT and ODF and calls them during the processing. It should be empty every time before a new set is selected at this moment. The files found within are:", files_to_del_list, ". Delete them? Choosing 'No' will exit the R Session without saving the workspace. Yes = Recommended")
  
  msgBox <- tk_messageBox(type = c("yesno"), del_meta_files_message, caption = "Delete the metadata files listed? YES!", default = "")
  msgBoxCharacter <- as.character(msgBox)
  
  if(msgBoxCharacter == "yes"){
    #quit(save="no")
    for (del_files in 1:length(files_already_in_metadata)){
      file.remove(files_already_in_metadata[del_files])
    }  
  }
  
  if(msgBoxCharacter == "no"){
    quit(save="no")
  }
}






#delete files if any - confirmation
#The folder _ keeps a copy of the metadata files selected for processing - HPLC, QAT and ODF and calls them during the processing. It should be empty every time before a new set is selected at this moment. The files are: _ . Delete them? Yes = Recommended






#select the HPLC file
#the_HPLC_file_selected <- tk_choose.files(default = getwd(), caption = paste0("Please select the HPLC file (must have HPLC in the file name) (xls, xlsx or xlsm, NOT CSV) for the cruise ", folder_name_selected, " ", coded_cruise_name_entered), multi = FALSE, filters = NULL, index = 1)

HPLC_filter <- matrix(c("HPLC xls, xlsx, xlsm files", "*HPLC*.xls*"), 1, 2, byrow = TRUE)
the_HPLC_file_selected <- if(interactive()) tk_choose.files(default = "", filters =  HPLC_filter, caption = paste0("Please select the HPLC file (must have HPLC in the file name) (xls, xlsx or xlsm, NOT CSV) for the cruise ", folder_name_selected, " ", coded_cruise_name_entered, ". For this selection only *HPLC* files are shown."), multi = FALSE, index = 1)
the_HPLC_file_selected <- paste(the_HPLC_file_selected, collapse = " ")


#select the _QAT file
#the_QAT_file_selected <- tk_choose.files(default = "", caption = paste0("Please select the QAT file (must have _QAT in the file name) (xls, xlsx or csv, NOT xlsm) for the cruise ", folder_name_selected, " ", coded_cruise_name_entered), multi = FALSE, filters = NULL, index = 1)

QAT_filter <- matrix(c("_QAT xls, xlsx, csv files", "*_QAT*.*s*"), 1, 2, byrow = TRUE)
the_QAT_file_selected <- tk_choose.files(default = "", filters =  QAT_filter, caption = paste0("Please select the QAT file (must have _QAT in the file name) (xls, xlsx or csv, NOT xlsm) for the cruise ", folder_name_selected, " ", coded_cruise_name_entered, ". For this selection only *_QAT* files are shown."), multi = FALSE, index = 1)
the_QAT_file_selected <- paste(the_QAT_file_selected, collapse = " ")

#if QAT file extension = xlsm choose again exit

selected_QAT_file_extension <- get.ext(the_QAT_file_selected)

if (selected_QAT_file_extension == "xlsm"){
  
  print("ERROR: The _QAT file selected extension is 'xlsm'. The _QAT file selection will be cleared. The program cannot process _QAT files with 'xlsm' extension, only _QAT files with 'xls, 'xlsx' and 'csv' extensions. Would you like to try again?")
  
  QAT_xlsm_try_again_message <- "ERROR: The _QAT file selected extension is 'xlsm'. The _QAT file selection will be cleared. The program cannot process _QAT files with 'xlsm' extension, only _QAT files with 'xls, 'xlsx' and 'csv' extensions. Would you like to try again? 'Yes' will open the dialog one more time and 'No' will keep 'No _QAT file selected' entry, like 'Cancel' button was clicked.                   Yes = Recommended"
  
  msgBox_QAT <- tk_messageBox(type = c("yesno"), QAT_xlsm_try_again_message, caption = "Continue with selecting the _QAT file again?", default = "", icon = "warning")
  msgBoxCharacter_QAT <- as.character(msgBox_QAT)
  
  if(msgBoxCharacter_QAT == "yes"){
    #quit(save="no")
    
    the_QAT_file_selected <- tk_choose.files(default = "", filters =  QAT_filter, caption = paste0("Please select the QAT file (must have _QAT in the file name) (xls, xlsx or csv, NOT xlsm) for the cruise ", folder_name_selected, " ", coded_cruise_name_entered, ". If a _QAT file with xlsm extension will be selected again in the next window the R Session will exit and the R workspace will not be saved."), multi = FALSE, index = 1)
    the_QAT_file_selected <- paste(the_QAT_file_selected, collapse = " ")
  }
  
  if(msgBoxCharacter_QAT == "no"){
    the_QAT_file_selected <- ""
  }
}



selected_QAT_file_extension <- get.ext(the_QAT_file_selected)

if (selected_QAT_file_extension == "xlsm"){
  
  print("ERROR: A _QAT file with 'xlsm' extension has been selected the second time. The program cannot process _QAT files with 'xlsm' extension, only _QAT files with 'xls, 'xlsx' and 'csv' extensions. The program cannot continue. R Session will exit and the workspace will not be saved.")
  
  QAT_xlsm_exit_message <- "ERROR: A _QAT file with 'xlsm' extension has been selected the second time. The program cannot process _QAT files with 'xlsm' extension, only _QAT files with 'xls, 'xlsx' and 'csv' extensions. The program cannot continue. R Session will exit and the workspace will not be saved. Exit the R Session without saving the workspace? (Only 'OK' is available)"
  
  msgBox_QAT <- tk_messageBox(type = c("ok"), QAT_xlsm_exit_message, caption = "Exit the R Session without saving the workspace?", default = "", icon = "error")
  msgBoxCharacter_QAT <- as.character(msgBox_QAT)
  
  if(msgBoxCharacter_QAT == "ok"){
    quit(save="no")
    
  }
}





#select the .ODF file
#the_ODF_file_selected <- tk_choose.files(default = "", caption = paste0("Please select the ODF file (must have .ODF file extension) for the cruise ", folder_name_selected, " ", coded_cruise_name_entered), multi = FALSE, filters = NULL, index = 1)

ODF_filter <- matrix(c("*.ODF files", "*.ODF"), 1, 2, byrow = TRUE)
the_ODF_file_selected <- tk_choose.files(default = "", filters = ODF_filter, caption = paste0("Please select the ODF file (must have .ODF file extension) for the cruise ", folder_name_selected, " ", coded_cruise_name_entered, ". For this selection only *.ODF files are shown."), multi = FALSE, index = 1)
the_ODF_file_selected <- paste(the_ODF_file_selected, collapse = " ")

if (the_HPLC_file_selected == "" | the_QAT_file_selected == "" | the_ODF_file_selected == ""){
  
  print("ERROR: One or more needed values entered trough Graphycal User Interface for the HPLC, _QAT and/or .ODF metadata files selected is/are not defined (Cancel button has been selected). Please clear the environment and run the R script from the beginning.")
  
  quit_R_Session_message2 <- "ERROR: One or more needed values entered trough Graphycal User Interface for the HPLC, _QAT and/or .ODF metadata files selected is/are not defined (Cancel button has been selected). If you choose No the program will process and plot only the Absorbance files, but it will exit before the R script sequence labeled with #008 at line 135 '003_004_metadata_for_final_file_34_3_absorbance_to_absorption_8_3_2_no_HPLC_stops_enter_fdia_2.R' where it cannot continue to convert Absorbance to Absorption without the HPLC, _QAT and .ODF files. It is strongly recommended to select the OK button to quit and close the R Session. The R Workspace WILL NOT be saved. Also before the R script sequence will be launched again the directory 'C:/R_WD/WRITE' should be renamed from 'WRITE' to something like 'WRITE_OLD1' or deleted. Continue with closing the R Session? Yes = Recommended"
  
  msgBox_meta <- tk_messageBox(type = c("yesno"), quit_R_Session_message2, caption = "Continue with closing the R Session?", default = "")
  msgBoxCharacter_meta <- as.character(msgBox_meta)
  
  if(msgBoxCharacter_meta == "yes"){
    quit(save="no")
  }
}



#copy the selected HPLC, QAT and ODF to C:/R_WD/Metadata_per_cruise/cruise_selected_folder_name

if(exists("the_HPLC_file_selected") && the_HPLC_file_selected != ""){
  file.copy(the_HPLC_file_selected, paste0("C:/R_WD/Metadata_per_cruise/", folder_name_selected))
}  

if(exists("the_QAT_file_selected") && the_QAT_file_selected != ""){
  file.copy(the_QAT_file_selected, paste0("C:/R_WD/Metadata_per_cruise/", folder_name_selected))
}

if(exists("the_ODF_file_selected") && the_ODF_file_selected != ""){
  file.copy(the_ODF_file_selected, paste0("C:/R_WD/Metadata_per_cruise/", folder_name_selected))
}

#enter the value for the filter diameter conditioned to numeric >10 <20
values_list <- varEntryDialog(vars=c('filter_diameter'), labels=c('Enter the filter diameter value for the entire cruise (between 10 and 20) in millimeters(mm) as numeric (Example:16.5):'), fun=c(
  function(x) {
    x <- as.numeric(x)
    
    if (is.na(x)){
      x <- 0
    }
    
    if(x >= 10 & x <= 20){
      return(x)
    } else {
      stop("ERROR: Please enter a number between 10 and 20.")
    }
  } ))



filter_diameter <- values_list[["filter_diameter"]]

#filter_diameter <- 16.5




if (is.null(filter_diameter)){
  
  print("ERROR: The filter_diameter value in millimeters (mm) (Ex.:16.5) entered trough Graphycal User Interface needed to calculate the Absorption from Absorbance is not defined (Cancel button has been selected). Please clear the environment and run the R script from the beginning.")
  
  quit_R_Session_message3 <- "ERROR: The filter_diameter value in millimeters (mm) (Ex.:16.5) entered trough Graphycal User Interface needed to calculate the Absorption from Absorbance is not defined (Cancel button has been selected). If you choose No the program will process and plot only the Absorbance files, but it will exit before the R script sequence labeled with #007 at line 365 '003_004_metadata_for_final_file_34_3_absorbance_to_absorption_8_3_2_no_HPLC_stops_enter_fdia_2.R' where it cannot continue to convert Absorbance to Absorption without the filter_diameter numeric value. It is strongly recommended to select the OK button to quit and close the R Session. The R Workspace WILL NOT be saved. Also before the R script sequence will be launched again the directory 'C:/R_WD/WRITE' should be renamed from 'WRITE' to something like 'WRITE_OLD1' or deleted. Continue with closing the R Session? Yes = Recommended"
  
  msgBox_fdia <- tk_messageBox(type = c("yesno"), quit_R_Session_message3, caption = "Continue with closing the R Session?", default = "")
  msgBoxCharacter_fdia <- as.character(msgBox_fdia)
  
  if(msgBoxCharacter_fdia == "yes"){
    quit(save="no")
  }
}



#summary messages with the values selected before proceeding to the next step
message1 <- paste0("The filter_diameter for the selected cruise = ", filter_diameter, " mm         ")
message2 <- paste0("The cruise folder selected for processing = ", input_folder_to_read_files, "   ")
message3 <- paste0("R Work Directory is set to ", getwd(), " as a condition for the code to run. It cannot be changed.                           ")
message4 <- paste0("The HPLC file selected is '", basename(the_HPLC_file_selected), "'   ")
message5 <- paste0("The QAT file selected is '", basename(the_QAT_file_selected), "'                   ")
message6 <- paste0("The ODF file selected is '", basename(the_ODF_file_selected), "'")
message7 <- paste0("All results will be written in ", getwd(), "/WRITE/                       Continue with testing?")

#appending all the messages in one because the tk_messageBox requires vector
message <- append(message1, message2)
message <- append(message, message3)
message <- append(message, message4)
message <- append(message, message5)
message <- append(message, message6)
message <- append(message, message7)

#Continue confirmation box with the message above
tk_messageBox(type = c("yesno"),
              message, caption = "Continue?", default = "")


#warn if "C:/R_WD/WRITE" directory exists
if (dir.exists(paste0(getwd(), "/WRITE"))){
  
  message5 <- paste0("The folder ", getwd(), "/WRITE/ already exists. If you choose Yes, the files will be overwritten. This is not recommended unless the R code runs partially a selection for testing purposes. Are you sure do you want to continue before you rename it or delete it? ")
  
  tk_messageBox(type = c("yesno"),
                message5, caption = "Continue?", default = "", icon = "warning")
  
}else{
  
  message6 <- paste0("The folder ", getwd(), "/WRITE/ does not exists yet which is okay. Continue?")
  
  tk_messageBox(type = c("yesno"),
                message6, caption = "Continue?", default = "")
  
}

###############
###############
###############
#end UI

username <- Sys.info()[["user"]]
sysname <- Sys.info()[["sysname"]]
release <- Sys.info()[["release"]]
R_version_required <- "R version 4.0.4 (2021-02-15)"
R_version_running <- R.Version()$version.string
start_time
getwd()
input_folder_to_read_files
folder_name_selected
coded_cruise_name_entered
the_HPLC_file_selected
the_QAT_file_selected
the_ODF_file_selected
filter_diameter
end_time_UI <- Sys.time()


user_input_last_session <- data.frame(username, sysname, release, R_version_required, R_version_running, start_time, getwd(), input_folder_to_read_files, folder_name_selected, coded_cruise_name_entered, the_HPLC_file_selected, the_QAT_file_selected, the_ODF_file_selected, filter_diameter, end_time_UI)
user_input_last_session <- data.frame(t(user_input_last_session))

dir.create(file.path("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/"), showWarnings = FALSE, recursive = TRUE)


nrows_user_input_last_session <- nrow(user_input_last_session)
write.csv(user_input_last_session, paste0("C:/R_WD/WRITE/METADATA_TEST_BEFORE_PROCEED/", "user_input_last_session_", format(Sys.time(),'%Y-%m-%d_%H-%M-%S_'), nrows_user_input_last_session, "_rows.csv"), row.names = TRUE)


#####################

end_time <- Sys.time()
start_time
end_time





