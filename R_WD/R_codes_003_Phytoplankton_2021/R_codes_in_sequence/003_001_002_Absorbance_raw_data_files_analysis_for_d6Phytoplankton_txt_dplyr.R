#Absorbance_raw_data_files_analysis_for_d6Phytoplankton_txt

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021


#only the files that have a pair

start_time <- Sys.time()
print(paste0("start_time = ", start_time))


setwd("C:/R_WD")
getwd()


#install.packages("reader")

library("reader")
library("dplyr")
library("tidyr")
library("stringr")
library("R.utils")


input_folder_to_read_written_files <- "C:/R_WD/WRITE/WORKS/RESULTS"

#########


#search for the d6Phytoplankton.txt files that have been and NOT been processed

#input_folder_to_read_written_files <- "C:/R_WD/WRITE/WORKS/RESULTS"
search_result_d6Phytoplankton_txt_files_processed  <- list.files(pattern = "\\d{6}Phytoplankton.txt$"  , path = input_folder_to_read_written_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
#search_result_d6Phytoplankton_txt_files_processed  <- list.files(pattern = "\\Phytoplankton.txt$"  , path = input_folder_to_read_written_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)


# nrows_search_result_d6Phytoplankton_txt_files_processed <- length(search_result_d6Phytoplankton_txt_files_processed)
# write.csv(search_result_d6Phytoplankton_txt_files_processed, paste0("C:/R_WD/WRITE/WORKS/", "search_result_d6Phytoplankton_txt_files_processed_", nrows_search_result_d6Phytoplankton_txt_files_processed, "_rows.csv"), row.names = FALSE)

search_result_d6Phytoplankton_txt_files_processed_df <- data.frame(search_result_d6Phytoplankton_txt_files_processed)
search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6 <- sub('.*/', '', search_result_d6Phytoplankton_txt_files_processed_df[,1])
#search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6 <- sub('_-999_', '', search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6)


search_result_d6Phytoplankton_txt_files_processed_df$filename_d6 <- sub('\\Phytoplankton.txt$', '', search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6)
#search_result_d6Phytoplankton_txt_files_processed_df$filename_d6 <- sub('_-999_', '', search_result_d6Phytoplankton_txt_files_processed_df$filename_d6)


search_result_d6Phytoplankton_txt_files_processed_df$file <- search_result_d6Phytoplankton_txt_files_processed_df$filename_d6
#search_result_d6Phytoplankton_txt_files_processed_df$file <- sub('_-999_', '', search_result_d6Phytoplankton_txt_files_processed_df$file)



search_result_d6Phytoplankton_txt_files_processed_df$folder_name <- sub('\\..*$', '', basename(dirname(search_result_d6Phytoplankton_txt_files_processed_df[,1])))

# nrows_search_result_d6Phytoplankton_txt_files_processed_df <- nrow(search_result_d6Phytoplankton_txt_files_processed_df)
# write.csv(search_result_d6Phytoplankton_txt_files_processed_df, paste0("C:/R_WD/WRITE/WORKS/", "search_result_d6Phytoplankton_txt_files_processed_df_", nrows_search_result_d6Phytoplankton_txt_files_processed_df, "_rows.csv"), row.names = FALSE)

########

############


#check in d6Phytoplankton.txt where Particulate is smaller than Detritus
#search_result_d6Phytoplankton_txt_files_processed_df

smaller_df2_if1 <- data.frame()
smaller_df2_if2 <- data.frame()
smaller_df2_if3 <- data.frame()
smaller_df2_if4 <- data.frame()
smaller_df2_if5 <- data.frame()
smaller_df2_if6 <- data.frame()
smaller_df2_if7 <- data.frame()
smaller_df2_if8 <- data.frame()
smaller_df2_if9 <- data.frame()
smaller_df2_if10 <- data.frame()
smaller_df2_if11 <- data.frame()
smaller_df2_if12 <- data.frame()


for (i in 1:nrow(search_result_d6Phytoplankton_txt_files_processed_df)){
  
  #i <- 1
  #i <- 50
  
  d6Phytoplankton_txt_file <- read.table(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i], skip = 1, sep = ",", header = TRUE)#i
  
  
  
  #print(paste0(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i]))
  

  
  
  #if1
  #if (d6Phytoplankton_txt_file$Absorbance.Particulate[j] < d6Phytoplankton_txt_file$Absorbance.Detritus[j]){ }
  
  smaller_df_if1 <- d6Phytoplankton_txt_file %>%
    select(everything()) %>% 
    filter(d6Phytoplankton_txt_file$Absorbance.Particulate < d6Phytoplankton_txt_file$Absorbance.Detritus)
  
  values_per_file_if1 <- nrow(smaller_df_if1)
  from_Wavelength_if1 <- min(smaller_df_if1$Wavelength.nm.)
  to_Wavelength_if1 <- max(smaller_df_if1$Wavelength.nm.)
  
  smaller_df1_if1 <- data.frame(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i], search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6[i], search_result_d6Phytoplankton_txt_files_processed_df$folder_name[i] , values_per_file_if1, from_Wavelength_if1, to_Wavelength_if1)#iii
  names(smaller_df1_if1)[1:6] <- c("file_path", "file_name", "folder_name", "values_per_file", "from_Wavelength", "to_Wavelength")
  
  
  
  #if2
  #if (d6Phytoplankton_txt_file$Absorbance.Particulate[j] < 0){ }
  
  smaller_df_if2 <- d6Phytoplankton_txt_file %>%
    select(everything()) %>% 
    filter(d6Phytoplankton_txt_file$Absorbance.Particulate < 0)
  
  
  values_per_file_if2 <- nrow(smaller_df_if2)
  from_Wavelength_if2 <- min(smaller_df_if2$Wavelength.nm.)
  to_Wavelength_if2 <- max(smaller_df_if2$Wavelength.nm.)
  
  smaller_df1_if2 <- data.frame(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i], search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6[i], search_result_d6Phytoplankton_txt_files_processed_df$folder_name[i] , values_per_file_if2, from_Wavelength_if2, to_Wavelength_if2)#iii
  names(smaller_df1_if2)[1:6] <- c("file_path", "file_name", "folder_name", "values_per_file", "from_Wavelength", "to_Wavelength")
  
  
  
  
  
  
  #if3
  #if (d6Phytoplankton_txt_file$Absorbance.Detritus[j] < 0){ }
    
  smaller_df_if3 <- d6Phytoplankton_txt_file %>%
    select(everything()) %>% 
    filter(d6Phytoplankton_txt_file$Absorbance.Detritus < 0)
  
    
    values_per_file_if3 <- nrow(smaller_df_if3)
    from_Wavelength_if3 <- min(smaller_df_if3$Wavelength.nm.)
    to_Wavelength_if3 <- max(smaller_df_if3$Wavelength.nm.)
    
    smaller_df1_if3 <- data.frame(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i], search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6[i], search_result_d6Phytoplankton_txt_files_processed_df$folder_name[i] , values_per_file_if3, from_Wavelength_if3, to_Wavelength_if3)#iii
    names(smaller_df1_if3)[1:6] <- c("file_path", "file_name", "folder_name", "values_per_file", "from_Wavelength", "to_Wavelength")
    
  
  
    #if4
    #if (d6Phytoplankton_txt_file$Absorbance.Phytoplankton[j] < 0){ }
      
    smaller_df_if4 <- d6Phytoplankton_txt_file %>%
      select(everything()) %>% 
      filter(d6Phytoplankton_txt_file$Absorbance.Phytoplankton < 0)
      
      
      
      values_per_file_if4 <- nrow(smaller_df_if4)
      from_Wavelength_if4 <- min(smaller_df_if4$Wavelength.nm.)
      to_Wavelength_if4 <- max(smaller_df_if4$Wavelength.nm.)
      
      smaller_df1_if4 <- data.frame(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i], search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6[i], search_result_d6Phytoplankton_txt_files_processed_df$folder_name[i] , values_per_file_if4, from_Wavelength_if4, to_Wavelength_if4)#iii
      names(smaller_df1_if4)[1:6] <- c("file_path", "file_name", "folder_name", "values_per_file", "from_Wavelength", "to_Wavelength")  
  
  
      #if5
      #if (d6Phytoplankton_txt_file$Absorbance.Particulate[j] < 0 && d6Phytoplankton_txt_file$Absorbance.Detritus[j] < 0){ }
        
      smaller_df_if5 <- d6Phytoplankton_txt_file %>%
        select(everything()) %>% 
        filter(d6Phytoplankton_txt_file$Absorbance.Particulate < 0 && d6Phytoplankton_txt_file$Absorbance.Detritus < 0)
        
        
        
        values_per_file_if5 <- nrow(smaller_df_if5)
        from_Wavelength_if5 <- min(smaller_df_if5$Wavelength.nm.)
        to_Wavelength_if5 <- max(smaller_df_if5$Wavelength.nm.)
        
        smaller_df1_if5 <- data.frame(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i], search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6[i], search_result_d6Phytoplankton_txt_files_processed_df$folder_name[i] , values_per_file_if5, from_Wavelength_if5, to_Wavelength_if5)#iii
        names(smaller_df1_if5)[1:6] <- c("file_path", "file_name", "folder_name", "values_per_file", "from_Wavelength", "to_Wavelength")
        
  
  
        #if6
        #if (d6Phytoplankton_txt_file$Absorbance.Particulate[j] > 0 && d6Phytoplankton_txt_file$Absorbance.Detritus[j] < 0){ }
          
        smaller_df_if6 <- d6Phytoplankton_txt_file %>%
          select(everything()) %>% 
          filter(d6Phytoplankton_txt_file$Absorbance.Particulate > 0 && d6Phytoplankton_txt_file$Absorbance.Detritus < 0)
        
          
          
          values_per_file_if6 <- nrow(smaller_df_if6)
          from_Wavelength_if6 <- min(smaller_df_if6$Wavelength.nm.)
          to_Wavelength_if6 <- max(smaller_df_if6$Wavelength.nm.)
          
          smaller_df1_if6 <- data.frame(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i], search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6[i], search_result_d6Phytoplankton_txt_files_processed_df$folder_name[i] , values_per_file_if6, from_Wavelength_if6, to_Wavelength_if6)#iii
          names(smaller_df1_if6)[1:6] <- c("file_path", "file_name", "folder_name", "values_per_file", "from_Wavelength", "to_Wavelength")
          
  
  
          #if7
          #if (d6Phytoplankton_txt_file$Absorbance.Particulate[j] < 0 && d6Phytoplankton_txt_file$Absorbance.Detritus[j] > 0){ }
            
          smaller_df_if7 <- d6Phytoplankton_txt_file %>%
            select(everything()) %>% 
            filter(d6Phytoplankton_txt_file$Absorbance.Particulate < 0 && d6Phytoplankton_txt_file$Absorbance.Detritus > 0)
          
            
            
            values_per_file_if7 <- nrow(smaller_df_if7)
            from_Wavelength_if7 <- min(smaller_df_if7$Wavelength.nm.)
            to_Wavelength_if7 <- max(smaller_df_if7$Wavelength.nm.)
            
            smaller_df1_if7 <- data.frame(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i], search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6[i], search_result_d6Phytoplankton_txt_files_processed_df$folder_name[i] , values_per_file_if7, from_Wavelength_if7, to_Wavelength_if7)#iii
            names(smaller_df1_if7)[1:6] <- c("file_path", "file_name", "folder_name", "values_per_file", "from_Wavelength", "to_Wavelength")
            
        
            #if8
            #if (d6Phytoplankton_txt_file$Absorbance.Particulate[j] == d6Phytoplankton_txt_file$Absorbance.Detritus[j]){ }
              
            smaller_df_if8 <- d6Phytoplankton_txt_file %>%
              select(everything()) %>% 
              filter(d6Phytoplankton_txt_file$Absorbance.Particulate == d6Phytoplankton_txt_file$Absorbance.Detritus)
            
              
              
              values_per_file_if8 <- nrow(smaller_df_if8)
              from_Wavelength_if8 <- min(smaller_df_if8$Wavelength.nm.)
              to_Wavelength_if8 <- max(smaller_df_if8$Wavelength.nm.)
              
              smaller_df1_if8 <- data.frame(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i], search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6[i], search_result_d6Phytoplankton_txt_files_processed_df$folder_name[i] , values_per_file_if8, from_Wavelength_if8, to_Wavelength_if8)#iii
              names(smaller_df1_if8)[1:6] <- c("file_path", "file_name", "folder_name", "values_per_file", "from_Wavelength", "to_Wavelength")
              
        
              
              
              #if9
              #if (d6Phytoplankton_txt_file$Absorbance.Particulate[j] == 0){ }
              
              smaller_df_if9 <- d6Phytoplankton_txt_file %>%
                select(everything()) %>% 
                filter(d6Phytoplankton_txt_file$Absorbance.Particulate == 0)
              
              
              
              values_per_file_if9 <- nrow(smaller_df_if9)
              from_Wavelength_if9 <- min(smaller_df_if9$Wavelength.nm.)
              to_Wavelength_if9 <- max(smaller_df_if9$Wavelength.nm.)
              
              smaller_df1_if9 <- data.frame(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i], search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6[i], search_result_d6Phytoplankton_txt_files_processed_df$folder_name[i] , values_per_file_if9, from_Wavelength_if9, to_Wavelength_if9)#iii
              names(smaller_df1_if9)[1:6] <- c("file_path", "file_name", "folder_name", "values_per_file", "from_Wavelength", "to_Wavelength")

              
              
              #if10
              #if (d6Phytoplankton_txt_file$Absorbance.Detritus[j] == 0){ }
              
              smaller_df_if10 <- d6Phytoplankton_txt_file %>%
                select(everything()) %>% 
                filter(d6Phytoplankton_txt_file$Absorbance.Detritus == 0)
              
              
              
              values_per_file_if10 <- nrow(smaller_df_if10)
              from_Wavelength_if10 <- min(smaller_df_if10$Wavelength.nm.)
              to_Wavelength_if10 <- max(smaller_df_if10$Wavelength.nm.)
              
              smaller_df1_if10 <- data.frame(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i], search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6[i], search_result_d6Phytoplankton_txt_files_processed_df$folder_name[i] , values_per_file_if10, from_Wavelength_if10, to_Wavelength_if10)#iii
              names(smaller_df1_if10)[1:6] <- c("file_path", "file_name", "folder_name", "values_per_file", "from_Wavelength", "to_Wavelength")
              
              
              
              #if11
              #if (d6Phytoplankton_txt_file$Absorbance.Particulate[j] == 0 && d6Phytoplankton_txt_file$Absorbance.Detritus[j] == 0){ }
              
              smaller_df_if11 <- d6Phytoplankton_txt_file %>%
                select(everything()) %>% 
                filter(d6Phytoplankton_txt_file$Absorbance.Particulate == 0 && d6Phytoplankton_txt_file$Absorbance.Detritus == 0)
              
              
              
              values_per_file_if11 <- nrow(smaller_df_if11)
              from_Wavelength_if11 <- min(smaller_df_if11$Wavelength.nm.)
              to_Wavelength_if11 <- max(smaller_df_if11$Wavelength.nm.)
              
              smaller_df1_if11 <- data.frame(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i], search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6[i], search_result_d6Phytoplankton_txt_files_processed_df$folder_name[i] , values_per_file_if11, from_Wavelength_if11, to_Wavelength_if11)#iii
              names(smaller_df1_if11)[1:6] <- c("file_path", "file_name", "folder_name", "values_per_file", "from_Wavelength", "to_Wavelength")
              

              
              
              #if12
              #if (d6Phytoplankton_txt_file$Absorbance.Particulate[j] > d6Phytoplankton_txt_file$Absorbance.Detritus[j]){ }
              
              smaller_df_if12 <- d6Phytoplankton_txt_file %>%
                select(everything()) %>% 
                filter(d6Phytoplankton_txt_file$Absorbance.Particulate > d6Phytoplankton_txt_file$Absorbance.Detritus)
              
              values_per_file_if12 <- nrow(smaller_df_if12)
              from_Wavelength_if12 <- min(smaller_df_if12$Wavelength.nm.)
              to_Wavelength_if12 <- max(smaller_df_if12$Wavelength.nm.)
              
              smaller_df1_if12 <- data.frame(search_result_d6Phytoplankton_txt_files_processed_df$search_result_d6Phytoplankton_txt_files_processed[i], search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6[i], search_result_d6Phytoplankton_txt_files_processed_df$folder_name[i] , values_per_file_if12, from_Wavelength_if12, to_Wavelength_if12)#iii
              names(smaller_df1_if12)[1:6] <- c("file_path", "file_name", "folder_name", "values_per_file", "from_Wavelength", "to_Wavelength")
              
              
              
  
  
  print(paste0("Looking for Phytoplankton, Particulate and Detritus in folder ", search_result_d6Phytoplankton_txt_files_processed_df$folder_name[i], " in file ",  search_result_d6Phytoplankton_txt_files_processed_df$filename_ext_d6[i], " file ", i, " of ", nrow(search_result_d6Phytoplankton_txt_files_processed_df)))
  
  
  smaller_df2_if1 <- rbind(smaller_df2_if1, smaller_df1_if1)
  smaller_df2_if2 <- rbind(smaller_df2_if2, smaller_df1_if2)
  smaller_df2_if3 <- rbind(smaller_df2_if3, smaller_df1_if3)
  smaller_df2_if4 <- rbind(smaller_df2_if4, smaller_df1_if4)
  smaller_df2_if5 <- rbind(smaller_df2_if5, smaller_df1_if5)
  smaller_df2_if6 <- rbind(smaller_df2_if6, smaller_df1_if6)
  smaller_df2_if7 <- rbind(smaller_df2_if7, smaller_df1_if7)
  smaller_df2_if8 <- rbind(smaller_df2_if8, smaller_df1_if8)
  smaller_df2_if9 <- rbind(smaller_df2_if9, smaller_df1_if9)
  smaller_df2_if10 <- rbind(smaller_df2_if10, smaller_df1_if10)
  smaller_df2_if11 <- rbind(smaller_df2_if11, smaller_df1_if11)
  smaller_df2_if12 <- rbind(smaller_df2_if12, smaller_df1_if12)
  
  
#end i  
}



smaller_df2_if1 <- smaller_df2_if1 %>%
  select(everything()) %>% 
  filter(smaller_df2_if1$values_per_file > 0)

smaller_df2_if2 <- smaller_df2_if2 %>%
  select(everything()) %>% 
  filter(smaller_df2_if2$values_per_file > 0)

smaller_df2_if3 <- smaller_df2_if3 %>%
  select(everything()) %>% 
  filter(smaller_df2_if3$values_per_file > 0)

smaller_df2_if4 <- smaller_df2_if4 %>%
  select(everything()) %>% 
  filter(smaller_df2_if4$values_per_file > 0)

smaller_df2_if5 <- smaller_df2_if5 %>%
  select(everything()) %>% 
  filter(smaller_df2_if5$values_per_file > 0)

smaller_df2_if6 <- smaller_df2_if6 %>%
  select(everything()) %>% 
  filter(smaller_df2_if6$values_per_file > 0)

smaller_df2_if7 <- smaller_df2_if7 %>%
  select(everything()) %>% 
  filter(smaller_df2_if7$values_per_file > 0)

smaller_df2_if8 <- smaller_df2_if8 %>%
  select(everything()) %>% 
  filter(smaller_df2_if8$values_per_file > 0)


smaller_df2_if9 <- smaller_df2_if9 %>%
  select(everything()) %>% 
  filter(smaller_df2_if9$values_per_file > 0)


smaller_df2_if10 <- smaller_df2_if10 %>%
  select(everything()) %>% 
  filter(smaller_df2_if10$values_per_file > 0)


smaller_df2_if11 <- smaller_df2_if11 %>%
  select(everything()) %>% 
  filter(smaller_df2_if11$values_per_file > 0)


smaller_df2_if12 <- smaller_df2_if12 %>%
  select(everything()) %>% 
  filter(smaller_df2_if12$values_per_file > 0)




# 
print(paste0(nrow(smaller_df2_if1), " from ", nrow(search_result_d6Phytoplankton_txt_files_processed_df), " checked Particulate values smaller than Detritus have been identified."))
print(paste0(nrow(smaller_df2_if2), " from ", nrow(search_result_d6Phytoplankton_txt_files_processed_df), " checked for Particulate negative values."))
print(paste0(nrow(smaller_df2_if3), " from ", nrow(search_result_d6Phytoplankton_txt_files_processed_df), " checked Detritus negative values."))
print(paste0(nrow(smaller_df2_if4), " from ", nrow(search_result_d6Phytoplankton_txt_files_processed_df), " checked Phytoplankton negative values."))
print(paste0(nrow(smaller_df2_if5), " from ", nrow(search_result_d6Phytoplankton_txt_files_processed_df), " checked Particulate and Detritus both with negative values."))
print(paste0(nrow(smaller_df2_if6), " from ", nrow(search_result_d6Phytoplankton_txt_files_processed_df), " checked Particulate positive and Detritus negative."))
print(paste0(nrow(smaller_df2_if7), " from ", nrow(search_result_d6Phytoplankton_txt_files_processed_df), " checked Particulate negative and Detritus positive"))
print(paste0(nrow(smaller_df2_if8), " from ", nrow(search_result_d6Phytoplankton_txt_files_processed_df), " checked Particulate = Detritus Phytoplankton zero"))
print(paste0(nrow(smaller_df2_if9), " from ", nrow(search_result_d6Phytoplankton_txt_files_processed_df), " checked Particulate = zero"))
print(paste0(nrow(smaller_df2_if10), " from ", nrow(search_result_d6Phytoplankton_txt_files_processed_df), " checked Detritus = zero"))
print(paste0(nrow(smaller_df2_if11), " from ", nrow(search_result_d6Phytoplankton_txt_files_processed_df), " checked Particulate = 0 & Detritus = zero"))
print(paste0(nrow(smaller_df2_if12), " from ", nrow(search_result_d6Phytoplankton_txt_files_processed_df), " checked Particulate higher than Detritus"))

# 


#chickens[order(chickens$feathers, decreasing = TRUE),]
smaller_df2_if1 <- smaller_df2_if1[order(smaller_df2_if1$values_per_file, decreasing = TRUE),]
smaller_df2_if2 <- smaller_df2_if2[order(smaller_df2_if2$values_per_file, decreasing = TRUE),]
smaller_df2_if3 <- smaller_df2_if3[order(smaller_df2_if3$values_per_file, decreasing = TRUE),]
smaller_df2_if4 <- smaller_df2_if4[order(smaller_df2_if4$values_per_file, decreasing = TRUE),]
smaller_df2_if5 <- smaller_df2_if5[order(smaller_df2_if5$values_per_file, decreasing = TRUE),]
smaller_df2_if6 <- smaller_df2_if6[order(smaller_df2_if6$values_per_file, decreasing = TRUE),]
smaller_df2_if7 <- smaller_df2_if7[order(smaller_df2_if7$values_per_file, decreasing = TRUE),]
smaller_df2_if8 <- smaller_df2_if8[order(smaller_df2_if8$values_per_file, decreasing = TRUE),]
smaller_df2_if9 <- smaller_df2_if9[order(smaller_df2_if9$values_per_file, decreasing = TRUE),]
smaller_df2_if10 <- smaller_df2_if10[order(smaller_df2_if10$values_per_file, decreasing = TRUE),]
smaller_df2_if11 <- smaller_df2_if11[order(smaller_df2_if11$values_per_file, decreasing = TRUE),]
smaller_df2_if12 <- smaller_df2_if12[order(smaller_df2_if12$values_per_file, decreasing = TRUE),]



nrows_smaller_df2_if1 <- nrow(smaller_df2_if1)
nrows_smaller_df2_if2 <- nrow(smaller_df2_if2)
nrows_smaller_df2_if3 <- nrow(smaller_df2_if3)
nrows_smaller_df2_if4 <- nrow(smaller_df2_if4)
nrows_smaller_df2_if5 <- nrow(smaller_df2_if5)
nrows_smaller_df2_if6 <- nrow(smaller_df2_if6)
nrows_smaller_df2_if7 <- nrow(smaller_df2_if7)
nrows_smaller_df2_if8 <- nrow(smaller_df2_if8)
nrows_smaller_df2_if9 <- nrow(smaller_df2_if9)
nrows_smaller_df2_if10 <- nrow(smaller_df2_if10)
nrows_smaller_df2_if11 <- nrow(smaller_df2_if11)
nrows_smaller_df2_if12 <- nrow(smaller_df2_if12)



dir.create(file.path("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/"), showWarnings = FALSE, recursive = TRUE)



write.csv(smaller_df2_if1,  paste0("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/", "Particulate_values_smaller_than_Detritus_",           nrows_smaller_df2_if1,  "_rows_stopped_at_file_", i, "_of_", nrow(search_result_d6Phytoplankton_txt_files_processed_df), ".csv"), row.names = FALSE)
write.csv(smaller_df2_if2,  paste0("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/", "Particulate_negative_values_",                        nrows_smaller_df2_if2,  "_rows_stopped_at_file_", i, "_of_", nrow(search_result_d6Phytoplankton_txt_files_processed_df), ".csv"), row.names = FALSE)
write.csv(smaller_df2_if3,  paste0("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/", "Detritus_negative_values_",                           nrows_smaller_df2_if3,  "_rows_stopped_at_file_", i, "_of_", nrow(search_result_d6Phytoplankton_txt_files_processed_df), ".csv"), row.names = FALSE)
write.csv(smaller_df2_if4,  paste0("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/", "Phytoplankton_negative_values_",                      nrows_smaller_df2_if4,  "_rows_stopped_at_file_", i, "_of_", nrow(search_result_d6Phytoplankton_txt_files_processed_df), ".csv"), row.names = FALSE)
write.csv(smaller_df2_if5,  paste0("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/", "Particulate_and_Detritus_both_with_negative_values_", nrows_smaller_df2_if5,  "_rows_stopped_at_file_", i, "_of_", nrow(search_result_d6Phytoplankton_txt_files_processed_df), ".csv"), row.names = FALSE)
write.csv(smaller_df2_if6,  paste0("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/", "Particulate_positive_and_Detritus_negative_",         nrows_smaller_df2_if6,  "_rows_stopped_at_file_", i, "_of_", nrow(search_result_d6Phytoplankton_txt_files_processed_df), ".csv"), row.names = FALSE)
write.csv(smaller_df2_if7,  paste0("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/", "Particulate_negative_and_Detritus_positive_",         nrows_smaller_df2_if7,  "_rows_stopped_at_file_", i, "_of_", nrow(search_result_d6Phytoplankton_txt_files_processed_df), ".csv"), row.names = FALSE)
write.csv(smaller_df2_if8,  paste0("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/", "Particulate_equal_Detritus_Phytoplankton_is_zero_",   nrows_smaller_df2_if8,  "_rows_stopped_at_file_", i, "_of_", nrow(search_result_d6Phytoplankton_txt_files_processed_df), ".csv"), row.names = FALSE)
write.csv(smaller_df2_if9,  paste0("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/", "Particulate_equal_zero_",                             nrows_smaller_df2_if9,  "_rows_stopped_at_file_", i, "_of_", nrow(search_result_d6Phytoplankton_txt_files_processed_df), ".csv"), row.names = FALSE)
write.csv(smaller_df2_if10, paste0("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/", "Detritus_equal_zero_",                                nrows_smaller_df2_if10, "_rows_stopped_at_file_", i, "_of_", nrow(search_result_d6Phytoplankton_txt_files_processed_df), ".csv"), row.names = FALSE)
write.csv(smaller_df2_if11, paste0("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/", "Particulate_is_zero_and_Detritus_is_zero_",           nrows_smaller_df2_if11, "_rows_stopped_at_file_", i, "_of_", nrow(search_result_d6Phytoplankton_txt_files_processed_df), ".csv"), row.names = FALSE)
write.csv(smaller_df2_if12, paste0("C:/R_WD/WRITE/WORKS_Absorbance_raw_data_files_analysis/", "Particulate_higher_than_Detritus_",                   nrows_smaller_df2_if12, "_rows_stopped_at_file_", i, "_of_", nrow(search_result_d6Phytoplankton_txt_files_processed_df), ".csv"), row.names = FALSE)

#############


end_time <- Sys.time()
start_time
end_time



#############







