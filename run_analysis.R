# Download and store data into local system
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

print("Data successfully downloaded and stored in the local system.")
# Task-1 Merging the training and the test sets to create one data set
print("Task-1 Merging the training and the test sets to create one data set.")
# Loading "train" and "test" datasets into R.
print("Loading train data...")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
s_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

print("Train data loaded successfully")

print("Loading test data...")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
s_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

print("Test data loaded successfully.")

# Merging both tain and test data using rbind.
print("Merging both tain and test data using rbind...")

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)

print("Merging completed successfully.")

# Creating a single dataset.
print("Creating a single dataset...")
if(!file.exists("./data/UCI HAR Dataset/total"))
{
  dir.create("./data/UCI HAR Dataset/total")
}
write.table(x_data, file = "./data/UCI HAR Dataset/total/x_data.csv")
write.table(y_data, file = "./data/UCI HAR Dataset/total/y_data.csv")
write.table(s_data, file = "./data/UCI HAR Dataset/total/s_data.csv")
  
print("Single dataset is created successfully.")

print("Task-1 completed successfully.")

# Task-2 Extracting only the measurements on the mean and standard deviation for each measurement. 
print("Task-2 Extracting only the measurements on the mean and standard deviation for each measurement.")

# Loading features and activity_labels files.

print("Loading features and activity_labels files...")

features <- read.table("./data/UCI HAR Dataset/features.txt")
act_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

print("Features and activity_labels files loaded successfully.")
# Extracting the measurements on the mean and standard deviation for each measurement.
print("Extracting the measurements on the mean and standard deviation for each measurement...")

selected_measurements_indices <- grep("-(mean|std).*", features[,2])
selected_measurements_names <- features[selected_measurements_indices, 2]

print("The measurements on the mean and standard deviation for each measurement has extracted successfully.")
print("Task-2 com[pleted successfully.")

# Task-3 Using descriptive activity names to name the activities in the data set.
print("Task-3 Using descriptive activity names to name the activities in the data set.")
selected_measurements_names <- gsub("-mean", "Mean", selected_measurements_names)
selected_measurements_names<- gsub("-std", "standard deviation", selected_measurements_names)
selected_measurements_names <- gsub("[-()]", "", selected_measurements_names)

x_data <- x_data[selected_measurements_indices]
total_data <- cbind(x_data, y_data, s_data)
colnames(total_data) <- c(selected_measurements_names, "Activity", "Subject" )
print("Task-3 has successfully completed.")

# Task-4 Appropriately labeling the data set with descriptive variable names. 
print("Task-4 Appropriately labeling the data set with descriptive variable names.")

total_data$Subject <- as.factor(total_data$Subject)
levels <- act_labels[,1]
labels <- act_labels[,2]
total_data$Activity <- factor(total_data$Activity, levels = levels, labels = labels)

print("Task-4 has successfully completed.")
# Loading required packages.
library(reshape2)
# Task-5 From the data set in step 4, creating a second, independent tidy data set with the average of each variable for each activity and each subject.
print("Task-5 From the data set in step 4, creating a second, independent tidy data set with the average of each variable for each activity and each subject.")
melted_data <- melt(total_data, id.vars = c("Subject", "Activity"))
tidy_data <- dcast(melted_data, Subject + Activity ~ variable, mean)

write.table(tidy_data, "./data/tidy_data.csv", row.names = FALSE, quote = FALSE , sep = ",")
print("Task-5 has successfully completed.")
