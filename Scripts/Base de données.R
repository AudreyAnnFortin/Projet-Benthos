# Set the working directory
setwd("E:/université/BIO500/projet/benthos")
# Charge the RSQLite library
library(RSQLite)
# Connect to the data base
con <- dbConnect(SQLite(),dbname="benthos.db")


#                 supprimer table pour la modifier
#delete_cmnd <- 
#  "DROP TABLE date_observed"
#dbSendQuery(con, delete_cmnd)
#dbListTables(con)


# Creation of the table observation
creer_observation<-
  "CREATE TABLE observations (
      nom_sci   VARCHAR(100) PRIMARY KEY,
      site      VARCHAR(100),
      date_obs  DATE,
      abondance REAL CHECK (abondance >= 0),
      fraction  REAL CHECK (fraction >= 0),
      FOREIGN KEY (site) REFERENCES site(site),
      FOREIGN KEY (date_obs) REFERENCES date_observed(date_obs)
  );"
dbSendQuery(con, creer_observation)
#get the datas to put them in the data base
observations<-read.csv("observations.csv")
dbWriteTable(con,append=TRUE,name="observations",value=observations,row.names=FALSE)

#Creation of the table site
creer_site<-
  "CREATE TABLE sites (
      site                VARCHAR(100),
      largeur_riviere     REAL,
      profondeur_riviere  REAL,
      vitesse_courant     REAL,
      transparence_eau    REAL
      PRIMARY KEY         (site)
);"
dbSendQuery(con, creer_site)
#get the datas to put them in the data base
sites<- read.csv("sites.csv")
dbWriteTable(con,append=TRUE,name="sites",value=sites,row.names=FALSE)

# Creation of the table date_observed
creer_date_observed<-
  "CREATE TABLE date_observed (
      date                VARCHAR(50),
      date_obs            DATE,
      heure_obs           VARCHAR(50),
      temperature_eau_c   REAL,
      PRIMARY KEY         (date_obs)
);"
dbSendQuery(con, creer_date_observed)
#get the datas to put them in the data base
date_observed<- read.csv("date_observed.csv")
dbWriteTable(con,append=TRUE,name='Observations dates',value=date_observed,row.names=FALSE)

# disconnect from the data base
dbDisconnect(con)

# Reconnect to the database
con <- dbConnect(SQLite(), dbname = "benthos.db")

# Query to select the first few rows from each table
query_observations <- "SELECT * FROM observations LIMIT 5;"
query_sites <- "SELECT * FROM sites LIMIT 5;"
query_date_observed <- "SELECT * FROM date_observed LIMIT 5;"

# Execute the queries
observations_result <- dbGetQuery(con, query_observations)
sites_result <- dbGetQuery(con, query_sites)
date_observed_result <- dbGetQuery(con, query_date_observed)

# Print the results
print("Observations:")
print(observations_result)
print("Sites:")
print(sites_result)
print("Date Observed:")
print(date_observed_result)

# Disconnect from the database
dbDisconnect(con)
