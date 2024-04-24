abondance <- function()   {
# Connecter à la base de données
con <- dbConnect(SQLite(), dbname = "benthos.db")

# Définir la requête SQL pour sélectionner les 10 espèces les plus abondantes et regrouper les autres sous "Autres"
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

# Exécuter la requête SQL et récupérer les résultats dans un dataframe
data_espece <- dbGetQuery(con, query)

# Convertir la colonne date_obs en format de date
data_espece$date_obs <- as.Date(data_espece$date_obs)

# Créer un vecteur pour définir l'ordre des facteurs de la variable nom_sci
esp_ordre <- c(unique(data_espece$nom_sci[data_espece$nom_sci != "Autres"]), "Autres")

# Convertir la variable nom_sci en facteur avec l'ordre spécifié
data_espece$nom_sci <- factor(data_espece$nom_sci, levels = esp_ordre)

# Créer le graphique
ggplot(data_espece, aes(x = format(date_obs, "%Y"), y = abondance, fill = nom_sci)) +
  geom_bar(stat = "identity") +
  labs(title = "Abondance relative des espèces à chaque année",
       x = "Année d'observation",
       y = "Abondance relative des espèces",
       fill = "Espèce") +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Déconnecter de la base de données
dbDisconnect(con)
}
