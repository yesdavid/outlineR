# outlineR


## Example

```
pathname_input <- "./2_data/raw_data/Points" # where the images are right now

pathname_output <- "./2_data/derived_data/" #where the separate images should be saved


####### 1. separate single artefacts/barbs from picture with multiple artefacts/barbs on one image
outlineR::separate_single_artefacts_function(pathname_input = pathname_input, pathname_output = pathname_output)

# afterwards, the JPEGs of the single artefacts should be saved in the folder which you defined under "pathname_output"
# if there is just plain white images in your "pathname_output" folder, re-check the images you prepared in "pathname_input" for single outlier pixels or open outlines. If necessary, delete all JPEGS in pathname_output. Then, re-run this command.


####### 2. use Momocs' funtion import_jpg1() to get the outlines of the images. This function only needs the files in your "output_path_name" folder, so you do not (necesarrily) have to run all of the code above again.

single_outlines_list <- get_outlines_function(pathname_output = pathname_output)


####### 3. combine all outlines into a common file
combine_outlines_function(single_outlines_list = single_outlines_list)


####### 4. inspect your outlines
length(outlines_combined) #how many outlines do you have?
Momocs::stack(outlines_combined) #shows all outlines above one another
Momocs::panel(outlines_combined) #shows all outlines next to each other
Momocs::inspect(outlines_combined) #shows only a single outline at a time. press enter to see the next one, press escape to quit the "viewing mode"
```

