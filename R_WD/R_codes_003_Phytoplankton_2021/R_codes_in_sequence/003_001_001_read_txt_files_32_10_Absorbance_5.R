#003_001_001_read_txt_files_32_10_Absorbance_5

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021


#reads all .txt files with 6 numbers(d6.txt) in the filename and 6 numbers and letter "p"(d6p.txt) located in folder input_folder_to_read_files "C:/DATA_READ/Particulate_Absorbance/NewSpectro_2015_continue"
#keeping the subdirectories structure, creates:
#1. from d6.txt creates d6Particulate.txt
#2. from d6p.txt creates d6Detritus.txt
#3. from d6.txt and d6p.txt creates d6Phytoplankton.txt substracting Detritus values from Particulate values
#writes results in "C:\R_WD\WRITE\WORKS\RESULTS"
#writes reports in ""C:\R_WD\WRITE\WORKS"



start_time <- Sys.time()
print(paste0("start_time = ", start_time))

# dir.create(file.path("C:/R_WD"), showWarnings = FALSE)
# dir.create(file.path("C:/R_WD/WRITE"), showWarnings = FALSE)
# dir.create(file.path("C:/R_WD/WRITE/WORKS"), showWarnings = FALSE)
# dir.create(file.path("C:/R_WD/WRITE/WORKS/d6_d6p_txt_first_lines/"), showWarnings = FALSE)
dir.create(file.path("C:/R_WD/WRITE/WORKS/d6_d6p_txt_first_lines/d6_txt_first_lines/"), showWarnings = FALSE, recursive = TRUE)
dir.create(file.path("C:/R_WD/WRITE/WORKS/d6_d6p_txt_first_lines/d6p_txt_first_lines/"), showWarnings = FALSE, recursive = TRUE)


setwd("C:/R_WD")
getwd()


#install.packages("reader")

library("reader")
library("dplyr")
library("tidyr")
library("stringr")
library("R.utils")

#CHANGE \ TO / IN FOLDER PATH
#input_folder_to_read_files <- "C:/DATA_READ/Particulate_Absorbance/ONE_FOLDER/AMU2019-001 Lab sea" #no "/"
input_folder_to_read_written_files <- "C:/R_WD/WRITE/WORKS/RESULTS"

write.csv(input_folder_to_read_files, paste0("C:/R_WD/WRITE/WORKS/", "input_folder_to_read_files", ".csv"))

file_list <- list.files(path = input_folder_to_read_files, '*.*', all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
l_fl <- length(file_list)

nrows_file_list <- length(file_list)
write.csv(file_list, paste0("C:/R_WD/WRITE/WORKS/", "file_list_by_extension_all_", nrows_file_list, "_rows.csv"))

file_extensions <- character()

for (i in 1:l_fl) {
file_extensions1 <- get.ext(file_list[i])
#file_extensions <- sub('\\..*$', '', basename(file_extensions))

file_extensions <- append(file_extensions1, file_extensions)

}

file_extensions <- unique(file_extensions)
file_extensions <- sort(file_extensions)
l_fe <- length(file_extensions)

print(file_extensions)

file_extensions_df <- data.frame(1:length(file_extensions), file_extensions)
names(file_extensions_df)[1] <- "Num_Row"
names(file_extensions_df)[2] <- "File_Extension"

nrows_file_extensions_df <- nrow(file_extensions_df)
write.csv(file_extensions_df, paste0("C:/R_WD/WRITE/WORKS/", "file_extensions_df_has_", nrows_file_extensions_df, "_rows.csv"), row.names = FALSE)

#############

#search_by_file_extension_txt

extension_to_search_for_txt <- '*.txt'
file_list_by_extension_txt <- list.files(path = input_folder_to_read_files, extension_to_search_for_txt, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_file_list_by_extension_txt <- length(file_list_by_extension_txt)
write.csv(file_list_by_extension_txt, paste0("C:/R_WD/WRITE/WORKS/", "file_list_by_extension_txt_", nrows_file_list_by_extension_txt, "_rows.csv"), row.names = FALSE)

##########

file_list_txt <- list.files(pattern = "\\.txt$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_file_list_txt <- length(file_list_txt)
write.csv(file_list_txt, paste0("C:/R_WD/WRITE/WORKS/", "file_list_txt_", nrows_file_list_txt, "_rows.csv"), row.names = FALSE)

file_list_txt_d6 <- list.files(pattern = "\\d{6}.txt$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_file_list_txt_d6 <- length(file_list_txt_d6)
write.csv(file_list_txt_d6, paste0("C:/R_WD/WRITE/WORKS/", "file_list_txt_d6_", nrows_file_list_txt_d6, "_rows.csv"), row.names = FALSE)

file_list_txt_d6p <- list.files(pattern = "\\d{6}p.txt$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_file_list_txt_d6p <- length(file_list_txt_d6p)
write.csv(file_list_txt_d6p, paste0("C:/R_WD/WRITE/WORKS/", "file_list_txt_d6p_", nrows_file_list_txt_d6p, "_rows.csv"), row.names = FALSE)

file_list_txt_d6_and_p <- append(file_list_txt_d6, file_list_txt_d6p)
nrows_file_list_txt_d6_and_p <- length(file_list_txt_d6_and_p)
write.csv(file_list_txt_d6_and_p, paste0("C:/R_WD/WRITE/WORKS/", "file_list_txt_d6_and_p_", nrows_file_list_txt_d6_and_p, "_rows.csv"), row.names = FALSE)

file_list_txt_without_d6_d6p <- setdiff(file_list_txt, file_list_txt_d6_and_p)
nrows_file_list_txt_without_d6_d6p <- length(file_list_txt_without_d6_d6p)
write.csv(file_list_txt_without_d6_d6p, paste0("C:/R_WD/WRITE/WORKS/", "file_list_txt_without_d6_d6p_", nrows_file_list_txt_without_d6_d6p, "_rows.csv"), row.names = FALSE)


# file_list_txt_d6pdn <- list.files(pattern = "\\d{6}\\D{1}\\.txt", path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
# file_list_txt_d6pdn <- list.files(pattern = "\\d{6}\\D+\\.txt", path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
file_list_txt_d6_S <- list.files(pattern = "\\d{6}\\S+\\.txt", path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_file_list_txt_d6_S <- length(file_list_txt_d6_S)
write.csv(file_list_txt_d6_S, paste0("C:/R_WD/WRITE/WORKS/", "file_list_txt_d6_S_", nrows_file_list_txt_d6_S, "_rows.csv"), row.names = FALSE)


file_list_txt_d6_S_without_d6p <- setdiff(file_list_txt_d6_S, file_list_txt_d6p)
nrows_file_list_txt_d6_S_without_d6p <- length(file_list_txt_d6_S_without_d6p)
write.csv(file_list_txt_d6_S_without_d6p, paste0("C:/R_WD/WRITE/WORKS/", "file_list_txt_d6_S_without_d6p_", nrows_file_list_txt_d6_S_without_d6p, "_rows.csv"), row.names = FALSE)

# #manually writing the files that must be renamed
# file_list_txt_D2 <- list.files(pattern = "\\d{6}\\D{2}\\.txt", path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
# file_list_txt_r <- list.files(pattern = "\\d{6}r\\.txt", path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
# file_list_txt_D2_and_r <- append(file_list_txt_D2, file_list_txt_r)
# files_identified_to_be_renamed <- file_list_txt_D2_and_r
# nrows_files_identified_to_be_renamed <- length(files_identified_to_be_renamed)
# write.csv(files_identified_to_be_renamed, paste0("C:/R_WD/WRITE/WORKS/", "files_identified_to_be_renamed_", nrows_files_identified_to_be_renamed, "_rows.csv"), row.names = FALSE)


#########


#d6 = txt files with just 6 numbers in the filename
file_list_txt_d6_df <- data.frame(file_list_txt_d6)
file_list_txt_d6_df$dirname <- dirname(file_list_txt_d6_df[,1])
file_list_txt_d6_df$filename_ext_d6 <- sub('.*/', '', file_list_txt_d6_df$file_list_txt_d6)
file_list_txt_d6_df$filename_d6 <- sub('\\.txt$', '', file_list_txt_d6_df$filename_ext_d6)
file_list_txt_d6_df$file <- file_list_txt_d6_df$filename_d6
file_list_txt_d6_df$folder_name <- sub('\\..*$', '', basename(dirname(file_list_txt_d6_df[,1])))

#add num row
NumRow_for_file_list_txt_d6_df <- data.frame(NumRow_d6 = 1:nrow(file_list_txt_d6_df))
file_list_txt_d6_df_with_NumRow <- cbind(NumRow_for_file_list_txt_d6_df, file_list_txt_d6_df)

nrows_file_list_txt_d6_df_with_NumRow <- nrow(file_list_txt_d6_df_with_NumRow)
write.csv(file_list_txt_d6_df_with_NumRow, paste0("C:/R_WD/WRITE/WORKS/", "file_list_txt_d6_df_with_NumRow_", nrows_file_list_txt_d6_df_with_NumRow, "_rows.csv"), row.names = FALSE)

#check for duplicates in d6 txt
duplicates_in_file_list_txt_d6_df_with_NumRow <- file_list_txt_d6_df_with_NumRow %>%
  group_by(filename_d6)%>% filter(n() >1)
 
nrows_duplicates_in_file_list_txt_d6_df_with_NumRow <- nrow(duplicates_in_file_list_txt_d6_df_with_NumRow)
write.csv(duplicates_in_file_list_txt_d6_df_with_NumRow, paste0("C:/R_WD/WRITE/WORKS/", "duplicates_in_file_list_txt_d6_df_with_NumRow_", nrows_duplicates_in_file_list_txt_d6_df_with_NumRow, "_rows.csv"), row.names = FALSE)
#found 1 duplicate, 438116.txt, same filename but different data


###########


#d6p = txt files with just 6 numbers AND letter p in the filename
file_list_txt_d6p_df <- data.frame(file_list_txt_d6p)
file_list_txt_d6p_df$dirname <- dirname(file_list_txt_d6p_df[,1])
file_list_txt_d6p_df$filename_ext_d6p <- sub('.*/', '', file_list_txt_d6p_df$file_list_txt_d6p)
file_list_txt_d6p_df$filename_d6p <- sub('\\.txt$', '', file_list_txt_d6p_df$filename_ext_d6p)
file_list_txt_d6p_df$filename_d6p_no_p <- sub('p', '', file_list_txt_d6p_df$filename_d6p)
file_list_txt_d6p_df$file <- file_list_txt_d6p_df$filename_d6p_no_p
file_list_txt_d6p_df$folder_name <- sub('\\..*$', '', basename(dirname(file_list_txt_d6p_df[,1])))


#add num row
NumRow_for_file_list_txt_d6p_df <- data.frame(NumRow_d6p = 1:nrow(file_list_txt_d6p_df))
file_list_txt_d6p_df_with_NumRow <- cbind(NumRow_for_file_list_txt_d6p_df, file_list_txt_d6p_df)

nrows_file_list_txt_d6p_df_with_NumRow <- nrow(file_list_txt_d6p_df_with_NumRow)
write.csv(file_list_txt_d6p_df_with_NumRow, paste0("C:/R_WD/WRITE/WORKS/", "file_list_txt_d6p_df_with_NumRow_", nrows_file_list_txt_d6p_df_with_NumRow, "_rows.csv"), row.names = FALSE)

#check for duplicates in d6p txt
duplicates_in_file_list_txt_d6p_df_with_NumRow <- file_list_txt_d6p_df_with_NumRow %>%
  group_by(filename_d6p)%>% filter(n() >1)

nrows_duplicates_in_file_list_txt_d6p_df_with_NumRow <- nrow(duplicates_in_file_list_txt_d6p_df_with_NumRow)
write.csv(duplicates_in_file_list_txt_d6p_df_with_NumRow, paste0("C:/R_WD/WRITE/WORKS/", "duplicates_in_file_list_txt_d6p_df_with_NumRow_", nrows_duplicates_in_file_list_txt_d6p_df_with_NumRow, "_rows.csv"), row.names = FALSE)
#found 1 duplicate, 438116p.txt, same filename but different data


##############

#inner_join d6p.txt in d6.txt
d6p_txt_that_ARE_in_d6_txt <- inner_join(file_list_txt_d6p_df_with_NumRow, file_list_txt_d6_df_with_NumRow, by = c("file", "dirname", "folder_name"))
nrows_d6p_txt_that_ARE_in_d6_txt <- nrow(d6p_txt_that_ARE_in_d6_txt)
write.csv(d6p_txt_that_ARE_in_d6_txt, paste0("C:/R_WD/WRITE/WORKS/", "final_d6p_txt_that_ARE_in_d6_txt_before_nrow_error_", nrows_d6p_txt_that_ARE_in_d6_txt, "_rows.csv"), row.names = FALSE)

#inner_join d6.txt in d6p.txt
d6_txt_that_ARE_in_d6p_txt <- inner_join(file_list_txt_d6_df_with_NumRow, file_list_txt_d6p_df_with_NumRow, by = c("file", "dirname", "folder_name"))
nrows_d6_txt_that_ARE_in_d6p_txt <- nrow(d6_txt_that_ARE_in_d6p_txt)
write.csv(d6_txt_that_ARE_in_d6p_txt, paste0("C:/R_WD/WRITE/WORKS/", "final_d6_txt_that_ARE_in_d6p_txt_before_nrow_error_", nrows_d6_txt_that_ARE_in_d6p_txt, "_rows.csv"), row.names = FALSE)


#create '%!in%' as reverse condition operator for '%in%'
'%!in%' <- function(x,y)!('%in%'(x,y))

#filter d6p.txt that ARE NOT in d6.txt
d6p_txt_that_ARE_NOT_in_d6_txt <- file_list_txt_d6p_df_with_NumRow %>%
  select(everything()) %>%
  filter(file %!in% c(file_list_txt_d6_df_with_NumRow$file))

nrows_d6p_txt_that_ARE_NOT_in_d6_txt <- nrow(d6p_txt_that_ARE_NOT_in_d6_txt)
write.csv(d6p_txt_that_ARE_NOT_in_d6_txt, paste0("C:/R_WD/WRITE/WORKS/", "d6p_txt_that_ARE_NOT_in_d6_txt_before_nrow_error_", nrows_d6p_txt_that_ARE_NOT_in_d6_txt, "_rows.csv"), row.names = FALSE)

 
#filter d6.txt that ARE NOT in d6p.txt
d6_txt_that_ARE_NOT_in_d6p_txt <- file_list_txt_d6_df_with_NumRow %>%
  select(everything()) %>%
  filter(file %!in% c(file_list_txt_d6p_df_with_NumRow$file))

nrows_d6_txt_that_ARE_NOT_in_d6p_txt <- nrow(d6_txt_that_ARE_NOT_in_d6p_txt)
write.csv(d6_txt_that_ARE_NOT_in_d6p_txt, paste0("C:/R_WD/WRITE/WORKS/", "d6_txt_that_ARE_NOT_in_d6p_txt_before_nrow_error_", nrows_d6_txt_that_ARE_NOT_in_d6p_txt, "_rows.csv"), row.names = FALSE)

#########

#search_d6p_txt_that_ARE_NOT_in_d6_txt

if(nrow(d6p_txt_that_ARE_NOT_in_d6_txt)>0){
  

l2 <- nrow(d6p_txt_that_ARE_NOT_in_d6_txt)

input_folder_to_search_df <- data.frame()
string_to_search_df <- data.frame()
search_d6p_txt_that_ARE_NOT_in_d6_txt_df <- data.frame()
search_d6p_txt_that_ARE_NOT_in_d6_txt_df1 <- data.frame()

for (i in 1:l2){
  
  search_result <- as.character(list.files(path = input_folder_to_read_files, d6p_txt_that_ARE_NOT_in_d6_txt$file[i], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE))
  search_result_df <- data.frame(search_result)
  l4 <- length(search_result)
  
  input_folder_to_search <- input_folder_to_read_files
  input_folder_to_search_df[1:l4,1] <- data.frame(input_folder_to_search)
  
  string_to_search <- d6p_txt_that_ARE_NOT_in_d6_txt$file[i]
  string_to_search_df[1:l4,1] <- data.frame(string_to_search)
  
  search_d6p_txt_that_ARE_NOT_in_d6_txt_df1 <- cbind(input_folder_to_search_df, string_to_search_df, search_result_df)
  search_d6p_txt_that_ARE_NOT_in_d6_txt_df <- rbind(search_d6p_txt_that_ARE_NOT_in_d6_txt_df, search_d6p_txt_that_ARE_NOT_in_d6_txt_df1)
  
  input_folder_to_search_df <- data.frame()
  string_to_search_df <- data.frame()
  search_d6p_txt_that_ARE_NOT_in_d6_txt_df1 <- data.frame()
  
}



NumRow_for_search_d6p_txt_that_ARE_NOT_in_d6_txt_df <- data.frame(NumRow = 1:nrow(search_d6p_txt_that_ARE_NOT_in_d6_txt_df))
search_d6p_txt_that_ARE_NOT_in_d6_txt_df <- cbind(NumRow_for_search_d6p_txt_that_ARE_NOT_in_d6_txt_df, search_d6p_txt_that_ARE_NOT_in_d6_txt_df)

nrows_search_d6p_txt_that_ARE_NOT_in_d6_txt_df <- nrow(search_d6p_txt_that_ARE_NOT_in_d6_txt_df)
write.csv(search_d6p_txt_that_ARE_NOT_in_d6_txt_df, paste0("C:/R_WD/WRITE/WORKS/", "search_d6p_txt_that_ARE_NOT_in_d6_txt_df_", nrows_search_d6p_txt_that_ARE_NOT_in_d6_txt_df, "_rows.csv"), row.names = FALSE)

}

########

#search_d6_txt_that_ARE_NOT_in_d6p_txt

if(nrow(d6_txt_that_ARE_NOT_in_d6p_txt)>0){
  

l2 <- nrow(d6_txt_that_ARE_NOT_in_d6p_txt)

input_folder_to_search_df <- data.frame()
string_to_search_df <- data.frame()
search_d6_txt_that_ARE_NOT_in_d6p_txt_df <- data.frame()
search_d6_txt_that_ARE_NOT_in_d6p_txt_df1 <- data.frame()

for (i in 1:l2){

  search_result <- as.character(list.files(path = input_folder_to_read_files, d6_txt_that_ARE_NOT_in_d6p_txt$file[i], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE))
  search_result_df <- data.frame(search_result)
  l4 <- length(search_result)
  
  input_folder_to_search <- input_folder_to_read_files
  input_folder_to_search_df[1:l4,1] <- data.frame(input_folder_to_search)
  
  string_to_search <- d6_txt_that_ARE_NOT_in_d6p_txt$file[i]
  string_to_search_df[1:l4,1] <- data.frame(string_to_search)
  
  search_d6_txt_that_ARE_NOT_in_d6p_txt_df1 <- cbind(input_folder_to_search_df, string_to_search_df, search_result_df)
  search_d6_txt_that_ARE_NOT_in_d6p_txt_df <- rbind(search_d6_txt_that_ARE_NOT_in_d6p_txt_df, search_d6_txt_that_ARE_NOT_in_d6p_txt_df1)
  
  input_folder_to_search_df <- data.frame()
  string_to_search_df <- data.frame()
  search_d6_txt_that_ARE_NOT_in_d6p_txt_df1 <- data.frame()
  
}

NumRow_for_search_d6_txt_that_ARE_NOT_in_d6p_txt_df <- data.frame(NumRow = 1:nrow(search_d6_txt_that_ARE_NOT_in_d6p_txt_df))
search_d6_txt_that_ARE_NOT_in_d6p_txt_df <- cbind(NumRow_for_search_d6_txt_that_ARE_NOT_in_d6p_txt_df, search_d6_txt_that_ARE_NOT_in_d6p_txt_df)

nrows_search_d6_txt_that_ARE_NOT_in_d6p_txt_df <- nrow(search_d6_txt_that_ARE_NOT_in_d6p_txt_df)
write.csv(search_d6_txt_that_ARE_NOT_in_d6p_txt_df, paste0("C:/R_WD/WRITE/WORKS/", "search_d6_txt_that_ARE_NOT_in_d6p_txt_df_", nrows_search_d6_txt_that_ARE_NOT_in_d6p_txt_df, "_rows.csv"), row.names = FALSE)

}

#########


#full_join d6.txt in d6p.txt
d6_txt_that_ARE_in_d6p_txt_full_join <- full_join(file_list_txt_d6_df_with_NumRow, file_list_txt_d6p_df_with_NumRow, by = c("file", "dirname", "folder_name"))
nrows_d6_txt_that_ARE_in_d6p_txt_full_join <- nrow(d6_txt_that_ARE_in_d6p_txt_full_join)
write.csv(d6_txt_that_ARE_in_d6p_txt_full_join, paste0("C:/R_WD/WRITE/WORKS/", "d6_txt_that_ARE_in_d6p_txt_full_join_", nrows_d6_txt_that_ARE_in_d6p_txt_full_join, "_rows.csv"), row.names = FALSE)


#creating d6 d6p txt related data frame without NA
d6_d6p_txt_related <- d6_txt_that_ARE_in_d6p_txt_full_join
d6_d6p_txt_related_without_NA <- d6_d6p_txt_related %>% drop_na()

nrows_d6_d6p_txt_related_without_NA <- nrow(d6_d6p_txt_related_without_NA)
write.csv(d6_d6p_txt_related_without_NA, paste0("C:/R_WD/WRITE/WORKS/", "d6_d6p_txt_related_without_NA_ini_only_paired_", nrows_d6_d6p_txt_related_without_NA, "_rows.csv"), row.names = FALSE)

d6_txt_file <- read.table(d6_d6p_txt_related_without_NA$file_list_txt_d6[1], skip = 1, sep = ",", header = TRUE)
d6p_txt_file <- read.table(d6_d6p_txt_related_without_NA$file_list_txt_d6p[1], skip = 1, sep = ",", header = TRUE)
#801 obs of 2 vars (400 for old)

##############################################################

#check if all d6 and d6p files have 801 records


#for d6

l <- nrow(d6_d6p_txt_related_without_NA)

nrow_d6_txt <- numeric()
d6_txt_filepath <- character()
nrow_d6_txt_err <- numeric()
d6_txt_filepath_err <- character()
d6_txt_filepath_unsorted_err <- character()
d6_txt_filepath_wavelength_scale_err <- character()
d6_txt_filepath_wavelength_scale_err2 <- character()
d6_txt_err_line_j2 <- numeric()
d6_txt_filepath_unsorted_err2 <- character()

for (i in 1:l) {
  d6_txt_file <- read.table(d6_d6p_txt_related_without_NA$file_list_txt_d6[i], skip = 1, sep = ",", header = TRUE)
  nrow_d6_txt1 <- nrow(d6_txt_file)
  nrow_d6_txt <- append(nrow_d6_txt, nrow_d6_txt1)
  d6_txt_filepath1 <- as.character(d6_d6p_txt_related_without_NA$file_list_txt_d6[i])
  d6_txt_filepath <- append(d6_txt_filepath, d6_txt_filepath1)
  
  if (nrow_d6_txt1 == 801){ 
  
 #TRUE for sorted ascending d6_txt_file Wavelength
    if (!is.unsorted(d6_txt_file[,1], strictly = TRUE) == FALSE){
        
      d6_txt_filepath_unsorted_err1 <- as.character(d6_d6p_txt_related_without_NA$file_list_txt_d6[i])
      d6_txt_filepath_unsorted_err <- append(d6_txt_filepath_unsorted_err, d6_txt_filepath_unsorted_err1)
      #i_count <- i
      #print(i)
    }
    
    #check if all d6 txt files have the same wavelength column as the first one
    d6_txt_file_1st <- read.table(d6_d6p_txt_related_without_NA$file_list_txt_d6[1], skip = 1, sep = ",", header = TRUE)

          l1 <- nrow(d6_txt_file_1st)  
          for (j in 1:l1){
            
            #if(d6_txt_file[j,1] != d6_txt_file_1st[j,1]){
            if(d6_txt_file[j,1] != d6_txt_file_1st[j,1]){
              d6_txt_filepath_unsorted_err21 <- as.character(d6_d6p_txt_related_without_NA$file_list_txt_d6[i])
              d6_txt_filepath_unsorted_err2 <- append(d6_txt_filepath_unsorted_err2, d6_txt_filepath_unsorted_err21)
              d6_txt_err_line_j2 <- append(d6_txt_err_line_j2, j)
              
            }
        }
   }
  
  if (nrow_d6_txt1 != 801){
    print("File length ERROR: nrow_d6_txt1 is not equal to 801, but to ", nrow_d6_txt1)
    print(nrow_d6_txt1)
    nrow_d6_txt_err1 <- nrow(d6_txt_file)
    nrow_d6_txt_err <- append(nrow_d6_txt_err, nrow_d6_txt_err1)
    
    print(d6_txt_filepath1)
    d6_txt_filepath_err1 <- as.character(d6_d6p_txt_related_without_NA$file_list_txt_d6[i])
    d6_txt_filepath_err <- append(d6_txt_filepath_err, d6_txt_filepath_err1)
    
  }
  
  }

d6_txt_nrow_filepath_NROW_ERR_df <- data.frame(nrow_d6_txt_err, d6_txt_filepath_err)
d6_txt_nrow_filepath_NROW_ERR_df$dirname <- dirname(d6_txt_nrow_filepath_NROW_ERR_df$d6_txt_filepath_err)
d6_txt_nrow_filepath_NROW_ERR_df$folder_name <- basename(d6_txt_nrow_filepath_NROW_ERR_df$dirname)
d6_txt_nrow_filepath_NROW_ERR_df$filename_ext <- sub('.*/', '', d6_txt_nrow_filepath_NROW_ERR_df$d6_txt_filepath_err)

nrows_d6_txt_nrow_filepath_NROW_ERR_df <- nrow(d6_txt_nrow_filepath_NROW_ERR_df)
write.csv(d6_txt_nrow_filepath_NROW_ERR_df, paste0("C:/R_WD/WRITE/WORKS/", "final_d6_txt_nrow_filepath_NROW_ERR_df_", nrows_d6_txt_nrow_filepath_NROW_ERR_df, "_rows.csv"), row.names = FALSE)


#copy the pair(d6p) of  d6 files if any d6 has file length error(<801) in "C:/R_WD/WRITE/WORKS/FILE_LENGTH_ERROR_THE_PAIR/"

if (nrow(d6_txt_nrow_filepath_NROW_ERR_df) > 0){
  
  for (m in 1:nrow(d6_txt_nrow_filepath_NROW_ERR_df)){
    
       
    
    
    dir.create(path = paste0("C:/R_WD/WRITE/WORKS/FILE_LENGTH_ERROR_THE_PAIR/", d6_txt_nrow_filepath_NROW_ERR_df$folder_name[m]), showWarnings = FALSE, recursive = TRUE)
    
    filename_d6 <- d6_txt_nrow_filepath_NROW_ERR_df$filename_ext[m]
    string <- filename_d6            
    pattern <- ".txt"
    replacement <- "p.txt"
    filename_d6p_from_d6 <- str_replace(string, pattern, replacement)
    
    
    d6_txt_file_nrow <- read.table(paste0(d6_txt_nrow_filepath_NROW_ERR_df$dirname[m], "/", filename_d6p_from_d6), skip = 1, sep = ",", header = TRUE)
    
    if (nrow(d6_txt_file_nrow) == 801){
    
    file.copy(paste0(d6_txt_nrow_filepath_NROW_ERR_df$dirname[m], "/", filename_d6p_from_d6), paste0("C:/R_WD/WRITE/WORKS/FILE_LENGTH_ERROR_THE_PAIR/", d6_txt_nrow_filepath_NROW_ERR_df$folder_name[m]), overwrite = TRUE)
  
    }else{
      
      print(paste0("The pair of file length error ", paste0(d6_txt_nrow_filepath_NROW_ERR_df$dirname[m], "/", filename_d6p_from_d6), " has file length error as well. Particulate, Detritus or Phytoplankton Absorbance file will NOT BE written for the Sample ID."))
     
    #end if  
    }  
      
  #end m    
  }
  
#end if  
}




###################

###########


#for d6p


l <- nrow(d6_d6p_txt_related_without_NA)

nrow_d6p_txt <- numeric()
d6p_txt_filepath <- character()
nrow_d6p_txt_err <- numeric()
d6p_txt_filepath_err <- character()
d6p_txt_filepath_unsorted_err <- character()
d6p_txt_filepath_wavelength_scale_err <- character()
d6p_txt_filepath_wavelength_scale_err2 <- character()
d6p_txt_err_line_j2 <- numeric()
d6p_txt_filepath_unsorted_err2 <- character()

for (i in 1:l) {
  d6p_txt_file <- read.table(d6_d6p_txt_related_without_NA$file_list_txt_d6p[i], skip = 1, sep = ",", header = TRUE)
  nrow_d6p_txt1 <- nrow(d6p_txt_file)
  nrow_d6p_txt <- append(nrow_d6p_txt, nrow_d6p_txt1)
  d6p_txt_filepath1 <- as.character(d6_d6p_txt_related_without_NA$file_list_txt_d6p[i])
  d6p_txt_filepath <- append(d6p_txt_filepath, d6p_txt_filepath1)
  
  if (nrow_d6p_txt1 == 801){ 
    
    #TRUE for sorted ascending d6p_txt_file Wavelength
    if (!is.unsorted(d6p_txt_file[,1], strictly = TRUE) == FALSE){
      
      d6p_txt_filepath_unsorted_err1 <- as.character(d6_d6p_txt_related_without_NA$file_list_txt_d6p[i])
      d6p_txt_filepath_unsorted_err <- append(d6p_txt_filepath_unsorted_err, d6p_txt_filepath_unsorted_err1)
      #i_count <- i
      #print(i)
    }
    
    #check if all d6p txt files have the same wavelength column as the first one
    d6p_txt_file_1st <- read.table(d6_d6p_txt_related_without_NA$file_list_txt_d6p[1], skip = 1, sep = ",", header = TRUE)
    
    l1 <- nrow(d6p_txt_file_1st)  
    for (j in 1:l1){
      
      #if(d6p_txt_file[j,1] != d6p_txt_file_1st[j,1]){
      if(d6p_txt_file[j,1] != d6p_txt_file_1st[j,1]){
        d6p_txt_filepath_unsorted_err21 <- as.character(d6_d6p_txt_related_without_NA$file_list_txt_d6p[i])
        d6p_txt_filepath_unsorted_err2 <- append(d6p_txt_filepath_unsorted_err2, d6p_txt_filepath_unsorted_err21)
        d6p_txt_err_line_j2 <- append(d6p_txt_err_line_j2, j)
        
      }
    }
  }
  
  if (nrow_d6p_txt1 != 801){
    print("File length ERROR: nrow_d6p_txt1 is not equal to 801, but to ", nrow_d6p_txt1)
    print(nrow_d6p_txt1)
    nrow_d6p_txt_err1 <- nrow(d6p_txt_file)
    nrow_d6p_txt_err <- append(nrow_d6p_txt_err, nrow_d6p_txt_err1)
    
    print(d6p_txt_filepath1)
    d6p_txt_filepath_err1 <- as.character(d6_d6p_txt_related_without_NA$file_list_txt_d6p[i])
    d6p_txt_filepath_err <- append(d6p_txt_filepath_err, d6p_txt_filepath_err1)
    
  }
  
}

d6p_txt_nrow_filepath_NROW_ERR_df <- data.frame(nrow_d6p_txt_err, d6p_txt_filepath_err)
d6p_txt_nrow_filepath_NROW_ERR_df$dirname <- dirname(d6p_txt_nrow_filepath_NROW_ERR_df$d6p_txt_filepath_err)
d6p_txt_nrow_filepath_NROW_ERR_df$folder_name <- basename(d6p_txt_nrow_filepath_NROW_ERR_df$dirname)
d6p_txt_nrow_filepath_NROW_ERR_df$filename_ext <- sub('.*/', '', d6p_txt_nrow_filepath_NROW_ERR_df$d6p_txt_filepath_err)

nrows_d6p_txt_nrow_filepath_NROW_ERR_df <- nrow(d6p_txt_nrow_filepath_NROW_ERR_df)
write.csv(d6p_txt_nrow_filepath_NROW_ERR_df, paste0("C:/R_WD/WRITE/WORKS/", "final_d6p_txt_nrow_filepath_NROW_ERR_df_", nrows_d6p_txt_nrow_filepath_NROW_ERR_df, "_rows.csv"), row.names = FALSE)

###################


#copy the pair(d6) of  d6p files if any d6p has file length error(<801) in "C:/R_WD/WRITE/WORKS/FILE_LENGTH_ERROR_THE_PAIR/"

if (nrow(d6p_txt_nrow_filepath_NROW_ERR_df) > 0){
  
  for (m in 1:nrow(d6p_txt_nrow_filepath_NROW_ERR_df)){
    
    dir.create(path = paste0("C:/R_WD/WRITE/WORKS/FILE_LENGTH_ERROR_THE_PAIR/", d6p_txt_nrow_filepath_NROW_ERR_df$folder_name[m]), showWarnings = FALSE, recursive = TRUE)
    
    filename_d6p <- d6p_txt_nrow_filepath_NROW_ERR_df$filename_ext[m]
    string <- filename_d6p            
    pattern <- "p.txt"
    replacement <- ".txt"
    filename_d6_from_d6p <- str_replace(string, pattern, replacement)
    
    
    
    d6p_txt_file_nrow <- read.table(paste0(d6p_txt_nrow_filepath_NROW_ERR_df$dirname[m], "/", filename_d6_from_d6p), skip = 1, sep = ",", header = TRUE)
    
    if (nrow(d6p_txt_file_nrow) == 801){
      
      file.copy(paste0(d6p_txt_nrow_filepath_NROW_ERR_df$dirname[m], "/", filename_d6_from_d6p), paste0("C:/R_WD/WRITE/WORKS/FILE_LENGTH_ERROR_THE_PAIR/", d6p_txt_nrow_filepath_NROW_ERR_df$folder_name[m]), overwrite = TRUE)
      
    }else{
      
      print(paste0("The pair of file length error ", paste0(d6p_txt_nrow_filepath_NROW_ERR_df$dirname[m], "/", filename_d6_from_d6p), " has file length error as well. Particulate, Detritus or Phytoplankton Absorbance file will NOT BE written for the Sample ID."))
      
      #end if  
    }  
    
        
    #end m    
  }
  
  #end if  
}




###########




###########

#d6
#remove nrows < 801 errors from d6_d6p_txt_related_without_NA data frame

if(nrow(d6_txt_nrow_filepath_NROW_ERR_df)>0){
  

  d6_d6p_txt_related_without_NA_nrowERR <- d6_d6p_txt_related_without_NA %>%
    select(everything()) %>%
    filter(d6_d6p_txt_related_without_NA$file_list_txt_d6 %!in% d6_txt_nrow_filepath_NROW_ERR_df$d6_txt_filepath_err)
  

# nrows_d6_d6p_txt_related_without_NA_nrowERR <- nrow(d6_d6p_txt_related_without_NA_nrowERR)
# write.csv(d6_d6p_txt_related_without_NA_nrowERR, paste0("C:/R_WD/WRITE/WORKS/", "d6_d6p_txt_related_without_NA_nrowERR_", nrows_d6_d6p_txt_related_without_NA_nrowERR, "_rows.csv"), row.names = FALSE)

d6_d6p_txt_related_without_NA <- d6_d6p_txt_related_without_NA_nrowERR

}


#############


d6_txt_filepath_unsorted_err_df <- data.frame(d6_txt_filepath_unsorted_err)
nrows_d6_txt_filepath_unsorted_err_df <- nrow(d6_txt_filepath_unsorted_err_df)
write.csv(d6_txt_filepath_unsorted_err_df, paste0("C:/R_WD/WRITE/WORKS/", "d6_txt_filepath_unsorted_err_df_", nrows_d6_txt_filepath_unsorted_err_df, "_rows.csv"), row.names = FALSE)

d6_txt_filepath_unsorted_err2_line_j <- data.frame(d6_txt_err_line_j2, d6_txt_filepath_unsorted_err2)
nrows_d6_txt_filepath_unsorted_err2_line_j <- nrow(d6_txt_filepath_unsorted_err2_line_j)
write.csv(d6_txt_filepath_unsorted_err2_line_j, paste0("C:/R_WD/WRITE/WORKS/", "d6_txt_filepath_unsorted_err2_line_j_", nrows_d6_txt_filepath_unsorted_err2_line_j, "_rows.csv"), row.names = FALSE)


nrow_d6_txt_unique <- unique(nrow_d6_txt)
print(nrow_d6_txt_unique)

nrow_d6_txt_unique_df <- data.frame(nrow_d6_txt_unique)

nrows_nrow_d6_txt_unique_df <- nrow(nrow_d6_txt_unique_df)
write.csv(nrow_d6_txt_unique_df, paste0("C:/R_WD/WRITE/WORKS/", "nrow_d6_txt_unique_df_", nrows_nrow_d6_txt_unique_df, "_rows.csv"), row.names = FALSE)



###########

#d6p
#remove nrows < 801 errors from d6_d6p_txt_related_without_NA data frame

if(nrow(d6p_txt_nrow_filepath_NROW_ERR_df)>0){
  
 
  d6_d6p_txt_related_without_NA_nrowERR <- d6_d6p_txt_related_without_NA %>%
    select(everything()) %>%
    filter(d6_d6p_txt_related_without_NA$file_list_txt_d6p %!in% d6p_txt_nrow_filepath_NROW_ERR_df$d6p_txt_filepath_err)
  
  
  # nrows_d6_d6p_txt_related_without_NA_nrowERR <- nrow(d6_d6p_txt_related_without_NA_nrowERR)
  # write.csv(d6_d6p_txt_related_without_NA_nrowERR, paste0("C:/R_WD/WRITE/WORKS/", "d6_d6p_txt_related_without_NA_nrowERR2_", nrows_d6_d6p_txt_related_without_NA_nrowERR, "_rows.csv"), row.names = FALSE)
  
  d6_d6p_txt_related_without_NA <- d6_d6p_txt_related_without_NA_nrowERR
  
}


nrows_d6_d6p_txt_related_without_NA <- nrow(d6_d6p_txt_related_without_NA)
write.csv(d6_d6p_txt_related_without_NA, paste0("C:/R_WD/WRITE/WORKS/", "final_d6_d6p_txt_related_without_NA_paired_without_nrow_errors_", nrows_d6_d6p_txt_related_without_NA, "_rows.csv"), row.names = FALSE)


#############


d6p_txt_filepath_unsorted_err_df <- data.frame(d6p_txt_filepath_unsorted_err)
nrows_d6p_txt_filepath_unsorted_err_df <- nrow(d6p_txt_filepath_unsorted_err_df)
write.csv(d6p_txt_filepath_unsorted_err_df, paste0("C:/R_WD/WRITE/WORKS/", "d6p_txt_filepath_unsorted_err_df_", nrows_d6p_txt_filepath_unsorted_err_df, "_rows.csv"), row.names = FALSE)

d6p_txt_filepath_unsorted_err2_line_j <- data.frame(d6p_txt_err_line_j2, d6p_txt_filepath_unsorted_err2)
nrows_d6p_txt_filepath_unsorted_err2_line_j <- nrow(d6p_txt_filepath_unsorted_err2_line_j)
write.csv(d6p_txt_filepath_unsorted_err2_line_j, paste0("C:/R_WD/WRITE/WORKS/", "d6p_txt_filepath_unsorted_err2_line_j_", nrows_d6p_txt_filepath_unsorted_err2_line_j, "_rows.csv"), row.names = FALSE)


nrow_d6p_txt_unique <- unique(nrow_d6p_txt)
print(nrow_d6p_txt_unique)

nrow_d6p_txt_unique_df <- data.frame(nrow_d6p_txt_unique)

nrows_nrow_d6p_txt_unique_df <- nrow(nrow_d6p_txt_unique_df)
write.csv(nrow_d6p_txt_unique_df, paste0("C:/R_WD/WRITE/WORKS/", "nrow_d6p_txt_unique_df_", nrows_nrow_d6p_txt_unique_df, "_rows.csv"), row.names = FALSE)


#############

#copy to  "C:/R_WD/WRITE/WORKS/MISSING_THE_PAIR/" the particulate and the detritus that do not have pair


if (nrow(d6p_txt_that_ARE_NOT_in_d6_txt) > 0){

for (r in 1:nrow(d6p_txt_that_ARE_NOT_in_d6_txt)){

  
  d6p_txt_file_missing_pair <- read.table(paste0(d6p_txt_that_ARE_NOT_in_d6_txt$file_list_txt_d6p[r]), skip = 1, sep = ",", header = TRUE)
  
  if (nrow(d6p_txt_file_missing_pair) == 801){
    
    dir.create(path = paste0("C:/R_WD/WRITE/WORKS/MISSING_THE_PAIR/", d6p_txt_that_ARE_NOT_in_d6_txt$folder_name[r]), showWarnings = FALSE, recursive = TRUE)
    
    file.copy(d6p_txt_that_ARE_NOT_in_d6_txt$file_list_txt_d6p[r], paste0("C:/R_WD/WRITE/WORKS/MISSING_THE_PAIR/", d6p_txt_that_ARE_NOT_in_d6_txt$folder_name[r]), overwrite = TRUE)
    
  }else{
    
    print(paste0("The pair of file missing ", paste0(d6p_txt_that_ARE_NOT_in_d6_txt$file_list_txt_d6p[r]), " has file length error. Particulate, Detritus or Phytoplankton Absorbance file will NOT BE written for the Sample ID."))
    
    #end if  
  }  
  

    
dir.create(path = paste0("C:/R_WD/WRITE/WORKS/MISSING_THE_PAIR/", d6p_txt_that_ARE_NOT_in_d6_txt$folder_name[r]), showWarnings = FALSE, recursive = TRUE)
  
file.copy(d6p_txt_that_ARE_NOT_in_d6_txt$file_list_txt_d6p[r], paste0("C:/R_WD/WRITE/WORKS/MISSING_THE_PAIR/", d6p_txt_that_ARE_NOT_in_d6_txt$folder_name[r]))

#end r
}

#end if
}



if (nrow(d6_txt_that_ARE_NOT_in_d6p_txt) > 0){

for (r in 1:nrow(d6_txt_that_ARE_NOT_in_d6p_txt)){

  
  
  d6_txt_file_missing_pair <- read.table(paste0(d6_txt_that_ARE_NOT_in_d6p_txt$file_list_txt_d6[r]), skip = 1, sep = ",", header = TRUE)
  
  if (nrow(d6_txt_file_missing_pair) == 801){
    
    dir.create(path = paste0("C:/R_WD/WRITE/WORKS/MISSING_THE_PAIR/", d6_txt_that_ARE_NOT_in_d6p_txt$folder_name[r]), showWarnings = FALSE, recursive = TRUE)
    
    file.copy(d6_txt_that_ARE_NOT_in_d6p_txt$file_list_txt_d6[r], paste0("C:/R_WD/WRITE/WORKS/MISSING_THE_PAIR/", d6_txt_that_ARE_NOT_in_d6p_txt$folder_name[r]), overwrite = TRUE)
    
  }else{
    
    print(paste0("The pair of file missing ", paste0(d6_txt_that_ARE_NOT_in_d6p_txt$file_list_txt_d6[r]), " has file length error. Particulate, Detritus or Phytoplankton Absorbance file will NOT BE written for the Sample ID."))
    
    #end if  
  }  
  


#end r
}

#end if  
}


#############

#########

###############

#get metadata 1st line from d6_txt and d6p_txt and put them into file d6_d6p_txt_related_without_NA_with_1st_metadata_line.csv

first_lines_d6_txt <- character()
first_lines_d6_txt_df <- data.frame()
d6_txt_only_first_lines_filelist_df <- data.frame()
d6_txt_only_first_lines_filelist_df1 <- data.frame()

d6p_txt_only_first_lines_filelist_df <- data.frame()
d6p_txt_only_first_lines_filelist_df1 <- data.frame()

for (i in 1:nrow(d6_d6p_txt_related_without_NA)){
  
  d6_txt_file_to_read <- d6_d6p_txt_related_without_NA$file_list_txt_d6[i]#i
  con <- file(d6_txt_file_to_read, "r")
  first_lines_d6_txt <- readLines(con, n=2)
  close(con)
  
  string <- first_lines_d6_txt            
  pattern <- c(" -", "Abs.")
  replacement <- c("Particulate -", "Absorbance")
  first_lines_d6_txt <- str_replace(string, pattern, replacement)
  
  
  
  first_lines_d6_txt_df <- data.frame(first_lines_d6_txt)
  #first_line_d6_txt_df <- rbind(first_line_d6_txt_df, first_line_d6_txt_df1)

  #write.csv(first_lines_d6_txt_df, paste0("C:/R_WD/WRITE/WORKS/d6_d6p_txt_first_lines/d6_txt_first_lines/", d6_d6p_txt_related_without_NA$filename_d6[i], "_txt_first_lines.csv"), row.names = FALSE)
  
  dir.create(file.path(paste0("C:/R_WD/WRITE/WORKS/d6_d6p_txt_first_lines/d6_txt_first_lines/", d6_d6p_txt_related_without_NA$folder_name[i],"/")), showWarnings = FALSE, recursive = TRUE)
  write.csv(first_lines_d6_txt_df, paste0("C:/R_WD/WRITE/WORKS/d6_d6p_txt_first_lines/d6_txt_first_lines/", d6_d6p_txt_related_without_NA$folder_name[i],"/" , d6_d6p_txt_related_without_NA$filename_d6[i], "_txt_first_lines.csv"), row.names = FALSE)
  #for folder_name
    
  d6_txt_only_first_lines_filelist_df1 <- data.frame(paste0("C:/R_WD/WRITE/WORKS/d6_d6p_txt_first_lines/d6_txt_first_lines/", d6_d6p_txt_related_without_NA$folder_name[i],"/" , d6_d6p_txt_related_without_NA$filename_d6[i], "_txt_first_lines.csv"))
  d6_txt_only_first_lines_filelist_df <- rbind(d6_txt_only_first_lines_filelist_df, d6_txt_only_first_lines_filelist_df1)
  
  
  d6p_txt_file_to_read <- d6_d6p_txt_related_without_NA$file_list_txt_d6p[i]
  con <- file(d6p_txt_file_to_read, "r")
  first_lines_d6p_txt <- readLines(con, n=2)
  close(con)
  
  string <- first_lines_d6p_txt            
  pattern <- c("p -", "Abs.")
  replacement <- c("Detritus -", "Absorbance")
  first_lines_d6p_txt <- str_replace(string, pattern, replacement)
  
  
  
  first_lines_d6p_txt_df <- data.frame(first_lines_d6p_txt)
  #first_line_d6_txt_df <- rbind(first_line_d6_txt_df, first_line_d6_txt_df1)
  
  #write.csv(first_lines_d6p_txt_df, paste0("C:/R_WD/WRITE/WORKS/d6_d6p_txt_first_lines/d6p_txt_first_lines/", d6_d6p_txt_related_without_NA$filename_d6p[i], "_txt_first_lines.csv"), row.names = FALSE)
  dir.create(file.path(paste0("C:/R_WD/WRITE/WORKS/d6_d6p_txt_first_lines/d6p_txt_first_lines/", d6_d6p_txt_related_without_NA$folder_name[i],"/")), showWarnings = FALSE, recursive = TRUE)
  write.csv(first_lines_d6p_txt_df, paste0("C:/R_WD/WRITE/WORKS/d6_d6p_txt_first_lines/d6p_txt_first_lines/", d6_d6p_txt_related_without_NA$folder_name[i],"/", d6_d6p_txt_related_without_NA$filename_d6p[i], "_txt_first_lines.csv"), row.names = FALSE)
  
   
  
  d6p_txt_only_first_lines_filelist_df1 <- data.frame(paste0("C:/R_WD/WRITE/WORKS/d6_d6p_txt_first_lines/d6p_txt_first_lines/", d6_d6p_txt_related_without_NA$folder_name[i],"/", d6_d6p_txt_related_without_NA$filename_d6p[i], "_txt_first_lines.csv"))
  d6p_txt_only_first_lines_filelist_df <- rbind(d6p_txt_only_first_lines_filelist_df, d6p_txt_only_first_lines_filelist_df1)
  
  
  
}

names(d6_txt_only_first_lines_filelist_df)[1] <- "d6_txt_only_first_lines_filelist_df"
nrows_d6_txt_only_first_lines_filelist_df <- nrow(d6_txt_only_first_lines_filelist_df)
write.csv(d6_txt_only_first_lines_filelist_df, paste0("C:/R_WD/WRITE/WORKS/", "d6_txt_only_first_lines_filelist_df_", nrows_d6_txt_only_first_lines_filelist_df, "_rows.csv"), row.names = FALSE)

names(d6p_txt_only_first_lines_filelist_df)[1] <- "d6p_txt_only_first_lines_filelist_df"
nrows_d6p_txt_only_first_lines_filelist_df <- nrow(d6p_txt_only_first_lines_filelist_df)
write.csv(d6p_txt_only_first_lines_filelist_df, paste0("C:/R_WD/WRITE/WORKS/", "d6p_txt_only_first_lines_filelist_df_", nrows_d6p_txt_only_first_lines_filelist_df, "_rows.csv"), row.names = FALSE)


d6_d6p_txt_related_without_NA_with_first_lines <- d6_d6p_txt_related_without_NA
d6_d6p_txt_related_without_NA_with_first_lines <- cbind(d6_d6p_txt_related_without_NA_with_first_lines, d6_txt_only_first_lines_filelist_df)
d6_d6p_txt_related_without_NA_with_first_lines <- cbind(d6_d6p_txt_related_without_NA_with_first_lines, d6p_txt_only_first_lines_filelist_df)

nrows_d6_d6p_txt_related_without_NA_with_first_lines <- nrow(d6_d6p_txt_related_without_NA_with_first_lines)
write.csv(d6_d6p_txt_related_without_NA_with_first_lines, paste0("C:/R_WD/WRITE/WORKS/", "final_d6_d6p_txt_related_without_NA_with_first_lines_", nrows_d6_d6p_txt_related_without_NA_with_first_lines, "_rows.csv"), row.names = FALSE)

###############

#get filepath to write

file_path_to_write_d6_d6p_txt_df <- data.frame()

for (i in 1:nrow(d6_d6p_txt_related_without_NA_with_first_lines)){
  
# 
# file_path_to_write_d6_d6p_txt <- d6_d6p_txt_related_without_NA_with_first_lines$file_list_txt_d6[i]
# string <- file_path_to_write_d6_d6p_txt            
# pattern <- "C:/DATA_READ/"
# replacement <- "C:/R_WD/WRITE/WORKS/RESULTS/"
# file_path_to_write_d6_d6p_txt <- str_replace(string, pattern, replacement)
# file_path_to_write_d6_d6p_txt <- paste0(dirname(file_path_to_write_d6_d6p_txt), "/")

file_path_to_write_d6_d6p_txt <- paste0("C:/R_WD/WRITE/WORKS/RESULTS/", d6_d6p_txt_related_without_NA_with_first_lines$folder_name[i], "/")

file_path_to_write_d6_d6p_txt_df1 <- data.frame(file_path_to_write_d6_d6p_txt)
file_path_to_write_d6_d6p_txt_df <- rbind(file_path_to_write_d6_d6p_txt_df, file_path_to_write_d6_d6p_txt_df1)

}

d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite <- cbind(d6_d6p_txt_related_without_NA_with_first_lines, file_path_to_write_d6_d6p_txt_df)
nrows_d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite <- nrow(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite)
write.csv(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite, paste0("C:/R_WD/WRITE/WORKS/", "final_d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite_", nrows_d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite, "_rows.csv"), row.names = FALSE)
######does not recognize space


#calculate Phytoplankton = Particulate(d6) - Detritus(d6p)

for (i in 1:nrow(d6_d6p_txt_related_without_NA_with_first_lines)){

  d6_txt_file <- read.table(d6_d6p_txt_related_without_NA_with_first_lines$file_list_txt_d6[i], skip = 1, sep = ",", header = TRUE)
  d6p_txt_file <- read.table(d6_d6p_txt_related_without_NA_with_first_lines$file_list_txt_d6p[i], skip = 1, sep = ",", header = TRUE)
  
  d6_txt_file_df <- data.frame(d6_txt_file)
  d6p_txt_file_df <- data_frame(d6p_txt_file)
  
  #d6_Phytoplankton_txt_df <- data.frame()
  
  
d6_Phytoplankton_txt_df <- cbind(d6_txt_file_df, d6p_txt_file_df)
d6_Phytoplankton_txt_df[,3] = NULL
d6_Phytoplankton_txt_df$Abs.Phytoplankton <- d6_Phytoplankton_txt_df[,2] - d6_Phytoplankton_txt_df[,3]

names(d6_Phytoplankton_txt_df)[2] <- "Absorbance.Particulate"
names(d6_Phytoplankton_txt_df)[3] <- "Absorbance.Detritus"
names(d6_Phytoplankton_txt_df)[4] <- "Absorbance.Phytoplankton"

#d6_Phytoplankton_txt_df <- data.frame(lapply(d6_Phytoplankton_txt_df, as.numeric))

d6_Phytoplankton_txt_df[,1] <- format(d6_Phytoplankton_txt_df[,1], digits = 2, nsmall = 2)
d6_Phytoplankton_txt_df[,2] <- format(d6_Phytoplankton_txt_df[,2], digits = 3, nsmall = 3)
d6_Phytoplankton_txt_df[,3] <- format(d6_Phytoplankton_txt_df[,3], digits = 3, nsmall = 3)
d6_Phytoplankton_txt_df[,4] <- format(d6_Phytoplankton_txt_df[,4], digits = 3, nsmall = 3)



d6_txt_first_lines_from_file_written <- data.frame(read.table(d6_d6p_txt_related_without_NA_with_first_lines$d6_txt_only_first_lines_filelist_df[i], skip = 0, sep = ",", header = TRUE))
d6_txt_first_lines_from_file_written <- data.frame(d6_txt_first_lines_from_file_written[1,1])

d6p_txt_first_lines_from_file_written <- data.frame(read.table(d6_d6p_txt_related_without_NA_with_first_lines$d6p_txt_only_first_lines_filelist_df[i], skip = 0, sep = ",", header = TRUE))
d6p_txt_first_lines_from_file_written <- data.frame(d6p_txt_first_lines_from_file_written[1,1])

d6_d6p_txt_first_lines_from_file_written <- data.frame(d6_txt_first_lines_from_file_written, d6p_txt_first_lines_from_file_written)


d6_Phytoplankton_txt_df_colnames <- data.frame(t(names(d6_Phytoplankton_txt_df)))



dir.create(file.path(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_path_to_write_d6_d6p_txt[i]), showWarnings = FALSE, recursive = TRUE)

write.table(d6_d6p_txt_first_lines_from_file_written, file = paste0(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_path_to_write_d6_d6p_txt[i], d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$filename_d6[i], "Phytoplankton.txt"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
write.table(d6_Phytoplankton_txt_df_colnames,         file = paste0(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_path_to_write_d6_d6p_txt[i], d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$filename_d6[i], "Phytoplankton.txt"), sep = ",", row.names = FALSE, dec = ".", quote = TRUE, col.names = F, append = TRUE)
write.table(d6_Phytoplankton_txt_df,                  file = paste0(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_path_to_write_d6_d6p_txt[i], d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$filename_d6[i], "Phytoplankton.txt"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)

}

#wrote 950 files instead of 952, because the file that shows as a duplicate, 438116, shows up 4 times in the first table and twice in the second table

#print("wrote 950 files instead of 952, because the file that shows as a duplicate, 438116, shows up 4 times in the first table and twice in the second table")


#########


#search for the d6Phytoplankton.txt files that have been and NOT been processed

#input_folder_to_read_written_files <- "C:/R_WD/WRITE/WORKS/RESULTS"
search_result_d6Phytoplankton_txt_files_processed  <- list.files(pattern = "\\d{6}Phytoplankton.txt$"  , path = input_folder_to_read_written_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
# nrows_search_result_d6Phytoplankton_txt_files_processed <- length(search_result_d6Phytoplankton_txt_files_processed)
# write.csv(search_result_d6Phytoplankton_txt_files_processed, paste0("C:/R_WD/WRITE/WORKS/", "search_result_d6Phytoplankton_txt_files_processed_", nrows_search_result_d6Phytoplankton_txt_files_processed, "_rows.csv"), row.names = FALSE)

search_result_d6Phytoplankton_txt_files_processed_df <- data.frame(search_result_d6Phytoplankton_txt_files_processed)
search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6 <- sub('.*/', '', search_result_d6Phytoplankton_txt_files_processed_df[,1])
search_result_d6Phytoplankton_txt_files_processed_df$filename_d6 <- sub('\\Phytoplankton.txt$', '', search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6)
search_result_d6Phytoplankton_txt_files_processed_df$file <- search_result_d6Phytoplankton_txt_files_processed_df$filename_d6
search_result_d6Phytoplankton_txt_files_processed_df$folder_name <- sub('\\..*$', '', basename(dirname(search_result_d6Phytoplankton_txt_files_processed_df[,1])))

nrows_search_result_d6Phytoplankton_txt_files_processed_df <- nrow(search_result_d6Phytoplankton_txt_files_processed_df)
write.csv(search_result_d6Phytoplankton_txt_files_processed_df, paste0("C:/R_WD/WRITE/WORKS/", "search_result_d6Phytoplankton_txt_files_processed_df_", nrows_search_result_d6Phytoplankton_txt_files_processed_df, "_rows.csv"), row.names = FALSE)

########

#filter Phytoplankton processed that ARE NOT in d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite
d6Phytoplankton_txt_that_WERE_NOT_processed <- search_result_d6Phytoplankton_txt_files_processed_df %>%
  select(everything()) %>%
  filter(file %!in% c(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file))

nrows_d6Phytoplankton_txt_that_WERE_NOT_processed <- nrow(d6Phytoplankton_txt_that_WERE_NOT_processed)
write.csv(d6Phytoplankton_txt_that_WERE_NOT_processed, paste0("C:/R_WD/WRITE/WORKS/", "d6Phytoplankton_txt_that_WERE_NOT_processed_", nrows_d6Phytoplankton_txt_that_WERE_NOT_processed, "_rows.csv"), row.names = FALSE)

##########







##########write all valid d6 and d6p with new name, Particulate and Detritus

##write all valid d6 Particulate and header


for (i in 1:nrow(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite)){
  
  d6_txt_file <- read.table(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_list_txt_d6[i], skip = 1, sep = ",", header = TRUE)
   
  d6_txt_file_df <- data.frame(d6_txt_file)

  d6_txt_file_df[,1] <- format(d6_txt_file_df[,1], digits = 2, nsmall = 2)
  d6_txt_file_df[,2] <- format(d6_txt_file_df[,2], digits = 3, nsmall = 3)

  d6_txt_first_lines_from_file_written <- data.frame(read.table(d6_d6p_txt_related_without_NA_with_first_lines$d6_txt_only_first_lines_filelist_df[i], skip = 0, sep = ",", header = TRUE))
  d6_txt_first_lines_from_file_written <- data.frame(d6_txt_first_lines_from_file_written[1,1])
  
  d6_Particulate_txt_df_colnames <- data.frame(t(names(d6_txt_file_df)))
  d6_Particulate_txt_df_colnames[2] <- "Absorbance.Particulate"
  
  #dir.create(file.path(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_path_to_write_d6_d6p_txt[i]), showWarnings = FALSE, recursive = TRUE)
  
  write.table(d6_txt_first_lines_from_file_written, file = paste0(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_path_to_write_d6_d6p_txt[i], d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$filename_d6[i], "Particulate.txt"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
  write.table(d6_Particulate_txt_df_colnames,       file = paste0(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_path_to_write_d6_d6p_txt[i], d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$filename_d6[i], "Particulate.txt"), sep = ",", row.names = FALSE, dec = ".", quote = TRUE, col.names = F, append = TRUE)
  write.table(d6_txt_file_df,                       file = paste0(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_path_to_write_d6_d6p_txt[i], d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$filename_d6[i], "Particulate.txt"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
  

}

#search for d6 the d6Particulate.txt files that have BEEN and NOT been processed

input_folder_to_read_files <- "C:/R_WD/WRITE/WORKS/RESULTS" #without "/"
search_result_d6Particulate_txt_files_processed  <- list.files(pattern = "\\d{6}Particulate.txt$"  , path = input_folder_to_read_written_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
# nrows_search_result_d6Particulate_txt_files_processed <- length(search_result_d6Particulate_txt_files_processed)
# write.csv(search_result_d6Particulate_txt_files_processed, paste0("C:/R_WD/WRITE/WORKS/", "search_result_d6Particulate_txt_files_processed_", nrows_search_result_d6Particulate_txt_files_processed, "_rows.csv"), row.names = FALSE)

search_result_d6Particulate_txt_files_processed_df <- data.frame(search_result_d6Particulate_txt_files_processed)
search_result_d6Particulate_txt_files_processed_df$filename_ext_d6 <- sub('.*/', '', search_result_d6Particulate_txt_files_processed_df[,1])
search_result_d6Particulate_txt_files_processed_df$filename_d6 <- sub('\\Particulate.txt$', '', search_result_d6Particulate_txt_files_processed_df$filename_ext_d6)
search_result_d6Particulate_txt_files_processed_df$file <- search_result_d6Particulate_txt_files_processed_df$filename_d6

nrows_search_result_d6Particulate_txt_files_processed_df <- nrow(search_result_d6Particulate_txt_files_processed_df)
write.csv(search_result_d6Particulate_txt_files_processed_df, paste0("C:/R_WD/WRITE/WORKS/", "search_result_d6Particulate_txt_files_processed_df_", nrows_search_result_d6Particulate_txt_files_processed_df, "_rows.csv"), row.names = FALSE)


#filter Particulate processed that ARE NOT in d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite
d6Particulate_txt_that_WERE_NOT_processed <- search_result_d6Particulate_txt_files_processed_df %>%
  select(everything()) %>%
  filter(file %!in% c(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file))

nrows_d6Particulate_txt_that_WERE_NOT_processed <- nrow(d6Particulate_txt_that_WERE_NOT_processed)
write.csv(d6Particulate_txt_that_WERE_NOT_processed, paste0("C:/R_WD/WRITE/WORKS/", "d6Particulate_txt_that_WERE_NOT_processed_", nrows_d6Particulate_txt_that_WERE_NOT_processed, "_rows.csv"), row.names = FALSE)


###############



##write all valid d6p Detritus and header


for (i in 1:nrow(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite)){
  
  d6p_txt_file <- read.table(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_list_txt_d6p[i], skip = 1, sep = ",", header = TRUE)
  
  d6p_txt_file_df <- data.frame(d6p_txt_file)
  
  d6p_txt_file_df[,1] <- format(d6p_txt_file_df[,1], digits = 2, nsmall = 2)
  d6p_txt_file_df[,2] <- format(d6p_txt_file_df[,2], digits = 3, nsmall = 3)
  
  d6p_txt_first_lines_from_file_written <- data.frame(read.table(d6_d6p_txt_related_without_NA_with_first_lines$d6p_txt_only_first_lines_filelist_df[i], skip = 0, sep = ",", header = TRUE))
  d6p_txt_first_lines_from_file_written <- data.frame(d6p_txt_first_lines_from_file_written[1,1])
  
  d6p_Particulate_txt_df_colnames <- data.frame(t(names(d6p_txt_file_df)))
  d6p_Particulate_txt_df_colnames[2] <- "Absorbance.Detritus"
  
  #dir.create(file.path(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_path_to_write_d6_d6p_txt[i]), showWarnings = FALSE, recursive = TRUE)
  
  write.table(d6p_txt_first_lines_from_file_written, file = paste0(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_path_to_write_d6_d6p_txt[i], d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$filename_d6[i], "Detritus.txt"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
  write.table(d6p_Particulate_txt_df_colnames,       file = paste0(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_path_to_write_d6_d6p_txt[i], d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$filename_d6[i], "Detritus.txt"), sep = ",", row.names = FALSE, dec = ".", quote = TRUE, col.names = F, append = TRUE)
  write.table(d6p_txt_file_df,                       file = paste0(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file_path_to_write_d6_d6p_txt[i], d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$filename_d6[i], "Detritus.txt"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
  
  
}

#search for d6p the d6Detritus.txt files that have NOT been processed

input_folder_to_read_files <- "C:/R_WD/WRITE/WORKS/RESULTS"
search_result_d6Detritus_txt_files_processed  <- list.files(pattern = "\\d{6}Detritus.txt$"  , path = input_folder_to_read_written_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
# nrows_search_result_d6Detritus_txt_files_processed <- length(search_result_d6Detritus_txt_files_processed)
# write.csv(search_result_d6Detritus_txt_files_processed, paste0("C:/R_WD/WRITE/WORKS/", "search_result_d6Detritus_txt_files_processed_", nrows_search_result_d6Detritus_txt_files_processed, "_rows.csv"), row.names = FALSE)

search_result_d6Detritus_txt_files_processed_df <- data.frame(search_result_d6Detritus_txt_files_processed)
search_result_d6Detritus_txt_files_processed_df$filename_ext_d6p <- sub('.*/', '', search_result_d6Detritus_txt_files_processed_df[,1])
search_result_d6Detritus_txt_files_processed_df$filename_d6p <- sub('\\Detritus.txt$', '', search_result_d6Detritus_txt_files_processed_df$filename_ext_d6p)
search_result_d6Detritus_txt_files_processed_df$file <- search_result_d6Detritus_txt_files_processed_df$filename_d6p

nrows_search_result_d6Detritus_txt_files_processed_df <- nrow(search_result_d6Detritus_txt_files_processed_df)
write.csv(search_result_d6Detritus_txt_files_processed_df, paste0("C:/R_WD/WRITE/WORKS/", "search_result_d6Detritus_txt_files_processed_df_", nrows_search_result_d6Detritus_txt_files_processed_df, "_rows.csv"), row.names = FALSE)


#filter Detritus processed that ARE NOT in d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite
d6Detritus_txt_that_WERE_NOT_processed <- search_result_d6Detritus_txt_files_processed_df %>%
  select(everything()) %>%
  filter(file %!in% c(d6_d6p_txt_related_without_NA_with_first_lines_and_filewrite$file))

nrows_d6Detritus_txt_that_WERE_NOT_processed <- nrow(d6Detritus_txt_that_WERE_NOT_processed)
write.csv(d6Detritus_txt_that_WERE_NOT_processed, paste0("C:/R_WD/WRITE/WORKS/", "d6Detritus_txt_that_WERE_NOT_processed_", nrows_d6Detritus_txt_that_WERE_NOT_processed, "_rows.csv"), row.names = FALSE)


#############


end_time <- Sys.time()
start_time
end_time



#############





