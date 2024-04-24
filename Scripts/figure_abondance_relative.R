abondance <- function() {
  # Connect to the database
  con <- dbConnect(SQLite(), dbname = "benthos.db")
  
  # Define the SQL query to select the 10 most abundant species and group others as "Others"
  query <- "
    WITH Top11 AS (
      SELECT 
        date_obs, 
        nom_sci,
        SUM(abondance) AS total_abondance
      FROM 
        observations
      WHERE
        date_obs BETWEEN '2016-01-01' AND '2021-12-31'
      GROUP BY 
        date_obs, nom_sci
      ORDER BY 
        total_abondance DESC, nom_sci DESC
      LIMIT 17
    )
    SELECT 
      date_obs,
      CASE 
        WHEN nom_sci IN (SELECT nom_sci FROM Top11) THEN nom_sci
        ELSE 'Autres'
      END AS nom_sci,
      SUM(abondance) AS abondance
    FROM 
      observations
    WHERE
      date_obs BETWEEN '2016-01-01' AND '2021-12-31'
    GROUP BY 
      date_obs, nom_sci
  "
  
  # Execute the SQL query and retrieve the results into a dataframe
  data_espece <- dbGetQuery(con, query)
  
  # Print the retrieved data for debugging
  #print(data_espece)
  
  # Convert the date_obs column to date format
  data_espece$date_obs <- as.Date(data_espece$date_obs)
  
  # Create a vector to define the order of factors of the nom_sci variable
  esp_ordre <- c(unique(data_espece$nom_sci[data_espece$nom_sci != "Autres"]), "Autres")
  
  # Convert the nom_sci variable to a factor with the specified order
  data_espece$nom_sci <- factor(data_espece$nom_sci, levels = esp_ordre)
  
  # Create the plot
  abondance_plot <- ggplot(data_espece, aes(x = format(date_obs, "%Y"), y = abondance, fill = nom_sci)) +
    geom_bar(stat = "identity") +
    labs(title = "Abondance relative des espèces à chaque année",
         x = "Année d'observation",
         y = "Abondance relative des espèces",
         fill = "Espèce") +
    scale_fill_brewer(palette = "Set3") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  # Disconnect from the database
  dbDisconnect(con)
  
  # Return the plot
  return(abondance_plot)
}
