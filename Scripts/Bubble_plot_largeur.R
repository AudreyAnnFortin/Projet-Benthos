largeur <- function() {
  # Connecter à la base de données
  con <- dbConnect(SQLite(), dbname = "benthos.db")
  
  # Charger les données d'abondance par espèce depuis la base de données
  query_abondance <- "SELECT site, nom_sci, abondance FROM observations"
  data_abondance <- dbGetQuery(con, query_abondance)
  
  # Charger les données de largeur de la rivière depuis la base de données
  query_largeur <- "SELECT site, largeur_riviere FROM sites"
  data_largeur <- dbGetQuery(con, query_largeur)
  
  # Fusionner les données d'abondance avec les données de largeur
  data_merged <- merge(data_abondance, data_largeur, by = "site")
  
  # Créer le bubble plot avec ggplot2
  plot <- ggplot(data_merged, aes(x = largeur_riviere, y = abondance, size = abondance)) +
    geom_point(alpha = 0.6) +  # Points avec transparence
    scale_size_continuous(range = c(3, 10)) +  # Définir la plage de tailles des bulles
    labs(x = "Largeur de la rivière", y = "Abondance") +  # Titres des axes
    ggtitle("Bubble plot de l'abondance en fonction de la largeur de la rivière") +  # Titre du plot
    theme_minimal()  # Style du plot
  
  # Déconnecter de la base de données
  dbDisconnect(con)
  
  return(plot)
}
