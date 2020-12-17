#' A function to create open outlines from closed outlines. The way it is implemented, the open outline will start at the highest, left-most coordinate, run clock-wise, and will end at the lowest, left-most coordinate.
#'
#' @param single_outlines_list A Momocs Out file containing closed outlines.
#' @param return_combined_outlines (default = TRUE) A logical parameter stating wether to output a Momocs Opn-file, or a list of coordinate matrices of each open outline.
#' @return If return_combined_outlines = TRUE, returns the combined Coo objects in a single Opn file. If return_combined_outlines = FALSE, returns a list of coordinate matrices of each open outline.
#' @examples
#' open_outlines_from_closed_outlines_function(closed_outlines_Momocs = outlines_combined, return_combined_outlines = TRUE)




open_outlines_from_closed_outlines_function <- function(closed_outlines_Momocs = outlines_combined, return_combined_outlines = TRUE){

  open_outlines_list <- list()

  pb <- txtProgressBar(min = 0, max = length(outlines_combined), style = 3)
  for(counter in 1:length(outlines_combined)){

    current_outline_name <- names(outlines_combined$coo[counter])

    current_outline <- outlines_combined$coo[[counter]]

    current_outline_df <- as.data.frame(current_outline)
    names(current_outline_df) <- c("X", "Y")


    starting_lowest_x <- subset(current_outline_df,
                                X == min(current_outline_df$X))

    starting_lowest_x_highest_y <- subset(starting_lowest_x,
                                          Y == max(starting_lowest_x$Y))

    ending_lowest_x <- subset(current_outline_df,
                              X == min(current_outline_df$X))

    ending_lowest_x_highest_y <- subset(ending_lowest_x,
                                        Y == min(ending_lowest_x$Y))

    start <- rownames(starting_lowest_x_highest_y)
    end <- rownames(ending_lowest_x_highest_y)

    closed <- Momocs::Opn(current_outline[c(1:end,start:nrow(current_outline)),])

    open_outlines_list[[current_outline_name]] <- coo_slidegap(closed, force = T)


    setTxtProgressBar(pb, counter)
  }
  close(pb)


  if(return_combined_outlines == TRUE){
    return(combine_outlines_function(open_outlines_list))
  } else {
    return(open_outlines_list)
  }



}










