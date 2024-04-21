#plan :
#mettre les trucs en fonctions
#automatiser avec target
#batir les figures
#faire le rmarkdown

#set the working directory
setwd("E:/université/BIO500/projet/benthos")

# ===========================================
# _targets.R file
# ===========================================
# Dépendances
library(targets)
tar_option_set(packages = c("MASS", "igraph"))

# Scripts R
source("fonctions.R")
source("Base de données.R")
source("Nettoyage.R")
source("tables.R")

# Pipeline
list(
  # Une target pour le chemin du fichier de donnée permet de suivre les 
  # changements dans le fichier
  tar_target(
    name = path, # Cible
    command = "data/data.txt", # Emplacement du fichier
    format = "file"
  ), 
  # La target suivante a "path" pour dépendance et importe les données. Sans
  # la séparation de ces deux étapes, la dépendance serait brisée et une
  # modification des données n'entrainerait pas l'exécution du pipeline
  tar_target(
    name = data, # Cible pour l'objet de données
    command = read.table(path) # Lecture des données
  ),   
  tar_target(
    resultat_modele, # Cible pour le modèle 
    mon_modele(data) # Exécution de l'analyse
  ),
  tar_target(
    figure, # Cible pour l'exécution de la figure
    ma_figure(data, resultat_modele) # Réalisation de la figure
  )
)