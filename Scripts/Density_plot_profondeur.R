profondeur <- function() {
  # Connecter à la base de données
  con <- dbConnect(SQLite(), dbname = "benthos.db")
  
  query <- "
    WITH Top10 AS (
      SELECT sites.profondeur_riviere, observations.nom_sci, sum(observations.abondance) as abondance
      FROM sites
      INNER JOIN observations ON sites.site = observations.site
      WHERE  sites.profondeur_riviere IS NOT NULL
      GROUP BY 
        observations.nom_sci
      ORDER BY 
        abondance DESC, observations.nom_sci DESC
      LIMIT 15
    )
    SELECT sites.profondeur_riviere, observations.nom_sci, observations.abondance
    FROM sites
    INNER JOIN observations ON sites.site = observations.site
    WHERE  observations.nom_sci in (SELECT nom_sci FROM Top10)
    GROUP BY observations.nom_sci, sites.profondeur_riviere
  "
  data <- dbGetQuery(con, query)
  
  # Créer le density plot avec ggplot2
  profondeur_plot <- ggplot(data, aes(x = profondeur_riviere, y = nom_sci, size = abondance)) +
    geom_point(alpha = 0.7) +
    scale_size_continuous(range = c(3, 10)) +
    labs(x = "Profondeur de la rivière", y = "Densité") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
  
  dbDisconnect(con)
  
  return(profondeur_plot)  # Retourner le graphique créé
}
