#Authors: Amélie Garnier, Audrey-Ann Fortin and Myriam Marentette
#Get the datas
source("Data.R")

# Create a data frame to insert the different variables needed for the observation data frame
observations <- data.frame(nom_sci = character(), site = character(), date_obs = as.Date(character()), abondance = numeric(), fraction = numeric())
# Create a loop iterate over each file in data_list
for (file_name in names(data_list)) {
  # Select the columns needed in the new data frame and save them into a new object
  selected_columns <- data_list[[file_name]][, c("nom_sci", "site", "date_obs", "abondance", "fraction")]
  # Add these to the observations data frame
  observations <- rbind(observations, selected_columns)
}
#put the data frame into a CSV file to be read into the data base
write.csv(observations, "observations.csv",row.names = F)


# Create a data frame to insert the different variables needed for the site's data frame
site <- data.frame(site = character(), largeur_riviere = numeric(), profondeur_riviere = numeric(), vitesse_courant = numeric(), transparence_eau = character())
# Create a loop to iterate over each file in data_list
for (file_name in names(data_list)) {
  # Select the columns needed in the new data frame and save them into a new object
  selected_columns <- data_list[[file_name]][, c("site", "largeur_riviere", "profondeur_riviere", "vitesse_courant", "transparence_eau")]
  # Add these to the site data frame
  site <- rbind(site, selected_columns)
}
#put the data frame into a CSV file to be read into the data base
write.csv(site, "sites.csv",row.names =F)

# Create a data frame to insert the different variables needed for the date_observed's data frame
date_observed<- data.frame(date=as.Date(character()), date_obs=as.Date(character()), heure_obs=as.Date(character()),temperature_eau_c=as.numeric())
# Create a loop to iterate over each file in data_list
for (file_name in names(data_list)) {
  # Select the columns needed in the new data frame and save them into a new object
  selected_columns <- data_list[[file_name]][, c("date","date_obs", "heure_obs", "temperature_eau_c")]
  # Add these to the date_observed data frame
  date_observed <- rbind(date_observed, selected_columns)
}
#put the data frame into a CSV file to be read into the data base
write.csv(date_observed, "date_observed.csv",row.names=F)