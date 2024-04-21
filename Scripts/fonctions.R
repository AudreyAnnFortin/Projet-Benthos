

#fonction appelant nos scriptes

fonct.script= function(script){
  source(script)}

fonct.script("Data.R")
fonct.script("Nettoyage.R")
fonct.script("tables.R")

