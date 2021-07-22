#exit_R_if_dirname_df_fails

#exit R if dirname(data.frame) fails on 003_000_002 file_list_txt_d6_df$dirname <- dirname(file_list_txt_d6_df[,1])

if (is.null(file_list_txt_d6_df$dirname)){
  
  dirname_err_message <- "Because of an R Version incompatibility, R base cannot perform the required command 'dirname(data.frame)', but only 'dirname(character_vector)'. Please install 'R version 4.0.4 (2021-02-15)' and try again. The program cannot continue. R will exit without saving the workspace."
  msgBox_dirname_err_message <- tk_messageBox(type = c("ok"),
                                              dirname_err_message, caption = "Continue?", default = "")
  msgBoxCharacter_dirname_err_message <- as.character(msgBox_dirname_err_message)
  
  if(msgBoxCharacter_dirname_err_message == "ok"){
    print("Quit R")
    quit(save="no")
    
  }
  
}


