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

  split_by_image <- strsplit(tps_file, split = "IMAGE=")[[1]]
  split_by_image <- split_by_image[2:length(split_by_image)]

  df_list <- list()
  for(current_img_index in 1:length(split_by_image)){

    current_scale <- if(is.na(stringr::str_extract(pattern = "SCALE=", string = split_by_image[current_img_index])) == FALSE){
      gsub(".*SCALE=|\r\n.*", "", split_by_image[current_img_index])
    } else{"NA"}

    df_list[[current_img_index]] <-
      data.frame(IMAGE = strsplit(gsub(".*.^|\r\n.*", "", split_by_image[current_img_index]), split = "\\.")[[1]][1],
                 ID = gsub(".*ID=|\r\n.*", "", split_by_image[current_img_index]),
                 SCALE = current_scale)

  }
  tps_file_df <- do.call(rbind.data.frame, df_list)

  tps_file_df$SCALE <- as.numeric(gsub(",", ".", x = tps_file_df$SCALE))

  return(tps_file_df)
}

