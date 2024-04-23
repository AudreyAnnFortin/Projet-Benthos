# Charger les bibliothèques nécessaires
library(RSQLite)
library(ggplot2)

# Connecter à la base de données
con <- dbConnect(SQLite(), dbname = "benthos.db")

# Charger les données d'abondance par espèce depuis la base de données
query <- "SELECT nom_sci, abondance FROM observations"
data_abondance <- dbGetQuery(con, query)

# Charger les données de profondeur de la rivière depuis la base de données
query <- "SELECT sites, profondeur_riviere FROM sites"
data_profondeur <- dbGetQuery(con, query)

# Fusionner les données d'abondance avec les données de profondeur
data_merged <- merge(data_abondance, data_profondeur, by = "site")

# Créer le density plot avec ggplot2
ggplot(data_merged, aes(x = profondeur_riviere, y = abondance)) +
  geom_point(alpha = 0.4) +  # Points avec transparence
  geom_density_2d() +  # Density plot
  labs(x = "Profondeur de la rivière", y = "Abondance") +  # Titres des axes
  ggtitle("Density plot de l'abondance par espèce en fonction de la profondeur de la rivière") +  # Titre du plot
  theme_minimal()  # Style du plot

dbDisconnect(con)
