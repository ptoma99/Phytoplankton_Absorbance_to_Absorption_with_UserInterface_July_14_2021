README

Process and convert Particulate, Detritus and Phytoplankton Absorbance bottle data to Absorption using R
By Peter Toma, July 2021

Department of Fisheries and Oceans
Bedford Institute of Oceanography
Dartmouth, Nova Scotia, CANADA

Ocean and Ecosystem Science Division
Supervisor: Dr. Emmanuel Devred
Science Information Officer: Diana Cardoso

Updated July 20, 2021

***instructions to run the code***

The code is written as a series functions called by a main script.   
There are User Interface Dialogs that help read the required files and help with the identification of metadata incompatibilities.  
The working directory is C:\R_WD\ and each “C:\R_WD\WORKS(1-7)” folder contains multiple report files (their file names describe the content) to facilitate problem solving if needed. 
All report files show the number of rows in the file name to facilitate reading.  

The R codepack is a directory named “R_WD” that can be found within “Phytoplankton_Absorbance_to_Absorption_R_Work_Directory.zip”. 

The R script writes all files and reports in "C:\R_WD\WRITE\". 
It is recommended that the "WRITE" folder to be deleted or renamed if it exists each time before running the scripts to avoid file overwriting.

R main script name and path to run which calls all the functions:
“C:\R_WD \all_in_one_Phytoplankton_Absorbance_to_Absorption_with_UserInterface_2021.R”
Line 1 to line 90 – User input and testing, line 90 to 245 – processing.

The R script above will call the other 19 R scripts that are located in:
“C:\R_WD\R_codes_003_Phytoplankton_2021\R_codes_in_sequence\”

required input files and data:

- Cruise folder with raw data txt absorbance files particulate 123456.txt and detritus   123456p.txt
- cruise coded name or cruise number (ABC1234567)
- the HPLC file (must have HPLC in the file name) (xls, xlsx or xlsm, NOT CSV)
- the QAT file (must have _QAT in the file name) (xls, xlsx or csv, NOT xlsm)
- the ODF file (must have .ODF file extension)
- filter diameter in millimeters (mm)
- broadband internet connection

***Versions of R and all packages***
 R version 4.0.4 (2021-02-15)

Packages required: "tcltk2", "DescTools", "reader", "dplyr", "tidyr", "stringr", "R.utils", "readxl", "fs", "qdapRegex", "gdata", "lmodel2", "robustbase", "leaflet",  "mapview", "leaflet.providers", "leaflet.extras2", "sf", "rgl", "xfun", "webshot", "webdriver", "phantomjs"(webdriver::install_phantomjs(version = "2.1.1", baseURL = "https://github.com/wch/webshot/releases/download/v0.3.1/") 	

***Organisation of folder structure or repository***
C:\R_WD\
Metadata_links_HPLC_QAT_ODF\
R_codes_003_Phytoplankton_2021\
Metadata_per_cruise_Example_files_for_colnames_and_empty_rows\
QC_plots_Colors_Legend.png
Absorbance_to_Absorption_R_scripts_input_table_info.xlsx
session_info_2021-06-23_12-27-57_.txt
Absorbance_to_Absorption_R_scripts_output_table_info.xlsx
all_in_one_Phytoplankton_Absorbance_to_Absorption_with_UserInterface_2021.R
Manual_R_code_Absorbance_to_Absorption_Peter_Toma_July_14_2021.docx
Manual_R_code_Absorbance_to_Absorption_Peter_Toma_July_14_2021.pdf
README.txt

C:\R_WD\WRITE\
	\WORKS_Absorbance_raw_data_files_analysis

C:\R_WD\WRITE\WORKS\

\METADATA_TEST_BEFORE_PROCEED\AMU2019001_Absorbance_Particulate_plus_Detritus_file_list_txt_d6_and_d6p_264_rows.csv
\WORKS\RESULTS\
\WORKS\final_d6_txt_nrow_filepath_NROW_ERR_df_0_rows.csv
\WORKS\final_d6p_txt_nrow_filepath_NROW_ERR_df_0_rows.csv
\WORKS\GENERATE_UNPAIRED_P_D_PHY\all_Absorbance_files_including_the_ones_999_created_should_be_396_and_they_are_396_rows.csv
\WORKS_Absorbance_raw_data_files_analysis\Phytoplankton_negative_values_124_rows_stopped_at_file_132_of_132.csv
\WORKS2\RESULTS\
\WORKS_PLOT_Absorbance_no_VOL\RESULTS
\WORKS4\RESULTS\Absorbance_3tables_with_metadata\
\WORKS4\ALL_samples_ID_not_found_in_HPLC_and_QAT\
\WORKS5\RESULTS\
\WORKS_PLOT_Absorption_final_tables\RESULTS
\Absorbance_vs_Absorption_3dplots_copy
\WORKS_QC\QC_plots
\WORKS6
\WORKS7\RESULTS
\WORKS_PLOT_Phytoplankton_Absorption_by_QC_flags_Comments\RESULTS
\WORKS_PLOT_Absorbance_and_Absorption\RESULTS
\WORKS_PLOT_ON_MAP_Phytoplankton_Absorption_QC_Comments\RESULTS
\WORKS_Metadata_per_cruise_stats\


***Steps to run the code ***

1) Read the manual "Manual_R_code_Absorbance_to_Absorption_Peter_Toma_July_14_2021.pdf"  
2)The “R_WD”  directory must be extracted and copied in “C:\” drive root; C:\R_WD  before running.
3) assemble input data and files 
4) Run the main script:  “C:\R_WD \all_in_one_Phytoplankton_Absorbance_to_Absorption_with_UserInterface_2021.R”
5) View results in "C:\R_WD\WRITE\"

*** sessioninfo() ***

R version 4.0.4 (2021-02-15)						
Platform: x86_64-w64-mingw32/x64 (64-bit)						
Running under: Windows 10 x64 (build 18363)						
					
Matrix products: default						
					
locale:						
 LC_COLLATE=English_United States.1252, LC_CTYPE=English_United States.1252, LC_MONETARY=English_United States.1252				
 LC_NUMERIC=C, LC_TIME=English_United States.1252					
						
attached base packages:						
 tcltk, stats, graphics, grDevices, utils, datasets, methods, base
						
other attached packages:						
 webdriver_1.0.6, webshot_0.5.2, xfun_0.22, sf_0.9-8, leaflet.extras2_1.1.0, leaflet.providers_1.9.0	
 mapview_2.9.0, leaflet_2.0.4.1, robustbase_0.93-7, lmodel2_1.7-3, gdata_2.18.0, qdapRegex_0.7.2	
 fs_1.5.0, readxl_1.3.1, R.utils_2.10.1, R.oo_1.24.0, R.methodsS3_1.8.1, stringr_1.4.0	
 tidyr_1.1.3, dplyr_1.0.5, reader_1.0.6, NCmisc_1.1.6, DescTools_0.99.41, tcltk2_1.2-11	
						
loaded via a namespace (and not attached):						
 satellite_1.0.2, showimage_1.0.0, httr_1.4.2, tools_4.0.4, utf8_1.2.1, R6_2.5.0	 
 KernSmooth_2.23-18, DBI_1.1.1, colorspace_2.0-0, manipulateWidget_0.10.1, raster_3.4-5, sp_1.4-5	 	
 processx_3.5.1, tidyselect_1.1.0, Exact_2.1, curl_4.3, compiler_4.0.4, leafem_0.1.3	 
 expm_0.999-6, scales_1.1.1, DEoptimR_1.0-8, classInt_0.4-3, mvtnorm_1.1-1, callr_3.7.0	
 proxy_0.4-25, digest_0.6.27, rmarkdown_2.7, base64enc_0.1-3, pkgconfig_2.0.3, htmltools_0.5.1.1	
 fastmap_1.1.0, htmlwidgets_1.5.3, rlang_0.4.10, rstudioapi_0.13, shiny_1.6.0, generics_0.1.0	 
 jsonlite_1.7.2, crosstalk_1.1.1, gtools_3.8.2, magrittr_2.0.1, Matrix_1.2-18, Rcpp_1.0.6	 
 munsell_0.5.0, fansi_0.4.2, lifecycle_1.0.0, yaml_2.2.1, stringi_1.5.3, debugme_1.1.0	
 MASS_7.3-53.1, rootSolve_1.8.2.1, grid_4.0.4, promises_1.2.0.1, crayon_1.4.1, lmom_2.8	 
 miniUI_0.1.1.1, lattice_0.20-41, ps_1.6.0, knitr_1.32, pillar_1.6.0, boot_1.3-27	
 gld_2.6.2, markdown_1.1, codetools_0.2-18, stats4_4.0.4, glue_1.4.2, evaluate_0.14	
 data.table_1.14.0, png_0.1-7, vctrs_0.3.7, httpuv_1.5.5, cellranger_1.1.0, purrr_0.3.4	
 assertthat_0.2.1, mime_0.10, xtable_1.8-4, e1071_1.7-6, later_1.1.0.1, class_7.3-18	 
 tibble_3.1.1, tinytex_0.31, proftools_0.99-3, units_0.7-1, ellipsis_0.3.1	 	
