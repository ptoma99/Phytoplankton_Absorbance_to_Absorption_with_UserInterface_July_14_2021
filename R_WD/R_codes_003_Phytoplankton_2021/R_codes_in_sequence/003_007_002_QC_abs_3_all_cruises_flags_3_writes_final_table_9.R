#001_007_002_QC_abs_3_all_cruises_flags_3_writes_final_table_9

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021


start_time <- Sys.time()
print(paste0("start_time = ", start_time))


setwd("C:/R_WD")
getwd()


library(gdata)
library(dplyr)
library(lmodel2)
library(robustbase)
library("readxl")

library("dplyr")
#library("readxl")
library("fs")
library("qdapRegex")
library("stringr")





dir.create(file.path("C:/R_WD/WRITE/WORKS_QC"), showWarnings = FALSE, recursive = TRUE)

filepath_to_write_plot <- "C:/R_WD/WRITE/WORKS_QC/"

filepath_to_write_final_with_QC_flags <- "C:/R_WD/WRITE/WORKS6/"

#enter folder that contains all the cruises sub folders
input_folder_to_read_files <- "C:/R_WD/WRITE/WORKS5/RESULTS"
write.csv(input_folder_to_read_files, paste0("C:/R_WD/WRITE/WORKS_QC/", "input_folder_to_read_files", ".csv"))

input_metadata_folder_name <- "C:/R_WD/Metadata_per_cruise"

cruise_name_table_location <- "C:/R_WD/folder_name_to_coded_cruise_name_table.csv"
cruise_name_table <- read.table(cruise_name_table_location, skip = 0, sep = ",", header = TRUE)
cruise_name_table_df <- data.frame(cruise_name_table)



input_folder_name <- sub('\\..*$', '', basename(input_folder_to_read_files))
search_result_for_Absorption_Phytoplankton  <- list.files(pattern = "\\_Absorption_Phytoplankton.csv$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)


search_result_for_Absorption_Phytoplankton_dirname <- dirname(search_result_for_Absorption_Phytoplankton)
search_result_for_Absorption_Phytoplankton_folder_name <- basename(dirname(search_result_for_Absorption_Phytoplankton))

search_result_for_Absorption_Phytoplankton_file_name <- sub('.*/', '', basename(search_result_for_Absorption_Phytoplankton))

search_result_for_Absorption_Phytoplankton_df <- data.frame(search_result_for_Absorption_Phytoplankton)
search_result_for_Absorption_Phytoplankton_df$Phytoplankton_dirname <- search_result_for_Absorption_Phytoplankton_dirname
search_result_for_Absorption_Phytoplankton_df$folder_name <- search_result_for_Absorption_Phytoplankton_folder_name
search_result_for_Absorption_Phytoplankton_df$Phytoplankton_file_name <- search_result_for_Absorption_Phytoplankton_file_name

nrows_search_result_for_Absorption_Phytoplankton_df <- nrow(search_result_for_Absorption_Phytoplankton_df)
write.csv(search_result_for_Absorption_Phytoplankton_df, paste0("C:/R_WD/WRITE/WORKS_QC/", "search_result_for_Absorption_Phytoplankton_df_", nrows_search_result_for_Absorption_Phytoplankton_df, "_rows.csv"), row.names = FALSE)


#check if all needed HPLC-final_JB.xlsx files are in the metadata folders

#all_HPLC_xlsx_files<- list.files(pattern = "\\HPLC-final_JB.xlsx$"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
all_HPLC_xlsx_files<- list.files(pattern = "\\HPLC*"  , path = input_metadata_folder_name, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)


all_HPLC_xlsx_files <- grep('~$', all_HPLC_xlsx_files, fixed = TRUE, value = TRUE, invert = TRUE)
all_HPLC_xlsx_files_dirname <- dirname(all_HPLC_xlsx_files)
all_HPLC_xlsx_files_folder_name <- sub('\\..*$', '', basename(all_HPLC_xlsx_files_dirname))
all_HPLC_xlsx_files_file_name <- sub('.*/', '', basename(all_HPLC_xlsx_files))

all_HPLC_xlsx_files_df <- data.frame(all_HPLC_xlsx_files)
all_HPLC_xlsx_files_df$HPLC_dirname <- all_HPLC_xlsx_files_dirname
all_HPLC_xlsx_files_df$folder_name <- all_HPLC_xlsx_files_folder_name
all_HPLC_xlsx_files_df$HPLC_file_name <- all_HPLC_xlsx_files_file_name
nrows_all_HPLC_xlsx_files_df <- nrow(all_HPLC_xlsx_files_df)
write.csv(all_HPLC_xlsx_files_df, paste0("C:/R_WD/WRITE/WORKS_QC/", "all_HPLC_xlsx_files_df_", nrows_all_HPLC_xlsx_files_df, "_rows.csv"), row.names = FALSE)




#pairing all the files that need metadata with the metadata they need in one table
all_tables_joined_by_folder_name <- inner_join(cruise_name_table_df, search_result_for_Absorption_Phytoplankton_df, by = c("folder_name"))
all_tables_joined_by_folder_name <- inner_join(all_tables_joined_by_folder_name, all_HPLC_xlsx_files_df, by = c("folder_name"))

nrows_all_tables_joined_by_folder_name <- nrow(all_tables_joined_by_folder_name)
write.csv(all_tables_joined_by_folder_name, paste0("C:/R_WD/WRITE/WORKS_QC/", "all_tables_joined_by_folder_name_", nrows_all_tables_joined_by_folder_name, "_rows.csv"), row.names = FALSE)



sink("C:/R_WD/WRITE/WORKS_QC/QC_log_file.txt")


#disable scientific notation in R.
options(scipen = 999)


# input_HPLC_xlsx_file <- "C:/R_WD/Metadata_per_cruise/NewSpectro_2015_continue/AZMP Fall 2015/Hud2015-030HPLC-final_JB.xlsx"
# input_Absorption_Phytoplankton_final_file <- "C:/R_WD/WRITE/WORKS5/RESULTS/Absorption_3tables_with_metadata/Particulate_Absorption/NewSpectro_2015_continue/AZMP Fall 2015/HUD2015030_Absorption_Phytoplankton.csv"



for (h in 1:nrow(all_tables_joined_by_folder_name)){
#for (h in 2:2){

print(paste0("______________________________________________________________________________________"))  
  
print(paste0(all_tables_joined_by_folder_name$folder_name[h], " ", all_tables_joined_by_folder_name$coded_cruise_name[h], " ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " ", all_tables_joined_by_folder_name$HPLC_file_name[h]))  
  
  
#if1  
if (all_tables_joined_by_folder_name$folder_name[h]=="Bedford Basin 2016"){
  hplc <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[h], skip = 3, sheet = "JBEDITS", col_names = TRUE)
  names(hplc)[1] <- "ID"
  
}else if (all_tables_joined_by_folder_name$folder_name[h]=="Bedford basin 2017" | all_tables_joined_by_folder_name$folder_name[h]=="Endeavor 2017 fall AZMP" ){
  hplc <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[h], skip = 1, sheet = "JBEDITS", col_names = TRUE)
  names(hplc)[1] <- "ID"
    
}else{     
  
  
#hplc = read.xls("Hud2015-030HPLC-final_JB.xlsx",skip=3)
#hplc = read.xls(input_HPLC_xlsx_file,skip=3)
#hplc <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[h], skip = 4, sheet = "JBEDITS", col_names = TRUE)
  hplc <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[h], skip = 5, col_names = TRUE)
  
  
  if (names(hplc)[2] != "DEPTH"){
    hplc <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[h], skip = 4, col_names = TRUE)
  }
  
  
  if (names(hplc)[2] != "DEPTH"){
    hplc <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[h], skip = 3, col_names = TRUE)
  }
  
  
  if (names(hplc)[2] != "DEPTH"){
    hplc <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[h], skip = 2, col_names = TRUE)
  }
  
  if (names(hplc)[2] != "DEPTH"){
    hplc <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[h], skip = 1, col_names = TRUE)
  }
  
  if (names(hplc)[2] != "DEPTH"){
    hplc <- read_excel(all_tables_joined_by_folder_name$all_HPLC_xlsx_files[h], skip = 0, col_names = TRUE)
  }
  
names(hplc)[1] <- "ID"

#end if
}

#absp = read.csv("HUD2015030_Absorption_Phytoplankton_final.csv",skip=17)
absp = read.csv(all_tables_joined_by_folder_name$search_result_for_Absorption_Phytoplankton[h],skip=17)


hplchla = hplc %>% select(ID, DEPTH, HPLCHLA)
#absphyto = absp %>% select(Sample.ID,X443,X490,X550,X670)
absphyto = absp %>% select(Sample.ID, X410, X440 ,X443, X490, X550, X670)


absphyto = rename(absphyto, ID = Sample.ID)

dataset = inner_join(hplchla, absphyto) 

IDflag_0 =  matrix(99,length(dataset$X443),2)
IDflag_0[,1] = dataset$ID


#remove from dataset 0 and -999 values

dataset1 <- dataset

dataset2 <- dataset

for (g in 1:ncol(dataset2)){   
#dataset2 <- filter(dataset2, dataset2[, g] != 0)
#dataset2 <- filter(dataset2, dataset2[, g] != -999)
dataset2 <- filter(dataset2, dataset2[, g] > 0)
}

#get the samples ID with 0 and -999 values excluded from QC tests

#create '%!in%' as reverse condition operator for '%in%'
'%!in%' <- function(x,y)!('%in%'(x,y))

dataset3 <- dataset %>%
  select(everything()) %>%
  filter(ID %!in% c(dataset2$ID))

no_QC_SamplesID <- dataset$ID %!in% c(dataset2$ID)

IDflag_0[no_QC_SamplesID,2] = 0 #(if flag is one. or any other number)


IDflag_0_df <- data.frame(IDflag_0)

IDflag_0_only0_df <- IDflag_0_df %>%
  select(everything()) %>%
  filter(X2 %in% c("0"))




dataset <- dataset2

#ind1sd
IDflag_410_smaller_than_440 =  matrix(1,length(dataset$X443),2)
IDflag_410_smaller_than_440[,1] = dataset$ID

#ind3sd
IDflag_443_to_490 =  matrix(1,length(dataset$X443),2)
IDflag_443_to_490[,1] = dataset$ID

#ind2sd
IDflag_ChlA_to_443_550_670 =  matrix(1,length(dataset$X443),2)
IDflag_ChlA_to_443_550_670[,1] = dataset$ID

############

# IDflag_410_smaller_than_440
# IDflag_443_to_490
# IDflag_ChlA_to_443_550_670

############

#test 0: 410nm < 440nm 1 pass, 4 fail

ind1sd <- dataset$X410 > dataset$X440

IDflag_410_smaller_than_440[ind1sd,2] = 4 #(if flag is one. or any other number)





######################################################
## FIRST TEST ON ABSORPTION 443 TO 490 RELATIONSHIP ## #443 to 490
######################################################

print(paste0("FIRST TEST ON ABSORPTION 443 TO 490 RELATIONSHIP"))

dir.create(file.path(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h])), showWarnings = FALSE, recursive = TRUE)

png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_1_1_1_Absorption_443_TO_490_REL.png"), width = 465, height = 225, units = "mm", res = 150)

.Default = par()
par(mfcol = c(1,2))

plot(dataset$X443,dataset$X490,main = "Linear", sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " TEST 1_1_1 Absorption 443 TO 490 REL"), 
     xlab = expression(paste(a[phy],"(443) (",nm^{-1},")")),
     ylab = expression(paste(a[phy],"(490) (",nm^{-1},")"))
     )#h

plot(dataset$X443,dataset$X490,log="xy",main = "Log10",
     xlab = expression(paste(a[phy],"(443) (",nm^{-1},")")),
     ylab = expression(paste(a[phy],"(490) (",nm^{-1},")"))
     )

dev.off()

# LINEAR SCALE
mlin = lmodel2(dataset$X490 ~ dataset$X443)
mlinInt = mlin$regression.results[3,2]
mlinSl = mlin$regression.results[3,3]


aphy490mod = mlinInt + dataset$X443 * mlinSl

# Absolute residual in linear scale
residu = aphy490mod - dataset$X490

png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_1_2_1_hist_linear_Absolute_Residuals_443_TO_490.png"), width = 465, height = 225, units = "mm", res = 150)
hist(residu, breaks = 40, main = "Absolute residuals", sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " TEST 1_2_1 hist linear Absolute Residuals 443 TO 490"),
     xlab = "residual: Model - Observation   (linear scale)"
     )
dev.off()


muresidu = mean(residu)
sdresidu = sd(residu)
ind3sd = abs(residu) >= 3*sdresidu
print(sum(ind3sd))




#IDflag[ind3sd,2] = 2 #(if flag is one. or any other number)
IDflag_443_to_490[ind3sd,2] = 2



png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_1_2_2_plot_linear_Absolute_Residuals_443_TO_490.png"), width = 465, height = 225, units = "mm", res = 150)
plot(dataset$X443,dataset$X490, sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " TEST 1_2_2 plot linear Absolute Residuals 443 TO 490"),
     xlab = expression(paste(a[phy],"(443) (",nm^{-1},")")),
     ylab = expression(paste(a[phy],"(490) (",nm^{-1},")"))
     )
points(dataset$X443[ind3sd],dataset$X490[ind3sd],pch=16,col="red")
dev.off()


# percentage residuals in linear scale
residu = (aphy490mod - dataset$X490)/dataset$X490 * 100

png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_1_3_1_hist_linear_Percent_Residuals_443_TO_490.png"), width = 465, height = 225, units = "mm", res = 150)
hist(residu, breaks = 40, main = "Percent residuals", sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " TEST 1_3_1 hist linear Percent Residuals 443 TO 490"),
     xlab = "residual: (Model - Observation) / Observation x 100   (linear scale)"
     )
dev.off()

muresidu = mean(residu)
sdresidu = sd(residu)
ind3sd = abs(residu) >= 3*sdresidu


#IDflag[ind3sd,2] = 2 #(if flag is one. or any other number)
IDflag_443_to_490[ind3sd,2] = 2



png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_1_3_2_plot_linear_Percent_Residuals_443_TO_490.png"), width = 465, height = 225, units = "mm", res = 150)
plot(dataset$X443,dataset$X490, sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " TEST 1_3_2 plot linear Percent Residuals 443 TO 490"),
     xlab = expression(paste(a[phy],"(443) (",nm^{-1},")")),
     ylab = expression(paste(a[phy],"(490) (",nm^{-1},")"))
     )
points(dataset$X443[ind3sd],dataset$X490[ind3sd],pch=16,col="red")
dev.off()

ind3sdkeep = ind3sd

# LOG10 SCALE
x = log10(dataset$X443)
y = log10(dataset$X490)

mlog = lmodel2(y ~ x)
mlogInt = mlog$regression.results[3,2]
mlogSl = mlog$regression.results[3,3]

ymod = mlogInt + x * mlogSl
# Absolute residual in log10 scale
residu = ymod - y

png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_1_4_1_hist_log10_Absolute_Residuals_443_TO_490.png"), width = 465, height = 225, units = "mm", res = 150)
hist(residu, breaks = 40, main = "Absolute residuals", sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " TEST 1_4_1 hist log10 Absolute Residuals 443 TO 490"),
     xlab = "residual: Model - Observation   (log10 scale)"
     )
dev.off()


muresidu = mean(residu)
sdresidu = sd(residu)
ind3sd = abs(residu) >= 3*sdresidu
print(sum(ind3sd))


#IDflag[ind3sd,2] = 2 #(if flag is one. or any other number)
IDflag_443_to_490[ind3sd,2] = 2



png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_1_4_2_plot_log10_Absolute_Residuals_443_TO_490.png"), width = 465, height = 225, units = "mm", res = 150)
plot(x,y, sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " TEST 1_4_2 plot log10 Absolute Residuals 443 TO 490"),
     xlab = expression(paste(a[phy],"(443) (",nm^{-1},")")),
     ylab = expression(paste(a[phy],"(490) (",nm^{-1},")"))
     )
points(x[ind3sd],y[ind3sd],pch=16,col="red")
dev.off()



# percentage residuals in log10 scale
residu = (ymod - y)/y * 100


png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_1_5_1_hist_log10_Percent_Residuals_443_TO_490.png"), width = 465, height = 225, units = "mm", res = 150)
hist(residu, breaks = 40, main = "percent residuals", sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " TEST 1_5_1 hist log10 Percent Residuals 443 TO 490"),
     xlab = "residual: (Model - Observation) / Observation x 100    (log10 scale)"
     )
dev.off()





muresidu = mean(residu)
sdresidu = sd(residu)
ind3sd = abs(residu) >= 3*sdresidu
print(sum(ind3sd))


#IDflag[ind3sd,2] = 2 #(if flag is one. or any other number)
IDflag_443_to_490[ind3sd,2] = 2



png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_1_5_2_plot_log10_Percent_Residuals_443_TO_490.png"), width = 465, height = 225, units = "mm", res = 150)
plot(x,y, sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " TEST 1_5_2 plot log10 Percent Residuals 443 TO 490"),
     xlab = expression(paste(a[phy],"(443) (",nm^{-1},")")),
     ylab = expression(paste(a[phy],"(490) (",nm^{-1},")"))
     )
points(x[ind3sd],y[ind3sd],pch=16,col="red")
dev.off()


######################################################
##   SECOND: CHECK CHLA ABSORPTION  RELATIONSHIP    ## #443
######################################################
# 
# plot(dataset$HPLCHLA,dataset$X443,main = "Linear")
# plot(dataset$HPLCHLA,dataset$X443,log="xy",main = "Log10")
# 
# 

print(paste0("SECOND: CHECK CHLA ABSORPTION  RELATIONSHIP 443"))

png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_2_1_1_CHLA_Absorption_TO_443_REL.png"), width = 465, height = 225, units = "mm", res = 150)

.Default = par()
par(mfcol = c(1,2))
plot(dataset$HPLCHLA,dataset$X443,main = "Linear", sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " TEST 2_1_1 CHLA Absorption TO 443 REL"),
     xlab = expression(paste("Chla (mg",m^{-3},")")),
     ylab = expression(paste(a[phy],"(443) (",nm^{-1},")"))
     )#h
plot(dataset$HPLCHLA,dataset$X443,log="xy",main = "Log10", sub = paste0("HPLC file = ", all_tables_joined_by_folder_name$HPLC_file_name[h]),
     xlab = expression(paste("Chla (mg",m^{-3},")")),
     ylab = expression(paste(a[phy],"(443) (",nm^{-1},")"))
     )#h
dev.off()




# LOG10 SCALE we loop 3 times through it.

#par(.Default)
.Default = par()

x = log10(dataset$HPLCHLA[!ind3sdkeep])
y = log10(dataset$X443[!ind3sdkeep])

png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_2_2_1_log10_CHLA_Absorption_TO_443_REL.png"), width = 465, height = 225, units = "mm", res = 150)
plot(x,y, sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " - " , all_tables_joined_by_folder_name$HPLC_file_name[h], " TEST 2_2_1 log10 CHLA Absorption TO 443 REL"),
     xlab = expression(paste("Chla (mg",m^{-3},")")),
     ylab = expression(paste(a[phy],"(443) (",nm^{-1},")"))
     )#h
dev.off()

# Here is a loop that will go through 3 iterations and
# remove the outliers at each step. In this case, I choose
# 3 standard deviation and nothing was excluded.

png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_2_2_2_EXCLUDE_log10_CHLA_Absorption_TO_443_REL.png"), width = 465, height = 225, units = "mm", res = 150)
plot(x,y, sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " - " , all_tables_joined_by_folder_name$HPLC_file_name[h], " TEST 2_2_2 EXCLUDE log10 CHLA Absorption TO 443 REL"),
     xlab = expression(paste("Chla (mg",m^{-3},")")),
     ylab = expression(paste(a[phy],"(443) (",nm^{-1},")"))
     )#h


for (i in 1:3)
{
mlog = lmodel2(y ~ x)
mlogInt = mlog$regression.results[3,2]
mlogSl = mlog$regression.results[3,3]

ymod = mlogInt + x * mlogSl
# Absolute residual in log10 scale
residu = (ymod - y)
#hist(residu, breaks = 40)
muresidu = mean(residu)
sdresidu = sd(residu)
ind2sd = abs(residu) >= 3*sdresidu
print(c(sum(ind2sd),format(mlog$rsquare,digits = 3) ))
points(x[ind2sd],y[ind2sd],pch=16,col=i+1)
#legend("topleft",as.character(format(mlog$rsquare,digits = 3)))
# percentage residuals in log10 scale
#residu = (ymod - y)/y * 100
#hist(residu, breaks = 40)
#muresidu = mean(residu)
#sdresidu = sd(residu)
#ind2sd = abs(residu) >= 2*sdresidu
#print(sum(ind2sd))
#plot(x,y)
#points(x[ind2sd],y[ind2sd],pch=16,col="red")

x = x[!ind2sd]
y = y[!ind2sd]

#IDflag[ind2sd,2] = 3 #(if flag is one. or any other number)
IDflag_ChlA_to_443_550_670[ind2sd,2] = 2

}

dev.off()

######################################################
##   SECOND: CHECK CHLA ABSORPTION  RELATIONSHIP    ## #550
######################################################
# 
# plot(dataset$HPLCHLA,dataset$X550,main = "Linear")
# plot(dataset$HPLCHLA,dataset$X550,log="xy",main = "Log10")
# 
# 

print(paste0("SECOND: CHECK CHLA ABSORPTION  RELATIONSHIP 550"))


png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_3_1_1_CHLA_Absorption_TO_550_REL.png"), width = 465, height = 225, units = "mm", res = 150)

.Default = par()
par(mfcol = c(1,2))
plot(dataset$HPLCHLA,dataset$X550,main = "Linear", sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " TEST 3_1_1 CHLA Absorption TO 550 REL"),
     xlab = expression(paste("Chla (mg",m^{-3},")")),
     ylab = expression(paste(a[phy],"(550) (",nm^{-1},")"))
     )#h
plot(dataset$HPLCHLA,dataset$X550,log="xy",main = "Log10", sub = paste0("HPLC file = ", all_tables_joined_by_folder_name$HPLC_file_name[h]),
     xlab = expression(paste("Chla (mg",m^{-3},")")),
     ylab = expression(paste(a[phy],"(550) (",nm^{-1},")"))
     )#h
dev.off()




# LOG10 SCALE we loop 3 times through it.

#par(.Default)
.Default = par()

x = log10(dataset$HPLCHLA[!ind3sdkeep])
y = log10(dataset$X550[!ind3sdkeep])

png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_3_2_1_log10_CHLA_Absorption_TO_550_REL.png"), width = 465, height = 225, units = "mm", res = 150)
plot(x,y, sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " - " , all_tables_joined_by_folder_name$HPLC_file_name[h], " TEST 3_2_1 log10 CHLA Absorption TO 550 REL"),
     xlab = expression(paste("Chla (mg",m^{-3},")")),
     ylab = expression(paste(a[phy],"(550) (",nm^{-1},")"))
     )#h
dev.off()

# Here is a loop that will go through 3 iterations and
# remove the outliers at each step. In this case, I choose
# 3 standard deviation and nothing was excluded.

png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_3_2_2_EXCLUDE_log10_CHLA_Absorption_TO_550_REL.png"), width = 465, height = 225, units = "mm", res = 150)
plot(x,y, sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " - " , all_tables_joined_by_folder_name$HPLC_file_name[h], " TEST 2_2_2 EXCLUDE log10 CHLA Absorption TO 550 REL"),
     xlab = expression(paste("Chla (mg",m^{-3},")")),
     ylab = expression(paste(a[phy],"(550) (",nm^{-1},")"))
     )#i, i


for (i in 1:3)
{
  mlog = lmodel2(y ~ x)
  mlogInt = mlog$regression.results[3,2]
  mlogSl = mlog$regression.results[3,3]
  
  ymod = mlogInt + x * mlogSl
  # Absolute residual in log10 scale
  residu = (ymod - y)
  #hist(residu, breaks = 40)
  muresidu = mean(residu)
  sdresidu = sd(residu)
  ind2sd = abs(residu) >= 3*sdresidu
  print(c(sum(ind2sd),format(mlog$rsquare,digits = 3) ))
  points(x[ind2sd],y[ind2sd],pch=16,col=i+1)
  #legend("topleft",as.character(format(mlog$rsquare,digits = 3)))
  # percentage residuals in log10 scale
  #residu = (ymod - y)/y * 100
  #hist(residu, breaks = 40)
  #muresidu = mean(residu)
  #sdresidu = sd(residu)
  #ind2sd = abs(residu) >= 2*sdresidu
  #print(sum(ind2sd))
  #plot(x,y)
  #points(x[ind2sd],y[ind2sd],pch=16,col="red")
  
  x = x[!ind2sd]
  y = y[!ind2sd]
  
  
  #IDflag[ind2sd,2] = 3 #(if flag is one. or any other number)
  IDflag_ChlA_to_443_550_670[ind2sd,2] = 2
  
}

dev.off()


######################################################
##   SECOND: CHECK CHLA ABSORPTION  RELATIONSHIP    ## #670
######################################################
# 
# plot(dataset$HPLCHLA,dataset$X550,main = "Linear")
# plot(dataset$HPLCHLA,dataset$X550,log="xy",main = "Log10")
# 
# 

print(paste0("SECOND: CHECK CHLA ABSORPTION  RELATIONSHIP 670"))


png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_4_1_1_CHLA_Absorption_TO_670_REL.png"), width = 465, height = 225, units = "mm", res = 150)

.Default = par()
par(mfcol = c(1,2))
plot(dataset$HPLCHLA,dataset$X670,main = "Linear", sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " TEST 4_1_1 CHLA Absorption TO 670 REL"),
     xlab = expression(paste("Chla (mg",m^{-3},")")),
     ylab = expression(paste(a[phy],"(670) (",nm^{-1},")"))
     )#h
plot(dataset$HPLCHLA,dataset$X670,log="xy",main = "Log10", sub = paste0("HPLC file = ", all_tables_joined_by_folder_name$HPLC_file_name[h]),
     xlab = expression(paste("Chla (mg",m^{-3},")")),
     ylab = expression(paste(a[phy],"(670) (",nm^{-1},")"))
     )#h
dev.off()




# LOG10 SCALE we loop 3 times through it.

#par(.Default)
.Default = par()

x = log10(dataset$HPLCHLA[!ind3sdkeep])
y = log10(dataset$X670[!ind3sdkeep])

png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_4_2_1_log10_CHLA_Absorption_TO_670_REL.png"), width = 465, height = 225, units = "mm", res = 150)
plot(x,y, sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " - " , all_tables_joined_by_folder_name$HPLC_file_name[h], " TEST 4_2_1 log10 CHLA Absorption TO 670 REL"),
     xlab = expression(paste("Chla (mg",m^{-3},")")),
     ylab = expression(paste(a[phy],"(670) (",nm^{-1},")"))
     )#h
dev.off()

# Here is a loop that will go through 3 iterations and
# remove the outliers at each step. In this case, I choose
# 3 standard deviation and nothing was excluded.

png(paste0(filepath_to_write_plot, "QC_plots/", all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_TEST_4_2_2_EXCLUDE_log10_CHLA_Absorption_TO_670_REL.png"), width = 465, height = 225, units = "mm", res = 150)
plot(x,y, sub = paste0(all_tables_joined_by_folder_name$folder_name[h], " - ", all_tables_joined_by_folder_name$Phytoplankton_file_name[h], " - " , all_tables_joined_by_folder_name$HPLC_file_name[h], " TEST 2_2_2 EXCLUDE log10 CHLA Absorption TO 670 REL"),
     xlab = expression(paste("Chla (mg",m^{-3},")")),
     ylab = expression(paste(a[phy],"(670) (",nm^{-1},")"))
     )#h


for (i in 1:3)
{
  mlog = lmodel2(y ~ x)
  mlogInt = mlog$regression.results[3,2]
  mlogSl = mlog$regression.results[3,3]
  
  ymod = mlogInt + x * mlogSl
  # Absolute residual in log10 scale
  residu = (ymod - y)
  #hist(residu, breaks = 40)
  muresidu = mean(residu)
  sdresidu = sd(residu)
  ind2sd = abs(residu) >= 3*sdresidu
  print(c(sum(ind2sd),format(mlog$rsquare,digits = 3) ))
  points(x[ind2sd],y[ind2sd],pch=16,col=i+1)
  #legend("topleft",as.character(format(mlog$rsquare,digits = 3)))
  # percentage residuals in log10 scale
  #residu = (ymod - y)/y * 100
  #hist(residu, breaks = 40)
  #muresidu = mean(residu)
  #sdresidu = sd(residu)
  #ind2sd = abs(residu) >= 2*sdresidu
  #print(sum(ind2sd))
  #plot(x,y)
  #points(x[ind2sd],y[ind2sd],pch=16,col="red")
  
  x = x[!ind2sd]
  y = y[!ind2sd]
  

  #IDflag[ind2sd,2] = 3 #(if flag is one. or any other number)
  IDflag_ChlA_to_443_550_670[ind2sd,2] = 2
  
}

dev.off()


####

IDflag_410_smaller_than_440_df <- data.frame(IDflag_410_smaller_than_440)
IDflag_443_to_490_df <- data.frame(IDflag_443_to_490)
IDflag_ChlA_to_443_550_670_df <- data.frame(IDflag_ChlA_to_443_550_670)

####

#IDflag_df <- data.frame(IDflag)
#IDflag_0_only0_df

# ID_all_flags <- rbind(IDflag_0_only0_df, IDflag_df)
# names(ID_all_flags) <- c("Sample.ID", "QC_flag_0123")

ID_all_flags_410 <- rbind(IDflag_0_only0_df, IDflag_410_smaller_than_440_df)
names(ID_all_flags_410) <- c("Sample.ID", "QC_flag_410_smaller_than_440")

ID_all_flags_443 <- rbind(IDflag_0_only0_df, IDflag_443_to_490_df)
names(ID_all_flags_443) <- c("Sample.ID", "QC_flag_443_to_490")

ID_all_flags_ChlA <- rbind(IDflag_0_only0_df, IDflag_ChlA_to_443_550_670_df)
names(ID_all_flags_ChlA) <- c("Sample.ID", "QC_flag_ChlA_to_443_550_670")



#Absorption_Phytoplankton_with_flag_no_header <- left_join(absp, ID_all_flags, by = c("Sample.ID"))

Absorption_Phytoplankton_with_flag_no_header <- left_join(absp, ID_all_flags_410, by = c("Sample.ID"))
Absorption_Phytoplankton_with_flag_no_header <- left_join(Absorption_Phytoplankton_with_flag_no_header, ID_all_flags_443, by = c("Sample.ID"))
Absorption_Phytoplankton_with_flag_no_header <- left_join(Absorption_Phytoplankton_with_flag_no_header, ID_all_flags_ChlA, by = c("Sample.ID"))


for (i in 1:nrow(Absorption_Phytoplankton_with_flag_no_header)){
  
  #if1
  if (is.na(Absorption_Phytoplankton_with_flag_no_header$QC_flag_410_smaller_than_440[i])){
    
    Absorption_Phytoplankton_with_flag_no_header$QC_flag_410_smaller_than_440[i] <- 0
   
  #end if1   
  }
  
  
  #if2
  if (is.na(Absorption_Phytoplankton_with_flag_no_header$QC_flag_443_to_490[i])){
    
    Absorption_Phytoplankton_with_flag_no_header$QC_flag_443_to_490[i] <- 0
    
    #end if2   
  }
  
  
  #if3
  if (is.na(Absorption_Phytoplankton_with_flag_no_header$QC_flag_ChlA_to_443_550_670[i])){
    
    Absorption_Phytoplankton_with_flag_no_header$QC_flag_ChlA_to_443_550_670[i] <- 0
    
    #end if3   
  }
  
  
  
#end i  
}



Absorption_Phytoplankton_filepath <- all_tables_joined_by_folder_name$search_result_for_Absorption_Phytoplankton[h]
con <- file(Absorption_Phytoplankton_filepath, "r")
Absorption_Phytoplankton_header <- readLines(con, n=18)
#Absorption_Phytoplankton_header <- readLines(con, n=17)

close(con)

#QC_flag_column_name <- "QC_flag_0123"

QC_flag_column_name1 <- "QC_flag_410_smaller_than_440"
QC_flag_column_name2 <- "QC_flag_443_to_490"
QC_flag_column_name3 <- "QC_flag_ChlA_to_443_550_670"


#Absorption_Phytoplankton_header2 <- append(Absorption_Phytoplankton_header[18], QC_flag_column_name, after = length(Absorption_Phytoplankton_header[18]))

Absorption_Phytoplankton_header[18] <- paste0(Absorption_Phytoplankton_header[18],"," , QC_flag_column_name1, ",", QC_flag_column_name2, ",", QC_flag_column_name3)





#filepath_to_write_final_with_QC_flags

dir.create(file.path(paste0(filepath_to_write_final_with_QC_flags, all_tables_joined_by_folder_name$folder_name[h])), showWarnings = FALSE, recursive = TRUE)

#paste0(filepath_to_write_final_with_QC_flags, all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_Absorption_Phytoplankton_QC.csv")

#write Phytoplankton final table file with metadata
write.table(Absorption_Phytoplankton_header, file = paste0(filepath_to_write_final_with_QC_flags, all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_Absorption_Phytoplankton_QC.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F)#i
write.table(Absorption_Phytoplankton_with_flag_no_header,  file = paste0(filepath_to_write_final_with_QC_flags, all_tables_joined_by_folder_name$folder_name[h], "/", all_tables_joined_by_folder_name$coded_cruise_name[h], "_Absorption_Phytoplankton_QC.csv"), sep = ",", row.names = FALSE, dec = ".", quote = FALSE, col.names = F, na = "", append = TRUE)#i


#end h
}


sink()

#####################

end_time <- Sys.time()
start_time
end_time










