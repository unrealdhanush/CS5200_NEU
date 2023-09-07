# Connect to SQLite
library(RSQLite)
library(XML)
con <- dbConnect(RSQLite::SQLite(), "pharma.sqlite")

# Create tables
dbExecute(con, "
  CREATE TABLE products (
    prodID INTEGER PRIMARY KEY, 
    prod TEXT
  );")

dbExecute(con, "  
  CREATE TABLE reps (
    repID INTEGER PRIMARY KEY,
    firstName TEXT,
    lastName TEXT,
    territory TEXT
  );")

dbExecute(con, "  
  CREATE TABLE customers (
    custID INTEGER PRIMARY KEY,
    cust TEXT,
    country TEXT
  );")
  
dbExecute(con, "
  CREATE TABLE salestxn (
    txnID INTEGER PRIMARY KEY,
    date TEXT, 
    prodID INTEGER,
    custID INTEGER,
    repID INTEGER,
    qty INTEGER,
    amount INTEGER,
    FOREIGN KEY(prodID) REFERENCES products(prodID),
    FOREIGN KEY(custID) REFERENCES customers(custID),
    FOREIGN KEY(repID) REFERENCES reps(repID)
  );
")

# Get list of XML files
files <- dir("txn-xml", pattern = "pharmaSalesTxn.*\\.xml", full.names = TRUE)

# Load rep data
doc <- xmlParse("txn-xml/pharmaReps.xml")

# Create dataframe rep from the XML
rep <- data.frame(
  firstName = xpathSApply(doc, "//rep/firstName/text()", xmlValue),
  lastName = xpathSApply(doc, "//rep/lastName/text()", xmlValue),
  territory = xpathSApply(doc, "//rep/territory/text()", xmlValue),
  rID = xpathSApply(doc, "//rep", xmlGetAttr, "rID")
)

rep$rID <- gsub("r","", as.character(rep$rID))

reps <- data.frame(repID = rep$rID, 
                   firstName = rep$firstName,
                   lastName = rep$lastName,
                   territory = rep$territory)

dbWriteTable(con, "reps", reps, overwrite = F, append = T)

# Load each file
for(file in files) {
  
  # Parse XML
  doc <- xmlParse(file) 
  
  # Extract data
  txns <- xmlToDataFrame(nodes = getNodeSet(doc, "//txn"))
  
  n.txns <- nrow(txns)
  # Process dates
  
  txns$act_date <- as.Date(txns$date, "%m/%d/%Y") 
  
  # Extract Product data
  products <- data.frame(prod = unique(txns$prod))
  
  # Process ID
  products$prodID <- 100 + seq(1,nrow(products))
  
  # Extract customer data
  customers <- data.frame(cust = unique(txns$cust))
  
  # Process ID
  customers$custID <- 100 + seq(1,nrow(customers))
  
  # using a temporary dataframe for ease
  txns <- merge(txns, products, by.x = "prod", by.y = "prod", all.x = TRUE)
  
  txns <- merge(txns, customers, by.x = "cust", by.y = "cust", all.x = TRUE)
  
  # defining and populating the salestxn dataframe
  salestxn <- data.frame(txnID = txns$txnID, 
                         date = txns$date,
                         prodID = txns$prodID,
                         custID = txns$custID,
                         repID = txns$repID,
                         qty = txns$qty,
                         amount = txns$amount) 
  
  
  # Add to database
  dbWriteTable(con, "products", products, overwrite = T,append = F)
  dbWriteTable(con, "customers", customers, overwrite = T,append = F)
  dbWriteTable(con, "salestxn", salestxn, overwrite = T,append = F) 
}

# Disconnecting Connection
dbDisconnect(con)

