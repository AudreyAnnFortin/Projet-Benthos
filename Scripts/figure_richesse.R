

# Charger la librairie ggplot2
library(ggplot2)

# Données
sites <- data_list$sites$site
temps <- data_list$date_observed$date
especes <- data_list$observations$nom_sci

# Créer un dataframe avec les données
data <- data.frame(sites = sites, temps = as.Date(temps), especes = especes)

# Formater l'axe du temps pour afficher le mois et l'année
data$temps <- format(data$temps, "%b %Y")

# Créer le graphique
ggplot(data, aes(x = temps, fill = sites)) +
  geom_bar(position = "dodge", stat = "count") +
  labs(title = "Nombre d'espèces observées dans le temps par site",
       x = "Mois et année",
       y = "Nombre d'espèces") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotation des étiquettes de l'axe x pour une meilleure lisibilité



