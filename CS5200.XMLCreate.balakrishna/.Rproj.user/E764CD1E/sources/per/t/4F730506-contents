# Load the required package
library(XML)
library(xml2)
library(methods)

# Read the XML file with validation
xml_data <- xmlParse(file = "balakrishnaD.CS5200.SuF.Grants.xml", validate = TRUE)

# Check if the XML file was correctly encoded and validates
print("XML content:")
print(xml_data)

# Assuming we want to find the total number of grants for researcher with specific rid
print("Enter Researcher ID [R1, R2, R3]: ")
researcher_id <- readline()
xpath_query <- paste0("//Link[@rid='", researcher_id, "']")

# Find the total number of grants for the specified researcher
grants_nodes <- xpathSApply(xml_data, xpath_query)
grants_count <- length(grants_nodes)
print(paste("Total number of grants for Researcher with rid '", researcher_id, "':", grants_count))
