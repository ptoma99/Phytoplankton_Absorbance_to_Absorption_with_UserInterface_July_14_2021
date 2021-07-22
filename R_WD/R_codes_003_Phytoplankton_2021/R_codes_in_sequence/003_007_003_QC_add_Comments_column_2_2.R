#001_007_003_QC_add_Comments_column_2

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021


#reads the Phytoplankton final CSV tables with 3 QC flag columns from "C:/R_WD/WRITE/WORKS6/RESULTS"
#writes the Phytoplankton final CSV files with the comments column in "C:/R_WD/WRITE/WORKS7/RESULTS"


start_time <- Sys.time()
print(paste0("start_time = ", start_time))


setwd("C:/R_WD")
getwd()


#library(gdata)
library(dplyr)
#library(lmodel2)
#library(robustbase)
library("readxl")

library("dplyr")
#library("readxl")
library("fs")
library("qdapRegex")
library("stringr")





dir.create(file.path("C:/R_WD/WRITE/WORKS7"), showWarnings = FALSE, recursive = TRUE)

#filepath_to_write_plot <- "C:/R_WD/WRITE/WORKS_QC/"

filepath_to_write_final_with_Comments <- "C:/R_WD/WRITE/WORKS7/RESULTS/"

#input_folder_to_read_txt_files <- "C:/R_WD/WRITE/WORKS/RESULTS"

#enter folder that contains all the cruises sub folders
input_folder_to_read_files <- "C:/R_WD/WRITE/WORKS6/"
write.csv(input_folder_to_read_files, paste0("C:/R_WD/WRITE/WORKS7/", "input_folder_to_read_files", ".csv"))

input_metadata_folder_name <- "C:/R_WD/Metadata_per_cruise"

cruise_name_table_location <- "C:/R_WD/folder_name_to_coded_cruise_name_table.csv"
cruise_name_table <- read.table(cruise_name_table_location, skip = 0, sep = ",", header = TRUE)
cruise_name_table_df <- data.frame(cruise_name_table)



input_folder_name <- sub('\\..*$', '', basename(input_folder_to_read_files))
search_result_for_Absorption_Phytoplankton  <- list.files(pattern = "\\_Absorption_Phytoplankton_QC.csv$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)


search_result_for_Absorption_Phytoplankton_dirname <- dirname(search_result_for_Absorption_Phytoplankton)
search_result_for_Absorption_Phytoplankton_folder_name <- basename(dirname(search_result_for_Absorption_Phytoplankton))

search_result_for_Absorption_Phytoplankton_file_name <- sub('.*/', '', basename(search_result_for_Absorption_Phytoplankton))

search_result_for_Absorption_Phytoplankton_df <- data.frame(search_result_for_Absorption_Phytoplankton)
search_result_for_Absorption_Phytoplankton_df$Phytoplankton_dirname <- search_result_for_Absorption_Phytoplankton_dirname
search_result_for_Absorption_Phytoplankton_df$folder_name <- search_result_for_Absorption_Phytoplankton_folder_name
search_result_for_Absorption_Phytoplankton_df$Phytoplankton_file_name <- search_result_for_Absorption_Phytoplankton_file_name

nrows_search_result_for_Absorption_Phytoplankton_df <- nrow(search_result_for_Absorption_Phytoplankton_df)
write.csv(search_result_for_Absorption_Phytoplankton_df, paste0("C:/R_WD/WRITE/WORKS7/", "search_result_for_Absorption_Phytoplankton_df_", nrows_search_result_for_Absorption_Phytoplankton_df, "_rows.csv"), row.names = FALSE)





#pairing all the files that need metadata with the metadata they need in one table
all_tables_joined_by_folder_name <- inner_join(cruise_name_table_df, search_result_for_Absorption_Phytoplankton_df, by = c("folder_name"))
#all_tables_joined_by_folder_name <- inner_join(all_tables_joined_by_folder_name, all_HPLC_xlsx_files_df, by = c("folder_name"))

nrows_all_tables_joined_by_folder_name <- nrow(all_tables_joined_by_folder_name)
write.csv(all_tables_joined_by_folder_name, paste0("C:/R_WD/WRITE/WORKS7/", "all_tables_joined_by_folder_name_", nrows_all_tables_joined_by_folder_name, "_rows.csv"), row.names = FALSE)

####################


#disable scientific notation in R.
options(scipen = 999)


for (i in 1:nrow(all_tables_joined_by_folder_name)){

  #i <- 1
  
  Absorption_Phytoplankton_filepath <- all_tables_joined_by_folder_name$search_result_for_Absorption_Phytoplankton[i]
  con <- file(Absorption_Phytoplankton_filepath, "r")
  Absorption_Phytoplankton_header <- readLines(con, n=18)
  close(con)
  
  
  Absorption_Phytoplankton <- read.csv(all_tables_joined_by_folder_name$search_result_for_Absorption_Phytoplankton[i],skip=17)
  
  #data.frame(matrix(NA, nrow = 2, ncol = 3))

  Comments_column <- data.frame(matrix("No comments", nrow = nrow(Absorption_Phytoplankton), ncol = 1))

  names(Comments_column)[1] <- "Comments"

  input_folder_to_read_txt_files <- paste0("C:/R_WD/WRITE/WORKS/RESULTS/", all_tables_joined_by_folder_name$folder_name[i])
    
for (j in 1:nrow(Absorption_Phytoplankton)){
  
  #j <- 15
    
  Sample_ID <- Absorption_Phytoplankton$Sample.ID[j]

     
     minus_999_df <- data.frame(matrix(data = -999, nrow = 1, ncol = -8 +ncol(Absorption_Phytoplankton) -3))
      
     all_values_per_sample_ID_df <- data.frame(Absorption_Phytoplankton[j, 9:((ncol(Absorption_Phytoplankton)-3))])
     
     #if1
     if (sum(all_values_per_sample_ID_df) == sum(minus_999_df) && !is.na(Absorption_Phytoplankton$ABS..VOL.L.[j]) && !is.na(Absorption_Phytoplankton$Event.number[j])){  
     
       file_list_txt_d6_only_999_Particulate <- list.files(pattern = paste0(Sample_ID, "\\S+\\-999_Particulate.txt$") , path = input_folder_to_read_txt_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
       file_list_txt_d6_only_999_Detritus    <- list.files(pattern = paste0(Sample_ID, "\\S+\\-999_Detritus.txt$")    , path = input_folder_to_read_txt_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
       
       #if2
       if (length(file_list_txt_d6_only_999_Particulate) == 1 && length(file_list_txt_d6_only_999_Detritus) == 0){
         
         Comments_column$Comments[j] <- "missing Detritus Absorbance txt raw data file "
         
       }else if (length(file_list_txt_d6_only_999_Particulate) == 0 && length(file_list_txt_d6_only_999_Detritus) == 1){
         
         Comments_column$Comments[j] <- "missing Particulate Absorbance txt raw data file"
         
       }else{
         
         Comments_column$Comments[j] <- " ! can't tell - more than one or none missing Particulate or/and Detritus. Please check manually."
       
       #end if2
       }
       
     
     }else if (sum(all_values_per_sample_ID_df) == sum(minus_999_df) && is.na(Absorption_Phytoplankton$ABS..VOL.L.[j]) && !is.na(Absorption_Phytoplankton$Event.number[j])){
       
       Comments_column$Comments[j] <- "The Sample ID is missing from HPLC"
       
     }else if (sum(all_values_per_sample_ID_df) == sum(minus_999_df) && !is.na(Absorption_Phytoplankton$ABS..VOL.L.[j]) && is.na(Absorption_Phytoplankton$Event.number[j])){       
       
       Comments_column$Comments[j] <- "The Sample ID is missing from QAT" 
      
     }else if (sum(all_values_per_sample_ID_df) == sum(minus_999_df) && is.na(Absorption_Phytoplankton$ABS..VOL.L.[j]) && is.na(Absorption_Phytoplankton$Event.number[j])){       
       
       Comments_column$Comments[j] <- "The Sample ID is missing from HPLC and QAT" 
       
       
        
       
  #end if1  
    }else{
    
      Comments_column$Comments[j] <- paste0("No filter diameter specified - used ", filter_diameter, " mm" )
      
  #end else if1    
  }
  

    
#end j    
}


  Absorption_Phytoplankton_with_Comments_no_header <- cbind(Absorption_Phytoplankton, Comments_column)


  Comments_column_name <- "Comments"
  
  Absorption_Phytoplankton_header[18] <- paste0(Absorption_Phytoplankton_header[18],"," , Comments_column_name)
  
  
  
  #filepath_to_write_final_with_Comments
  
  dir.create(file.path(paste0(filepath_to_write_final_with_Comments, all_tables_joined_by_folder_name$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
  
  #paste0(filepath_to_write_final_with_QC_flags, all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_Absorption_Phytoplankton_QC.csv")
  
  #write Phytoplankton final table file with Comments
  write.table(Absorption_Phytoplankton_header, file = paste0(filepath_to_write_final_with_Comments, all_tables_joined_by_folder_name$folder_name[i], "/", all_tables_joined_by_folder_name$coded_cruise_name[i], "_Absorption_Phytoplankton_QC_Comments.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)#i
  write.table(Absorption_Phytoplankton_with_Comments_no_header,  file = paste0(filepath_to_write_final_with_Comments, all_tables_joined_by_folder_name$folder_name[i], "/", all_tables_joined_by_folder_name$coded_cruise_name[i], "_Absorption_Phytoplankton_QC_Comments.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, na = "", append = TRUE)#i


#end i
}


#####################

end_time <- Sys.time()
start_time
end_time












