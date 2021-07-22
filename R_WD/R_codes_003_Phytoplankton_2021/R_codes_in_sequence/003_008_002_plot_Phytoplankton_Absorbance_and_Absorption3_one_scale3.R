#plot_Phytoplankton_Absorbance_and_Absorption

#001_008_plot_Phytoplankton_Absorption_final_table_QC_by_QC_flags_Comments_21_2

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021

#-999 values are plotted as 0

start_time <- Sys.time()
print(paste0("start_time = ", start_time))

setwd("C:/R_WD")
getwd()

#install.packages("rgl", dependencies = TRUE)

library("rgl")
library("dplyr")
library("stringr")
library("reader")

# filter_diameter <- 16.5

dir.create(file.path("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption"), showWarnings = FALSE, recursive = TRUE)

#filepath_to_write_plot <- "C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/"

#enter Absorption folder that contains all the cruises sub folders
input_folder_to_read_files <- "C:/R_WD/WRITE/WORKS7"
write.csv(input_folder_to_read_files, paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/", "input_folder_to_read_files", ".csv"))


cruise_name_table_location <- "C:/R_WD/folder_name_to_coded_cruise_name_table.csv"
cruise_name_table <- read.table(cruise_name_table_location, skip = 0, sep = ",", header = TRUE)
cruise_name_table_df <- data.frame(cruise_name_table)


input_folder_name <- sub('\\..*$', '', basename(input_folder_to_read_files))
search_result_for_Absorption_Phytoplankton_QC  <- list.files(pattern = "\\_Absorption_Phytoplankton_QC_Comments.csv$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
search_result_for_Absorption_Phytoplankton_QC_df <- data.frame(search_result_for_Absorption_Phytoplankton_QC)
search_result_for_Absorption_Phytoplankton_QC_df$folder_name <- basename(dirname(search_result_for_Absorption_Phytoplankton_QC))

nrows_search_result_for_Absorption_Phytoplankton_QC_df <- nrow(search_result_for_Absorption_Phytoplankton_QC_df)
write.csv(search_result_for_Absorption_Phytoplankton_QC_df, paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/", "search_result_for_Absorption_Phytoplankton_QC_df_", nrows_search_result_for_Absorption_Phytoplankton_QC_df, "_rows.csv"), row.names = FALSE)


distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC <- unique(dirname(search_result_for_Absorption_Phytoplankton_QC))
distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df <- data.frame(distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC)
distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df$folder_name <- sub('\\..*$', '', basename(distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC))

nrows_distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df <- nrow(distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df)
write.csv(distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df, paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/", "distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df_", nrows_distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df, "_rows.csv"), row.names = FALSE)


all_tables_joined_by_folder_name <- inner_join(cruise_name_table_df, search_result_for_Absorption_Phytoplankton_QC_df, by = c("folder_name"))
all_tables_joined_by_folder_name <- inner_join(all_tables_joined_by_folder_name, distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df, by = c("folder_name"))
nrows_all_tables_joined_by_folder_name <- nrow(all_tables_joined_by_folder_name)
write.csv(all_tables_joined_by_folder_name, paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/", "all_tables_joined_by_folder_name_", nrows_all_tables_joined_by_folder_name, "_rows.csv"), row.names = FALSE)




#disable scientific notation in R.
options(scipen = 999)


########## start get min max Absorption and Absorbance



for (i in 1:nrow(all_tables_joined_by_folder_name)){
  
  #i <- 1
  
  print(paste0("Working on folder ", all_tables_joined_by_folder_name$folder_name[i], " ", all_tables_joined_by_folder_name$coded_cruise_name[i], " to get min and max for Phytoplankton Absorption and Absorbance"))
  
  
  project_folder_name <- all_tables_joined_by_folder_name$folder_name[i]
  filepath_to_write_plot <- paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/RESULTS/", project_folder_name, "/")
  
  Absorption_Phytoplankton_file <- read.table(all_tables_joined_by_folder_name$search_result_for_Absorption_Phytoplankton_QC[i], skip = 17, sep = ",", header = TRUE)#, row.names = NULL)
  
  
  
  xyz_all_folder_Phytoplankton <- data.frame()
  xyz_all_folder_Phytoplankton_Absorbance <- data.frame()
  
  
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
    
    w <- rep(paste0(Absorption_Phytoplankton_file$QC_flag_410_smaller_than_440[j], Absorption_Phytoplankton_file$QC_flag_443_to_490[j], Absorption_Phytoplankton_file$QC_flag_ChlA_to_443_550_670[j]), times = length(x), length.out = NA, each = 1)
    
    
    Wavelength_nm <- x
    #Absorption <- y_Phytoplankton
    Sample_IDs <- z
    
    # #d6_string
    # #project_folder_name
    # 
    # #the absorbance file
    # 
    # # d6_string <- 476288
    # # project_folder_name <- "AMU2019-001 Lab sea"
    
    input_folder_to_read_the_absorbance_file <- paste0("C:/R_WD/WRITE/WORKS/RESULTS/", project_folder_name, "/")
    
    search_result_d6Phytoplankton_txt_Absorbance_file  <- list.files(pattern = paste0(d6_string, "Phytoplankton.txt")  , path = input_folder_to_read_the_absorbance_file, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
    
    #if length = 0
    
    if (length(search_result_d6Phytoplankton_txt_Absorbance_file) == 0){
      search_result_d6Phytoplankton_txt_Absorbance_file  <- list.files(pattern = paste0(d6_string, "\\S+", "Phytoplankton.txt")  , path = input_folder_to_read_the_absorbance_file, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
    }
    
    if (length(search_result_d6Phytoplankton_txt_Absorbance_file) == 0){
      stop(paste0("The Phytoplankton Absorbance txt file with Sample ID = ", d6_string, " could not be found in cruise folder C:/R_WD/WRITE/WORKS/RESULTS/", project_folder_name))
    }
    
    if (length(search_result_d6Phytoplankton_txt_Absorbance_file) > 1){
      stop(paste0("More than one Phytoplankton Absorbance txt file with Sample ID = ", d6_string, " have been found in cruise folder C:/R_WD/WRITE/WORKS/RESULTS/", project_folder_name))
    }
    
    
    d6Phytoplankton_Absorbance_txt_file <- read.table(search_result_d6Phytoplankton_txt_Absorbance_file, skip = 1, sep = ",", header = TRUE)
    
    
    x2 <- d6Phytoplankton_Absorbance_txt_file[,1]
    y2_Phytoplankton <- d6Phytoplankton_Absorbance_txt_file[,4]
    
    
    y2_Particulate <- d6Phytoplankton_Absorbance_txt_file[,2]
    y2_Detritus <- d6Phytoplankton_Absorbance_txt_file[,3]
    
    #Absorbance 1:801
    z2 <- as.numeric(1:length(x2))
    
    #change all -999 to 0
    for (m in 1:length(x2)){
      
      #if1
      if (y2_Particulate[m] == -999){
        
        y2_Particulate[m] <- 0
        y2_Phytoplankton[m] <- 0
        
        #end if1  
      }
      
      
      #if2
      if (y2_Detritus[m] == -999){
        
        y2_Detritus[m] <- 0
        y2_Phytoplankton[m] <- 0
        
        #end if2  
      }
      
      
      #end m  
    }
    
    
    
    #2d plot all 3 for each file
    
    Wavelength_nm2 <- x2
    #Absorbance <- y2_Phytoplankton 
    
    
    
    #the IF sequences
    
    
    
    #Absorption
    xyz_all_folder_Phytoplankton1 <- data.frame(x, y_Phytoplankton, j, w)
    names(xyz_all_folder_Phytoplankton1)[3] <- "z"
    xyz_all_folder_Phytoplankton <- rbind(xyz_all_folder_Phytoplankton, xyz_all_folder_Phytoplankton1)
    
    #Absorbance
    xyz_all_folder_Phytoplankton2 <- data.frame(x2, y2_Phytoplankton, z2, z2)
    names(xyz_all_folder_Phytoplankton2)[3] <- "z"
    xyz_all_folder_Phytoplankton_Absorbance <- rbind(xyz_all_folder_Phytoplankton_Absorbance, xyz_all_folder_Phytoplankton2)
    
    
   
    
    #end j  
  }
  
  
  min_Absorption <- min(xyz_all_folder_Phytoplankton$y_Phytoplankton)
  max_Absorption <- max(xyz_all_folder_Phytoplankton$y_Phytoplankton)
  
  min_Absorbance <- min(xyz_all_folder_Phytoplankton_Absorbance$y2_Phytoplankton)
  max_Absorbance <- max(xyz_all_folder_Phytoplankton_Absorbance$y2_Phytoplankton)
  
  
  
  print(paste0("min_Absorption = ", min_Absorption))
  print(paste0("max_Absorption = ", max_Absorption))
  
  print(paste0("min_Absorbance = ", min_Absorbance))
  print(paste0("max_Absorbance = ", max_Absorbance))
  
  min_max_Phytoplankton_Absorption_and_Absorbance <- data.frame(project_folder_name, min_Absorption, max_Absorption, min_Absorbance, max_Absorbance)
  write.csv(all_tables_joined_by_folder_name, paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/", "min_max_Phytoplankton_Absorption_and_Absorbance", ".csv"), row.names = FALSE)
  
  
  
  #Phytoplankton
  
  #Absorption
  Wavelength_nm <- xyz_all_folder_Phytoplankton$x
  Absorption <- xyz_all_folder_Phytoplankton$y
  Sample_IDs <- xyz_all_folder_Phytoplankton$z
  QC_flag_list <- xyz_all_folder_Phytoplankton$w
  
  # ??? y y2
  Absorbance <- xyz_all_folder_Phytoplankton_Absorbance$y2
  
  
  # colour by number list 
  # 
  # 1 black
  # 2 red
  # 3 green
  # 4 blue
  # 5 turquoise
  # 6 purple
  # 7 orange
  # 8 grey
  
  
  
  
  #end i
}

#rgl::rgl.quit()



########## end get min max Absorption and Absorbance


for (i in 1:nrow(all_tables_joined_by_folder_name)){
  
  #i <- 1
  
  print(paste0("Working on folder ", all_tables_joined_by_folder_name$folder_name[i], " ", all_tables_joined_by_folder_name$coded_cruise_name[i]))
  
  
  project_folder_name <- all_tables_joined_by_folder_name$folder_name[i]
  filepath_to_write_plot <- paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/RESULTS/", project_folder_name, "/")
  
  Absorption_Phytoplankton_file <- read.table(all_tables_joined_by_folder_name$search_result_for_Absorption_Phytoplankton_QC[i], skip = 17, sep = ",", header = TRUE)#, row.names = NULL)
  
  
  
  xyz_all_folder_Phytoplankton <- data.frame()
  xyz_all_folder_Phytoplankton_Absorbance <- data.frame()
  
  
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
    
    w <- rep(paste0(Absorption_Phytoplankton_file$QC_flag_410_smaller_than_440[j], Absorption_Phytoplankton_file$QC_flag_443_to_490[j], Absorption_Phytoplankton_file$QC_flag_ChlA_to_443_550_670[j]), times = length(x), length.out = NA, each = 1)
    
    
    Wavelength_nm <- x
    #Absorption <- y_Phytoplankton
    Sample_IDs <- z
    
    
    dir.create(file.path(paste0(filepath_to_write_plot, "Plot2d_each_file_QC_flag_by_color/")), showWarnings = FALSE, recursive = TRUE)
    png(paste0(filepath_to_write_plot, "Plot2d_each_file_QC_flag_by_color/", d6_string, "_Phytoplankton_Absorption_by_QC_flag_color.png"), width = 465, height = 225, units = "mm", res = 150)
    
    if (Absorption_Phytoplankton_file$Comments[j] == paste0("No filter diameter specified - used ", filter_diameter, " mm") && 
        Absorption_Phytoplankton_file$QC_flag_410_smaller_than_440[j] == 0 &&
        Absorption_Phytoplankton_file$QC_flag_443_to_490[j] == 0 &&
        Absorption_Phytoplankton_file$QC_flag_ChlA_to_443_550_670[j] == 0){
      
      
      phyto_negative <- "Phytoplankton contains negative values"
      
    }else{
      
      phyto_negative <- "All values are -999 and are plotted as 0 "
      
    }
    
    
    if (Absorption_Phytoplankton_file$QC_flag_410_smaller_than_440[j] == 1){
      
      text_410_440 <- "410 < 440 passed"
      
    }else{
      
      text_410_440 <- "410 < 440 failed"
      
    }
    
    
    
    
    
    
    
    
    
    
    #d6_string
    #project_folder_name
    
    #the absorbance file
    
    # d6_string <- 476288
    # project_folder_name <- "AMU2019-001 Lab sea"
    
    input_folder_to_read_the_absorbance_file <- paste0("C:/R_WD/WRITE/WORKS/RESULTS/", project_folder_name, "/")
    
    search_result_d6Phytoplankton_txt_Absorbance_file  <- list.files(pattern = paste0(d6_string, "Phytoplankton.txt")  , path = input_folder_to_read_the_absorbance_file, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
    
    #if length = 0
    
    if (length(search_result_d6Phytoplankton_txt_Absorbance_file) == 0){
    search_result_d6Phytoplankton_txt_Absorbance_file  <- list.files(pattern = paste0(d6_string, "\\S+", "Phytoplankton.txt")  , path = input_folder_to_read_the_absorbance_file, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
    }
    
    if (length(search_result_d6Phytoplankton_txt_Absorbance_file) == 0){
    stop(paste0("The Phytoplankton Absorbance txt file with Sample ID = ", d6_string, " could not be found in cruise folder C:/R_WD/WRITE/WORKS/RESULTS/", project_folder_name))
    }
    
    if (length(search_result_d6Phytoplankton_txt_Absorbance_file) > 1){
      stop(paste0("More than one Phytoplankton Absorbance txt file with Sample ID = ", d6_string, " have been found in cruise folder C:/R_WD/WRITE/WORKS/RESULTS/", project_folder_name))
    }
    
    
    d6Phytoplankton_Absorbance_txt_file <- read.table(search_result_d6Phytoplankton_txt_Absorbance_file, skip = 1, sep = ",", header = TRUE)
    
    
    x2 <- d6Phytoplankton_Absorbance_txt_file[,1]
    y2_Phytoplankton <- d6Phytoplankton_Absorbance_txt_file[,4]

    
    y2_Particulate <- d6Phytoplankton_Absorbance_txt_file[,2]
    y2_Detritus <- d6Phytoplankton_Absorbance_txt_file[,3]
    
    #Absorbance 1:801
    z2 <- as.numeric(1:length(x2))
    
    #change all -999 to 0
    for (m in 1:length(x2)){
      
      #if1
      if (y2_Particulate[m] == -999){
        
        y2_Particulate[m] <- 0
        y2_Phytoplankton[m] <- 0
        
        #end if1  
      }
      
      
      #if2
      if (y2_Detritus[m] == -999){
        
        y2_Detritus[m] <- 0
        y2_Phytoplankton[m] <- 0
        
        #end if2  
      }
      
      
      #end m  
    }
    
    
    
    #2d plot all 3 for each file
    
    Wavelength_nm2 <- x2
    #Absorbance <- y2_Phytoplankton 
    
    
    # ylim=c(min_Absorbance, max_Absorbance),
    # ylim = range(c(min_Absorbance, max_Absorbance))
    
    if (Absorption_Phytoplankton_file$QC_flag_410_smaller_than_440[j] == 0 && Absorption_Phytoplankton_file$QC_flag_443_to_490[j] == 0 && Absorption_Phytoplankton_file$QC_flag_ChlA_to_443_550_670[j] == 0){   
      
      # plot(Wavelength_nm, y_Phytoplankton, xlab = "Wavelength (nm)", ylab = "Absorption", type = "l", col = "black", lwd=2, sub = paste0(project_folder_name, " - ",all_tables_joined_by_folder_name$coded_cruise_name[i]," - " ,"Pkytoplankton Absorption by QC flags - Sample ID = " , d6_string))
      # legend("topright", legend=c("black 000 - All QC flags = 0 - no quality control ", paste0("Comments: ", Absorption_Phytoplankton_file$Comments[j]), phyto_negative),
      #        col=c("black"), lty=1, cex=0.7, lwd=2)
      
      plot(Wavelength_nm2, y2_Phytoplankton, xlab = "Wavelength (nm)", ylab = "Absorbance and Absorption", ylim = c(min_Absorbance, max_Absorbance), type = "l", col = "turquoise", lwd=2, sub = paste0(project_folder_name, " - ",all_tables_joined_by_folder_name$coded_cruise_name[i]," - " ,"Pkytoplankton Absorbance and Absorption by QC flags - Sample ID = " , d6_string))
      lines(Wavelength_nm, y_Phytoplankton, col = "black", lwd=2)
      legend("topright", legend=c("Absorbance", "Absorption black 000 - All QC flags = 0 - no quality control ", paste0("Comments: ", Absorption_Phytoplankton_file$Comments[j]), phyto_negative),
             col=c("turquoise", "black", "black", "black"), lty=1, cex=0.7, lwd=2)
      
    }else if (Absorption_Phytoplankton_file$QC_flag_410_smaller_than_440[j] == 1 && Absorption_Phytoplankton_file$QC_flag_443_to_490[j] == 1 && Absorption_Phytoplankton_file$QC_flag_ChlA_to_443_550_670[j] == 1){
      
      # plot(Wavelength_nm, y_Phytoplankton, xlab = "Wavelength (nm)", ylab = "Absorption", type = "l", col = "green", lwd=2, sub = paste0(project_folder_name, " - ",all_tables_joined_by_folder_name$coded_cruise_name[i]," - " ,"Pkytoplankton Absorption by QC flags - Sample ID = " , d6_string))
      # legend("topright", legend=c("green 111 - 410nm < 440nm passed, 443_to_490 passed, ChlA_to_443_550_670 passed", "value seems correct ", paste0("Comments: ", Absorption_Phytoplankton_file$Comments[j])),
      #        col=c("green"), lty=1, cex=0.7, lwd=2)
      
      plot(Wavelength_nm2, y2_Phytoplankton, xlab = "Wavelength (nm)", ylab = "Absorbance and Absorption", ylim = c(min_Absorbance, max_Absorbance), type = "l", col = "turquoise", lwd=2, sub = paste0(project_folder_name, " - ",all_tables_joined_by_folder_name$coded_cruise_name[i]," - " ,"Pkytoplankton Absorbance and Absorption by QC flags - Sample ID = " , d6_string))
      lines(Wavelength_nm, y_Phytoplankton, col = "green", lwd=2)
      legend("topright", legend=c("Absorbance", "Absorption green 111 - 410nm < 440nm passed, 443_to_490 passed, ChlA_to_443_550_670 passed", "value seems correct ", paste0("Comments: ", Absorption_Phytoplankton_file$Comments[j])),
             col=c("turquoise", "green", "green", "green"), lty=1, cex=0.7, lwd=2)
      
    }else if (Absorption_Phytoplankton_file$QC_flag_410_smaller_than_440[j] == 4 && Absorption_Phytoplankton_file$QC_flag_443_to_490[j] == 1 && Absorption_Phytoplankton_file$QC_flag_ChlA_to_443_550_670[j] == 1){
      
      # plot(Wavelength_nm, y_Phytoplankton, xlab = "Wavelength (nm)", ylab = "Absorption", type = "l", col = "blue", lwd=2, sub = paste0(project_folder_name, " - ",all_tables_joined_by_folder_name$coded_cruise_name[i]," - " ,"Pkytoplankton Absorption by QC flags - Sample ID = " , d6_string))
      # legend("topright", legend=c("blue 411 - 410nm < 440nm failed, 443_to_490 passed, ChlA_to_443_550_670 passed ", paste0("Comments: ", Absorption_Phytoplankton_file$Comments[j])),
      #        col=c("blue"), lty=1, cex=0.7, lwd=2)
      
      plot(Wavelength_nm2, y2_Phytoplankton, xlab = "Wavelength (nm)", ylab = "Absorbance and Absorption", ylim = c(min_Absorbance, max_Absorbance), type = "l", col = "turquoise", lwd=2, sub = paste0(project_folder_name, " - ",all_tables_joined_by_folder_name$coded_cruise_name[i]," - " ,"Pkytoplankton Absorbance and Absorption by QC flags - Sample ID = " , d6_string))
      lines(Wavelength_nm, y_Phytoplankton, col = "blue", lwd=2)
      legend("topright", legend=c("Absorbance", "Absorption blue 411 - 410nm < 440nm failed ", "443_to_490 passed, ChlA_to_443_550_670 passed ", paste0("Comments: ", Absorption_Phytoplankton_file$Comments[j])),
             col=c("turquoise", "blue", "blue", "blue"), lty=1, cex=0.7, lwd=2)
      
      
      
    }else if (Absorption_Phytoplankton_file$QC_flag_443_to_490[j] == 2 && Absorption_Phytoplankton_file$QC_flag_ChlA_to_443_550_670[j] == 2){
      
      # plot(Wavelength_nm, y_Phytoplankton, xlab = "Wavelength (nm)", ylab = "Absorption", type = "l", col = "red", lwd=2, sub = paste0(project_folder_name, " - ",all_tables_joined_by_folder_name$coded_cruise_name[i]," - " ,"Pkytoplankton Absorption by QC flags - Sample ID = " , d6_string))
      # legend("topright", legend=c(paste0("red x22 - ", text_410_440, ", 443_to_490 failed, ChlA_to_443_550_670 failed ", " value seems doubtful "), paste0("Comments: ", Absorption_Phytoplankton_file$Comments[j])),
      #        col=c("red"), lty=1, cex=0.7, lwd=2)
      
      plot(Wavelength_nm2, y2_Phytoplankton, xlab = "Wavelength (nm)", ylab = "Absorbance and Absorption", ylim = c(min_Absorbance, max_Absorbance), type = "l", col = "turquoise", lwd=2, sub = paste0(project_folder_name, " - ",all_tables_joined_by_folder_name$coded_cruise_name[i]," - " ,"Pkytoplankton Absorbance and Absorption by QC flags - Sample ID = " , d6_string))
      lines(Wavelength_nm, y_Phytoplankton, col = "red", lwd=2)
      legend("topright", legend=c("Absorbance", paste0("Absorption red x22 - ", text_410_440, ", 443_to_490 failed, ChlA_to_443_550_670 failed "), " value seems doubtful ", paste0("Comments: ", Absorption_Phytoplankton_file$Comments[j])),
             col=c("turquoise", "red", "red", "red"), lty=1, cex=0.7, lwd=2)
      
      print(paste0("The sample ID = ", d6_string, " within the folder folder ", all_tables_joined_by_folder_name$folder_name[i], " ", all_tables_joined_by_folder_name$coded_cruise_name[i], ", Sample ID's = ", nrow(Absorption_Phytoplankton_file), " failed on both QC tests 443_to_490 and ChlA_to_443_550_670"))
      
      
    }else if (Absorption_Phytoplankton_file$QC_flag_443_to_490[j] == 2 && Absorption_Phytoplankton_file$QC_flag_ChlA_to_443_550_670[j] == 1){
      
      # plot(Wavelength_nm, y_Phytoplankton, xlab = "Wavelength (nm)", ylab = "Absorption", type = "l", col = "orange", lwd=2, sub = paste0(project_folder_name, " - ",all_tables_joined_by_folder_name$coded_cruise_name[i]," - " ,"Pkytoplankton Absorption by QC flags - Sample ID = " , d6_string))
      # legend("topright", legend=c(paste0("orange x21 - ", text_410_440, ", 443_to_490 failed, ChlA_to_443_550_670 passed"), "value appears inconsistent with other values ", paste0("Comments: ", Absorption_Phytoplankton_file$Comments[j])),
      #        col=c("orange"), lty=1, cex=0.7, lwd=2)
      
      plot(Wavelength_nm2, y2_Phytoplankton, xlab = "Wavelength (nm)", ylab = "Absorbance and Absorption", ylim = c(min_Absorbance, max_Absorbance), type = "l", col = "turquoise", lwd=2, sub = paste0(project_folder_name, " - ",all_tables_joined_by_folder_name$coded_cruise_name[i]," - " ,"Pkytoplankton Absorbance and Absorption by QC flags - Sample ID = " , d6_string))
      lines(Wavelength_nm, y_Phytoplankton, col = "orange", lwd=2)
      legend("topright", legend=c("Absorbance", paste0("Absorption orange x21 - ", text_410_440, ", 443_to_490 failed, ChlA_to_443_550_670 passed"), "value appears inconsistent with other values ", paste0("Comments: ", Absorption_Phytoplankton_file$Comments[j])),
             col=c("turquoise", "orange", "orange", "orange"), lty=1, cex=0.7, lwd=2)
      
      
    }else if (Absorption_Phytoplankton_file$QC_flag_443_to_490[j] == 1 && Absorption_Phytoplankton_file$QC_flag_ChlA_to_443_550_670[j] == 2){
      
      # plot(Wavelength_nm, y_Phytoplankton, xlab = "Wavelength (nm)", ylab = "Absorption", type = "l", col = "purple", lwd=2, sub = paste0(project_folder_name, " - ",all_tables_joined_by_folder_name$coded_cruise_name[i]," - " ,"Pkytoplankton Absorption by QC flag 0123 - Sample ID = " , d6_string))
      # legend("topright", legend=c(paste0("purple x12 - ", text_410_440, ", 443_to_490 passed, ChlA_to_443_550_670 failed"), "value appears inconsistent with other values ", paste0("Comments: ", Absorption_Phytoplankton_file$Comments[j])),
      #        col=c("purple"), lty=1, cex=0.7, lwd=2)    
      
      
      plot(Wavelength_nm2, y2_Phytoplankton, xlab = "Wavelength (nm)", ylab = "Absorbance and Absorption", ylim = c(min_Absorbance, max_Absorbance), type = "l", col = "turquoise", lwd=2, sub = paste0(project_folder_name, " - ",all_tables_joined_by_folder_name$coded_cruise_name[i]," - " ,"Pkytoplankton Absorbance and Absorption by QC flags - Sample ID = " , d6_string))
      lines(Wavelength_nm, y_Phytoplankton, col = "purple", lwd=2)
      legend("topright", legend=c("Absorbance", paste0("Absorption purple x12 - ", text_410_440, ", 443_to_490 passed, ChlA_to_443_550_670 failed"), "value appears inconsistent with other values ", paste0("Comments: ", Absorption_Phytoplankton_file$Comments[j])),
             col=c("turquoise", "purple", "purple", "purple"), lty=1, cex=0.7, lwd=2)
      
      
    }
    
    dev.off()
    
    
    #Absorption
    xyz_all_folder_Phytoplankton1 <- data.frame(x, y_Phytoplankton, j, w)
    names(xyz_all_folder_Phytoplankton1)[3] <- "z"
    xyz_all_folder_Phytoplankton <- rbind(xyz_all_folder_Phytoplankton, xyz_all_folder_Phytoplankton1)
    
    #Absorbance
    xyz_all_folder_Phytoplankton2 <- data.frame(x2, y2_Phytoplankton, z2, z2)
    names(xyz_all_folder_Phytoplankton2)[3] <- "z"
    xyz_all_folder_Phytoplankton_Absorbance <- rbind(xyz_all_folder_Phytoplankton_Absorbance, xyz_all_folder_Phytoplankton2)
    
    
    
    #end j  
  }
  
  #Phytoplankton
  
  #Absorption
  Wavelength_nm <- xyz_all_folder_Phytoplankton$x
  Absorption <- xyz_all_folder_Phytoplankton$y
  Sample_IDs <- xyz_all_folder_Phytoplankton$z
  QC_flag_list <- xyz_all_folder_Phytoplankton$w
  
  # ??? y y2
  Absorbance <- xyz_all_folder_Phytoplankton_Absorbance$y2
  
  
  # colour by number list 
  # 
  # 1 black
  # 2 red
  # 3 green
  # 4 blue
  # 5 turquoise
  # 6 purple
  # 7 orange
  # 8 grey
  
  
  QC_flag_colours <- QC_flag_list
  
  
  string <- QC_flag_colours
  pattern <- c("000")
  replacement <- c("black")
  QC_flag_colours <- str_replace(string, pattern, replacement)
  
  string <- QC_flag_colours
  pattern <- c("111")
  replacement <- c("green")
  QC_flag_colours <- str_replace(string, pattern, replacement)
  
  string <- QC_flag_colours
  pattern <- c("411")
  replacement <- c("blue")
  QC_flag_colours <- str_replace(string, pattern, replacement)
  
  string <- QC_flag_colours
  pattern <- c("121")
  replacement <- c("orange")
  QC_flag_colours <- str_replace(string, pattern, replacement)
  
  string <- QC_flag_colours
  pattern <- c("421")
  replacement <- c("orange")
  QC_flag_colours <- str_replace(string, pattern, replacement)
  
  string <- QC_flag_colours
  pattern <- c("112")
  replacement <- c("purple")
  QC_flag_colours <- str_replace(string, pattern, replacement)
  
  string <- QC_flag_colours
  pattern <- c("412")
  replacement <- c("purple")
  QC_flag_colours <- str_replace(string, pattern, replacement)
  
  string <- QC_flag_colours
  pattern <- c("122")
  replacement <- c("red")
  QC_flag_colours <- str_replace(string, pattern, replacement)
  
  string <- QC_flag_colours
  pattern <- c("422")
  replacement <- c("red")
  QC_flag_colours <- str_replace(string, pattern, replacement)
  
  
  
  
  # QC_flag_colours_no
  #   1 black
  #   3 green
  #   7 orange
  #   2 red
  
  
  rgl::open3d()
  
  # resize window
  rgl::par3d(windowRect = c(0, 30, 1280, 680))
  
  
  rgl::plot3d(Wavelength_nm, Sample_IDs, Absorption, col = QC_flag_colours, labels = c(1,2,3), 
              size = 1, type='p')
  
  # add legend topleft
  rgl::legend3d("topleft", legend = c(paste('Phytoplankton Absorption by QC_flags'), paste(c(project_folder_name)), paste(all_tables_joined_by_folder_name$coded_cruise_name[i]," - ", length(1:nrow(Absorption_Phytoplankton_file)), " Sample ID's" ), paste(' '),
                                      paste('Phytoplankton Absorbance - color = turquoise'), paste(' '),
                                      paste('QC_Flags = 000   color = black   -  no quality control'), paste(' '),
                                      paste('QC_Flags = 111   color = green    '), paste('410nm < 440nm passed,'), paste('443_to_490 passed, '), paste('ChlA_to_443_550_670 passed,'), paste('value seems correct'),  paste(' '),
                                      paste('QC_Flags = 411   color = blue     '), paste('410nm < 440nm failed,'), paste('443_to_490 passed, '), paste('ChlA_to_443_550_670 passed'),  paste(' '),
                                      paste('QC_Flags = x21   color = orange   '), paste('443_to_490 failed,'), paste('ChlA_to_443_550_670 passed,'), paste('value appears inconsistent with other values'),  paste(' '),
                                      paste('QC_Flags = x12   color = purple   '), paste('443_to_490 passed,'), paste('ChlA_to_443_550_670 failed,'), paste('value appears inconsistent with other values'),  paste(' '),
                                      paste('QC_Flags = x22   color = red      '), paste('443_to_490 failed,'), paste('ChlA_to_443_550_670 failed,'), paste('value seems doubtful')),
                
                pch = 16, col = c("white", "white", "white", "white", "turquoise", "white", "black", "white", "green", "green", "green", "green", "green", "white", "blue", "blue", "blue", "blue", "white", "orange", "orange", "orange", "orange", "white", "purple", "purple", "purple", "purple", "white", "red", "red", "red", "red"), cex=1, inset=c(0.02) 
                )#, add = TRUE)#, box.lty = 0)
  
  rgl::points3d(Wavelength_nm2, Sample_IDs, Absorbance, color = "turquoise", lwd = 0.3, add = TRUE)
  
  dir.create(file.path(paste0(filepath_to_write_plot, "one_3d_plot_by_QC_flag_color_", length(1:nrow(Absorption_Phytoplankton_file)), "_SampleIDs" )), showWarnings = FALSE, recursive = TRUE)
  #paste0(filepath_to_write_plot, "one_3d_plot_by_QC_flag_color_", length(1:nrow(Absorption_Phytoplankton_file)), "_SampleIDs" )
  
  # filename <- tempfile(fileext = paste0(all_tables_joined_by_folder_name$coded_cruise_name[i], "_Phytoplankton_Absorption_by_QC_Comments_", length(1:nrow(Absorption_Phytoplankton_file)), "_SampleIDs.html"))
  # htmlwidgets::saveWidget(rglwidget(), filename)
  # browseURL(filename)
  
  
  #saves the 3d plot as interactive html but it doesn't work with this plot
  browseURL(paste0(filepath_to_write_plot, rgl::writeWebGL(dir=file.path(paste0(filepath_to_write_plot, "one_3d_plot_by_QC_flag_color_", length(1:nrow(Absorption_Phytoplankton_file)), "_SampleIDs" )))))
  
  
  #rgl.postscript(paste0(filepath_to_write_plot, "one_3d_plot_", length(1:nrow(Absorption_Phytoplankton_file)), "_SampleIDs/", all_tables_joined_by_folder_name$coded_cruise_name[i], "_Phytoplankton_Absorption_by_QC_Comments_", length(1:nrow(Absorption_Phytoplankton_file)), "_SampleIDs.pdf"), fmt = "pdf")
  
  rgl::rgl.snapshot(paste0(filepath_to_write_plot, "one_3d_plot_by_QC_flag_color_", length(1:nrow(Absorption_Phytoplankton_file)), "_SampleIDs/", all_tables_joined_by_folder_name$coded_cruise_name[i], "_Phytoplankton_Absorption_by_QC_Comments_", length(1:nrow(Absorption_Phytoplankton_file)), "_SampleIDs.png"))                 
  
  dir.create(file.path(paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/RESULTS/1_index_png/")), showWarnings = FALSE, recursive = TRUE)
  rgl::rgl.snapshot(paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_and_Absorption/RESULTS/1_index_png/", project_folder_name, "_", all_tables_joined_by_folder_name$coded_cruise_name[i], "_Phytoplankton_Absorption_by_QC_Comments_", length(1:nrow(Absorption_Phytoplankton_file)), "_SampleIDs.png"))
  
  
  
  
  rgl::rgl.close()
  rgl::rgl.quit()
  
  
  
  
  #end i
}

rgl::rgl.quit()

end_time <- Sys.time()
start_time
end_time



