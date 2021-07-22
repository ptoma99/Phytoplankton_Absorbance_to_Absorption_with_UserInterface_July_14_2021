#001_007_004_copy_Particulate_Detritus_with_Phytoplankton_QC_Comments

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021


#from "C:\R_WD\WRITE\WORKS5\RESULTS\Absorption_3tables_with_metadata"
#to C:\R_WD\WRITE\WORKS7\RESULTS"


start_time <- Sys.time()
print(paste0("start_time = ", start_time))

setwd("C:/R_WD")
getwd()

library("dplyr")

dir.create(file.path("C:/R_WD/WRITE/WORKS7/RESULTS"), showWarnings = FALSE, recursive = TRUE)

folder_to_copy_to <- "C:/R_WD/WRITE/WORKS7/RESULTS/"

#enter folder that contains all the cruises sub folders
input_folder_to_read_files <- "C:/R_WD/WRITE/WORKS5/RESULTS"
write.csv(input_folder_to_read_files, paste0("C:/R_WD/WRITE/WORKS5/", "input_folder_to_read_Par_Det_tables_to_be_copied", ".csv"))



cruise_name_table_location <- "C:/R_WD/folder_name_to_coded_cruise_name_table.csv"
cruise_name_table <- read.table(cruise_name_table_location, skip = 0, sep = ",", header = TRUE)
cruise_name_table_df <- data.frame(cruise_name_table)


input_folder_name <- sub('\\..*$', '', basename(input_folder_to_read_files))
search_result_for_Absorption_Particulate  <- list.files(pattern = "\\_Absorption_Particulate.csv$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_search_result_for_Absorption_Particulate <- length(search_result_for_Absorption_Particulate)
write.csv(search_result_for_Absorption_Particulate, paste0("C:/R_WD/WRITE/WORKS5/", "search_result_for_Absorption_Particulate_", nrows_search_result_for_Absorption_Particulate, "_rows.csv"), row.names = FALSE)

distinct_folders_in_search_result_for_Absorption_Particulate <- unique(dirname(search_result_for_Absorption_Particulate))
distinct_folders_in_search_result_for_Absorption_Particulate_df <- data.frame(distinct_folders_in_search_result_for_Absorption_Particulate)
distinct_folders_in_search_result_for_Absorption_Particulate_df$folder_name <- sub('\\..*$', '', basename(distinct_folders_in_search_result_for_Absorption_Particulate))

#distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df <- inner_join(distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df, cruise_name_table_df, by = c("folder_name"))
distinct_folders_in_search_result_for_Absorption_Particulate_df <- inner_join(distinct_folders_in_search_result_for_Absorption_Particulate_df, cruise_name_table_df, by = c("folder_name"))


nrows_distinct_folders_in_search_result_for_Absorption_Particulate_df <- nrow(distinct_folders_in_search_result_for_Absorption_Particulate_df)
write.csv(distinct_folders_in_search_result_for_Absorption_Particulate_df, paste0("C:/R_WD/WRITE/WORKS5/", "distinct_folders_in_search_result_for_Absorption_Particulate_df_", nrows_distinct_folders_in_search_result_for_Absorption_Particulate_df, "_rows.csv"), row.names = FALSE)


if (nrow(distinct_folders_in_search_result_for_Absorption_Particulate_df) > 0){


for (i in 1:nrow(distinct_folders_in_search_result_for_Absorption_Particulate_df)){
  
  #i <- 1
  
  filepath_to_search <- distinct_folders_in_search_result_for_Absorption_Particulate_df$distinct_folders_in_search_result_for_Absorption_Particulate[i]
  
  
  search_for_Absorption_Particulate  <- list.files(pattern = "\\_Absorption_Particulate.csv$"  , path = filepath_to_search, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
  search_for_Absorption_Detritus <- list.files(pattern = "\\_Absorption_Detritus.csv$"  , path = filepath_to_search, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
  
  #if2
  if (length(search_for_Absorption_Particulate) == 1 && length(search_for_Absorption_Detritus) == 1){
    
    file.copy(search_for_Absorption_Particulate, paste0(folder_to_copy_to, distinct_folders_in_search_result_for_Absorption_Particulate_df$folder_name[i]), overwrite = TRUE)
    file.copy(search_for_Absorption_Detritus, paste0(folder_to_copy_to, distinct_folders_in_search_result_for_Absorption_Particulate_df$folder_name[i]), overwrite = TRUE)
    
    print(paste0("The file ", search_for_Absorption_Particulate, " has been copied in folder ", paste0(folder_to_copy_to, distinct_folders_in_search_result_for_Absorption_Particulate_df$folder_name[i])))
    print(paste0("The file ", search_for_Absorption_Detritus, " has been copied in folder ", paste0(folder_to_copy_to, distinct_folders_in_search_result_for_Absorption_Particulate_df$folder_name[i])))
    
    
     
  #end if2  
  }else{
    
    print(paste0("Please check folder ", distinct_folders_in_search_result_for_Absorption_Particulate_df$folder_name[i], ", must have one Particulate csv table and one Detritus csv table; it does not."))
  #end else if2  
  }
  
  
#end i  
}

#end if 1
}else{
  
  print(paste0("There are no Particulate and Detritus csv tables in folder ", input_folder_to_read_files, ". Please check."))
}




end_time <- Sys.time()
start_time
end_time





