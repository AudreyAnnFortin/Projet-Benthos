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

# Full path to the directory
full_path <- "C:/Users/myria/OneDrive - USherbrooke/BIO500/Projet-Benthos"

# Extract the last part of the path
project_name <- basename(full_path)

# Display the extracted project name
print(project_name)

# Pipeline
list(
  tar_target(
    name = path,
    command = setwd(full_path)  # Set working directory to the full path
  ),
  tar_target(
    name = data,
    command = Data(full_path)  # Use the full path to load data
  ),
  tar_target(
    name = cleaning,
    command = Nettoyage(data)  # Example command, replace with your own logic
  ),
  tar_target(
    name = tabl,
    command = tabl(cleaning)  # Example command, replace with your own logic
  ),
  tar_target(
    name = base_de_donnee,
    command = Base_de_donnee()  # Example command, replace with your own logic
  ),
  tar_target(
    name = figure_un,
    command = richesse()  # Example command, replace with your own logic
  ),
  tar_target(
    name = figure_deux,
    command = abondance()  # Example command, replace with your own logic
  ),
  tar_target(
    name = figure_trois,
    command = largeur()  # Example command, replace with your own logic
  ),
  tar_target(
    name = figure_quatre,
    command = profondeur()  # Example command, replace with your own logic
  ),
  tar_render(
    name = rapport,
    path = "Rapport/Rapport.Rmd"  # Example path, replace with your own
  )
)
