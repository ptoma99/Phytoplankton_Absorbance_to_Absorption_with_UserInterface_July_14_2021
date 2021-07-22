#003_001_005_plot_Phytoplankton_Absorbance_no_vol_all_folders_26_2_one_scale

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021

#-999 as 0

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

#input_folder_to_read_files <- "C:/R_WD/WRITE/WORKS/RESULTS/Particulate_Absorbance/NewSpectro_2015_continue/AZMP Fall 2016"
input_folder_to_read_files <- "C:/R_WD/WRITE/WORKS/RESULTS"



#input_metadata_folder_name <- "C:/R_WD/Metadata_per_cruise"

cruise_name_table_location <- "C:/R_WD/folder_name_to_coded_cruise_name_table.csv"
cruise_name_table <- read.table(cruise_name_table_location, skip = 0, sep = ",", header = TRUE)
cruise_name_table_df <- data.frame(cruise_name_table)



input_folder_name <- sub('\\.*$', '', basename(input_folder_to_read_files))
#search_result_d6Phytoplankton_txt_files_processed  <- list.files(pattern = "\\d{6}Phytoplankton.txt$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
search_result_d6Phytoplankton_txt_files_processed  <- list.files(pattern = "\\Phytoplankton.txt$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)


distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed <- unique(dirname(search_result_d6Phytoplankton_txt_files_processed))
distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df <- data.frame(distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed)
names(distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df)[1] <- "folder_path"
distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df$folder_name <- sub('\\..*$', '', basename(distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed))

distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df <- inner_join(distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df, cruise_name_table_df, by = c("folder_name"))

dir.create(file.path("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL"), showWarnings = FALSE, recursive = TRUE)

nrows_distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df <- nrow(distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df)
write.csv(distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df, paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL/", "distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df_", nrows_distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df, "_rows.csv"), row.names = FALSE)



############################################### start get min max Absorbance

xyz_all_folder_Phyto_Par_Det <- data.frame()
for (h in 1:nrow(distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df)){
  
  # h <- 1
  
  #search_result_d6Phytoplankton_txt_files_processed  <- list.files(pattern = "\\d{6}Phytoplankton.txt$"  , path = distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df$folder_path[h], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)#h
  search_result_d6Phytoplankton_txt_files_processed  <- list.files(pattern = "\\Phytoplankton.txt$"  , path = distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df$folder_path[h], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)#h
  
  project_folder_name <- distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df$folder_name[h]#h
  coded_cruise_name <- distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df$coded_cruise_name[h]
  
  #filepath to write
  filepath_to_write_plot <- paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL/RESULTS/", distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df$folder_name[h], "/")#h
  # string <- filepath_to_write_plot            
  # pattern <- "C:/R_WD/WRITE/WORKS"
  # replacement <- "C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL"
  # filepath_to_write_plot <- str_replace(string, pattern, replacement)
  
  #dir.create(file.path(filepath_to_write_plot), showWarnings = FALSE, recursive = TRUE)
  
  
  
  
  
  
  
  all_d6Phytoplankton_txt_files <- search_result_d6Phytoplankton_txt_files_processed
  
  # print(paste0("The folder ", "'", input_folder_to_read_files, "'", " has ", length(search_result_d6Phytoplankton_txt_files_processed), " files."))
  # print(paste0("first file pattern = ", search_result_d6Phytoplankton_txt_files_processed[1]))
  
  all_d6Phytoplankton_txt_files_dirname <- dirname(all_d6Phytoplankton_txt_files)
  all_d6Phytoplankton_txt_files_folder_name <- sub('\\..*$', '', basename(all_d6Phytoplankton_txt_files_dirname))
  all_d6Phytoplankton_txt_files_file_name <- sub('.*/', '', basename(all_d6Phytoplankton_txt_files))
  
  all_d6Phytoplankton_txt_files_file_name <- sub('_-999_nodet_', '', all_d6Phytoplankton_txt_files_file_name)
  all_d6Phytoplankton_txt_files_file_name <- sub('_-999_nopar_', '', all_d6Phytoplankton_txt_files_file_name)
  
  
  
  
  all_d6Phytoplankton_txt_files_df <- data.frame(all_d6Phytoplankton_txt_files)
  all_d6Phytoplankton_txt_files_df$all_d6Phytoplankton_txt_files_dirname <- all_d6Phytoplankton_txt_files_dirname
  all_d6Phytoplankton_txt_files_df$folder_name <- all_d6Phytoplankton_txt_files_folder_name
  all_d6Phytoplankton_txt_files_df$file_name <- all_d6Phytoplankton_txt_files_file_name
  
  
  
  xyz_all_folder_Phytoplankton <- data.frame()
  xyz_all_folder_Particulate <- data.frame()
  xyz_all_folder_Detritus <- data.frame()
  for (i in 1:length(search_result_d6Phytoplankton_txt_files_processed)){
    
    # i <- 1
    
    d6Phytoplankton_txt_file <- read.table(search_result_d6Phytoplankton_txt_files_processed[i], skip = 1, sep = ",", header = TRUE)
    d6_string <- sub('\\Phytoplankton.txt', '', basename(search_result_d6Phytoplankton_txt_files_processed[i]))
    
    x <- d6Phytoplankton_txt_file[,1]
    y_Phytoplankton <- d6Phytoplankton_txt_file[,4]
    z <- as.numeric(i[1:length(x)])
    
    y_Particulate <- d6Phytoplankton_txt_file[,2]
    y_Detritus <- d6Phytoplankton_txt_file[,3]
    
    
    
    
    #change all -999 to 0
    for (m in 1:length(x)){
      
      #if1
      if (y_Particulate[m] == -999){
        
        y_Particulate[m] <- 0
        y_Phytoplankton[m] <- 0
        
        #end if1  
      }
      
      
      #if2
      if (y_Detritus[m] == -999){
        
        y_Detritus[m] <- 0
        y_Phytoplankton[m] <- 0
        
        #end if2  
      }
      
      
      #end m  
    }
    
    
    
    
    
    
    for (j in 1:length(z)){
      z[j] <- i
      
    }
    
    
    #2d plot all 3 for each file
    
    Wavelength_nm <- x
    #Absorbance <- y_Phytoplankton
    File_No <- z
    
    
    xyz_all_folder_Phytoplankton1 <- data.frame(x, y_Phytoplankton, z)
    xyz_all_folder_Phytoplankton <- rbind(xyz_all_folder_Phytoplankton, xyz_all_folder_Phytoplankton1)
    
    xyz_all_folder_Particulate1 <- data.frame(x, y_Particulate, z)
    xyz_all_folder_Particulate <- rbind(xyz_all_folder_Particulate, xyz_all_folder_Particulate1)
    
    xyz_all_folder_Detritus1 <- data.frame(x, y_Detritus, z)
    xyz_all_folder_Detritus <- rbind(xyz_all_folder_Detritus, xyz_all_folder_Detritus1)
    
    #end i    
  }
  
  
  xyz_all_folder_Phyto <- data.frame(xyz_all_folder_Phytoplankton$y_Phytoplankton)
  names(xyz_all_folder_Phyto)[1] <- "y_Absorbance"
  
  xyz_all_folder_Par <- data.frame(xyz_all_folder_Particulate$y_Particulate)
  names(xyz_all_folder_Par)[1] <- "y_Absorbance"
  
  xyz_all_folder_Det <- data.frame(xyz_all_folder_Detritus$y_Detritus)
  names(xyz_all_folder_Det)[1] <- "y_Absorbance"
  
  xyz_all_folder_Phyto_Par_Det <- rbind(xyz_all_folder_Phyto, xyz_all_folder_Par)
  
  xyz_all_folder_Phyto_Par_Det <- rbind(xyz_all_folder_Phyto_Par_Det, xyz_all_folder_Det)
  
  
  
  
  min_Absorbance <- min(xyz_all_folder_Phyto_Par_Det$y_Absorbance)
  max_Absorbance <- max(xyz_all_folder_Phyto_Par_Det$y_Absorbance)
  
  
  print(paste0("min_Absorbance = ", min_Absorbance))
  print(paste0("max_Absorbance = ", max_Absorbance))
  
  min_max_all_folder_Phyto_Par_Det_Absorbance <- data.frame(project_folder_name, coded_cruise_name, min_Absorbance, max_Absorbance)
  
  
  
  nrows_min_max_all_folder_Phyto_Par_Det_Absorbance <- nrow(min_max_all_folder_Phyto_Par_Det_Absorbance)
  write.csv(min_max_all_folder_Phyto_Par_Det_Absorbance, paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL/", coded_cruise_name, "_min_max_all_folder_Phyto_Par_Det_Absorbance_", nrows_min_max_all_folder_Phyto_Par_Det_Absorbance, "_rows.csv"), row.names = FALSE)
  
  
  
  #end h  
}

############################################### end get min max Absorbance




for (h in 1:nrow(distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df)){
  
  #search_result_d6Phytoplankton_txt_files_processed  <- list.files(pattern = "\\d{6}Phytoplankton.txt$"  , path = distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df$folder_path[h], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)#h
  search_result_d6Phytoplankton_txt_files_processed  <- list.files(pattern = "\\Phytoplankton.txt$"  , path = distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df$folder_path[h], all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)#h
  
  project_folder_name <- distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df$folder_name[h]#h
  coded_cruise_name <- distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df$coded_cruise_name[h]
    
  #filepath to write
  filepath_to_write_plot <- paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL/RESULTS/", distinct_folders_in_search_result_d6Phytoplankton_txt_files_processed_df$folder_name[h], "/")#h
  # string <- filepath_to_write_plot            
  # pattern <- "C:/R_WD/WRITE/WORKS"
  # replacement <- "C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL"
  # filepath_to_write_plot <- str_replace(string, pattern, replacement)
  
  dir.create(file.path(filepath_to_write_plot), showWarnings = FALSE, recursive = TRUE)
  
  
  




all_d6Phytoplankton_txt_files <- search_result_d6Phytoplankton_txt_files_processed

# print(paste0("The folder ", "'", input_folder_to_read_files, "'", " has ", length(search_result_d6Phytoplankton_txt_files_processed), " files."))
# print(paste0("first file pattern = ", search_result_d6Phytoplankton_txt_files_processed[1]))

all_d6Phytoplankton_txt_files_dirname <- dirname(all_d6Phytoplankton_txt_files)
all_d6Phytoplankton_txt_files_folder_name <- sub('\\..*$', '', basename(all_d6Phytoplankton_txt_files_dirname))
all_d6Phytoplankton_txt_files_file_name <- sub('.*/', '', basename(all_d6Phytoplankton_txt_files))

all_d6Phytoplankton_txt_files_file_name <- sub('_-999_nodet_', '', all_d6Phytoplankton_txt_files_file_name)
all_d6Phytoplankton_txt_files_file_name <- sub('_-999_nopar_', '', all_d6Phytoplankton_txt_files_file_name)




all_d6Phytoplankton_txt_files_df <- data.frame(all_d6Phytoplankton_txt_files)
all_d6Phytoplankton_txt_files_df$all_d6Phytoplankton_txt_files_dirname <- all_d6Phytoplankton_txt_files_dirname
all_d6Phytoplankton_txt_files_df$folder_name <- all_d6Phytoplankton_txt_files_folder_name
all_d6Phytoplankton_txt_files_df$file_name <- all_d6Phytoplankton_txt_files_file_name



xyz_all_folder_Phytoplankton <- data.frame()
xyz_all_folder_Particulate <- data.frame()
xyz_all_folder_Detritus <- data.frame()
for (i in 1:length(search_result_d6Phytoplankton_txt_files_processed)){

d6Phytoplankton_txt_file <- read.table(search_result_d6Phytoplankton_txt_files_processed[i], skip = 1, sep = ",", header = TRUE)
d6_string <- sub('\\Phytoplankton.txt', '', basename(search_result_d6Phytoplankton_txt_files_processed[i]))

x <- d6Phytoplankton_txt_file[,1]
y_Phytoplankton <- d6Phytoplankton_txt_file[,4]
z <- as.numeric(i[1:length(x)])

y_Particulate <- d6Phytoplankton_txt_file[,2]
y_Detritus <- d6Phytoplankton_txt_file[,3]




#change all -999 to 0
for (m in 1:length(x)){
  
  #if1
  if (y_Particulate[m] == -999){
    
    y_Particulate[m] <- 0
    y_Phytoplankton[m] <- 0
    
  #end if1  
  }
  
  
  #if2
  if (y_Detritus[m] == -999){
    
    y_Detritus[m] <- 0
    y_Phytoplankton[m] <- 0
    
    #end if2  
  }
  
  
#end m  
}






for (j in 1:length(z)){
z[j] <- i

}


#2d plot all 3 for each file

Wavelength_nm <- x
#Absorbance <- y_Phytoplankton
File_No <- z

dir.create(file.path(paste0(filepath_to_write_plot, "Plot2d_each_file_all3/")), showWarnings = FALSE, recursive = TRUE)
png(paste0(filepath_to_write_plot, "Plot2d_each_file_all3/", coded_cruise_name, "_", d6_string, "_Absorbance_no_VOL.png"), width = 465, height = 225, units = "mm", res = 150)

plot(Wavelength_nm, y_Particulate, xlab = "Wavelength (nm)", ylab = "Absorbance_no_VOL", ylim = c(min_Absorbance, max_Absorbance), type = "l", col = "blue", sub = paste0(project_folder_name, " - ", coded_cruise_name, " - ", " Sample ID = ", d6_string), lwd = 2)
lines(Wavelength_nm, y_Phytoplankton, col = "green", lwd = 2)
lines(Wavelength_nm, y_Detritus, col = "black", lwd = 2)
legend("topright", legend=c("Particulate", "Phytoplankton", "Detritus"),
       col=c("blue", "green", "black"), lty=1, cex=0.7, lwd = 2)

dev.off()


xyz_all_folder_Phytoplankton1 <- data.frame(x, y_Phytoplankton, z)
xyz_all_folder_Phytoplankton <- rbind(xyz_all_folder_Phytoplankton, xyz_all_folder_Phytoplankton1)

xyz_all_folder_Particulate1 <- data.frame(x, y_Particulate, z)
xyz_all_folder_Particulate <- rbind(xyz_all_folder_Particulate, xyz_all_folder_Particulate1)

xyz_all_folder_Detritus1 <- data.frame(x, y_Detritus, z)
xyz_all_folder_Detritus <- rbind(xyz_all_folder_Detritus, xyz_all_folder_Detritus1)

#end i
}

#Phytoplankton

Wavelength_nm <- xyz_all_folder_Phytoplankton$x
Absorbance_no_VOL <- xyz_all_folder_Phytoplankton$y
File_No <- xyz_all_folder_Phytoplankton$z


rgl::open3d()

# resize window
rgl::par3d(windowRect = c(0, 30, 1280, 680))

rgl::plot3d(Wavelength_nm, File_No, Absorbance_no_VOL, col = "green", labels = c(1,2,3), 
       size = 1, type='p')

# add legend
rgl::legend3d("topleft", legend = paste('Particulate Absorbance_no_VOL - Phytoplankton - ', c(project_folder_name), " - ", c(coded_cruise_name), " - ", length(search_result_d6Phytoplankton_txt_files_processed), " files" ), pch = 16, col = "green", cex=1, inset=c(0.02))

dir.create(file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(search_result_d6Phytoplankton_txt_files_processed), "_files/Phytoplankton" )), showWarnings = FALSE, recursive = TRUE)


                    browseURL(paste0(filepath_to_write_plot,
rgl::writeWebGL(dir=file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(search_result_d6Phytoplankton_txt_files_processed), "_files/Phytoplankton" )))))
rgl.snapshot(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(search_result_d6Phytoplankton_txt_files_processed), "_files/Phytoplankton/", coded_cruise_name, "_Phytoplankton_Absorbance_no_VOL.png" ))                 
#rgl::rgl.close()
rgl::rgl.quit()

                    
                    
#Particulate

Wavelength_nm <- xyz_all_folder_Particulate$x
Absorbance_no_VOL <- xyz_all_folder_Particulate$y
File_No <- xyz_all_folder_Particulate$z

rgl::open3d()

# resize window
rgl::par3d(windowRect = c(0, 30, 1280, 680))

rgl::plot3d(Wavelength_nm, File_No, Absorbance_no_VOL, col = "blue", labels = c(1,2,3), 
       size = 1, type='p')

# add legend
rgl::legend3d("topleft", legend = paste('Particulate Absorbance_no_VOL - Particulate - ', c(project_folder_name), " - ", c(coded_cruise_name), " - ", length(search_result_d6Phytoplankton_txt_files_processed), " files" ), pch = 16, col = "blue", cex=1, inset=c(0.02))

dir.create(file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(search_result_d6Phytoplankton_txt_files_processed), "_files/Particulate" )), showWarnings = FALSE, recursive = TRUE)


browseURL(paste0(filepath_to_write_plot,
                 rgl::writeWebGL(dir=file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(search_result_d6Phytoplankton_txt_files_processed), "_files/Particulate" )))))
rgl::rgl.snapshot(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(search_result_d6Phytoplankton_txt_files_processed), "_files/Particulate/", coded_cruise_name, "_Particulate_Absorbance_no_VOL.png" ))
#rgl::rgl.close()
rgl::rgl.quit()


#Detritus

Wavelength_nm <- xyz_all_folder_Detritus$x
Absorbance_no_VOL <- xyz_all_folder_Detritus$y
File_No <- xyz_all_folder_Detritus$z

rgl::open3d()

# resize window
rgl::par3d(windowRect = c(0, 30, 1280, 680))

rgl::plot3d(Wavelength_nm, File_No, Absorbance_no_VOL, col = "black", labels = c(1,2,3), 
       size = 1, type='p')

# add legend
rgl::legend3d("topleft", legend = paste('Particulate Absorbance_no_VOL - Detritus - ', c(project_folder_name), " - ", c(coded_cruise_name), " - ", length(search_result_d6Phytoplankton_txt_files_processed), " files" ), pch = 16, col = "black", cex=1, inset=c(0.02))

dir.create(file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(search_result_d6Phytoplankton_txt_files_processed), "_files/Detritus" )), showWarnings = FALSE, recursive = TRUE)


browseURL(paste0(filepath_to_write_plot,
                 rgl::writeWebGL(dir=file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(search_result_d6Phytoplankton_txt_files_processed), "_files/Detritus" )))))
rgl::rgl.snapshot(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(search_result_d6Phytoplankton_txt_files_processed), "_files/Detritus/", coded_cruise_name, "_Detritus_Absorbance_no_VOL.png" ))
#rgl::rgl.close()
rgl::rgl.quit()


#all_3_in_one                    

rgl::open3d()

# resize window
rgl::par3d(windowRect = c(0, 30, 1280, 680))

# plot3d(Wavelength_nm, File_No, Absorbance, col = "black", labels = c(1,2,3), 
#        size = 1, type='p')

rgl::plot3d(xyz_all_folder_Phytoplankton$x, xyz_all_folder_Phytoplankton$z, xyz_all_folder_Phytoplankton$y, xlab = "Wavelength_nm", ylab = "File_No", zlab = "Absorbance_no_VOL", col = "green", labels = c(1,2,3), size = 1, type='p')
rgl::plot3d(xyz_all_folder_Detritus$x, xyz_all_folder_Detritus$z, xyz_all_folder_Detritus$y, col = "black", labels = c(1,2,3), size = 1, type='p', add = TRUE)
rgl::plot3d(xyz_all_folder_Particulate$x, xyz_all_folder_Particulate$z, xyz_all_folder_Particulate$y, col = "blue", labels = c(1,2,3), size = 1, type='p', add = TRUE)


# add legend
rgl::legend3d("topleft", legend = c(paste('Particulate Absorbance_no_VOL - Phytoplankton - ', c(project_folder_name), " - ", c(coded_cruise_name), " - ", length(search_result_d6Phytoplankton_txt_files_processed), " files" ),
                               paste('Particulate Absorbance_no_VOL - Particulate       - ', c(project_folder_name), " - ", c(coded_cruise_name), " - ", length(search_result_d6Phytoplankton_txt_files_processed), " files" ), 
                               paste('Particulate Absorbance_no_VOL - Detritus            - ', c(project_folder_name), " - ", c(coded_cruise_name), " - ", length(search_result_d6Phytoplankton_txt_files_processed), " files" )),
         
         pch = 16, col = c("green", "blue", "black"), cex=1, inset=c(0.02))



dir.create(file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(search_result_d6Phytoplankton_txt_files_processed), "_files/all_3" )), showWarnings = FALSE, recursive = TRUE)


browseURL(paste0(filepath_to_write_plot,
                 rgl::writeWebGL(dir=file.path(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(search_result_d6Phytoplankton_txt_files_processed), "_files/all_3" )))))
rgl::rgl.snapshot(paste0(filepath_to_write_plot, "one_3d_plot_Phytoplankton_all_", length(search_result_d6Phytoplankton_txt_files_processed), "_files/all_3/", project_folder_name, "_" , coded_cruise_name, "_all_3_Absorbance_no_VOL.png" ))

dir.create(file.path(paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL/RESULTS/1_index_png/")), showWarnings = FALSE, recursive = TRUE)
rgl::rgl.snapshot(paste0("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL/RESULTS/1_index_png/", project_folder_name, "_" , coded_cruise_name, "_all_3_Absorbance_no_VOL.png" ))



#rgl::rgl.close()
rgl::rgl.quit()



#end h  
}

rgl::rgl.quit()

end_time <- Sys.time()
start_time
end_time







