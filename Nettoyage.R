#Authors: Amélie Garnier, Audrey-Ann Fortin and Myriam Marentette

# Get a list of all CSV files in the directory
csv_files <- list.files(getwd(), pattern = "\\.csv$", full.names = TRUE)
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
# Now, data_list contains data frames from all CSV files in the directory


# Loop through each data frame in data_list
for (file_name in names(data_list)) {
  # Get the data frame
  bent <- data_list[[file_name]]
  # Convert 'date' column to Date format
  bent$date <- as.Date(bent$date)
  # Convert 'site' column to character
  bent$site <- as.character(bent$site)
  # Convert 'date_obs' column to Date format
  bent$date_obs <- as.character(bent$date_obs)
  # Function to convert heure_obs to format "%H:%M:%S"
  convert_heure_obs <- function(heure_obs) {
    
    # Check if heure_obs is in the format "13h00.00"
    if (grepl("\\d{2}h\\d{2}\\.\\d{2}", heure_obs)) {
      # Extract hour and minute from the string
      parts <- strsplit(heure_obs, "h|\\.")[[1]]
      hour <- as.numeric(parts[1])
      minute <- as.numeric(parts[2])
      # Convert to format "%H:%M:%S"
      return(sprintf("%02d:%02d:00", hour, minute))
    }
    else {
      return(heure_obs)
    }
  }
  # Apply the conversion function to heure_obs column
  bent$heure_obs <- sapply(bent$heure_obs, convert_heure_obs)
  
  # Convert 'heure_obs' to character
  bent$heure_obs <- as.character(bent$heure_obs)
  # Convert 'fraction' column to numeric
  bent$fraction <- as.numeric(bent$fraction)
  # Convert 'nom_sci' column to character
  bent$nom_sci <- as.character(bent$nom_sci)
  # Convert 'abondance' column to numeric
  bent$abondance <- as.numeric(bent$abondance)
  # Convert 'largeur_riviere' column to numeric
  bent$largeur_riviere <- as.numeric(bent$largeur_riviere)
  # Convert 'profondeur_riviere' column to numeric
  bent$profondeur_riviere <- as.numeric(bent$profondeur_riviere)
  # Convert 'vitesse_courant' column to numeric
  bent$vitesse_courant <- as.numeric(bent$vitesse_courant)
  # Convert 'transparence_eau' column to character
  bent$transparence_eau <- as.character(bent$transparence_eau)
  # Convert 'temperature_eau_c' column to numeric
  bent$temperature_eau_c <- as.numeric(bent$temperature_eau_c)
  # Update the data frame in data_list
  data_list[[file_name]] <- bent
}

#maintenant le data_list contient les 3 tableaux de données qui seront utilisé pour la SQL.