# DO: Implement Transactions
# Group 11
# Zialynn Anderson, Sreekar Anne, Dhanush Balakrishna, Francisco Rovirosa

## Prerequisite
library(RMySQL)

## Connect to Zialynn Anderson's cloud MySQL database from Practicum 1. 
db_name <- "sql9625980"
db_user <- "sql9625980"
db_host <- "sql9.freemysqlhosting.net"
db_pwd <- "tpanHG5KeV"
db_port <- 3306

dbConn <- dbConnect(MySQL(),
                    user = db_user,
                    password = db_pwd,
                    dbname = db_name,
                    host = db_host,
                    port = db_port)

# Read CSV into dataframe
strikes <- read.csv(paste(getwd(), "BalakrishnaD.TrxnStrikes.csv", sep="/"))

# Turn off autocommit
dbExecute(dbConn, "SET autocommit=0;")

# BEGIN TRANSACTION
dbBegin(dbConn)

# For each row
for (i in 1:nrow(strikes)) {
  # Extract necessary fields
  fid <- strikes$rid[i]
  date <- as.Date(gsub(" 0:00", "", strikes$flight_date[i]), format="%m/%d/%Y")
  airportName <- strikes$airport[i]
  airportState <- strikes$origin[i]
  airline <- strikes$airline[i]
  aircraft <- strikes$model[i]
  altitude <- if (strikes$altitude_ft[i] == "") 0 else gsub(",", "", strikes$altitude[i])
  heavy <- if (strikes$heavy[i] == 'Yes') TRUE else FALSE
  numBirds <- strikes$wildlife_struck[i]
  impact <- strikes$impact
  damage <- if (strikes$damage[i] == 'Caused damage') TRUE else FALSE
  conditions <- paste('(SELECT cid FROM conditions WHERE sky_condition="',
                      strikes$conditions[i], '")', sep="")
  
  # Use procedure as it handles foreign key references
  sqlCode <- paste("CALL addNewStrike (",
                   fid, ", ",
                   "'", date, "'", ", ",
                   "'", airportName, "'", ", ",
                   "'", airportState, "'", ", ",
                   "'", airline, "'", ", ",
                   "'", aircraft, "'", ", ",
                   altitude, ", ",
                   heavy, ", ",
                   numBirds, ", ",
                   "'", impact, "'", ", ",
                   damage, ", ",
                   conditions,
                   ")", sep="")
  
  dbExecute(dbConn, sqlCode)
}

dbCommit(dbConn)

# Turn on autocommit
dbExecute(dbConn, "SET autocommit=1;")

# Select a strike from our CSVs to show they were successfully added.
sqlCode <- "SELECT * FROM strikes WHERE fid=190382"
r1 <- dbGetQuery(dbConn, sqlCode)
print(r1)

dbDisconnect(dbConn)