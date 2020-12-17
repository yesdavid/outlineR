# outlineR

This package is basically just a helpful wrapper around functions from mainly the _Momocs_ (Bonhomme et al. 2014), _EBImage_ (Pau et al. 2010), and _imager_ (Barthelme et al. 2020) packages. It is designed for the fast and easy extraction of single outline shapes from, for example, stone tools from images containing multiple artefacts, such as the ones present in archaeological publications.


## Installation

```
devtools::install_github("yesdavid/outlineR", dependencies = TRUE)
```


## Example

```
# Define where the images containing multiple artefacts are right now.
pathname_input <- "./2_data/raw_data/Points" 

# Define where the separate images should be saved.
pathname_output <- "./2_data/derived_data/" 
```

1. Separate single artefacts/barbs from picture with multiple artefacts/barbs on one image.
```
outlineR::separate_single_artefacts_function(pathname_input = pathname_input, 
                                             pathname_output = pathname_output)
```
Afterwards, the JPEGs of the single artefacts should be saved in the folder which you defined under `pathname_output`. If there is just plain white images in your `pathname_output` folder, re-check the images you prepared in "pathname_input" for single outlier pixels or open outlines. If necessary, delete all JPEGS in `pathname_output`. Then, re-run this command.


2. Use Momocs' function import_jpg1() to get the outlines of the images. This function only needs the files in your `output_path_name` folder, so you do not (necesarrily) have to run all of the code above again.
```
single_outlines_list <- get_outlines_function(pathname_output = pathname_output)
```

3. Combine all outlines into a common file.
```
outlines_combined <- combine_outlines_function(single_outlines_list = single_outlines_list)
```

4. Inspect your outlines.
```
length(outlines_combined) #how many outlines do you have?
Momocs::stack(outlines_combined) # shows all outlines above one another(you might want to center and scale them first using Momocs)
Momocs::panel(outlines_combined) # shows all outlines next to each other
Momocs::inspect(outlines_combined) # shows only a single outline at a time. 
```



## References

__Barthelme et al. 2020__: Barthelme, S., Tschumperle, D., Wijffels, J., Assemlal, H. E., & Ochi, S. (2020). imager: Image Processing Library Based on “CImg” (0.42.3) [Computer software]. https://CRAN.R-project.org/package=imager

__Bonhomme et al. 2014__: Bonhomme, V., Picq, S., Gaucherel, C., & Claude, J. (2014). Momocs: Outline Analysis Using R. Journal of Statistical Software, 56(13). https://doi.org/10.18637/jss.v056.i13

__Pau et al. 2010__: Pau, G., Fuchs, F., Sklyar, O., Boutros, M., & Huber, W. (2010). EBImage—An R package for image processing with applications to cellular phenotypes. Bioinformatics, 26(7), 979–981. https://doi.org/10.1093/bioinformatics/btq046





