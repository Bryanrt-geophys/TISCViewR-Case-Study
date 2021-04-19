# TISCViewR Case Study: Testing mechanisms by which anomalous subsidence occurs - a study of the Alaskan Colville Trough
This project is an application of the [TISCViewR package](https://gitlab.com/Bryanrt-geophys/tisc_viewr), a package I have built in the R programming language to assist the analysis and visualization of TISC model outputs. This case study is meant to study numerous mechanism combinations that contribute to basin flexural development and sediment geometry patterns. As geologic processes are assumed to yield non-unique solutions, recognizing the influence of each variable at play can allow landscape evolution modelers better understanding of how to weight mechanisms at play in complex modeling scenarios.

## TISCViewR
TISCViewR is an R library built to work cooperatively with [TISC](https://github.com/danigeos/tisc), a landscape evolution and flexural modeling software written in C, for basin model analysis. TISCViewR is designed to call on both TISC input parameters and outputs files to use for analysis of each TISC model. TISCViewR calculates and outputs figures for basin geometry, basin symmetry, basin length, basin depth, and backstripping (e.g. decompaction, total subsidence, and tectonic subsidence). This allows the user to quickly perform deep analysis on many sets of models. Two R files are provided for simultaneous analysis of multiple TISC models. 

To get a glimpse of the visualizations output by TISCViewR see the [visualizations directory](visualizations).

## Getting Started
### R
TISCViewR was written in R - a programming language designed for statistics, data wrangling, analysis, visualization, and machine learning. To run TISCViewR, first [download R for MacOSX](https://cran.r-project.org/bin/macosx/) or [download R for Windows](https://cran.r-project.org/bin/windows/base/) and install it on your machine. If the user has any interest in editing the code or selectively using functions, it is recommended to also download and install the R IDE software, [RStudio](https://rstudio.com/products/rstudio/download/).

### Necessary TISC Edits
To use TISCViewR, a minor edit must be made to how TISC overwrites some of its output files at each timestep. After downloading TISC, navigate to the downloaded directory, open the src directory, and open the tiscio.c file in some form of text editing software. Find the `int write_file_cross_section()` function in the file (cmd+f/cntrl+f) and insert the following lines at the end of the function just above `return 1;`:

```
/*****************************************************************************************
 Username's edits to iterate pfl file's
*****************************************************************************************/
 
     char      command[300];
     sprintf(command, "cp %s.pfl %s_%03d.pfl", projectname, projectname, n_image);
               system(command);
/*****************************************************************************************
 Username's edits to iterate pfl file's
*****************************************************************************************/
```
When TISC is ran with this edit, the .pfl file - which contains transect data, will be copied at each timestep and renamed iteratively for the number of timesteps that take place in the model. This will provide the data frames necessary to perform the analysis.

TISCViewR is currently designed to look through a designated directory path that is adaptable to any machine due to the leveraging of R's [here package](https://cran.r-project.org/web/packages/here/index.html). Despite this, minor directory structuring is necessary if the user wants to avoid changing the code (see copy_files.R in the next section). TISCViewR will detect all TISC models within the designated directory path `Tisc_models/<model case name>/<model name>`. TISCViewR will not currently look deeper than two subdirectories for model data. TISCViewR uses the end of the directory path, `<model name>` to name listed data and faceted plots appropriately, so keep this in mind when naming the folders that will house your model data. It is good practice to names the directory in a fashion that explicitely states the unique attribute to that model (e.g. `Tisc_models/foreland_basin/75km_EET`, `Tisc_models/foreland_basin/25km_EET`, etc.).  

For a deeper understanding of how TISC files are passed to TISCViewR, see the [data directory](data).

## Under the Hood
This project leverages the [targets package](https://github.com/ropensci/targets) in R, a Make-like pipeline toolkit for R. This make-like file can be used as a template for modelers to use when designing the workflow of analysis through TISCViewR. A deeper breakdown of the make-like file, targets.R, and supplementary files for this projects workflow are listed below.

1. [copy_files.R](R/copy_files.R)
- parses through a provided root directory and locates models to gathers necessary files for passing to the targets file analysis 
- this was designed to relocate files into the version controlled directories in a space efficient way, ideal for sharing model results with collaborators interested in the development of the R package TISCViewR
- this is a supplementary workflow step 

2. [targets.R](https://gitlab.com/Bryanrt-geophys/Thesis_GitHub/-/blob/Thesis/_targets.R)
- controls the workflow of the TISCViewR functions to perform a number of processes to wrangle data, calculate backstripping, and create concise visuals for understanding basin flexure 




