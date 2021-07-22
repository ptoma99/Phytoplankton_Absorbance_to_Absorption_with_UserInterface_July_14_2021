#001_006_create_Absorbance_vs_Absorption_3dplots_copy_plotted

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021

start_time <- Sys.time()
print(paste0("start_time = ", start_time))

setwd("C:/R_WD")
getwd()

#######

dir.exists("C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL/RESULTS/1_index_png")
dir.exists("C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/RESULTS/1_index_png")

dir.create(file.path("C:/R_WD/WRITE/Absorbance_vs_Absorption_3dplots_copy"), showWarnings = FALSE, recursive = TRUE)

Absorbance_files_to_copy <- list.files(pattern = "\\.png$"  , path = "C:/R_WD/WRITE/WORKS_PLOT_Absorbance_no_VOL/RESULTS/1_index_png", all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
file.copy(Absorbance_files_to_copy, "C:/R_WD/WRITE/Absorbance_vs_Absorption_3dplots_copy", overwrite = TRUE)


Absorption_files_to_copy <- list.files(pattern = "\\.png$"  , path = "C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/RESULTS/1_index_png", all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
file.copy(Absorption_files_to_copy, "C:/R_WD/WRITE/Absorbance_vs_Absorption_3dplots_copy", overwrite = TRUE)

########

end_time <- Sys.time()
start_time
end_time
