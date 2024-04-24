#Authors: Amélie Garnier, Audrey-Ann Fortin and Myriam Marentette

Nettoyage <- function(data_list) { 
  for (file_name in names(data_list)) {
    bent <- data_list[[file_name]]
    bent$date <- as.Date(bent$date)
    bent$site <- as.character(bent$site)
    bent$date_obs <- as.Date(bent$date_obs)
    
    convert_heure_obs <- function(heure_obs) {
      if (grepl("\\d{2}h\\d{2}\\.\\d{2}", heure_obs)) {
        parts <- strsplit(heure_obs, "h|\\.")[[1]]
        hour <- as.numeric(parts[1])
        minute <- as.numeric(parts[2])
        return(sprintf("%02d:%02d:00", hour, minute))
      } else {
        return(heure_obs)
      }
    }
    bent$heure_obs <- sapply(bent$heure_obs, convert_heure_obs)
    bent$heure_obs <- as.character(bent$heure_obs)
    bent$fraction <- as.numeric(bent$fraction)
    bent$nom_sci <- as.character(bent$nom_sci)
    
    bent$abondance <- as.numeric(bent$abondance)
    
    #if (file_name %in% c("site_133_101_R01_2018-09-07", "site_133_101_R01_2019-09-13")) {
    #  print(paste("Converting 'abondance' for file:", file_name)) 
    bent$abondance <- sapply(bent$abondance, abs)
    #}
    
    bent$largeur_riviere <- as.numeric(bent$largeur_riviere)
    bent$profondeur_riviere <- as.numeric(bent$profondeur_riviere)
    bent$vitesse_courant <- as.numeric(bent$vitesse_courant)
    bent$transparence_eau <- as.character(bent$transparence_eau)
    bent$temperature_eau_c <- as.numeric(bent$temperature_eau_c)
    
    data_list[[file_name]] <- bent
  }
}


