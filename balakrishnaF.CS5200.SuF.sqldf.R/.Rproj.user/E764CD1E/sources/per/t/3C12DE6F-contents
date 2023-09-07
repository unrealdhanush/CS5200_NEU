#Reading the 3 given csv files
df1 <- read.csv('https://s3.us-east-2.amazonaws.com/artificium.us/assignments/80.xml/a-80-305/gen-xml/synthsalestxns-Jan2Mar.csv', header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
df2 <- read.csv('https://s3.us-east-2.amazonaws.com/artificium.us/assignments/80.xml/a-80-305/gen-xml/synthsalestxns-Sep2Oct.csv', header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
df3 <- read.csv('https://s3.us-east-2.amazonaws.com/artificium.us/assignments/80.xml/a-80-305/gen-xml/synthsalestxns-Nov2Dec.csv', header = TRUE, sep = ",", quote = "\"", dec = ".", fill = TRUE, comment.char = "")

#writing the read csv files into actual csv files
write.csv(df1, "/Users/dhanush/Northeastern/2023summer/CS5200/balakrishnaF.CS5200.SuF.sqldf.R/data1.csv", row.names = FALSE)
write.csv(df2, "/Users/dhanush/Northeastern/2023summer/CS5200/balakrishnaF.CS5200.SuF.sqldf.R/data2.csv", row.names = FALSE)
write.csv(df3, "/Users/dhanush/Northeastern/2023summer/CS5200/balakrishnaF.CS5200.SuF.sqldf.R/data3.csv", row.names = FALSE)

#installing packages required to merge the datasets into one big dataset
install.packages("dplyr")                          
install.packages("plyr")                            
install.packages("readr") 
install.packages("sqldf")

#calling all libraries.
library("dplyr")                                    
library("plyr")                                  
library("readr")                                   
library("sqldf")

#merging all datasets into one big dataset
data_all <- list.files(path = "/Users/dhanush/Northeastern/2023summer/CS5200/balakrishnaF.CS5200.SuF.sqldf.R", pattern = "*.csv", full.names = TRUE) %>% 
lapply(read_csv) %>%                            
bind_rows 
write.csv(data_all, "/Users/dhanush/Northeastern/2023summer/CS5200/balakrishnaF.CS5200.SuF.sqldf.R/data.csv", row.names = FALSE)

#performing the function of counting number of visits per restaurant and the aggregate revenue. 
visits <- sqldf('SELECT restaurant, COUNT(*) as Visits, SUM(TRIM(amount, "$")) as AggRev FROM data_all GROUP BY restaurant')
View(visits)

