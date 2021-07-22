#001_005_plot_Phytoplankton_Absorption_all_folders5_-999_as_0_7_2_one_scale

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021

#-999 values are plotted as 0

#Particulate = blue
#Detritus = black
#Phytoplankton = green


start_time <- Sys.time()
print(paste0("start_time = ", start_time))

setwd("C:/R_WD")
getwd()

#install.packages("rgl", dependencies = TRUE)

library("stringr")
library("rgl")
library("dplyr")
library("reader")

dir.create(file.path("C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables"), showWarnings = FALSE, recursive = TRUE)



###################################
###################################
################################### start get min max for Absorption Phytoplankton, Particulate and Detritus from WORKS5



# filter_diameter <- 16.5

dir.create(file.path("C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables"), showWarnings = FALSE, recursive = TRUE)

#filepath_to_write_plot <- "C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/"

#enter folder that contains all the cruises sub folders
input_folder_to_read_files <- "C:/R_WD/WRITE/WORKS5"
#write.csv(input_folder_to_read_files, paste0("C:/R_WD/WRITE/WORKS_PLOT_Phytoplankton_Absorption_by_QC_flags_Comments/", "input_folder_to_read_files", ".csv"))


cruise_name_table_location <- "C:/R_WD/folder_name_to_coded_cruise_name_table.csv"
cruise_name_table <- read.table(cruise_name_table_location, skip = 0, sep = ",", header = TRUE)
cruise_name_table_df <- data.frame(cruise_name_table)


input_folder_name <- sub('\\..*$', '', basename(input_folder_to_read_files))
#search_result_for_Absorption_Phytoplankton_QC  <- list.files(pattern = "\\_Absorption_Phytoplankton_QC_Comments.csv$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
search_result_for_Absorption_Phytoplankton_QC  <- list.files(pattern = "\\_Absorption_Phytoplankton.csv$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
search_result_for_Absorption_Particulate  <- list.files(pattern = "\\_Absorption_Particulate.csv$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
search_result_for_Absorption_Detritus  <- list.files(pattern = "\\_Absorption_Detritus.csv$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)


search_result_for_Absorption_Phytoplankton_QC_df <- data.frame(search_result_for_Absorption_Phytoplankton_QC)
search_result_for_Absorption_Phytoplankton_QC_df$folder_name <- basename(dirname(search_result_for_Absorption_Phytoplankton_QC))

search_result_for_Absorption_Particulate_df <- data.frame(search_result_for_Absorption_Particulate)
search_result_for_Absorption_Particulate_df$folder_name <- basename(dirname(search_result_for_Absorption_Particulate))


search_result_for_Absorption_Detritus_df <- data.frame(search_result_for_Absorption_Detritus)
search_result_for_Absorption_Detritus_df$folder_name <- basename(dirname(search_result_for_Absorption_Detritus))



nrows_search_result_for_Absorption_Phytoplankton_QC_df <- nrow(search_result_for_Absorption_Phytoplankton_QC)
#write.csv(search_result_for_Absorption_Phytoplankton_QC_df, paste0("C:/R_WD/WRITE/WORKS_PLOT_Phytoplankton_Absorption_by_QC_flags_Comments/", "search_result_for_Absorption_Phytoplankton_QC_df_", nrows_search_result_for_Absorption_Phytoplankton_QC_df, "_rows.csv"), row.names = FALSE)


distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC <- unique(dirname(search_result_for_Absorption_Phytoplankton_QC))
distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df <- data.frame(distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC)
distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df$folder_name <- sub('\\..*$', '', basename(distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC))

distinct_folders_in_search_result_for_Absorption_Particulate <- unique(dirname(search_result_for_Absorption_Particulate))
distinct_folders_in_search_result_for_Absorption_Particulate_df <- data.frame(distinct_folders_in_search_result_for_Absorption_Particulate)
distinct_folders_in_search_result_for_Absorption_Particulate_df$folder_name <- sub('\\..*$', '', basename(distinct_folders_in_search_result_for_Absorption_Particulate))

distinct_folders_in_search_result_for_Absorption_Detritus <- unique(dirname(search_result_for_Absorption_Detritus))
distinct_folders_in_search_result_for_Absorption_Detritus_df <- data.frame(distinct_folders_in_search_result_for_Absorption_Detritus)
distinct_folders_in_search_result_for_Absorption_Detritus_df$folder_name <- sub('\\..*$', '', basename(distinct_folders_in_search_result_for_Absorption_Detritus))



nrows_distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df <- nrow(distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df)
#write.csv(distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df, paste0("C:/R_WD/WRITE/WORKS_PLOT_Phytoplankton_Absorption_by_QC_flags_Comments/", "distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df_", nrows_distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df, "_rows.csv"), row.names = FALSE)


all_tables_joined_by_folder_name <- inner_join(cruise_name_table_df, search_result_for_Absorption_Phytoplankton_QC_df, by = c("folder_name"))
all_tables_joined_by_folder_name <- inner_join(all_tables_joined_by_folder_name, distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df, by = c("folder_name"))

all_tables_joined_by_folder_name <- inner_join(all_tables_joined_by_folder_name, search_result_for_Absorption_Particulate_df, by = c("folder_name"))
all_tables_joined_by_folder_name <- inner_join(all_tables_joined_by_folder_name, search_result_for_Absorption_Detritus_df, by = c("folder_name"))



nrows_all_tables_joined_by_folder_name <- nrow(all_tables_joined_by_folder_name)
#write.csv(all_tables_joined_by_folder_name, paste0("C:/R_WD/WRITE/WORKS_PLOT_Phytoplankton_Absorption_by_QC_flags_Comments/", "all_tables_joined_by_folder_name_", nrows_all_tables_joined_by_folder_name, "_rows.csv"), row.names = FALSE)



#disable scientific notation in R.
options(scipen = 999)



########## start get min max Phytoplankton Absorption



for (i in 1:nrow(all_tables_joined_by_folder_name)){
  
  #i <- 1
  
  print(paste0("Working on folder ", all_tables_joined_by_folder_name$folder_name[i], " ", all_tables_joined_by_folder_name$coded_cruise_name[i], " to get min and max for Phytoplankton Absorption and Absorbance"))
  
  
  project_folder_name <- all_tables_joined_by_folder_name$folder_name[i]
  filepath_to_write_plot <- paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/RESULTS/", project_folder_name, "/")
  
  Absorption_Phytoplankton_file <- read.table(all_tables_joined_by_folder_name$search_result_for_Absorption_Phytoplankton_QC[i], skip = 17, sep = ",", header = TRUE)#, row.names = NULL)
  
  
  
  xyz_all_folder_Phytoplankton <- data.frame()
  #xyz_all_folder_Phytoplankton_Absorbance <- data.frame()
  
  
  for (j in 1:nrow(Absorption_Phytoplankton_file)){
    
    #j <- 1
    
    #print(paste0("Working on folder ", all_tables_joined_by_folder_name$folder_name[i], " ", all_tables_joined_by_folder_name$coded_cruise_name[i], ", Sample ID's = ", nrow(Absorption_Phytoplankton_file)))
    
    
    d6_string <- Absorption_Phytoplankton_file$Sample.ID[j]
    
    
    
    #x <- as.numeric(Absorption_Phytoplankton_file[1,9:(ncol(Absorption_Phytoplankton_file)-1)])#1
    x <- names(Absorption_Phytoplankton_file[9:(ncol(Absorption_Phytoplankton_file)-4)])#1
    
    
    string <- x            
    pattern <- "X"
    replacement <- ""
    x <- str_replace(string, pattern, replacement)
    
    
    
    
    
    
    y_Phytoplankton <- as.numeric(Absorption_Phytoplankton_file[j,9:(ncol(Absorption_Phytoplankton_file)-4)])#2j
    
    for (k in 1:length(y_Phytoplankton)){
      if (y_Phytoplankton[k] == -999){
        y_Phytoplankton[k] <- 0
      }
    }  
    
    
    #z <- as.numeric(i[1:length(x)])
    z <- as.numeric(1:length(x))
    
    
    
    
    #w <- rep(Absorption_Phytoplankton_file$QC_flag_443_to_490[j], times = length(x), length.out = NA, each = 1)
    
    #w <- rep(paste0(Absorption_Phytoplankton_file$QC_flag_410_smaller_than_440[j], Absorption_Phytoplankton_file$QC_flag_443_to_490[j], Absorption_Phytoplankton_file$QC_flag_ChlA_to_443_550_670[j]), times = length(x), length.out = NA, each = 1)
    
    
    Wavelength_nm <- x
    #Absorption <- y_Phytoplankton
    Sample_IDs <- z
    
    
    
    #Absorption
    #xyz_all_folder_Phytoplankton1 <- data.frame(x, y_Phytoplankton, j, w)
    xyz_all_folder_Phytoplankton1 <- data.frame(x, y_Phytoplankton, j, j)
    
    
    names(xyz_all_folder_Phytoplankton1)[3] <- "z"
    xyz_all_folder_Phytoplankton <- rbind(xyz_all_folder_Phytoplankton, xyz_all_folder_Phytoplankton1)
    
    # #Absorbance
    # xyz_all_folder_Phytoplankton2 <- data.frame(x2, y2_Phytoplankton, z2, z2)
    # names(xyz_all_folder_Phytoplankton2)[3] <- "z"
    # xyz_all_folder_Phytoplankton_Absorbance <- rbind(xyz_all_folder_Phytoplankton_Absorbance, xyz_all_folder_Phytoplankton2)
    # 
    # 
    
    
    #end j  
  }
  
  
  min_Absorption_Phytoplankton <- min(xyz_all_folder_Phytoplankton$y_Phytoplankton)
  max_Absorption_Phytoplankton <- max(xyz_all_folder_Phytoplankton$y_Phytoplankton)
  
  # min_Absorbance <- min(xyz_all_folder_Phytoplankton_Absorbance$y2_Phytoplankton)
  # max_Absorbance <- max(xyz_all_folder_Phytoplankton_Absorbance$y2_Phytoplankton)
  # 
  
  
  print(paste0("min_Absorption_Phytoplankton = ", min_Absorption_Phytoplankton))
  print(paste0("max_Absorption_Phytoplankton = ", max_Absorption_Phytoplankton))
  
  # print(paste0("min_Absorbance = ", min_Absorbance))
  # print(paste0("max_Absorbance = ", max_Absorbance))
  
  coded_cruise_name <- all_tables_joined_by_folder_name$coded_cruise_name[i]
  
  #min_max_Phytoplankton_Absorption <- data.frame(project_folder_name, coded_cruise_name, min_Absorption, max_Absorption)
  #write.csv(min_max_Phytoplankton_Absorption, paste0("C:/R_WD/WRITE/WORKS_PLOT_Phytoplankton_Absorption_by_QC_flags_Comments/", coded_cruise_name, "_min_max_Phytoplankton_Absorption", ".csv"), row.names = FALSE)
  
  
  
  #end i
}


########## end get min max Phytoplankton Absorption





########## start get min max Particulate Absorption



for (i in 1:nrow(all_tables_joined_by_folder_name)){
  
  #i <- 1
  
  print(paste0("Working on folder ", all_tables_joined_by_folder_name$folder_name[i], " ", all_tables_joined_by_folder_name$coded_cruise_name[i], " to get min and max for Phytoplankton Absorption and Absorbance"))
  
  
  project_folder_name <- all_tables_joined_by_folder_name$folder_name[i]
  filepath_to_write_plot <- paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/RESULTS/", project_folder_name, "/")
  
  Absorption_Particulate_file <- read.table(all_tables_joined_by_folder_name$search_result_for_Absorption_Particulate[i], skip = 17, sep = ",", header = TRUE)#, row.names = NULL)
  
  
  
  xyz_all_folder_Particulate <- data.frame()
  #xyz_all_folder_Phytoplankton_Absorbance <- data.frame()
  
  
  for (j in 1:nrow(Absorption_Particulate_file)){
    
    #j <- 1
    
    #print(paste0("Working on folder ", all_tables_joined_by_folder_name$folder_name[i], " ", all_tables_joined_by_folder_name$coded_cruise_name[i], ", Sample ID's = ", nrow(Absorption_Phytoplankton_file)))
    
    
    d6_string <- Absorption_Particulate_file$Sample.ID[j]
    
    
    
    #x <- as.numeric(Absorption_Phytoplankton_file[1,9:(ncol(Absorption_Phytoplankton_file)-1)])#1
    x <- names(Absorption_Particulate_file[9:(ncol(Absorption_Particulate_file)-4)])#1
    
    
    string <- x            
    pattern <- "X"
    replacement <- ""
    x <- str_replace(string, pattern, replacement)
    
    
    
    
    
    
    y_Particulate <- as.numeric(Absorption_Particulate_file[j,9:(ncol(Absorption_Particulate_file)-4)])#2j
    
    for (k in 1:length(y_Particulate)){
      if (y_Particulate[k] == -999){
        y_Particulate[k] <- 0
      }
    }  
    
    
    #z <- as.numeric(i[1:length(x)])
    z <- as.numeric(1:length(x))
    
    
    
    
    #w <- rep(Absorption_Phytoplankton_file$QC_flag_443_to_490[j], times = length(x), length.out = NA, each = 1)
    
    #w <- rep(paste0(Absorption_Phytoplankton_file$QC_flag_410_smaller_than_440[j], Absorption_Phytoplankton_file$QC_flag_443_to_490[j], Absorption_Phytoplankton_file$QC_flag_ChlA_to_443_550_670[j]), times = length(x), length.out = NA, each = 1)
    
    
    Wavelength_nm <- x
    #Absorption <- y_Phytoplankton
    Sample_IDs <- z
    
    
    
    #Absorption
    #xyz_all_folder_Phytoplankton1 <- data.frame(x, y_Phytoplankton, j, w)
    xyz_all_folder_Particulate1 <- data.frame(x, y_Particulate, j, j)
    
    
    names(xyz_all_folder_Particulate1)[3] <- "z"
    xyz_all_folder_Particulate <- rbind(xyz_all_folder_Particulate, xyz_all_folder_Particulate1)
    
    # #Absorbance
    # xyz_all_folder_Phytoplankton2 <- data.frame(x2, y2_Phytoplankton, z2, z2)
    # names(xyz_all_folder_Phytoplankton2)[3] <- "z"
    # xyz_all_folder_Phytoplankton_Absorbance <- rbind(xyz_all_folder_Phytoplankton_Absorbance, xyz_all_folder_Phytoplankton2)
    # 
    # 
    
    
    #end j  
  }
  
  
  min_Absorption_Particulate <- min(xyz_all_folder_Particulate$y_Particulate)
  max_Absorption_Particulate <- max(xyz_all_folder_Particulate$y_Particulate)
  
  # min_Absorbance <- min(xyz_all_folder_Phytoplankton_Absorbance$y2_Phytoplankton)
  # max_Absorbance <- max(xyz_all_folder_Phytoplankton_Absorbance$y2_Phytoplankton)
  # 
  
  
  print(paste0("min_Absorption_Particulate = ", min_Absorption_Particulate))
  print(paste0("max_Absorption_Particulate = ", max_Absorption_Particulate))
  
  # print(paste0("min_Absorbance = ", min_Absorbance))
  # print(paste0("max_Absorbance = ", max_Absorbance))
  
  coded_cruise_name <- all_tables_joined_by_folder_name$coded_cruise_name[i]
  
  #min_max_Phytoplankton_Absorption <- data.frame(project_folder_name, coded_cruise_name, min_Absorption, max_Absorption)
  #write.csv(min_max_Phytoplankton_Absorption, paste0("C:/R_WD/WRITE/WORKS_PLOT_Phytoplankton_Absorption_by_QC_flags_Comments/", coded_cruise_name, "_min_max_Phytoplankton_Absorption", ".csv"), row.names = FALSE)
  
  
  
  #end i
}


########## end get min max Particulate Absorption





########## start get min max Detritus Absorption



for (i in 1:nrow(all_tables_joined_by_folder_name)){
  
  #i <- 1
  
  print(paste0("Working on folder ", all_tables_joined_by_folder_name$folder_name[i], " ", all_tables_joined_by_folder_name$coded_cruise_name[i], " to get min and max for Phytoplankton Absorption and Absorbance"))
  
  
  project_folder_name <- all_tables_joined_by_folder_name$folder_name[i]
  filepath_to_write_plot <- paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/RESULTS/", project_folder_name, "/")
  
  Absorption_Detritus_file <- read.table(all_tables_joined_by_folder_name$search_result_for_Absorption_Detritus[i], skip = 17, sep = ",", header = TRUE)#, row.names = NULL)
  
  
  
  xyz_all_folder_Detritus <- data.frame()
  #xyz_all_folder_Phytoplankton_Absorbance <- data.frame()
  
  
  for (j in 1:nrow(Absorption_Detritus_file)){
    
    #j <- 1
    
    #print(paste0("Working on folder ", all_tables_joined_by_folder_name$folder_name[i], " ", all_tables_joined_by_folder_name$coded_cruise_name[i], ", Sample ID's = ", nrow(Absorption_Phytoplankton_file)))
    
    
    d6_string <- Absorption_Detritus_file$Sample.ID[j]
    
    
    
    #x <- as.numeric(Absorption_Phytoplankton_file[1,9:(ncol(Absorption_Phytoplankton_file)-1)])#1
    x <- names(Absorption_Detritus_file[9:(ncol(Absorption_Detritus_file)-4)])#1
    
    
    string <- x            
    pattern <- "X"
    replacement <- ""
    x <- str_replace(string, pattern, replacement)
    
    
    
    
    
    
    y_Detritus <- as.numeric(Absorption_Detritus_file[j,9:(ncol(Absorption_Detritus_file)-4)])#2j
    
    for (k in 1:length(y_Detritus)){
      if (y_Detritus[k] == -999){
        y_Detritus[k] <- 0
      }
    }  
    
    
    #z <- as.numeric(i[1:length(x)])
    z <- as.numeric(1:length(x))
    
    
    
    
    #w <- rep(Absorption_Phytoplankton_file$QC_flag_443_to_490[j], times = length(x), length.out = NA, each = 1)
    
    #w <- rep(paste0(Absorption_Phytoplankton_file$QC_flag_410_smaller_than_440[j], Absorption_Phytoplankton_file$QC_flag_443_to_490[j], Absorption_Phytoplankton_file$QC_flag_ChlA_to_443_550_670[j]), times = length(x), length.out = NA, each = 1)
    
    
    Wavelength_nm <- x
    #Absorption <- y_Phytoplankton
    Sample_IDs <- z
    
    
    
    #Absorption
    #xyz_all_folder_Phytoplankton1 <- data.frame(x, y_Phytoplankton, j, w)
    xyz_all_folder_Detritus1 <- data.frame(x, y_Detritus, j, j)
    
    
    names(xyz_all_folder_Detritus1)[3] <- "z"
    xyz_all_folder_Detritus <- rbind(xyz_all_folder_Detritus, xyz_all_folder_Detritus1)
    
    # #Absorbance
    # xyz_all_folder_Phytoplankton2 <- data.frame(x2, y2_Phytoplankton, z2, z2)
    # names(xyz_all_folder_Phytoplankton2)[3] <- "z"
    # xyz_all_folder_Phytoplankton_Absorbance <- rbind(xyz_all_folder_Phytoplankton_Absorbance, xyz_all_folder_Phytoplankton2)
    # 
    # 
    
    
    #end j  
  }
  
  
  min_Absorption_Detritus <- min(xyz_all_folder_Detritus$y_Detritus)
  max_Absorption_Detritus <- max(xyz_all_folder_Detritus$y_Detritus)
  
  # min_Absorbance <- min(xyz_all_folder_Phytoplankton_Absorbance$y2_Phytoplankton)
  # max_Absorbance <- max(xyz_all_folder_Phytoplankton_Absorbance$y2_Phytoplankton)
  # 
  
  
  print(paste0("min_Absorption_Detritus = ", min_Absorption_Detritus))
  print(paste0("max_Absorption_Detritus = ", max_Absorption_Detritus))
  
  # print(paste0("min_Absorbance = ", min_Absorbance))
  # print(paste0("max_Absorbance = ", max_Absorbance))
  
  coded_cruise_name <- all_tables_joined_by_folder_name$coded_cruise_name[i]
  
  #min_max_Phytoplankton_Absorption <- data.frame(project_folder_name, coded_cruise_name, min_Absorption, max_Absorption)
  #write.csv(min_max_Phytoplankton_Absorption, paste0("C:/R_WD/WRITE/WORKS_PLOT_Phytoplankton_Absorption_by_QC_flags_Comments/", coded_cruise_name, "_min_max_Phytoplankton_Absorption", ".csv"), row.names = FALSE)
  
  
  
  #end i
}


########## end get min max Detritus Absorption


min_Absorption <- min(min_Absorption_Phytoplankton, min_Absorption_Particulate, min_Absorption_Detritus)
max_Absorption <- max(max_Absorption_Phytoplankton, max_Absorption_Particulate, max_Absorption_Detritus)


min_max_Absorption <- data.frame(project_folder_name, coded_cruise_name, min_Absorption, max_Absorption)
write.csv(min_max_Absorption, paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/", coded_cruise_name, "_min_max_Absorption", ".csv"), row.names = FALSE)


###################################
###################################
################################### end get min max for Absorption Phytoplankton, Particulate and Detritus from WORKS5










#filepath_to_write_plot <- "C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/"

#enter folder that contains all the cruises sub folders
input_folder_to_read_files <- "C:/R_WD/WRITE/WORKS5/RESULTS"
write.csv(input_folder_to_read_files, paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/", "input_folder_to_read_files", ".csv"))


#input_metadata_folder_name <- "C:/R_WD/Metadata_per_cruise"

cruise_name_table_location <- "C:/R_WD/folder_name_to_coded_cruise_name_table.csv"
cruise_name_table <- read.table(cruise_name_table_location, skip = 0, sep = ",", header = TRUE)
cruise_name_table_df <- data.frame(cruise_name_table)


input_folder_name <- sub('\\..*$', '', basename(input_folder_to_read_files))
search_result_for_Absorption_Particulate  <- list.files(pattern = "\\_Absorption_Particulate.csv$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
nrows_search_result_for_Absorption_Particulate <- length(search_result_for_Absorption_Particulate)
write.csv(search_result_for_Absorption_Particulate, paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/", "search_result_for_Absorption_Particulate_", nrows_search_result_for_Absorption_Particulate, "_rows.csv"), row.names = FALSE)

distinct_folders_in_search_result_for_Absorption_Particulate <- unique(dirname(search_result_for_Absorption_Particulate))
distinct_folders_in_search_result_for_Absorption_Particulate_df <- data.frame(distinct_folders_in_search_result_for_Absorption_Particulate)
distinct_folders_in_search_result_for_Absorption_Particulate_df$folder_name <- sub('\\..*$', '', basename(distinct_folders_in_search_result_for_Absorption_Particulate))

#distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df <- inner_join(distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df, cruise_name_table_df, by = c("folder_name"))
distinct_folders_in_search_result_for_Absorption_Particulate_df <- inner_join(distinct_folders_in_search_result_for_Absorption_Particulate_df, cruise_name_table_df, by = c("folder_name"))


nrows_distinct_folders_in_search_result_for_Absorption_Particulate_df <- nrow(distinct_folders_in_search_result_for_Absorption_Particulate_df)
write.csv(distinct_folders_in_search_result_for_Absorption_Particulate_df, paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/", "distinct_folders_in_search_result_for_Absorption_Particulate_df_", nrows_distinct_folders_in_search_result_for_Absorption_Particulate_df, "_rows.csv"), row.names = FALSE)


#disable scientific notation in R.
options(scipen = 999)



for (i in 1:nrow(distinct_folders_in_search_result_for_Absorption_Particulate_df)){

project_folder_name <- distinct_folders_in_search_result_for_Absorption_Particulate_df$folder_name[i]
coded_cruise_name <- distinct_folders_in_search_result_for_Absorption_Particulate_df$coded_cruise_name[i]

filepath_to_write_plot <- paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/RESULTS/", project_folder_name, "/")
  
filepath_to_search <- distinct_folders_in_search_result_for_Absorption_Particulate_df$distinct_folders_in_search_result_for_Absorption_Particulate[i]


search_for_Absorption_Particulate  <- list.files(pattern = "\\_Absorption_Particulate.csv$"  , path = filepath_to_search, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
search_for_Absorption_Detritus <- list.files(pattern = "\\_Absorption_Detritus.csv$"  , path = filepath_to_search, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
search_for_Absorption_Phytoplankton <- list.files(pattern = "\\_Absorption_Phytoplankton.csv$"  , path = filepath_to_search, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)

#if1
if ((length(search_for_Absorption_Particulate) != 1)){
  print (paste0("The length of search result for Absorption_Particulate final table result is different than 1. Please check folder " ,filepath_to_search))
stop()
}else if ((length(search_for_Absorption_Detritus) != 1)){
  print (paste0("The length of search result for Absorption_Detritus final table result is different than 1. Please check folder " ,filepath_to_search))
stop()
}else if ((length(search_for_Absorption_Phytoplankton) != 1)){
  print (paste0("The length of search result for Absorption_Phytoplankton final table result is different than 1. Please check folder " ,filepath_to_search))
stop()
  }else{
  print(paste0("The folder ", filepath_to_search, " looks like it has the Particulate, Detritus and Phytoplankton final table files."))
}


Absorption_Phytoplankton_file <- read.table(search_for_Absorption_Phytoplankton[1], skip = 17, sep = ",", header = TRUE)
Absorption_Particulate_file <- read.table(search_for_Absorption_Particulate[1], skip = 17, sep = ",", header = TRUE)
Absorption_Detritus_file <- read.table(search_for_Absorption_Detritus[1], skip = 17, sep = ",", header = TRUE)

xyz_all_folder_Phytoplankton <- data.frame()
xyz_all_folder_Particulate <- data.frame()
xyz_all_folder_Detritus <- data.frame()
for (j in 1:nrow(Absorption_Phytoplankton_file)){
  
  d6_string <- Absorption_Phytoplankton_file$Sample.ID[j]
  

  
  #x <- as.numeric(Absorption_Phytoplankton_file[1,9:ncol(Absorption_Phytoplankton_file)])#1
  
  x <- names(Absorption_Phytoplankton_file[1,9:ncol(Absorption_Phytoplankton_file)])#1
  
  string <- x
  pattern <- "X"
  replacement <- ""
  x <- str_replace(string, pattern, replacement)

  
  
  y_Phytoplankton <- as.numeric(Absorption_Phytoplankton_file[j,9:ncol(Absorption_Phytoplankton_file)])#2j
  
  for (k in 1:length(y_Phytoplankton)){
    if (y_Phytoplankton[k] == -999){
        y_Phytoplankton[k] <- 0
    }
  }  
  
  
  #z <- as.numeric(i[1:length(x)])
  z <- as.numeric(1:length(x))
  
  y_Particulate <- as.numeric(Absorption_Particulate_file[j,9:ncol(Absorption_Particulate_file)])#2j
  
  for (k in 1:length(y_Particulate)){
    if (y_Particulate[k] == -999){
      y_Particulate[k] <- 0
    }
  }  
  
  
  
  y_Detritus <- as.numeric(Absorption_Detritus_file[j,9:ncol(Absorption_Detritus_file)])#2j
  
  for (k in 1:length(y_Detritus)){
    if (y_Detritus[k] == -999){
      y_Detritus[k] <- 0
    }
  }  
  
  # 
  # for (k in 1:length(z)){
  #   z[j] <- i
  # 
  # 
  # }
  # 
  
  #2d plot all 3 for each file
  
  Wavelength_nm <- x
  #Absorption <- y_Phytoplankton
  File_No <- z
  
  
  dir.create(file.path(paste0(filepath_to_write_plot, "Plot2d_each_file_all3/")), showWarnings = FALSE, recursive = TRUE)
  png(paste0(filepath_to_write_plot, "Plot2d_each_file_all3/", coded_cruise_name, "_", d6_string, "_Absorption.png"), width = 465, height = 225, units = "mm", res = 150)
  
  plot(Wavelength_nm, y_Particulate, xlab = "Wavelength (nm)", ylab = "Absorption", ylim = c(min_Absorption, max_Absorption), type = "l", col = "blue", sub = paste0(project_folder_name, " - ", coded_cruise_name, " - ", " Sample ID = ", d6_string), lwd = 2)
  lines(Wavelength_nm, y_Phytoplankton, col = "green", lwd = 2)
  lines(Wavelength_nm, y_Detritus, col = "black", lwd = 2)
  legend("topright", legend=c("Particulate", "Phytoplankton", "Detritus"),
         col=c("blue", "green", "black"), lty=1, cex=0.7, lwd = 2)
  
  dev.off()
  
  
  
  xyz_all_folder_Phytoplankton1 <- data.frame(x, y_Phytoplankton, j)
  names(xyz_all_folder_Phytoplankton1)[3] <- "z"
  xyz_all_folder_Phytoplankton <- rbind(xyz_all_folder_Phytoplankton, xyz_all_folder_Phytoplankton1)
  
  xyz_all_folder_Particulate1 <- data.frame(x, y_Particulate, j)
  names(xyz_all_folder_Particulate1)[3] <- "z"
  xyz_all_folder_Particulate <- rbind(xyz_all_folder_Particulate, xyz_all_folder_Particulate1)
  
  xyz_all_folder_Detritus1 <- data.frame(x, y_Detritus, j)
  names(xyz_all_folder_Detritus1)[3] <- "z"
  xyz_all_folder_Detritus <- rbind(xyz_all_folder_Detritus, xyz_all_folder_Detritus1)
  
  
}

#Phytoplankton

Wavelength_nm <- xyz_all_folder_Phytoplankton$x
Absorption <- xyz_all_folder_Phytoplankton$y
File_No <- xyz_all_folder_Phytoplankton$z


rgl::open3d()

# resize window
rgl::par3d(windowRect = c(0, 30, 1280, 680))

rgl::plot3d(Wavelength_nm, File_No, Absorption, col = "green", labels = c(1,2,3), 
       size = 1, type='p')

# add legend
rgl::legend3d("topleft", legend = paste('Particulate Absorption - Phytoplankton - ', c(project_folder_name), " - ", c(coded_cruise_name), " - ", length(1:nrow(Absorption_Phytoplankton_file)), " files" ), pch = 16, col = "green", cex=1, inset=c(0.02))

dir.create(file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(1:nrow(Absorption_Phytoplankton_file)), "_files/Phytoplankton" )), showWarnings = FALSE, recursive = TRUE)


browseURL(paste0(filepath_to_write_plot,
                 rgl::writeWebGL(dir=file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(1:nrow(Absorption_Phytoplankton_file)), "_files/Phytoplankton" )))))
rgl::rgl.snapshot(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(1:nrow(Absorption_Phytoplankton_file)), "_files/Phytoplankton/", coded_cruise_name, "_Phytoplankton_Absorption.png" ))                 
rgl::rgl.close()
rgl::rgl.quit()


#Particulate

Wavelength_nm <- xyz_all_folder_Particulate$x
Absorption <- xyz_all_folder_Particulate$y
File_No <- xyz_all_folder_Particulate$z

rgl::open3d()

# resize window
rgl::par3d(windowRect = c(0, 30, 1280, 680))

rgl::plot3d(Wavelength_nm, File_No, Absorption, col = "blue", labels = c(1,2,3), 
       size = 1, type='p')

# add legend
rgl::legend3d("topleft", legend = paste('Particulate Absorption - Particulate - ', c(project_folder_name), " - ", c(coded_cruise_name), " - ", length(1:nrow(Absorption_Phytoplankton_file)), " files" ), pch = 16, col = "blue", cex=1, inset=c(0.02))

dir.create(file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(1:nrow(Absorption_Phytoplankton_file)), "_files/Particulate" )), showWarnings = FALSE, recursive = TRUE)


browseURL(paste0(filepath_to_write_plot,
                 rgl::writeWebGL(dir=file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(1:nrow(Absorption_Phytoplankton_file)), "_files/Particulate" )))))
rgl::rgl.snapshot(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(1:nrow(Absorption_Phytoplankton_file)), "_files/Particulate/", coded_cruise_name, "_Particulate_Absorption.png" ))
rgl::rgl.close()
rgl::rgl.quit()


#Detritus

Wavelength_nm <- xyz_all_folder_Detritus$x
Absorption <- xyz_all_folder_Detritus$y
File_No <- xyz_all_folder_Detritus$z

rgl::open3d()

# resize window
rgl::par3d(windowRect = c(0, 30, 1280, 680))

rgl::plot3d(Wavelength_nm, File_No, Absorption, col = "black", labels = c(1,2,3), 
       size = 1, type='p')

# add legend
rgl::legend3d("topleft", legend = paste('Particulate Absorption - Detritus - ', c(project_folder_name), " - ", c(coded_cruise_name), " - ", length(1:nrow(Absorption_Phytoplankton_file)), " files" ), pch = 16, col = "black", cex=1, inset=c(0.02))

dir.create(file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(1:nrow(Absorption_Phytoplankton_file)), "_files/Detritus" )), showWarnings = FALSE, recursive = TRUE)


browseURL(paste0(filepath_to_write_plot,
                 rgl::writeWebGL(dir=file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(1:nrow(Absorption_Phytoplankton_file)), "_files/Detritus" )))))
rgl::rgl.snapshot(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(1:nrow(Absorption_Phytoplankton_file)), "_files/Detritus/", coded_cruise_name, "_Detritus_Absorption.png" ))
rgl::rgl.close()
rgl::rgl.quit()


#all_3_in_one                    

rgl::open3d()

# resize window
rgl::par3d(windowRect = c(0, 30, 1280, 680))

# plot3d(Wavelength_nm, File_No, Absorption, col = "black", labels = c(1,2,3), 
#        size = 1, type='p')

rgl::plot3d(xyz_all_folder_Phytoplankton$x, xyz_all_folder_Phytoplankton$z, xyz_all_folder_Phytoplankton$y, xlab = "Wavelength_nm", ylab = "File_No", zlab = "Absorption", col = "green", labels = c(1,2,3), size = 1, type='p')
rgl::plot3d(xyz_all_folder_Detritus$x, xyz_all_folder_Detritus$z, xyz_all_folder_Detritus$y, col = "black", labels = c(1,2,3), size = 1, type='p', add = TRUE)
rgl::plot3d(xyz_all_folder_Particulate$x, xyz_all_folder_Particulate$z, xyz_all_folder_Particulate$y, col = "blue", labels = c(1,2,3), size = 1, type='p', add = TRUE)


# add legend
rgl::legend3d("topleft", legend = c(paste('Particulate Absorption - Phytoplankton - ', c(project_folder_name), " - ", c(coded_cruise_name), " - ", length(1:nrow(Absorption_Phytoplankton_file)), " files" ),
                               paste('Particulate Absorption - Particulate       - ', c(project_folder_name), " - ", c(coded_cruise_name), " - ", length(1:nrow(Absorption_Phytoplankton_file)), " files" ), 
                               paste('Particulate Absorption - Detritus            - ', c(project_folder_name), " - ", c(coded_cruise_name), " - ", length(1:nrow(Absorption_Phytoplankton_file)), " files" )),
         
         pch = 16, col = c("green", "blue", "black"), cex=1, inset=c(0.02))



dir.create(file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(1:nrow(Absorption_Phytoplankton_file)), "_files/all_3" )), showWarnings = FALSE, recursive = TRUE)


browseURL(paste0(filepath_to_write_plot,
                 rgl::writeWebGL(dir=file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(1:nrow(Absorption_Phytoplankton_file)), "_files/all_3" )))))
rgl::rgl.snapshot(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(1:nrow(Absorption_Phytoplankton_file)), "_files/all_3/", project_folder_name, "_" , coded_cruise_name, "_all_3_Absorption.png" ))

dir.create(file.path(paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/RESULTS/1_index_png/")), showWarnings = FALSE, recursive = TRUE)
rgl::rgl.snapshot(paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/RESULTS/1_index_png/", project_folder_name, "_" , coded_cruise_name, "_all_3_Absorption.png" ))



rgl::rgl.close()
rgl::rgl.quit()



#end h  
}

rgl::rgl.quit()

end_time <- Sys.time()
start_time
end_time







