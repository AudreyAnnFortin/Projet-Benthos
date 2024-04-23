# Charger la librairie ggplot2
library(ggplot2)
library(RSQLite)

# Connecter à la base de données
con <- dbConnect(SQLite(), dbname = "benthos.db")

# Charger les données de richesse spécifique depuis la base de données
query_espece <- "SELECT date_obs, COUNT(DISTINCT nom_sci) AS nb_especes FROM observations GROUP BY date_obs"
data_espece <- dbGetQuery(con, query_espece)

# Convertir la colonne date_obs en format de date
data_espece$date_obs <- as.Date(data_espece$date_obs)

# Créer le graphique
ggplot(data_espece, aes(x = date_obs, y = nb_especes)) +
  geom_point() + 
  stat_smooth(method = "loess", se = FALSE) +  # Ajustement d'une courbe de régression
  labs(title = "Nombre d'espèces observées à chaque date d'observation",
       x = "Date d'observation",
       y = "Nombre d'espèces") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotation des étiquettes de l'axe x pour une meilleure lisibilité

dbDisconnect(con)
