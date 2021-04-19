# Load packages ----

pacman::p_load(
  fs,
  here,
  stringr,
  purrr,
  furrr
)

# Point to where the root where the models are located

old_path <- here("../../../Tisc_Models")

# Provide the files the user wants to use

wanted_files <- c("pfl", "UNIT", "PRM", "SLV")

# Loop through each each file type and collect those files from the models 

map(wanted_files, function(x){
  new_path <- here(sprintf("data/raw/%s", x)) # Very likely data/raw
  
  file_paths <- if (x == "pfl") {
    dir_ls(
      path = old_path,
      recurse = TRUE,
      all = TRUE,
      regexp = sprintf("%s$", x)
    ) %>%
      str_subset(pattern = sprintf("NS\\.%s$", x), negate = TRUE)
  } else {
    dir_ls(
      path = old_path,
      recurse = TRUE,
      all = TRUE,
      regexp = sprintf("%s$", x)
    )
  }
  
  # Create model folders ----
  
  model_dir_names <- sort(unique(basename(dirname(file_paths))))
  
  if (x == "pfl") {
    unwanted_dir_names <- future_map(model_dir_names, ~ str_subset(string = file_paths, pattern = .x)) %>%
      keep(~ length(.x) == 1) %>%
      map_chr(~ basename(dirname(.x)))
    
    model_dir_names <- setdiff(model_dir_names, unwanted_dir_names)
    
    if (length(unwanted_dir_names) == 0) {
      print(" no unwanted_dir_names")
    } else {
      file_paths <- str_remove(string = file_paths, pattern = paste0(unwanted_dir_names, collapse = "|"))
    }
  }
  
  
  dir_create(path = new_path, model_dir_names)
  model_dir_paths <- sort(dir_ls(path = new_path))
  
  # Copy files to respective folders  
  
  future_map(model_dir_names, ~ str_subset(string = file_paths, pattern = .x)) %>%
    future_walk2(model_dir_paths, ~ file_copy(path = .x, new_path = .y, overwrite = TRUE))
})

# Clears the _targets directory so it is ready to call on the newest 
# data set that was just collected

unlink(x = here("_targets/meta"), recursive = T)
unlink(x = here("_targets/objects"), recursive = T)
