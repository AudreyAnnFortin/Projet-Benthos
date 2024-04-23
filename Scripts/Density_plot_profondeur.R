# Charger les bibliothèques nécessaires
library(RSQLite)
library(ggplot2)

# Connecter à la base de données
con <- dbConnect(SQLite(), dbname = "benthos.db")

query <- "
  SELECT sites.profondeur_riviere, observations.nom_sci, observations.abondance
  FROM sites
  INNER JOIN observations ON sites.site = observations.site
"
data <- dbGetQuery(con, query)

# Créer le density plot avec ggplot2
ggplot(data, aes(x = profondeur_riviere, fill = nom_sci)) +
  geom_density(alpha = 0.5) +
  labs(x = "Profondeur de la rivière", y = "Densité", fill = "Nom scientifique") +
  theme_minimal()

dbDisconnect(con)
