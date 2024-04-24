# ===========================================
# _targets.R file
# ===========================================
# Dépendances
library(dplyr)
library(RSQLite)
library(ggplot2)
library(targets)
library(tarchetypes) #Pour rendre le rapport (tar_render)
tar_option_set(packages = c("rmarkdown", "knitr")) #Besoin de ces librairies afin d'obtenir le rapport final

# Scripts R/fonctions nécessaires pour le target
source("Scripts/Data.R")
source("Scripts/Nettoyage.R")
source("Scripts/table.R")
source("Scripts/Base de données.R")
source("Scripts/figure_richesse.R")
source("Scripts/figure_abondance_relative.R")
source("Scripts/Bubble_plot_largeur.R")
source("Scripts/Density_plot_profondeur.R")

# Pipeline
list(
  # Une target pour le chemin du fichier de donnée permet de suivre les 
  # changements dans le fichier
  tar_target(
    name = path, # Cible
    command = setwd("./Données"), # Emplacement du fichier
  ), 
  # La target suivante a "path" pour dépendance et importe les donnees. Sans
  # la séparation de ces deux étapes, la dépendance serait brisée et une
  # modification des données n'entrainerait pas l'exécution du pipeline
  tar_target(
    name = data, # Cible pour l'objet de données
    command = Data(path) # Lecture des données
  ),
  tar_target(
    name = cleaning, # Cible pour nettoyer et corriger les donnees
    command = Nettoyage(data) # Nettoyage des données
  ),
  tar_target(
    name = table, # Cible pour la formation des tables
    command = table(cleaning) #Création des tables
  ),
  tar_target(
    name = base_de_donnee, # Cible pour la formation d'une base de donnees
    command = Base_de_donnee() #Formation de la base de donnees 
  ),
  tar_target(
    name = figure_un , # Cible pour la création d'une première figure
    command = richesse() #Création de la figure
  ),
  tar_target(
    name = figure_deux , # Cible pour la création d'une deuxième figure
    command = abondance() #Création de la figure
  ),
  tar_target(
    name = figure_trois , # Cible pour la création d'une troisième figure
    command = largeur() #Création de la figure
  ),
  tar_target(
    name = figure_quatre , # Cible pour la création d'une troisième figure
    command = profondeur() #Création de la figure
  ),
  tar_render( #Création du rapport
    name = rapport , #Cible pour la création du rapport, le nom qui sera donné au document
    path = "Rapport/rapport.Rmd" #Chemin vers le rapport
  )
)
