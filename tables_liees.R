#hello ! cecu est un essaie pour créer la table

#blabla


library(RSQLite)
reseau <- dbConnect(RSQLite::SQLite(), dbname="/Users/sylvie/Desktop/BIO500/projet/my_database.db")

#création de base de donnée à partir de la table "observations"


observationsTB <- 'CREATE TABLE observations(
    nom_sci     VARCHAR(40),
    site        VARCHAR(60),
    date_obs    DATE,
    abondance   INTEGER,
    fraction    INTEGER,            
    PRIMARY KEY (nom_sci),
    FOREIGN KEY (site) REFERENCES site(site),
    FOREIGN KEY (date_obs) REFERENCES date_observed(date_obs)
)'

#"/Users/sylvie/Desktop/BIO500/projet/my_database.db"
dbSendQuery(reseau, observationsTB)

dbWriteTable(reseau, append=TRUE, name="observarionsTB", value= tables.R, now.names=FALSE)

