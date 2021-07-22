#001_002_Create_3_csv_absoption_from_absorbance_801_to_400rows_Files_with_-999_created_3

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021


#for Phytoplankton, Particulate and Detritus - C:\R_WD\WRITE\WORKS\RESULTS\Particulate_Absorbance\OLD_to_NEW\Particulate_Absorbance\Old_Spectro_2005_2014
#located in "C:\R_WD\WRITE\WORKS\RESULTS\Particulate_Absorbance\NewSpectro_2015_continue"

#writes results in "C:\R_WD\WRITE\WORKS2\RESULTS\Abs_tables_all_3\Particulate_Absorbance\NewSpectro_2015_continue\OLD_to_NEW"
#writes reports in ""C:\R_WD\WRITE\WORKS2"

#C:\R_WD\WRITE\WORKS\RESULTS\Particulate_Absorbance\OLD_to_NEW\Particulate_Absorbance\Old_Spectro_2005_2014
#C:\R_WD\WRITE\WORKS\RESULTS\Particulate_Absorbance\OLD_to_NEW\Particulate_Absorbance\Old_Spectro_2005_2014

start_time <- Sys.time()
print(paste0("start_time = ", start_time))

setwd("C:/R_WD")
getwd()


library("dplyr")
library("stringr")



dir.create(file.path("C:/R_WD/WRITE/WORKS2"), showWarnings = FALSE, recursive = TRUE)

#enter folder that contains all the cruises sub folders
input_folder_to_read_files <- "C:/R_WD/WRITE/WORKS/RESULTS" # without "/" at the end
write.csv(input_folder_to_read_files, paste0("C:/R_WD/WRITE/WORKS2/", "input_folder_to_read_files", ".csv"))


input_folder_name <- sub('\\..*$', '', basename(input_folder_to_read_files))
#search_result_d6Phytoplankton_txt_files_processed  <- list.files(pattern = "\\d{6}Phytoplankton.txt$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
search_result_d6Phytoplankton_txt_files_processed  <- list.files(pattern = "\\Phytoplankton.txt$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)



print(paste0("The folder ", "'", input_folder_to_read_files, "'", " has ", length(search_result_d6Phytoplankton_txt_files_processed), " Phytoplankton files."))

d6Phytoplankton_txt_all_files <- data.frame(search_result_d6Phytoplankton_txt_files_processed)
names(d6Phytoplankton_txt_all_files)[1] <- "file_list_d6Phytoplankton_txt"
d6Phytoplankton_txt_all_files$input_folder_name <- input_folder_name

d6Phytoplankton_txt_all_files$d6Phytoplankton_txt_folder_dirname <- dirname(search_result_d6Phytoplankton_txt_files_processed)
nrows_d6Phytoplankton_txt_all_files <- nrow(d6Phytoplankton_txt_all_files)
write.csv(d6Phytoplankton_txt_all_files, paste0("C:/R_WD/WRITE/WORKS2/", "d6Phytoplankton_txt_all_files_", nrows_d6Phytoplankton_txt_all_files, "_rows.csv"), row.names = FALSE)


distinct_d6Phytoplankton_txt_folders <- unique(d6Phytoplankton_txt_all_files$d6Phytoplankton_txt_folder_dirname)
distinct_d6Phytoplankton_txt_folders_df <- data.frame(distinct_d6Phytoplankton_txt_folders)
distinct_d6Phytoplankton_txt_folders_df$folder_name <- sub('\\..*$', '', basename(distinct_d6Phytoplankton_txt_folders))
nrows_distinct_d6Phytoplankton_txt_folders_df <- nrow(distinct_d6Phytoplankton_txt_folders_df)
write.csv(distinct_d6Phytoplankton_txt_folders_df, paste0("C:/R_WD/WRITE/WORKS2/", "distinct_d6Phytoplankton_txt_folders_df_", nrows_distinct_d6Phytoplankton_txt_folders_df, "_rows.csv"), row.names = FALSE)


print(paste0("In folder ", input_folder_name, " found ", length(distinct_d6Phytoplankton_txt_folders), " distinct subfolders projects containing ", length(search_result_d6Phytoplankton_txt_files_processed) , " d6Phytoplancton.txt files listed below:"))
print(distinct_d6Phytoplankton_txt_folders)

log_1 <- data_frame()

for (i in 1:length(distinct_d6Phytoplankton_txt_folders)){
  

input_project_folder <- distinct_d6Phytoplankton_txt_folders[i] #i
  
input_project_folder_name <- sub('\\..*$', '', basename(input_project_folder))
#search_d6Phytoplankton_txt_in_subfolder  <- list.files(pattern = "\\d{6}Phytoplankton.txt$"  , path = input_project_folder, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
search_d6Phytoplankton_txt_in_subfolder  <- list.files(pattern = "\\Phytoplankton.txt$"  , path = input_project_folder, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)

print(paste0("In subfolder ", "'", input_project_folder_name, "'", " found ", length(search_d6Phytoplankton_txt_in_subfolder), " d6Phytoplankton.txt files."))
log1 <- data.frame(paste0("In subfolder ", "'", input_project_folder_name, "'", " found ", length(search_d6Phytoplankton_txt_in_subfolder), " d6Phytoplankton.txt files."))
log_1 <- rbind(log_1, log1)


d6Phytoplankton_project_table <- data.frame()
d6Particulate_project_table <- data.frame()
d6Detritus_project_table <- data.frame()

for (j in 1:length(search_d6Phytoplankton_txt_in_subfolder)){
  
d6Phytoplankton_txt_file <- read.table(search_d6Phytoplankton_txt_in_subfolder[j], skip = 1, sep = ",", header = TRUE) #j

#remove even rows - from 801 make 401 and then remove the last 750.00 to match old spectro format 400 rows
#GDPUK[seq(1,nrows(GDPUK),by=4),]
d6Phytoplankton_txt_file <- d6Phytoplankton_txt_file[seq(1,nrow(d6Phytoplankton_txt_file),by=2),]
d6Phytoplankton_txt_file <- d6Phytoplankton_txt_file[1:nrow(d6Phytoplankton_txt_file) - 1,]


d6_string <- sub('\\Phytoplankton.txt', '', basename(search_d6Phytoplankton_txt_in_subfolder[j])) #j


d6_string <- sub('_-999_nodet_', '', d6_string)
d6_string <- sub('_-999_nopar_', '', d6_string)


d6_string_df <- data.frame(as.character(d6_string))


d6Phytoplankton_txt_file_df <- data.frame(lapply(d6Phytoplankton_txt_file, as.numeric))

d6Phytoplankton_txt_file_df[,1] <- format(d6Phytoplankton_txt_file_df[,1], digits = 2, nsmall = 2)
d6Phytoplankton_txt_file_df[,2] <- format(d6Phytoplankton_txt_file_df[,2], digits = 3, nsmall = 3)
d6Phytoplankton_txt_file_df[,3] <- format(d6Phytoplankton_txt_file_df[,3], digits = 3, nsmall = 3)
d6Phytoplankton_txt_file_df[,4] <- format(d6Phytoplankton_txt_file_df[,4], digits = 3, nsmall = 3)

d6Phytoplankton_txt_file_df_t <- data.frame(t(d6Phytoplankton_txt_file_df))

Wavelength_Pattern <- data.frame(d6Phytoplankton_txt_file_df_t[1,])
key_cell_1 <- "Wavelength_nm - d6_string"
baserow_pattern_once <- cbind(key_cell_1, Wavelength_Pattern)


abs_Phytoplankton_values <- data.frame(d6Phytoplankton_txt_file_df_t[4,])
abs_Particulate_values <- data.frame(d6Phytoplankton_txt_file_df_t[2,])
abs_Detritus_values <- data.frame(d6Phytoplankton_txt_file_df_t[3,])


row_to_rbind_Phytoplankton <- cbind(d6_string_df, abs_Phytoplankton_values)
row_to_rbind_Particulate <- cbind(d6_string_df, abs_Particulate_values)
row_to_rbind_Detritus <- cbind(d6_string_df, abs_Detritus_values)


d6Phytoplankton_project_table <- rbind(d6Phytoplankton_project_table, row_to_rbind_Phytoplankton)
d6Particulate_project_table <- rbind(d6Particulate_project_table, row_to_rbind_Particulate)
d6Detritus_project_table <- rbind(d6Detritus_project_table, row_to_rbind_Detritus)

}

#get filepath to write

# filepath_to_write_d6_project_tables_df <- data.frame()
# 
# filepath_to_write_d6_project_tables <- input_project_folder
# string <- filepath_to_write_d6_project_tables            
# pattern <- "C:/R_WD/WRITE/WORKS/RESULTS/"
# replacement <- "C:/R_WD/WRITE/WORKS2/RESULTS/Abs_tables_all_3/"
# filepath_to_write_d6_project_tables <- str_replace(string, pattern, replacement)
# filepath_to_write_d6_project_tables <- paste0(file.path(filepath_to_write_d6_project_tables), "/")
# # filepath_to_write_d6_project_tables_df1 <- data.frame(filepath_to_write_d6_project_tables)
# # filepath_to_write_d6_project_tables_df <- rbind(filepath_to_write_d6_project_tables_df, filepath_to_write_d6_project_tables_df1)

filepath_to_write_d6_project_tables <- paste0("C:/R_WD/WRITE/WORKS2/RESULTS/", basename(distinct_d6Phytoplankton_txt_folders[i]), "/")




#write tables

dir.create(file.path(filepath_to_write_d6_project_tables), showWarnings = FALSE, recursive = TRUE)

names(baserow_pattern_once)[1] <- names(d6Phytoplankton_project_table)[1]

d6Phytoplankton_project_table <- rbind(baserow_pattern_once, d6Phytoplankton_project_table)
write.table(d6Phytoplankton_project_table, file = paste0(filepath_to_write_d6_project_tables, "d6Phytoplankton_project_table", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)

d6Particulate_project_table <- rbind(baserow_pattern_once, d6Particulate_project_table)
write.table(d6Particulate_project_table, file = paste0(filepath_to_write_d6_project_tables, "d6Particulate_project_table", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)

d6Detritus_project_table <- rbind(baserow_pattern_once, d6Detritus_project_table)
write.table(d6Detritus_project_table, file = paste0(filepath_to_write_d6_project_tables, "d6Detritus_project_table", ".csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)


}

#write log_1 file in R_WD\WRITE\WORKS2
nrows_log_1 <- nrow(log_1)
write.csv(log_1, paste0("C:/R_WD/WRITE/WORKS2/", "log_1_files_in_project_", nrows_log_1, "_rows.csv"), row.names = FALSE)



end_time <- Sys.time()
start_time
end_time





