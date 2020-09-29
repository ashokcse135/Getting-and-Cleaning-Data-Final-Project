if(!file.exists("./data"))
{
  dir.create("./data")
}

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./data/Dataset.zip"))
{
download.file(fileURL, destfile = "./data/Dataset.zip")
}
unzip("./data/Dataset.zip", exdir = "./data")