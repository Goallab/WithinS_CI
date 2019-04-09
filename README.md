# Confidence intervals for within and between designs
Standardized function that calculates confidence intervals for data that contains at least one within factor.

Created by [Myrthel Dogge](mailto:m.dogge@uu.nl) and [Chris Harris](mailto:c.a.harris@uu.nl)


INSTRUCTIONS:  
This function can be used to calculate confidence intervals in designs that contain at least one within factor. It is a generalized form based off of code in the [Cookbook For R](http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/) condensed in one flexible function. The repository contains three files:  

1. WithinS_CI.R contains the actual function.
2. examples.R contains some example uses of the function including example plots.
3. createdata.R generates example data.
  
The example data set contains two between subject variables and two within subject variables. The number of variables specified in the function MUST correspond to the number that is present in the dataframe. Accordingly, if you have a design with three IVs, but you're interested in a two-way interaction between two of the variable, the data needs to be collapsed over the third variable to render correct results. `WithinS_CI()` should recognize if within-factors are not declared and throw an error.  

The dependencies are not loaded automatically in the package but need to be loaded separately as exemplified in examples.R. These are `tidyr`, `dplyr`, and `rlang`. 