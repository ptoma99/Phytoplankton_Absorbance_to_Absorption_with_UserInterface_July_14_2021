#003_011_last_message_complete

#for R version 4.0.4
#by Peter Toma - DFO, BIO, Dartmouth NS - Ocean Ecosystem Science Division
#Supervisor: Dr. Emmanuel Devred
#Science Information Officer: Diana Cardoso
#Date: Thursday, April 23, 2021

last_message_complete <- "Processing and QC is complete!  this message indicates all went well. The file 'C:/R_WD/Absorbance_to_Absorption_R_scripts_output_table_info.xlsx' contains output details and where they are written. To open this file with excel = ('Yes'), to close this window without exiting R = ('No')"

msgBox_last_msg <- tk_messageBox(type = c("yesno"),
              last_message_complete, caption = "Continue?", default = "")
msgBoxCharacter_last_msg <- as.character(msgBox_last_msg)

if(msgBoxCharacter_last_msg == "yes"){
  shell.exec("C:/R_WD/Absorbance_to_Absorption_R_scripts_output_table_info.xlsx")
}






