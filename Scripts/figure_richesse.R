library(ggplot2)
library(RSQLite)

# Connecter à la base de données
con <- dbConnect(SQLite(), dbname = "benthos.db")

# Charger les données de richesse spécifique depuis la base de données
query_espece <- "SELECT date_obs, COUNT(DISTINCT nom_sci) AS nb_especes FROM observations GROUP BY date_obs"
data_espece <- dbGetQuery(con, query_espece)

# Convertir la colonne date_obs en format de date
data_espece$date_obs <- as.Date(data_espece$date_obs)

# Filtrer les données pour les années 2016 à 2021
data_espece <- data_espece[data_espece$date_obs >= "2016-01-01" & data_espece$date_obs <= "2021-12-31", ]

# Extraire l'année à partir de la colonne date_obs
data_espece$annee <- format(data_espece$date_obs, "%Y")

# Créer le graphique
ggplot(data_espece, aes(x = as.factor(annee), y = nb_especes, fill = as.factor(annee))) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.9), width = 0.9) +  # Utilisation de position_dodge pour positionner les barres côte à côte
  labs(title = "Nombre d'espèces totales observées chaque année",
       x = "Année d'observation",
       y = "Nombre d'espèces totales observées") +
  scale_fill_brewer(palette = "Set3") +  # Choix d'une palette de couleurs
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none") # Rotation des étiquettes de l'axe x pour une meilleure lisibilité et suppression de la légende

dbDisconnect(con)
