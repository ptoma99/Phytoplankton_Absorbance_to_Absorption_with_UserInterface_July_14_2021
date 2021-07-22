#001_009_plot_Phytoplankton_final_QC_Comments_cruises_samples_on_map_14

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021

start_time <- Sys.time()
print(paste0("start_time = ", start_time))

setwd("C:/R_WD")
getwd()

#install.packages("rgl", dependencies = TRUE)
#install.packages("rayshader", dependencies = TRUE)

library("dplyr")
#library("stringr")
#library("rgl")
library("reader")
#library("rayshader")
library("leaflet")
library("DescTools")
library("mapview")
library("leaflet.providers")
library("leaflet.extras2")
library("sf")

#str(providers_default()) 

# install.packages("webdriver", dependencies = TRUE)
# 
# webdriver::install_phantomjs(version = "2.1.1",
#                              baseURL = "https://github.com/wch/webshot/releases/download/v0.3.1/")




dir.create(file.path("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments"), showWarnings = FALSE, recursive = TRUE)

#filepath_to_write_plot <- "C:/R_WD/WRITE/WORKS_PLOT_Absorption_final_tables/"

#enter folder that contains all the cruises sub folders
input_folder_to_read_files <- "C:/R_WD/WRITE/WORKS7/RESULTS"
write.csv(input_folder_to_read_files, paste0("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/", "input_folder_to_read_files", ".csv"))


cruise_name_table_location <- "C:/R_WD/folder_name_to_coded_cruise_name_table.csv"
cruise_name_table <- read.table(cruise_name_table_location, skip = 0, sep = ",", header = TRUE)
cruise_name_table_df <- data.frame(cruise_name_table)


input_folder_name <- sub('\\..*$', '', basename(input_folder_to_read_files))
search_result_for_Absorption_Phytoplankton_QC  <- list.files(pattern = "\\_Absorption_Phytoplankton_QC_Comments.csv$"  , path = input_folder_to_read_files, all.files = TRUE, ignore.case = TRUE, include.dirs = FALSE, recursive = TRUE, full.names = TRUE)
search_result_for_Absorption_Phytoplankton_QC_df <- data.frame(search_result_for_Absorption_Phytoplankton_QC)
search_result_for_Absorption_Phytoplankton_QC_df$folder_name <- basename(dirname(search_result_for_Absorption_Phytoplankton_QC))

nrows_search_result_for_Absorption_Phytoplankton_QC_df <- nrow(search_result_for_Absorption_Phytoplankton_QC_df)
write.csv(search_result_for_Absorption_Phytoplankton_QC_df, paste0("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/", "search_result_for_Absorption_Phytoplankton_QC_df_", nrows_search_result_for_Absorption_Phytoplankton_QC_df, "_rows.csv"), row.names = FALSE)


distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC <- unique(dirname(search_result_for_Absorption_Phytoplankton_QC))
distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df <- data.frame(distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC)
distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df$folder_name <- sub('\\..*$', '', basename(distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC))

nrows_distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df <- nrow(distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df)
write.csv(distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df, paste0("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/", "distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df_", nrows_distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df, "_rows.csv"), row.names = FALSE)


all_tables_joined_by_folder_name <- inner_join(cruise_name_table_df, search_result_for_Absorption_Phytoplankton_QC_df, by = c("folder_name"))
all_tables_joined_by_folder_name <- inner_join(all_tables_joined_by_folder_name, distinct_folders_in_search_result_for_Absorption_Phytoplankton_QC_df, by = c("folder_name"))
nrows_all_tables_joined_by_folder_name <- nrow(all_tables_joined_by_folder_name)
write.csv(all_tables_joined_by_folder_name, paste0("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/", "all_tables_joined_by_folder_name_", nrows_all_tables_joined_by_folder_name, "_rows.csv"), row.names = FALSE)



#disable scientific notation in R.
options(scipen = 999)




for (i in 1:nrow(all_tables_joined_by_folder_name)){
  
    
  #i <- 1
  
  project_folder_name <- all_tables_joined_by_folder_name$folder_name[i]
  filepath_to_write_plot <- paste0("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/RESULTS/", project_folder_name, "/")
  
  Absorption_Phytoplankton_file <- read.table(all_tables_joined_by_folder_name$search_result_for_Absorption_Phytoplankton_QC[i], skip = 17, sep = ",", header = TRUE)#, row.names = NULL)
  
  print(paste0("Processing folder ", all_tables_joined_by_folder_name$folder_name[i], " ", all_tables_joined_by_folder_name$coded_cruise_name[i], " folder ", i, " of ", nrow(all_tables_joined_by_folder_name), " Sample ID's = ", nrow(Absorption_Phytoplankton_file)))
  
  Absorption_Phytoplankton_file_for_mapping <- Absorption_Phytoplankton_file[,1:8]
  
  
  #add last 4 columns
  #Absorption_Phytoplankton_file_for_mapping <- cbind(Absorption_Phytoplankton_file_for_mapping, Absorption_Phytoplankton_file[,ncol(Absorption_Phytoplankton_file)])
  Absorption_Phytoplankton_file_for_mapping <- cbind(Absorption_Phytoplankton_file_for_mapping, Absorption_Phytoplankton_file[,(ncol(Absorption_Phytoplankton_file)-3):(ncol(Absorption_Phytoplankton_file))])
  
  
  
  
  #names(Absorption_Phytoplankton_file_for_mapping)[9] <- names(Absorption_Phytoplankton_file)[ncol(Absorption_Phytoplankton_file)]
  
  names(Absorption_Phytoplankton_file_for_mapping)[4:5] <- c("lat", "lon")
  
  Absorption_Phytoplankton_file_for_mapping <- Absorption_Phytoplankton_file_for_mapping %>% filter (!is.na(lat) | !is.na(lon))
  
  
  #add num_row_ini as first column for Absorption_Phytoplankton_file_for_mapping
  num_row_ini_for_Absorption_Phytoplankton_file_for_mapping <- data.frame(num_row_ini = 1:nrow(Absorption_Phytoplankton_file_for_mapping))
  Absorption_Phytoplankton_file_for_mapping <- cbind(num_row_ini_for_Absorption_Phytoplankton_file_for_mapping, Absorption_Phytoplankton_file_for_mapping)
  # nrows_gpx_table_with_num_row_ini <- nrow(gpx_table_with_num_row_ini)
  # write.csv(gpx_table_with_num_row_ini, paste0("D:/R_WD/WRITE/", gpx_file_to_read, "/", gpx_file_to_read, "_", nrows_gpx_table_with_num_row_ini, "_rows.csv"), row.names = FALSE)
  
  
  #distinct_lat
  

  map_title <- as.character(paste0("Phytoplankton Absorption - ", all_tables_joined_by_folder_name$folder_name[i], " - ", all_tables_joined_by_folder_name$coded_cruise_name[i], " from ", Absorption_Phytoplankton_file_for_mapping$Date[1], " to ", Absorption_Phytoplankton_file_for_mapping$Date[nrow(Absorption_Phytoplankton_file_for_mapping)], " Sample ID's = ", nrow(Absorption_Phytoplankton_file_for_mapping)))
  
  
  
  
  m<-
  leaflet(Absorption_Phytoplankton_file_for_mapping) %>%
    fitBounds(min(Absorption_Phytoplankton_file_for_mapping$lon-0.003),min(Absorption_Phytoplankton_file_for_mapping$lat-0.003),max(Absorption_Phytoplankton_file_for_mapping$lon+0.003),max(Absorption_Phytoplankton_file_for_mapping$lat+0.003)) %>%
    # addTiles(urlTemplate = 'http://server.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}', 
    #          attribution = 'Tiles &copy; Esri &mdash; National Geographic, Esri, DeLorme, NAVTEQ, UNEP-WCMC, USGS, NASA, ESA, METI, NRCAN, GEBCO, NOAA, iPC')%>%  # Add awesome tiles
    # 
    
    addControl(map_title, position = "topleft")%>%
    addProviderTiles(providers$Esri.WorldImagery, options = providerTileOptions(opacity = 1))%>%
    addProviderTiles(providers$Esri.OceanBasemap, options = providerTileOptions(opacity = 0.2))%>%
    
    
    #Operations Points
    addCircles(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat, weight = 1, radius=1, color="red",stroke = TRUE, opacity=.5,
               group="Operations Locations",fillOpacity = 1, highlightOptions = highlightOptions(color = "white", weight = 20,bringToFront = TRUE))%>%  
    
    
    addPolylines(data = Absorption_Phytoplankton_file_for_mapping, lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat, color="yellow",weight=1)%>%
    
    
    ###add num_row_ini number as text
    addLabelOnlyMarkers(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat,label =  as.character(Absorption_Phytoplankton_file_for_mapping$num_row_ini),group="num_row_ini",
                        labelOptions = labelOptions(noHide = T, direction = 'center', textOnly = T, style = list("color" = "white", "font-size" = "9px")))%>%
    
    ###add Date as text
    addLabelOnlyMarkers(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat,label =  as.character(Absorption_Phytoplankton_file_for_mapping$Date),group="Date",
                        labelOptions = labelOptions(noHide = T, direction = 'bottom', textOnly = T, style = list("color" = "yellow", "font-size" = "7px")))%>%
    
    ###add Date as text
    addLabelOnlyMarkers(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat,label =  as.character(Absorption_Phytoplankton_file_for_mapping$Sample.ID),group="Sample.ID",
                        labelOptions = labelOptions(noHide = T, direction = 'left', textOnly = T, style = list("color" = "orange", "font-size" = "7px")))%>%

    
         
    ###add QC_flag_410_smaller_than_440 as text
    addLabelOnlyMarkers(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat,label =  as.character(Absorption_Phytoplankton_file_for_mapping$QC_flag_410_smaller_than_440),group="QC_flag_410_smaller_than_440",
                        labelOptions = labelOptions(noHide = T, direction = 'top', textOnly = T, style = list("color" = "pink", "font-size" = "10px")))%>%

    ###add QC_flag_443_to_490 as text
    addLabelOnlyMarkers(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat,label =  as.character(Absorption_Phytoplankton_file_for_mapping$QC_flag_443_to_490),group="QC_flag_443_to_490",
                        labelOptions = labelOptions(noHide = T, direction = 'top', textOnly = T, style = list("color" = "pink", "font-size" = "10px")))%>%
    
    ###add QC_flag_ChlA_to_443_550_670 as text
    addLabelOnlyMarkers(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat,label =  as.character(Absorption_Phytoplankton_file_for_mapping$QC_flag_ChlA_to_443_550_670),group="QC_flag_ChlA_to_443_550_670",
                        labelOptions = labelOptions(noHide = T, direction = 'top', textOnly = T, style = list("color" = "pink", "font-size" = "10px")))%>%
    
    ###add Comments as text
    addLabelOnlyMarkers(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat,label =  as.character(Absorption_Phytoplankton_file_for_mapping$Comments),group="Comments",
                        labelOptions = labelOptions(noHide = T, direction = 'top', textOnly = T, style = list("color" = "pink", "font-size" = "10px")))%>%
    
    
    
         
    ###add Event.number as text
    addLabelOnlyMarkers(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat,label =  as.character(Absorption_Phytoplankton_file_for_mapping$Event.number),group="Event.number",
                        labelOptions = labelOptions(noHide = T, direction = 'right', textOnly = T, style = list("color" = "yellow", "font-size" = "7px")))%>%
    
    ###add DEPTH as text
    addLabelOnlyMarkers(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat,label =  as.character(Absorption_Phytoplankton_file_for_mapping$DEPTH),group="DEPTH",
                        labelOptions = labelOptions(noHide = T, direction = 'right', textOnly = T, style = list("color" = "yellow", "font-size" = "5px")))%>%
    
    ###add ABS..VOL.L. as text
    addLabelOnlyMarkers(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat,label =  as.character(Absorption_Phytoplankton_file_for_mapping$ABS..VOL.L.),group="ABS..VOL.L.",
                        labelOptions = labelOptions(noHide = T, direction = 'right', textOnly = T, style = list("color" = "yellow", "font-size" = "7px")))%>%
    
    ###add Pressure as text
    addLabelOnlyMarkers(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat,label =  as.integer(Absorption_Phytoplankton_file_for_mapping$Pressure),group="Pressure",
                        labelOptions = labelOptions(noHide = T, direction = 'right', textOnly = T, style = list("color" = "yellow", "font-size" = "7px")))%>%
    
  
  #Scale Bar
  addScaleBar("bottomleft",options=scaleBarOptions(maxWidth=100,imperial=T,metric=T,updateWhenIdle=T))%>%
    
    #Layer Control
    addLayersControl(
      overlayGroups = c("num_row_ini", "Date", "Sample.ID", "QC_flag_410_smaller_than_440", "QC_flag_443_to_490", "QC_flag_ChlA_to_443_550_670", "Comments", "Event.number", "DEPTH", "ABS..VOL.L.", "Pressure"),
      options = layersControlOptions(collapsed = FALSE)) %>%
      hideGroup(c("Date", "Sample.ID", "QC_flag_410_smaller_than_440", "QC_flag_443_to_490", "QC_flag_ChlA_to_443_550_670", "Comments", "Event.number", "DEPTH", "ABS..VOL.L.", "Pressure"))
   
  

  dir.create(path =
  paste0("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/RESULTS/", all_tables_joined_by_folder_name$folder_name[i])
  , showWarnings = FALSE, recursive = TRUE)


  dir.create(path =
               paste0("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/RESULTS/1_index_png")
             , showWarnings = FALSE, recursive = TRUE)



  mapshot(m, file =
            paste0("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/RESULTS/", all_tables_joined_by_folder_name$folder_name[i], "/", all_tables_joined_by_folder_name$coded_cruise_name[i],"_Phytoplankton_Absorption_QC_plot_on_map_leaflet_",  nrow(Absorption_Phytoplankton_file_for_mapping), "_SampleIDs.png"),
          url =
            paste0("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/RESULTS/", all_tables_joined_by_folder_name$folder_name[i], "/", all_tables_joined_by_folder_name$coded_cruise_name[i],"_Phytoplankton_Absorption_QC_plot_on_map_leaflet_",  nrow(Absorption_Phytoplankton_file_for_mapping), "_SampleIDs.html")
          )

  file.copy(paste0("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/RESULTS/", all_tables_joined_by_folder_name$folder_name[i], "/", all_tables_joined_by_folder_name$coded_cruise_name[i],"_Phytoplankton_Absorption_QC_plot_on_map_leaflet_",  nrow(Absorption_Phytoplankton_file_for_mapping), "_SampleIDs.png"),
            paste0("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/RESULTS/1_index_png")
            )
  
  
  
  
  
  Absorption_Phytoplankton_file_for_mapping_sf = st_as_sf(Absorption_Phytoplankton_file_for_mapping, coords = c("lon", "lat"), crs = 4326, agr = "constant")
  #gpx_table_with_num_row_ini_sf[1:3,]
  
  data <- st_cast(Absorption_Phytoplankton_file_for_mapping_sf, "POINT")
  data$time = as.POSIXct(
  seq.POSIXt(Sys.time() - 1000, Sys.time(), length.out = nrow(data)))
  
  # data$time = as.POSIXct(
  #   seq.POSIXt(as.POSIXct(min(gpx_table_with_num_row_ini_sf$time)),
  #              as.POSIXct(max(gpx_table_with_num_row_ini_sf$time)),
  #              length.out = nrow(data)))
  
  
  icon_no_shadow <- makeIcon(
    iconUrl = ("http://cdn.leafletjs.com/leaflet/v1.3.1/images/marker-icon.png"),
    iconWidth = 25, iconHeight = 41,
    iconAnchorX = 14, iconAnchorY = 42,
    # shadowUrl = ("D:/R_WD/leaf-shadow.png"),
    # shadowWidth = 50, shadowHeight = 64,
    # shadowAnchorX = 4, shadowAnchorY = 62
  )
  
  
  map_title2 <- as.character(paste0("CRUISE TRACK ANIMATION - Phytoplankton Absorption - ", all_tables_joined_by_folder_name$folder_name[i], " - ", all_tables_joined_by_folder_name$coded_cruise_name[i], " from ", Absorption_Phytoplankton_file_for_mapping$Date[1], " to ", Absorption_Phytoplankton_file_for_mapping$Date[nrow(Absorption_Phytoplankton_file_for_mapping)], " Sample ID's = ", nrow(Absorption_Phytoplankton_file_for_mapping)))
  
  
  m<-
    leaflet(Absorption_Phytoplankton_file_for_mapping) %>%
    fitBounds(min(Absorption_Phytoplankton_file_for_mapping$lon-0.003),min(Absorption_Phytoplankton_file_for_mapping$lat-0.003),max(Absorption_Phytoplankton_file_for_mapping$lon+0.003),max(Absorption_Phytoplankton_file_for_mapping$lat+0.003)) %>%
    # addTiles(urlTemplate = 'http://server.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}', 
    #          attribution = 'Tiles &copy; Esri &mdash; National Geographic, Esri, DeLorme, NAVTEQ, UNEP-WCMC, USGS, NASA, ESA, METI, NRCAN, GEBCO, NOAA, iPC')%>%  # Add awesome tiles
    # 
    
    addControl(map_title2, position = "topleft")%>%
    addProviderTiles(providers$Esri.WorldImagery, options = providerTileOptions(opacity = 1))%>%
    addProviderTiles(providers$Esri.OceanBasemap, options = providerTileOptions(opacity = 0.2))%>%
    
    
    #Operations Points
    addCircles(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat, weight = 1, radius=1, color="red",stroke = TRUE, opacity=.5,
               group="Operations Locations",fillOpacity = 1, highlightOptions = highlightOptions(color = "white", weight = 20,bringToFront = TRUE))%>%  
    
    
    addPolylines(data = Absorption_Phytoplankton_file_for_mapping, lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat, color="yellow",weight=1)%>%
    
    
    ###add num_row_ini number as text
    addLabelOnlyMarkers(lng=Absorption_Phytoplankton_file_for_mapping$lon, lat=Absorption_Phytoplankton_file_for_mapping$lat,label =  as.character(Absorption_Phytoplankton_file_for_mapping$num_row_ini),group="num_row_ini",
                        labelOptions = labelOptions(noHide = T, direction = 'center', textOnly = T, style = list("color" = "white", "font-size" = "9px")))%>%
    
  
    addPlayback(data = data,
                icon = icon_no_shadow,
                options = playbackOptions(radius = 3, speed = 1, maxInterpolationTime = 5 * 60 * 1000, tickLen = 5000, playControl = TRUE, sliderControl = TRUE, speedControl = TRUE),
                pathOpts = pathOptions(weight = 5))
  
  #mapshot(m, url = paste0(getwd(), "/map.html"))
  #mapshot(m, url = paste0("D:/R_WD/WRITE/", gpx_file_to_read, "/", gpx_file_to_read,"World_Imagery_gpx_track_is_",  nrows_gpx_table_with_num_row_ini, "_rows", "_map_animation.html"))
  
  mapshot(m, 
          url = 
            paste0("C:/R_WD/WRITE/WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments/RESULTS/", all_tables_joined_by_folder_name$folder_name[i], "/", all_tables_joined_by_folder_name$coded_cruise_name[i],"_CRUISE_TRACK_ANIMATION_ON_MAP_Phytoplankton_Absorption_QC_",  nrow(Absorption_Phytoplankton_file_for_mapping), "_SampleIDs.html")
  )
  
  
  
  
  
  #.rs.restartR()
  
  
 

  
  #end i
}



end_time <- Sys.time()
start_time
end_time




