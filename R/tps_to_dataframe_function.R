#' tps_to_df
#'
#' Regular Expression loop to get .tps files containing "LM", "IMAGE", "ID", and "SCALE" information (no more no less) into a dataframe,
#' which subsequently can be used in the function *get_outlines()* for scaling.
#'
#' @param tps_file_path The path to the .tps file containing "LM", "IMAGE", "ID", and "SCALE" information (no more no less), as for example created using tpsUtil and tpsDig2 (Rohlf 2017).
#'
#' @return Returns a dataframe with "LM", "IMAGE", "ID", and "SCALE" as column names.
#'
#' @export



tps_to_df <- function(tps_file_path = tps_file_path) {
  tps_file <- readChar(tps_file_path,
                       file.info(tps_file_path)$size)


  tps_file_matrix <- matrix(strsplit(tps_file, split = "\r\n")[[1]], ncol = 4, byrow = TRUE)
  tps_file_df <- as.data.frame(tps_file_matrix,
                               stringsAsFactors = FALSE)
  names(tps_file_df) <- c("LM", "IMAGE", "ID", "SCALE") # works of course only if there is exactly these four variables. no more no less.

  for (current_col_name in names(tps_file_df)) {
    current_col <- unlist(strsplit(tps_file_df[,current_col_name], split = paste0(current_col_name, "=")))
    tps_file_df[,current_col_name] <- current_col[seq(from = 2, to = length(current_col), by = 2)]

    if (current_col_name == "IMAGE") {
      image_names <- unlist(strsplit(tps_file_df[,current_col_name], split = "[.]"))
      tps_file_df[,current_col_name] <- image_names[seq(from = 1, to = length(current_col), by = 2)]
    }


  }

  tps_file_df$SCALE <- as.numeric(tps_file_df$SCALE)

  return(tps_file_df)
}

