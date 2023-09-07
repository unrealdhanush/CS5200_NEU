#Hierarchial Database
# This is the global assignment of variables globalVar and root
globalVar <- 0
rootDir <- "docDB"

# Here is the definition of the main function:
main <- function()
{
  # Here is the definition of configDB:
  # 1. There are some configurations like mode and path which are defined by default.
  #    Change in these configurations can result in the function changung its functionalities. 
  # 2. Based on the mode, the function is either on config mode which basically creates a new directory in the name assigned to rootDir
  # 3. If the mode is not in config, then it will return the path which is given as the argument to configDB()
  
  configDB <- function(mode = "config",root,path = "/Users/dhanush/Northeastern/2023summer/CS5200/CS5200.BuildDocDB.balakrishna")
  {
    preConfigPath <- path
    if(mode == "config") {
      temp_path = paste(path,root,sep="/")
      dir.create(temp_path,recursive=F)
    }
    else {
      return(preConfigPath)
    }
  }
  
  # The following function generates the object path taking the root and tag as the input arguments
  genObjPath <- function(root,tag)
  {
   newtag = substring(tag,2)
   ObjPath = paste(root,tag,sep="/")
   return(ObjPath)
  }
  
  # The following function extracts tags from the given file name and stores it in a list. 
  # It also removes the hashtag from the names of the tags for further usage of that data. 
  # Also depending on the argument rettype which is essentially the return type, the function returns the tags as a vector
  # or as a list.
  getTags <- function(fileName,rettype = "vector")
  {
    hash <- "#"
    tag <- list()
    temp <- as.list(strsplit(as.character(fileName),split = " |\\.")[[1]])
    for (i in 1:length(temp)) {
      if(substring(temp[i],1,1)==hash) {
        tags <- append(tag, temp[i])
        tag <- tags
      }
      else {
        next
      }
    }
    tags_vector=unlist(tags)
    if (rettype == "list") {
      return(tags)
    }
    else if (rettype == "vector") {
      return(tags_vector)
    }
  }
  
  # The following function gets the name of the file from the filename that has hashtags along with the file name and the 
  # file extension.
  getFileName <- function(fileName) 
  {
    hash <- "#"
    fname <- list()
    temp <- as.list(strsplit(as.character(fileName),split = " |\\.")[[1]])
    for (i in 1:length(temp)) {
      if(substring(temp[i],1,1)!=hash) {
        fnames <- append(fname, temp[i])
        fname <- fnames
      }
      else {
        next
      }
    }
    Name <- paste(fname[1],fname[2],sep=".")
    return(Name)
  }
  
  # The following function stores copies of the file under the folders with the same names as the tags.
  # The function also takes a binary value as input, which decides whether it prints out a message while 
  # performing the storing operation.
  storeObjs <- function(folder,root,verbose=T) 
  {
    folder = "/Users/dhanush/Northeastern/2023summer/CS5200/CS5200.BuildDocDB.balakrishna/files"
    files <- list.files(path = folder, all.files = F, full.names = F)
    filenames <- as.list(files)
    Tname <- list()
    Fname <-getFileName(fileName=filenames[1])
    if(verbose==T) 
    {
      cat("Copying ",getFileName(fileName=filenames[1])," to ",getTags(fileName=filenames[1]))
    }
    filepath <- paste("/Users/dhanush/Northeastern/2023summer/CS5200/CS5200.BuildDocDB.balakrishna/files", filenames[1], sep = "/")
    Tags <- getTags(fileName=filenames[1], rettype = "list")
    for (k in 1:length(Tags)) {
      temptag = substring(Tags[k],2)
      Tnames <- append(Tname, temptag)
      Tname <- Tnames
    }
    for (j in 1:length(Tnames)) {
      dir_root <- paste(configDB(mode="path",root),genObjPath(root,Tnames[j]),sep="/")
      temp_root <- paste(dir_root,getFileName(fileName = "CampusAtNight.jpg #Northeastern #ISEC"),sep="/")
      dir.create(dir_root, recursive=F)
      file.copy(filepath, temp_root) #Copying operation is performed here.
    }
  }
  
  # The following function clears the database, i.e., the files and folders in the root folder.
  clearDB <- function(root)
  {
    unlink(paste(root,"*",sep="/"),recursive=T)
  }
  
  # All functions that are defined inside the main function are called below
  configDB(root=rootDir)
  # The file name is the only part hard coded into this code.
  print(getTags(fileName="CampusAtNight.jpg #Northeastern #ISEC"))
  print(getFileName(fileName = "CampusAtNight.jpg #Northeastern #ISEC"))
  storeObjs(folder = "/Users/dhanush/Northeastern/2023summer/CS5200/CS5200.BuildDocDB.balakrishna/files", root = rootDir)
  # The following sleep command is used to make the printing of the output a little more appealing and noticeable.
  Sys.sleep(2)
  cat("\nStoring Complete !")
  Sys.sleep(2)
  cat("\nInitiating Database Wipeout...")
  Sys.sleep(2)
  # Here the database is wiped out
  clearDB(root = rootDir)
  Sys.sleep(1)
  cat("\nDatabase Cleared")
}

# The main function is finally called in the end
main()
# The q() function(quit function) depicts the end of the program
q()