# Set the working directory
setwd("E:/université/BIO500/projet/benthos")
# Charge the RSQLite library
library(RSQLite)
#Charge the datas and the tables from other scripts
source("Nettoyage.R")
source("tables.R")
# Connect to the data base
con <- dbConnect(SQLite(),dbname="benthos.db")

# Creation of the table observation
creer_observation<-
  "CREATE TABLE observations (
      nom_sci   VARCHAR(100) PRIMARY KEY
      site      VARCHAR(100)
      date_obs  DATE
      abondance REAL CHECK (abondance >= 0)
      fraction  REAL CHECK (fraction >= 0)
      FOREIGN KEY (site) REFERENCES site(site),
      FOREIGN KEY (date_obs) REFERENCES date_observed(date_obs)
  );"
dbSendQuery(con, creer_observation)
dbWriteTable(con,append=TRUE,name="observations",value=observations,row.names=FALSE)

#Creation of the table site
creer_site<-
  "CREATE TABLE sites (
      site                VARCHAR(100) PRIMARY KEY
      largeur_riviere     REAL
      profondeur_riviere  REAL
      vitesse_courant     REAL
      transparence_eau    REAL
);"
dbSendQuery(con, creer_site)
sites<- read.csv("site.csv")
dbWriteTable(con,append=TRUE,name="sites",value=sites,row.names=FALSE)

# Creation of the table date_observed
creer_date_observed<-
  "CREATE TABLE date_observed (
      date                VARCHAR(50)
      heure_obs           VARCHAR(50)
      temperature_eau_c   REAL
);"
dbSendQuery(con, creer_date_observed)
date_observed<- read.csv("date_observed.csv")
dbWriteTable(con,append=TRUE,name='Observations dates',value=date_observed,row.names=FALSE)

# disconnect from the data base
dbDisconnect(con)
