# Charger les bibliothèques nécessaires
library(RSQLite)
library(ggplot2)

# Connecter à la base de données
con <- dbConnect(SQLite(), dbname = "benthos.db")

# Charger les données d'abondance par espèce depuis la base de données
query <- "SELECT nom_sci, abondance FROM observations"
data_abondance <- dbGetQuery(con, query)

# Charger les données de profondeur de la rivière depuis la base de données
query <- "SELECT site, largeur_riviere FROM sites"
data_largeur <- dbGetQuery(con, query)

# Fusionner les données d'abondance avec les données de profondeur
data_merged <- merge(data_abondance, data_largeur, by = "site")

# Créer le bubble plot avec ggplot2
ggplot(data_merged, aes(x = largeur_riviere, y = abondance, size = abondance)) +
  geom_point(alpha = 0.6) +  # Points avec transparence
  scale_size_continuous(range = c(3, 10)) +  # Définir la plage de tailles des bulles
  labs(x = "Largeur de la rivière", y = "Abondance") +  # Titres des axes
  ggtitle("Bubble plot de l'abondance en fonction de la largeur de la rivière") +  # Titre du plot
  theme_minimal()  # Style du plot

dbDisconnect(con)