# Script: run_analysis.R
# Author: Juan C. Garcia
# Date: 01-Feb-2022
# Purpose: Script retrieves, manipulates and cleans data for analysis.


# Verify directory, download file to analyze, and unzip.

    if(!file.exists("data")){dir.create("data")}
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl,destfile="./data/tracking.zip",method="curl")
    
    if(!file.exists("UCI HAR Dataset"))
        {unzip(zipfile = "./data/tracking.zip",exdir = "./data")}

# Assign path to data folder - UCI HAR Dataset
    path_rf <- file.path("./data", "UCI HAR Dataset")
    
    
# Read features and activities tables
    activity <- read.table(file.path(path_rf,"activity_labels.txt"),
                           header = FALSE)
    features <- read.table(file.path(path_rf,"features.txt"),
                           col.names = c("n","functions"))
    
# Read training tables and assign functions as column name   
    x_train <- read.table(file.path(path_rf,"train","X_train.txt"), 
            col.names = features$functions)
    
    y_train <- read.table(file.path(path_rf,"train","y_train.txt"), 
            col.names = "code")

    subject_train <- read.table(file.path(path_rf,"train","subject_train.txt"),
            col.names = "subject")
    
# Read test tables and assign functions as column name
    x_test <- read.table(file.path(path_rf,"test","X_test.txt"), 
            col.names = features$functions)
    
    y_test <- read.table(file.path(path_rf,"test","y_test.txt"), 
            col.names = "code")
    
    subject_test <- read.table(file.path(path_rf,"test","subject_test.txt"),
            col.names = "subject")

# Task #1: Merge the training and test sets
    
    train_data <- cbind(subject_train,y_train,x_train)
    test_data <- cbind(subject_test,y_test,x_test)
    merged_data <- rbind(train_data,test_data)
    
# Task #2: Extract measurements on the mean and standard deviation 
# for each measurement.
    
    subset_measures <- grep("mean\\(\\)|std\\(\\)",features$functions)
    
# Task #3: Uses descriptive activity names to name the activities in the data set.
    
    merged_data$code <- activity$V2[dataset$V1.1]

    
# Task #4: Name activities with descriptive activity names and label dataset.
    
   colnames(merged_data) <- gsub("^t","Time",colnames(merged_data))
   colnames(merged_data) <- gsub("^f","Frequency",colnames(merged_data))
   colnames(merged_data) <- gsub("Acc","Accelerometer",colnames(merged_data))
   colnames(merged_data) <- gsub("Gyro","Gyroscope",colnames(merged_data))
   colnames(merged_data) <- gsub("Mag","Magnitude",colnames(merged_data))
   
# Task #5: Create data set with average of each variable, activity and subject
   
   tidy_data <- aggregate(.~subject, merged_data, mean)
   
# Output Tidy data
   write.table(tidy_data,"Garcia_Tidy_Data.txt")
   