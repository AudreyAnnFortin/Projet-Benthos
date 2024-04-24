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
source("Scripts/tables.R")
source("Scripts/Base de données.R")
source("Scripts/figure_richesse.R")
source("Scripts/figure_abondance_relative.R")
source("Scripts/Bubble_plot_largeur.R")
source("Scripts/Density_plot_profondeur.R")

# Full path to the directory
full_path <- getwd()
print(full_path)

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
    command = Data()  # Use the full path to load data
  ),
  tar_target(
    name = cleaning,
    command = Nettoyage(data)  # Example command, replace with your own logic
  ),
  tar_target(
    name = tables,
    command = tables(cleaning)  # Example command, replace with your own logic
  ),
  tar_target(
    name = bd,
    command = Base_de_donnee()  # Example command, replace with your own logic
  ),
  tar_target(
    name = figure_un,
    command = {
      fig_path <- "figures/figure_un.png"  # Chemin où la figure sera enregistrée
      richesse_plot <- richesse()  # Appel de la fonction richesse() pour générer le graphique
      ggsave(filename = fig_path, plot = richesse_plot)  # Sauvegarder le graphique dans le fichier
    },
  ),
  tar_target(
    name = figure_deux,
    command = {
      fig_path <- "figures/figure_deux.png"  # Chemin où la figure sera enregistrée
      abondance_plot<- abondance()
      ggsave(filename = fig_path, plot = abondance_plot)  # Sauvegarder la figure
    },
  ),
  tar_target(
    name = figure_trois,
    command = {
      fig_path <- "figures/figure_trois.png"  # Chemin où la figure sera enregistrée
      largeur_plot <-largeur()
      ggsave(filename = fig_path, plot= largeur_plot)  # Sauvegarder la figure
    },
  ),
  tar_target(
    name = figure_quatre,
    command = {
      fig_path <- "figures/figure_quatre.png"  # Chemin où la figure sera enregistrée
      profondeur_plot <-profondeur()
      ggsave(filename = fig_path, plot = profondeur_plot)  # Sauvegarder la figure
    },
  ),
  tar_render(
    name = rapport,
    path = "Rapport/RAPPORT.Rmd"  # Example path, replace with your own
  )
)
