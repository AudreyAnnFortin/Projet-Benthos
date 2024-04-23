Data <- function(path) {
  # Get a list of all CSV files in the directory
  csv_files <- list.files(path, pattern = "^site_.*\\.csv$", full.names = TRUE)
  # Create an empty list to store data frames
  data_list <- list()
  
  # Loop through each CSV file
  for (file in csv_files) {
    # Read data from CSV file
    data <- read.csv(file)
    # Extract file name without extension
    file_name <- tools::file_path_sans_ext(basename(file))
    # Store the data frame in the list with file name as key/index
    data_list[[file_name]] <- data
  }
  # Return the populated data_list
  return(data_list)
}

# Call the Data function to populate data_list
data_list <- Data("C:/Users/myria/OneDrive - USherbrooke/BIO500/Projet-Benthos/Données")

# Print out the contents of data_list
print(data_list)

# Or simply type the name of the variable in the console
data_list

