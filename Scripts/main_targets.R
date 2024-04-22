#plan :
#mettre les trucs en fonctions
#automatiser avec target
#batir les figures
#faire le rmarkdown

#set the working directory
working_directory <- getwd()

# ===========================================
# _targets.R file
# ===========================================
# Dépendances
library(targets)
tar_option_set(packages = c("MASS", "igraph"))

# Scripts R
source("Scripts/Data.R")
source("Script/Nettoyage.R")
source("Script/tables.R")
source("Script/Base de données.R")

# Pipeline
list(
  # Une target pour le chemin du fichier de donnée permet de suivre les 
  # changements dans le fichier
  tar_target(
    name = path, # Cible
    command = working_directory, # Emplacement du fichier
    format = "file"
  ), 
  # La target suivante a "path" pour dépendance et importe les données. Sans
  # la séparation de ces deux étapes, la dépendance serait brisée et une
  # modification des données n'entrainerait pas l'exécution du pipeline
  tar_target(
    name = data, # Cible pour l'objet de données
    command = fonct.script("Data.R") # Lecture des données
  ),
  tar_target(
    name = cleaning, # Cible pour nettoyer et corriger les données
    command = fonct.script("Nettoyage.R") # Nettoyage des données
  ),
  tar_target(
    name = tables, # Cible pour la formation des tables
    command = fonct.script("tables.R")
  ),
  tar_target(
    name = base_données, # Cible pour la formation d'une base de données
    command = fonct.script("Base de données.R")
  )
)