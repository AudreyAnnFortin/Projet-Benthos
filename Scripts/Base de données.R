Base_de_donnee <- function(){
  # Connect to the data base
  con <- dbConnect(SQLite(),dbname="benthos.db")
  
  
  # supprimer table pour la modifier
delete_cmnd <- 
  "DROP TABLE observations"
  dbSendQuery(con, delete_cmnd)
  dbListTables(con)

  
  # Creation of the table observation
  creer_observation<-
    "CREATE TABLE observations (
      nom_sci   VARCHAR(100),
      site      VARCHAR(100),
      date_obs  DATE,
      abondance REAL CHECK (abondance >= 0),
      fraction  REAL CHECK (fraction >= 0),
      PRIMARY KEY (nom_sci, site, date_obs),
      FOREIGN KEY (site) REFERENCES site(site),
      FOREIGN KEY (date_obs) REFERENCES date_observed(date_obs)
  );"
  dbSendQuery(con, creer_observation)
  #get the datas to put them in the data base
  observations<-read.csv("observations.csv")
  dbWriteTable(con,append=TRUE,name="observations",value=observations,row.names=FALSE)
  
  # supprimer table pour la modifier
  delete_cmnd <- 
    "DROP TABLE sites"
  dbSendQuery(con, delete_cmnd)
  dbListTables(con)
  
  # Create the sites table
  creer_site <- "CREATE TABLE sites (
                site                VARCHAR(100),
                largeur_riviere     REAL,
                profondeur_riviere  REAL,
                vitesse_courant     REAL,
                transparence_eau    REAL,
                PRIMARY KEY         (site)
              );"
  dbSendQuery(con, creer_site)
  
  # Read the CSV file for sites
  sites <- read.csv("sites.csv")
  
  # Handle duplicate site values
  duplicated_sites <- duplicated(sites$site)
  sites <- sites[!duplicated_sites, ]
  
  # Write the data to the sites table
  dbWriteTable(con, append = TRUE, name = "sites", value = sites, row.names = FALSE)

  # supprimer table pour la modifier
  delete_cmnd <- 
    "DROP TABLE date_observed"
  dbSendQuery(con, delete_cmnd)
  dbListTables(con)
    
  # Create the date_observed table
  creer_date_observed <- "CREATE TABLE date_observed (
                           date                VARCHAR(50),
                           date_obs            DATE,
                           heure_obs           VARCHAR(50),
                           temperature_eau_c   REAL,
                           PRIMARY KEY         (date_obs)
                         );"
  dbSendQuery(con, creer_date_observed)
  
  # Read the CSV file for date_observed
  date_observed <- read.csv("date_observed.csv")
  
  # Remove all but one occurrence of each duplicated date
  unique_date_observed <- date_observed[!duplicated(date_observed$date_obs), ]
  
  # Write the data to the date_observed table
  dbWriteTable(con, append = TRUE, name = "date_observed", value = unique_date_observed, row.names = FALSE)
  
  # disconnect from the data base
  dbDisconnect(con)
  
  
  # Reconnect to the database
  con <- dbConnect(SQLite(), dbname = "benthos.db")
  
  
  query_observations <- "SELECT COUNT(*) FROM observations;"
  query_sites <- "SELECT COUNT(*) FROM sites;"
  query_date_observed <- "SELECT COUNT(*) FROM date_observed;"
  
  
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
  
}
  
  
