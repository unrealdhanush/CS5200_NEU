# Loading required Libraries
library(DBI)
library(RMySQL)
library(RSQLite)
library(dplyr)
library(tidyverse)

# Establishing MySQL server connection
db_name_fh <- "sql9639719"
db_user_fh <- "sql9639719"
db_host_fh <- "sql9.freemysqlhosting.net"
db_pwd_fh <- "3ULuvSERWS"
db_port_fh <- 3306

mysql_con <-  dbConnect(RMySQL::MySQL(), user = db_user_fh, password = db_pwd_fh, 
                   dbname = db_name_fh, host = db_host_fh, port = db_port_fh)

# Establishing local SQLite Connection 
sqlite_con <- dbConnect(RSQLite::SQLite(), "pharma.sqlite")

# Getting data from local database
salestxn_df <- dbReadTable(sqlite_con, "salestxn")
products_df <- dbReadTable(sqlite_con, "products")
reps_df <- dbReadTable(sqlite_con, "reps")

# Creating fact tables on MySQL Server
dbExecute(mysql_con, "
  CREATE TABLE IF NOT EXISTS product_facts (
    product_name VARCHAR(50), 
    total_sold INT, 
    q1_sold INT,
    q2_sold INT,
    q3_sold INT,
    q4_sold INT,
    y2020_sold INT,
    y2021_sold INT,
    y2022_sold INT,
    territory TEXT); ")

dbExecute(mysql_con, "
  CREATE TABLE IF NOT EXISTS rep_facts (
    rep_name VARCHAR(50), 
    total_sold INT, 
    q1_sold INT,
    q2_sold INT,
    q3_sold INT,
    q4_sold INT,
    y2020_sold INT,
    y2021_sold INT,
    y2022_sold INT,
    product_name TEXT); ")

# Joining data and processing datatypes 
list_df <- list(salestxn_df, products_df)
data_df <- list_df %>% reduce(inner_join, by = 'prodID')
data_df$repID <- as.numeric(data_df$repID)
list_df <- list(data_df, reps_df)
data_df <- list_df %>% reduce(inner_join, by = 'repID')
data_df$qty <- as.numeric(data_df$qty)
data_df$date <- as.Date(data_df$date, '%m/%d/%Y')

# Aggregate to product_facts structure
product_facts <- aggregate(qty~prod+territory, data = data_df, sum) 

# Adding quarterly aggregations
product_facts <- transform(product_facts,
                           q1_sold = ifelse(quarter(data_df$date) == 1, data_df$qty, 0),
                           q2_sold = ifelse(quarter(data_df$date) == 2, data_df$qty, 0), 
                           q3_sold = ifelse(quarter(data_df$date) == 3, data_df$qty, 0),
                           q4_sold = ifelse(quarter(data_df$date) == 4, data_df$qty, 0))

# Adding yearly aggregates
product_facts <- transform(product_facts, 
                           y2020_sold = ifelse(year(data_df$date) == 2020, data_df$qty, 0),
                           y2021_sold = ifelse(year(data_df$date) == 2021, data_df$qty, 0),
                           y2022_sold = ifelse(year(data_df$date) == 2022, data_df$qty, 0))

# Aggregating rep_facts with a different approach
rep_facts <- reps_df %>% 
    full_join(data_df) %>%
  group_by(firstName, lastName) %>% 
  summarise(
    total_sold = sum(qty, na.rm = T),
    q1_sold = sum(qty[quarter(date) == 1], na.rm = T),
    q2_sold = sum(qty[quarter(date) == 2], na.rm = T),
    q3_sold = sum(qty[quarter(date) == 3], na.rm = T),
    q4_sold = sum(qty[quarter(date) == 4], na.rm = T),
    y2020_sold = sum(qty[year(date) == 2020], na.rm = T),
    y2021_sold = sum(qty[year(date) == 2021], na.rm = T),
    y2022_sold = sum(qty[year(date) == 2022], na.rm = T)
  )

# Writing Tables to the MySQL server.
dbWriteTable(mysql_con, "product_facts", product_facts, overwrite = T, append = F)
dbWriteTable(mysql_con, "rep_facts", rep_facts, overwrite = T, append = F)

# Below commented code was used in testing and debugging 
# dbExecute(mysql_con, "DROP TABLE product_facts, rep_facts;")

# Disconnecting Connections
dbDisconnect(mysql_con)
dbDisconnect(sqlite_con)
