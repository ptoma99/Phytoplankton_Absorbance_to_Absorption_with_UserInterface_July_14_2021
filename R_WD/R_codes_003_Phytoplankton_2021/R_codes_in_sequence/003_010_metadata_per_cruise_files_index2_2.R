#002_010_metadata_per_cruise_files_index2

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021

start_time <- Sys.time()
print(paste0("start_time = ", start_time))

setwd("C:/R_WD")
getwd()

library("dplyr")


dir.create(file.path("C:/R_WD/WRITE/WORKS_Metadata_per_cruise_stats"), showWarnings = FALSE, recursive = TRUE)

#enter folder that contains all the cruises sub folders for Absorbance txt files
input_folder_for_list_dirs <- "C:/R_WD/WRITE/WORKS/RESULTS" #no "/"

write_folder <- "C:/R_WD/WRITE/WORKS_Metadata_per_cruise_stats/"


write.csv(input_folder_for_list_dirs, paste0(write_folder, "input_folder_for_list_dirs", ".csv"))

input_metadata_folder_name <- "C:/R_WD/Metadata_per_cruise"

cruise_name_table_location <- "C:/R_WD/folder_name_to_coded_cruise_name_table.csv"
cruise_name_table <- read.table(cruise_name_table_location, skip = 0, sep = ",", header = TRUE)
cruise_name_table_df <- data.frame(cruise_name_table)

cruise_folders <- basename(list.dirs(input_folder_for_list_dirs, full.names = TRUE, recursive = FALSE))
cruise_folders_df <- data.frame(cruise_folders)

names(cruise_folders_df)[1] <- "folder_name"

Metadata_per_files_index <- left_join(cruise_folders_df, cruise_name_table_df, by = c("folder_name"))



folders_in_metadata_per_cruise <-  basename(list.dirs(input_metadata_folder_name, full.names = TRUE, recursive = FALSE))

folders_in_metadata_per_cruise_df <- data.frame(folders_in_metadata_per_cruise)

names(folders_in_metadata_per_cruise_df)[1] <- "folder_name"

folders_in_metadata_per_cruise_df$folders_in_metadata_per_cruise <- folders_in_metadata_per_cruise_df$folder_name

Metadata_per_files_index2 <- left_join(Metadata_per_files_index, folders_in_metadata_per_cruise_df, by = c("folder_name"))




all_HPLC_xlsx_files <- list.files(pattern = "\\HPLC*"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
all_HPLC_xlsx_files <- grep('~$', all_HPLC_xlsx_files, fixed = TRUE, value = TRUE, invert = TRUE)

all_HPLC_xlsx_files_dirname <- dirname(all_HPLC_xlsx_files)
all_HPLC_xlsx_files_folder_name <- sub('\\..*$', '', basename(all_HPLC_xlsx_files_dirname))
all_HPLC_xlsx_files_file_name <- sub('.*/', '', basename(all_HPLC_xlsx_files))

all_HPLC_xlsx_files_df<- data.frame(all_HPLC_xlsx_files_folder_name)
names(all_HPLC_xlsx_files_df)[1] <- "folder_name"

all_HPLC_xlsx_files_df$HPLC_file_name <- all_HPLC_xlsx_files_file_name

Metadata_per_files_index3 <- left_join(Metadata_per_files_index2, all_HPLC_xlsx_files_df, by = c("folder_name"))



all_QAT_xlsx_files<- list.files(pattern = "\\_QAT*"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
all_QAT_xlsx_files <- grep('~$', all_QAT_xlsx_files, fixed = TRUE, value = TRUE, invert = TRUE)

all_QAT_xlsx_files_dirname <- dirname(all_QAT_xlsx_files)
all_QAT_xlsx_files_folder_name <- sub('\\..*$', '', basename(all_QAT_xlsx_files_dirname))
all_QAT_xlsx_files_file_name <- sub('.*/', '', basename(all_QAT_xlsx_files))

all_QAT_xlsx_files_df <- data.frame(all_QAT_xlsx_files_folder_name)
names(all_QAT_xlsx_files_df)[1] <- "folder_name"

all_QAT_xlsx_files_df$QAT_file_name <- all_QAT_xlsx_files_file_name

Metadata_per_files_index4 <- left_join(Metadata_per_files_index3, all_QAT_xlsx_files_df, by = c("folder_name"))



all_ODF_files<- list.files(pattern = "\\ODF*"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)

all_ODF_files_dirname <- dirname(all_ODF_files)
all_ODF_files_folder_name <- sub('\\..*$', '', basename(all_ODF_files_dirname))
all_ODF_files_file_name <- sub('.*/', '', basename(all_ODF_files))

all_ODF_files_df <- data.frame(all_ODF_files_folder_name)
names(all_ODF_files_df)[1] <- "folder_name"

all_ODF_files_df$ODF_file_name <- all_ODF_files_file_name


Metadata_per_files_index5 <- left_join(Metadata_per_files_index4, all_ODF_files_df, by = c("folder_name"))



# all_dvoldiam_files  <- list.files(pattern = "dvoldiam"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)#i
# 
# all_dvoldiam_files_dirname <- dirname(all_dvoldiam_files)
# all_dvoldiam_files_folder_name <- sub('\\..*$', '', basename(all_dvoldiam_files_dirname))
# all_dvoldiam_files_file_name <- sub('.*/', '', basename(all_dvoldiam_files))
# 
# all_dvoldiam_files_df <- data.frame(all_dvoldiam_files_folder_name)
# names(all_dvoldiam_files_df)[1] <- "folder_name"
# 
# all_dvoldiam_files_df$dvoldiam_file_name <- all_dvoldiam_files_file_name
# 
# Metadata_per_files_index6 <- left_join(Metadata_per_files_index5, all_dvoldiam_files_df, by = c("folder_name"))

#when no dvoldiam
Metadata_per_files_index6 <- Metadata_per_files_index5



nrows_Metadata_per_files_index6 <- nrow(Metadata_per_files_index6)
write.csv(Metadata_per_files_index6, paste0(write_folder, "Metadata_per_files_index_", nrows_Metadata_per_files_index6, "_rows.csv"), row.names = FALSE)



Metadata_stats <- matrix(nrow = 2, ncol = ncol(Metadata_per_files_index6)+1)

Metadata_stats_df <- data.frame(Metadata_stats)

names(Metadata_stats_df)[1] <- "Status"

names(Metadata_stats_df)[2:7] <- names(Metadata_per_files_index6)

Metadata_stats_df[1,1] <- "Present"
Metadata_stats_df[2,1] <- "Absent"

Metadata_stats_df[1,2] <- nrow(cruise_folders_df)
Metadata_stats_df[2,2] <- nrow(cruise_folders_df) - nrow(cruise_folders_df)

Metadata_stats_df[1,3] <- nrow(cruise_name_table_df)
Metadata_stats_df[2,3] <- nrow(cruise_folders_df) - nrow(cruise_name_table_df)


Metadata_stats_df[1,4] <- nrow(folders_in_metadata_per_cruise_df)
Metadata_stats_df[2,4] <- nrow(cruise_folders_df) - nrow(folders_in_metadata_per_cruise_df)


Metadata_stats_df[1,5] <- nrow(all_HPLC_xlsx_files_df)
Metadata_stats_df[2,5] <- nrow(cruise_folders_df) - nrow(all_HPLC_xlsx_files_df)


Metadata_stats_df[1,6] <- nrow(all_QAT_xlsx_files_df)
Metadata_stats_df[2,6] <- nrow(cruise_folders_df) - nrow(all_QAT_xlsx_files_df)


Metadata_stats_df[1,7] <- nrow(all_ODF_files_df)
Metadata_stats_df[2,7] <- nrow(cruise_folders_df) - nrow(all_ODF_files_df)


# Metadata_stats_df[1,8] <- nrow(all_dvoldiam_files_df)
# Metadata_stats_df[2,8] <- nrow(cruise_folders_df) - nrow(all_dvoldiam_files_df)



nrows_Metadata_stats_df <- nrow(Metadata_stats_df)
write.csv(Metadata_stats_df, paste0(write_folder, "Metadata_stats_df_", nrows_Metadata_stats_df, "_rows.csv"), row.names = FALSE)





#####################

end_time <- Sys.time()
start_time
end_time

