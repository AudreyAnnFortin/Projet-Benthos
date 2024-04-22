Data<- function(path) {
# Get a list of all CSV files in the directory
csv_files <- list.files(path, pattern = "\\.csv$", full.names = TRUE)
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
}

# Now, data_list contains data frames from all CSV files in the directory