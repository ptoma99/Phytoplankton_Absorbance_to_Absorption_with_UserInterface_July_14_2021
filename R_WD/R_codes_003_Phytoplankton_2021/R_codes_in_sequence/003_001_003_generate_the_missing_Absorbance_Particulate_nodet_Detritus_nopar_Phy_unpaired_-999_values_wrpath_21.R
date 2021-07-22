#001_001_003_generate_the_missing_Absorbance_Particulate_nodet_Detritus_nopar_Phy_unpaired_-999_values_wrpath_21

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021


#reads all .txt files with 6 numbers(d6.txt) in the filename and 6 numbers and letter "p"(d6p.txt) located in folder input_folder_to_read_files "C:/DATA_READ/Particulate_Absorbance/NewSpectro_2015_continue/A FOLDER FOR ERROR TESTING"

#reads and writes results in "C:\R_WD\WRITE\WORKS\RESULTS"
#writes reports in ""C:\R_WD\WRITE\WORKS\GENERATE_UNPAIRED_P_D_PHY"



start_time <- Sys.time()
print(paste0("start_time = ", start_time))

# dir.create(file.path("C:/R_WD"), showWarnings = FALSE)
# dir.create(file.path("C:/R_WD/WRITE"), showWarnings = FALSE)
# dir.create(file.path("C:/R_WD/WRITE/WORKS"), showWarnings = FALSE)
dir.create(file.path("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/"), showWarnings = FALSE, recursive = TRUE)



setwd("C:/R_WD")
getwd()


#install.packages("reader")

library("reader")
library("dplyr")
library("tidyr")
library("stringr")
library("R.utils")

input_folder_to_read_pair_of_missing <-    "C:/R_WD/WRITE/WORKS/MISSING_THE_PAIR" #no "/"
input_folder_to_read_pair_of_length_err <- "C:/R_WD/WRITE/WORKS/FILE_LENGTH_ERROR_THE_PAIR" #no "/"

#also path for write and convert d6 d6p that do not have a pair
input_folder_to_read_written_files <- "C:/R_WD/WRITE/WORKS/RESULTS" #no "/"

#check if dir exists and stop if doesn't

#if ini
if (dir.exists(input_folder_to_read_written_files) == TRUE){
  
# input_folder_to_read_files <- "C:/DATA_READ/Particulate_Absorbance/NewSpectro_2015_continue/A FOLDER FOR ERROR TESTING"
# input_folder_to_read_written_files <- "C:/R_WD/WRITE/WORKS/RESULTS"
 
write.csv(input_folder_to_read_written_files, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "input_folder_to_read_written_files", ".csv"))
write.csv(input_folder_to_read_pair_of_missing, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "input_folder_to_read_pair_of_missing", ".csv"))
write.csv(input_folder_to_read_pair_of_length_err, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "input_folder_to_read_pair_of_length_err", ".csv"))


file_list_txt_d6_missing <- list.files(pattern = "\\d{6}.txt$"  , path = input_folder_to_read_pair_of_missing, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
file_list_txt_d6_length_err <- list.files(pattern = "\\d{6}.txt$"  , path = input_folder_to_read_pair_of_length_err, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)

file_list_txt_d6 <- append(file_list_txt_d6_missing, file_list_txt_d6_length_err)

nrows_file_list_txt_d6 <- length(file_list_txt_d6)
write.csv(file_list_txt_d6, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "file_list_txt_d6_", nrows_file_list_txt_d6, "_rows.csv"), row.names = FALSE)


file_list_txt_d6p_missing <- list.files(pattern = "\\d{6}p.txt$"  , path = input_folder_to_read_pair_of_missing, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
file_list_txt_d6p_length_err <- list.files(pattern = "\\d{6}p.txt$"  , path = input_folder_to_read_pair_of_length_err, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)

file_list_txt_d6p <- append(file_list_txt_d6p_missing, file_list_txt_d6p_length_err)

nrows_file_list_txt_d6p <- length(file_list_txt_d6p)
write.csv(file_list_txt_d6p, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "file_list_txt_d6p_", nrows_file_list_txt_d6p, "_rows.csv"), row.names = FALSE)


#########


#d6 = txt files with just 6 numbers in the filename
file_list_txt_d6_df <- data.frame(file_list_txt_d6)
file_list_txt_d6_df$dirname <- dirname(file_list_txt_d6_df[,1])
file_list_txt_d6_df$filename_ext_d6 <- sub('.*/', '', file_list_txt_d6_df$file_list_txt_d6)
file_list_txt_d6_df$filename_d6 <- sub('\\.txt$', '', file_list_txt_d6_df$filename_ext_d6)
file_list_txt_d6_df$file <- file_list_txt_d6_df$filename_d6
file_list_txt_d6_df$folder_name <- sub('\\..*$', '', basename(dirname(file_list_txt_d6_df[,1])))


###########


#d6p = txt files with just 6 numbers AND letter p in the filename
file_list_txt_d6p_df <- data.frame(file_list_txt_d6p)
file_list_txt_d6p_df$dirname <- dirname(file_list_txt_d6p_df[,1])
file_list_txt_d6p_df$filename_ext_d6p <- sub('.*/', '', file_list_txt_d6p_df$file_list_txt_d6p)
file_list_txt_d6p_df$filename_d6p <- sub('\\.txt$', '', file_list_txt_d6p_df$filename_ext_d6p)
file_list_txt_d6p_df$filename_d6p_no_p <- sub('p', '', file_list_txt_d6p_df$filename_d6p)
file_list_txt_d6p_df$file <- file_list_txt_d6p_df$filename_d6p_no_p
file_list_txt_d6p_df$folder_name <- sub('\\..*$', '', basename(dirname(file_list_txt_d6p_df[,1])))



######### DO IF FILE EXISTS !!!

#string filepath to write
#string filename d6p in d6
#string first 2 rows
#-999

######################

#read d6p (Detritus) d6p_txt_that_ARE_NOT_in_d6_txt  and write d6 (_-999_Particulate)
#

#search

d6p_txt_that_ARE_NOT_in_d6_txt <- file_list_txt_d6p_df


d6p_txt_that_ARE_NOT_in_d6_txt$filepath_to_write <- d6p_txt_that_ARE_NOT_in_d6_txt$dirname
d6p_txt_that_ARE_NOT_in_d6_txt$filename_ext_to_write_Detritus <- d6p_txt_that_ARE_NOT_in_d6_txt$filename_ext_d6p

if (nrow(d6p_txt_that_ARE_NOT_in_d6_txt) > 0){

for (i in 1:nrow(d6p_txt_that_ARE_NOT_in_d6_txt)){
  
  #i <- 1
  
  
  file_path_to_write_d6p_Detritus <- paste0("C:/R_WD/WRITE/WORKS/RESULTS/", d6p_txt_that_ARE_NOT_in_d6_txt$folder_name[i])
  
  d6p_txt_that_ARE_NOT_in_d6_txt$filepath_to_write[i] <- file_path_to_write_d6p_Detritus
  
  #we replace p with particulate not Detritus because we create the missing Particulate with -999
  filename_ext_to_write_Detritus <- d6p_txt_that_ARE_NOT_in_d6_txt$filename_ext_to_write_Detritus[i]
  string <- filename_ext_to_write_Detritus            
  pattern <- "p.txt"
  replacement <- "_-999_Particulate.txt"
  filename_ext_to_write_Detritus <- str_replace(string, pattern, replacement)
  d6p_txt_that_ARE_NOT_in_d6_txt$filename_ext_to_write_Detritus[i] <- filename_ext_to_write_Detritus

#end i  
}

#end if
}
    
nrows_d6p_txt_that_ARE_NOT_in_d6_txt <- nrow(d6p_txt_that_ARE_NOT_in_d6_txt)
write.csv(d6p_txt_that_ARE_NOT_in_d6_txt, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "d6p_txt_that_ARE_NOT_in_d6_txt_", nrows_d6p_txt_that_ARE_NOT_in_d6_txt, "_rows.csv"), row.names = FALSE)

if (nrow(d6p_txt_that_ARE_NOT_in_d6_txt) > 0){
  
for (i in 1:nrow(d6p_txt_that_ARE_NOT_in_d6_txt)){
  
  #i <- 1
  
  d6p_txt_file_to_read <- d6p_txt_that_ARE_NOT_in_d6_txt$file_list_txt_d6p[i]
  con <- file(d6p_txt_file_to_read, "r")
  first_lines_d6p_txt <- readLines(con, n=2)
  close(con)
  
  #we replace p with particulate not Detritus because we create the missing Particulate with -999
  string <- first_lines_d6p_txt            
  pattern <- c("p -", "Abs.")
  replacement <- c("Particulate -", "Absorbance.Particulate")
  first_lines_d6p_txt <- str_replace(string, pattern, replacement)
  
  
  d6p_txt_file <- read.table(d6p_txt_that_ARE_NOT_in_d6_txt$file_list_txt_d6p[i], skip = 1, sep = ",", header = TRUE)
  d6p_txt_file$Abs. <- -999
  d6p_txt_file_df <- data.frame(d6p_txt_file)
  
  
  d6p_txt_file_df[,1] <- format(d6p_txt_file_df[,1], digits = 2, nsmall = 2)
  d6p_txt_file_df[,2] <- format(d6p_txt_file_df[,2], digits = 0, nsmall = 0)
 
  
  write.table(first_lines_d6p_txt, file = paste0(d6p_txt_that_ARE_NOT_in_d6_txt$filepath_to_write[i], "/", d6p_txt_that_ARE_NOT_in_d6_txt$filename_ext_to_write_Detritus[i]), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
  write.table(d6p_txt_file_df,                  file = paste0(d6p_txt_that_ARE_NOT_in_d6_txt$filepath_to_write[i], "/", d6p_txt_that_ARE_NOT_in_d6_txt$filename_ext_to_write_Detritus[i]), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
  
#end i
}

#end if
}

############################


######################

#read d6 (Particulate) d6_txt_that_ARE_NOT_in_d6p_txt  and write d6p (_-999_Detritus)
#

#search

d6_txt_that_ARE_NOT_in_d6p_txt <- file_list_txt_d6_df

d6_txt_that_ARE_NOT_in_d6p_txt$filepath_to_write <- d6_txt_that_ARE_NOT_in_d6p_txt$dirname
d6_txt_that_ARE_NOT_in_d6p_txt$filename_ext_to_write_Particulate <- d6_txt_that_ARE_NOT_in_d6p_txt$filename_ext_d6

if (nrow(d6_txt_that_ARE_NOT_in_d6p_txt) > 0){

for (i in 1:nrow(d6_txt_that_ARE_NOT_in_d6p_txt)){
  
  #i <- 1
  
  file_path_to_write_d6_Particulate <- paste0("C:/R_WD/WRITE/WORKS/RESULTS/", d6_txt_that_ARE_NOT_in_d6p_txt$folder_name[i])
  
  d6_txt_that_ARE_NOT_in_d6p_txt$filepath_to_write[i] <- file_path_to_write_d6_Particulate
  
  #we replace .txt with Detritus not Particulate because we create the missing Detritus with -999
  filename_ext_to_write_Particulate <- d6_txt_that_ARE_NOT_in_d6p_txt$filename_ext_to_write_Particulate[i]
  string <- filename_ext_to_write_Particulate            
  pattern <- ".txt"
  replacement <- "_-999_Detritus.txt"
  filename_ext_to_write_Particulate <- str_replace(string, pattern, replacement)
  d6_txt_that_ARE_NOT_in_d6p_txt$filename_ext_to_write_Particulate[i] <- filename_ext_to_write_Particulate
  
  #end i  
}

#end if
}

nrows_d6_txt_that_ARE_NOT_in_d6p_txt <- nrow(d6_txt_that_ARE_NOT_in_d6p_txt)
write.csv(d6_txt_that_ARE_NOT_in_d6p_txt, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "d6_txt_that_ARE_NOT_in_d6p_txt_", nrows_d6_txt_that_ARE_NOT_in_d6p_txt, "_rows.csv"), row.names = FALSE)


if (nrow(d6_txt_that_ARE_NOT_in_d6p_txt) > 0){

for (i in 1:nrow(d6_txt_that_ARE_NOT_in_d6p_txt)){
  
  #i <- 1
  
  d6_txt_file_to_read <- d6_txt_that_ARE_NOT_in_d6p_txt$file_list_txt_d6[i]
  con <- file(d6_txt_file_to_read, "r")
  first_lines_d6_txt <- readLines(con, n=2)
  close(con)
  
  
  #we replace - with Detritus not Particulate because we create the missing Detritus with -999
  string <- first_lines_d6_txt            
  pattern <- c(" -", "Abs.")
  replacement <- c("Detritus -", "Absorbance.Detritus")
  first_lines_d6_txt <- str_replace(string, pattern, replacement)
  
  
  d6_txt_file <- read.table(d6_txt_that_ARE_NOT_in_d6p_txt$file_list_txt_d6[i], skip = 1, sep = ",", header = TRUE)
  d6_txt_file$Abs. <- -999
  d6_txt_file_df <- data.frame(d6_txt_file)
  
  
  d6_txt_file_df[,1] <- format(d6_txt_file_df[,1], digits = 2, nsmall = 2)
  d6_txt_file_df[,2] <- format(d6_txt_file_df[,2], digits = 0, nsmall = 0)
  
  
  write.table(first_lines_d6_txt, file = paste0(d6_txt_that_ARE_NOT_in_d6p_txt$filepath_to_write[i], "/", d6_txt_that_ARE_NOT_in_d6p_txt$filename_ext_to_write_Particulate[i]), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
  write.table(d6_txt_file_df,                  file = paste0(d6_txt_that_ARE_NOT_in_d6p_txt$filepath_to_write[i], "/", d6_txt_that_ARE_NOT_in_d6p_txt$filename_ext_to_write_Particulate[i]), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
  
  #end i
}

#end if
}


############################

#create Absorbance Phytoplankton -999 for missing Particulate and for missing Detritus

#for Detritus

if (nrow(d6p_txt_that_ARE_NOT_in_d6_txt) > 0){

for (i in 1:nrow(d6p_txt_that_ARE_NOT_in_d6_txt)){
  
  #i <- 1
  
  first_lines_d6p_txt <- paste0('"', d6p_txt_that_ARE_NOT_in_d6_txt$file[i], 'Particulate - RawData"', ',', '"', d6p_txt_that_ARE_NOT_in_d6_txt$file[i], 'Detritus - RawData"')

  d6p_txt_file <- read.table(d6p_txt_that_ARE_NOT_in_d6_txt$file_list_txt_d6p[i], skip = 1, sep = ",", header = TRUE)
  
  Wavelength.nm. <- d6p_txt_file[,1]

  d6p_txt_file_df <- data.frame(Wavelength.nm.)
  d6p_txt_file_df$Absorbance.Particulate <- -999
  d6p_txt_file_df$Absorbance.Detritus <- d6p_txt_file[,2]
  d6p_txt_file_df$Absorbance.Phytoplankton <- -999

    
  d6p_txt_file_df[,1] <- format(d6p_txt_file_df[,1], digits = 2, nsmall = 2)
  d6p_txt_file_df[,2] <- format(d6p_txt_file_df[,2], digits = 0, nsmall = 0)
  d6p_txt_file_df[,3] <- format(d6p_txt_file_df[,3], digits = 3, nsmall = 3)
  d6p_txt_file_df[,4] <- format(d6p_txt_file_df[,4], digits = 0, nsmall = 0)
  
  colnames_d6p_txt_file_df <- paste0('"', names(d6p_txt_file_df)[1], '","',  names(d6p_txt_file_df)[2], '","', names(d6p_txt_file_df)[3], '","', names(d6p_txt_file_df)[4], '"')
  
  
  #we replace particulate with Phytoplankton in the file name to write -999 ; in code Detritus is Phytoplankton
  filename_ext_to_write_Detritus <- d6p_txt_that_ARE_NOT_in_d6_txt$filename_ext_to_write_Detritus[i]
  string <- filename_ext_to_write_Detritus            
  pattern <- "_-999_Particulate.txt"
  replacement <- "_-999_nopar_Phytoplankton.txt"
  filename_ext_to_write_Detritus <- str_replace(string, pattern, replacement)
  d6p_txt_that_ARE_NOT_in_d6_txt$filename_ext_to_write_Detritus[i] <- filename_ext_to_write_Detritus
  
  
  write.table(first_lines_d6p_txt,              file = paste0(d6p_txt_that_ARE_NOT_in_d6_txt$filepath_to_write[i], "/", d6p_txt_that_ARE_NOT_in_d6_txt$filename_ext_to_write_Detritus[i]), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
  write.table(colnames_d6p_txt_file_df,         file = paste0(d6p_txt_that_ARE_NOT_in_d6_txt$filepath_to_write[i], "/", d6p_txt_that_ARE_NOT_in_d6_txt$filename_ext_to_write_Detritus[i]), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
  write.table(d6p_txt_file_df,                  file = paste0(d6p_txt_that_ARE_NOT_in_d6_txt$filepath_to_write[i], "/", d6p_txt_that_ARE_NOT_in_d6_txt$filename_ext_to_write_Detritus[i]), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
  
#end i
}

#end if
}


#########  
  
#for Particulate  

if (nrow(d6_txt_that_ARE_NOT_in_d6p_txt) > 0){
  
  for (i in 1:nrow(d6_txt_that_ARE_NOT_in_d6p_txt)){
    
    #i <- 1
    
    first_lines_d6_txt <- paste0('"', d6_txt_that_ARE_NOT_in_d6p_txt$file[i], 'Particulate - RawData"', ',', '"', d6_txt_that_ARE_NOT_in_d6p_txt$file[i], 'Detritus - RawData"')

    d6_txt_file <- read.table(d6_txt_that_ARE_NOT_in_d6p_txt$file_list_txt_d6[i], skip = 1, sep = ",", header = TRUE)
    
    Wavelength.nm. <- d6_txt_file[,1]
    
    d6_txt_file_df <- data.frame(Wavelength.nm.)
    d6_txt_file_df$Absorbance.Particulate <- d6_txt_file[,2]
    d6_txt_file_df$Absorbance.Detritus <- -999
    d6_txt_file_df$Absorbance.Phytoplankton <- -999
    
    
    d6_txt_file_df[,1] <- format(d6_txt_file_df[,1], digits = 2, nsmall = 2)
    d6_txt_file_df[,2] <- format(d6_txt_file_df[,2], digits = 3, nsmall = 3)
    d6_txt_file_df[,3] <- format(d6_txt_file_df[,3], digits = 0, nsmall = 0)
    d6_txt_file_df[,4] <- format(d6_txt_file_df[,4], digits = 0, nsmall = 0)
    
    colnames_d6_txt_file_df <- paste0('"', names(d6_txt_file_df)[1], '","',  names(d6_txt_file_df)[2], '","', names(d6_txt_file_df)[3], '","', names(d6_txt_file_df)[4], '"')
    
    
    #we replace detritus with Phytoplankton in the file name to write -999 ; in code Particulate is Phytoplankton
    filename_ext_to_write_Particulate <- d6_txt_that_ARE_NOT_in_d6p_txt$filename_ext_to_write_Particulate[i]
    string <- filename_ext_to_write_Particulate            
    pattern <- "_-999_Detritus.txt"
    replacement <- "_-999_nodet_Phytoplankton.txt"
    filename_ext_to_write_Particulate <- str_replace(string, pattern, replacement)
    d6_txt_that_ARE_NOT_in_d6p_txt$filename_ext_to_write_Particulate[i] <- filename_ext_to_write_Particulate
    
    
    write.table(first_lines_d6_txt,              file = paste0(d6_txt_that_ARE_NOT_in_d6p_txt$filepath_to_write[i], "/", d6_txt_that_ARE_NOT_in_d6p_txt$filename_ext_to_write_Particulate[i]), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
    write.table(colnames_d6_txt_file_df,         file = paste0(d6_txt_that_ARE_NOT_in_d6p_txt$filepath_to_write[i], "/", d6_txt_that_ARE_NOT_in_d6p_txt$filename_ext_to_write_Particulate[i]), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
    write.table(d6_txt_file_df,                  file = paste0(d6_txt_that_ARE_NOT_in_d6p_txt$filepath_to_write[i], "/", d6_txt_that_ARE_NOT_in_d6p_txt$filename_ext_to_write_Particulate[i]), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
    
    #end i
  }
  
  #end if
}


#############

#convert and Write the files that are the pairs for missing from C:\R_WD\WRITE\WORKS\FILE_LENGTH_ERROR_THE_PAIR and C:\R_WD\WRITE\WORKS\MISSING_THE_PAIR
#in C:\R_WD\WRITE\WORKS\RESULTS

#####

#for Particulate

#file_list_txt_d6_df
#file_list_txt_d6p_df

if (nrow(file_list_txt_d6_df) > 0){

for (i in 1:nrow(file_list_txt_d6_df)){
  
  #i <- 1
  
  d6_txt_file_to_read <- file_list_txt_d6_df$file_list_txt_d6[i]#i
  con <- file(d6_txt_file_to_read, "r")
  first_lines_d6_txt <- readLines(con, n=2)
  close(con)
  
  string <- first_lines_d6_txt            
  pattern <- c(" -", "Abs.")
  replacement <- c("Particulate -", "Absorbance_nodet.Particulate")
  first_lines_d6_txt <- str_replace(string, pattern, replacement)
  
  first_lines_d6_txt_df <- data.frame(first_lines_d6_txt)


  d6_txt_file <- read.table(file_list_txt_d6_df$file_list_txt_d6[i], skip = 1, sep = ",", header = TRUE)
  d6_txt_file_df <- data.frame(d6_txt_file)
  
  d6_txt_file_df[,1] <- format(d6_txt_file_df[,1], digits = 2, nsmall = 2)
  d6_txt_file_df[,2] <- format(d6_txt_file_df[,2], digits = 3, nsmall = 3)
  

  dir.create(path = (paste0(input_folder_to_read_written_files, "/", file_list_txt_d6_df$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
  
  write.table(first_lines_d6_txt_df, file = paste0(input_folder_to_read_written_files, "/", file_list_txt_d6_df$folder_name[i], "/", file_list_txt_d6_df$file[i], "_nodet_Particulate.txt"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
  write.table(d6_txt_file_df,        file = paste0(input_folder_to_read_written_files, "/", file_list_txt_d6_df$folder_name[i], "/", file_list_txt_d6_df$file[i], "_nodet_Particulate.txt"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
  
  print(paste0("The written particulate file without detritus is ", paste0(input_folder_to_read_written_files, "/", file_list_txt_d6_df$folder_name[i], "/", file_list_txt_d6_df$file[i], "_nodet_Particulate.txt")))

#end i
}

#end if
}else{
  
  print(paste0("There are no Particulate without Detritus to be written."))
  
}



#####

#for Detritus

#file_list_txt_d6_df
#file_list_txt_d6p_df

if (nrow(file_list_txt_d6p_df) > 0){
  
  for (i in 1:nrow(file_list_txt_d6p_df)){
    
    #i <- 1
    
    d6p_txt_file_to_read <- file_list_txt_d6p_df$file_list_txt_d6p[i]#i
    con <- file(d6p_txt_file_to_read, "r")
    first_lines_d6p_txt <- readLines(con, n=2)
    close(con)
    
    string <- first_lines_d6p_txt            
    pattern <- c("p -", "Abs.")
    replacement <- c("Detritus -", "Absorbance_nopar.Detritus")
    first_lines_d6p_txt <- str_replace(string, pattern, replacement)
    
    first_lines_d6p_txt_df <- data.frame(first_lines_d6p_txt)
    
    
    d6p_txt_file <- read.table(file_list_txt_d6p_df$file_list_txt_d6p[i], skip = 1, sep = ",", header = TRUE)
    d6p_txt_file_df <- data.frame(d6p_txt_file)
    
    d6p_txt_file_df[,1] <- format(d6p_txt_file_df[,1], digits = 2, nsmall = 2)
    d6p_txt_file_df[,2] <- format(d6p_txt_file_df[,2], digits = 3, nsmall = 3)
    
    
    dir.create(path = (paste0(input_folder_to_read_written_files, "/", file_list_txt_d6p_df$folder_name[i])), showWarnings = FALSE, recursive = TRUE)
    
    write.table(first_lines_d6p_txt_df, file = paste0(input_folder_to_read_written_files, "/", file_list_txt_d6p_df$folder_name[i], "/", file_list_txt_d6p_df$file[i], "_nopar_Detritus.txt"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)
    write.table(d6p_txt_file_df,        file = paste0(input_folder_to_read_written_files, "/", file_list_txt_d6p_df$folder_name[i], "/", file_list_txt_d6p_df$file[i], "_nopar_Detritus.txt"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, append = TRUE)
    
    print(paste0("The written Detritus file without Particulate is ", paste0(input_folder_to_read_written_files, "/", file_list_txt_d6p_df$folder_name[i], "/", file_list_txt_d6p_df$file[i], "_nopar_Detritus.txt")))
    
    #end i
  }
  
  #end if
}else{
  
  print(paste0("There are no Detritus without Particulate to be written."))
  
}



#############



############################


file_list_txt_d6_and_999_Particulate <- list.files(pattern = "\\d{6}\\S*\\Particulate.txt$"  , path = input_folder_to_read_written_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_file_list_txt_d6_and_999_Particulate <- length(file_list_txt_d6_and_999_Particulate)
write.csv(file_list_txt_d6_and_999_Particulate, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "total_Particulate_including_created_", nrows_file_list_txt_d6_and_999_Particulate, "_rows.csv"), row.names = FALSE)


file_list_txt_d6_only_999_Particulate <- list.files(pattern = "\\d{6}\\S+\\Particulate.txt$"  , path = input_folder_to_read_written_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_file_list_txt_d6_only_999_Particulate <- length(file_list_txt_d6_only_999_Particulate)
write.csv(file_list_txt_d6_only_999_Particulate, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "missing_999_Particulate_created_for_Detritus_", nrows_file_list_txt_d6_only_999_Particulate, "_rows.csv"), row.names = FALSE)


file_list_txt_d6_and_999_Detritus <- list.files(pattern = "\\d{6}\\S*\\Detritus.txt$"  , path = input_folder_to_read_written_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_file_list_txt_d6_and_999_Detritus <- length(file_list_txt_d6_and_999_Detritus)
write.csv(file_list_txt_d6_and_999_Detritus, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "total_Detritus_including_created_", nrows_file_list_txt_d6_and_999_Detritus, "_rows.csv"), row.names = FALSE)


file_list_txt_d6_only_999_Detritus <- list.files(pattern = "\\d{6}\\S+\\Detritus.txt$"  , path = input_folder_to_read_written_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_file_list_txt_d6_only_999_Detritus <- length(file_list_txt_d6_only_999_Detritus)
write.csv(file_list_txt_d6_only_999_Detritus, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "missing_999_Detritus_created_for_Particulate_", nrows_file_list_txt_d6_only_999_Detritus, "_rows.csv"), row.names = FALSE)





file_list_txt_d6_and_999_Phytoplankton <- list.files(pattern = "\\d{6}\\S*\\Phytoplankton.txt$"  , path = input_folder_to_read_written_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_file_list_txt_d6_and_999_Phytoplankton <- length(file_list_txt_d6_and_999_Phytoplankton)
write.csv(file_list_txt_d6_and_999_Phytoplankton, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "total_Phytoplankton_including_created_", nrows_file_list_txt_d6_and_999_Phytoplankton, "_rows.csv"), row.names = FALSE)


file_list_txt_d6_only_999_Phytoplankton <- list.files(pattern = "\\d{6}\\S+\\Phytoplankton.txt$"  , path = input_folder_to_read_written_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_file_list_txt_d6_only_999_Phytoplankton <- length(file_list_txt_d6_only_999_Phytoplankton)
write.csv(file_list_txt_d6_only_999_Phytoplankton, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "missing_999_Phytoplankton_created_", nrows_file_list_txt_d6_only_999_Phytoplankton, "_rows.csv"), row.names = FALSE)





file_list_txt_d6_d6p_and_999_Particulate_Detritus_Phytoplankton <- list.files(pattern = "\\d{6}\\S*\\.txt$"  , path = input_folder_to_read_written_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_file_list_txt_d6_d6p_and_999_Particulate_Detritus_Phytoplankton <- length(file_list_txt_d6_d6p_and_999_Particulate_Detritus_Phytoplankton)
write.csv(file_list_txt_d6_d6p_and_999_Particulate_Detritus_Phytoplankton, paste0("C:/R_WD/WRITE/WORKS/GENERATE_UNPAIRED_P_D_PHY/", "all_Absorbance_files_including_the_ones_999_created_should_be_", nrows_file_list_txt_d6_and_999_Phytoplankton*3, "_and_they_are_",  nrows_file_list_txt_d6_d6p_and_999_Particulate_Detritus_Phytoplankton, "_rows.csv"), row.names = FALSE)

}else{

  print(paste0("The directory ", input_folder_to_read_written_files, " does not exists. The program cannot continue."))

#end if ini  
}





#############


end_time <- Sys.time()
start_time
end_time



#############




  
  
  
  
  
  


