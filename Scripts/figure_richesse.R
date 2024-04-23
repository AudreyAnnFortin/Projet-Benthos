# Charger la librairie ggplot2
library(ggplot2)
library(RSQLite)

# Connecter à la base de données
con <- dbConnect(SQLite(), dbname = "benthos.db")

# Charger les données de richesse spécifique depuis la base de données
query_espece <- "SELECT nom_sci, site FROM observations"
data_espece <- dbGetQuery(con, query_espece)

# Charger les données des dates d'observations depuis la base de données
query_date <- "SELECT date_obs, site FROM observations"
data_date <- dbGetQuery(con, query_date)

# Fusionner les données d'espèces avec les données de dates
data_merged <- merge(data_espece, data_date, by = "site")

# Convertir la colonne date_obs en format de date
data_merged$date_obs <- as.Date(data_merged$date_obs)

# Extraire le mois et l'année à partir de la date_obs
data_merged$month_year <- format(data_merged$date_obs, "%b %Y")

# Créer le graphique
ggplot(data_merged, aes(x = month_year, fill = site)) +
  geom_bar(position = "dodge") +
  labs(title = "Nombre d'espèces observées dans le temps par site",
       x = "Mois et année",
       y = "Nombre d'espèces") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotation des étiquettes de l'axe x pour une meilleure lisibilité

