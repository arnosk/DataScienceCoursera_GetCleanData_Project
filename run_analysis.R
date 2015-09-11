## Project from Coursera DataScience - Getting and cleaning data
## Arno Kemner
## 10-9-2015

# This R script gets and performs some cleaning on human activity data, built
# from recordings of subjects performing daily activities while carrying
# smartphone. The full description of the data set is available at:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Goals for fulfilling the coursera project:
# this scripts must do the following on the data
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names. 
# 5) From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

library(plyr)


# Step 0
# first check if data exist or else download the data
# dataset is stored in folder data
# and is named UCI_HAR_data.zip
downloaddata = function() {
    if (!file.exists("data")) {
        message("Creating data directory")
        dir.create("data")
    }
    if (!file.exists("data/UCI HAR Dataset")) {
        # download the data
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        zipfile="data/UCI_HAR_data.zip"
        message("Downloading data")
        download.file(fileURL, destfile=zipfile, method="curl")
        unzip(zipfile, exdir="data")
    }
}

# Step 1
# Merges the training and the test sets to create one data set
mergedata = function() {
    # Read data
    training.x <- read.table("data/UCI HAR Dataset/train/X_train.txt")
    training.y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
    training.subject <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
    test.x <- read.table("data/UCI HAR Dataset/test/X_test.txt")
    test.y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
    test.subject <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
    # Merge
    merged.x <- rbind(training.x, test.x)
    merged.y <- rbind(training.y, test.y)
    merged.subject <- rbind(training.subject, test.subject)
    # merge train and test datasets and return
    list(x=merged.x, y=merged.y, subject=merged.subject)
}

# Step 2
# Extracts only the measurements on the mean and standard deviation for each measurement
extractmeanstd = function(df) {
    # Given the dataset (x values), extract only the measurements on the mean
    # and standard deviation for each measurement.
    
    # Read the feature list file
    features <- read.table("data/UCI HAR Dataset/features.txt")
    # Find the mean and std columns
    mean.col <- sapply(features[,2], function(x) grepl("mean()", x, fixed=T))
    std.col <- sapply(features[,2], function(x) grepl("std()", x, fixed=T))
    # Extract them from the data
    edf <- df[, (mean.col | std.col)]
    colnames(edf) <- features[(mean.col | std.col), 2]
    edf
}

# Step 3
# Uses descriptive activity names to name the activities in the data set
renameactivities = function(df) {
    colnames(df) <- "activity"
    df$activity[df$activity == 1] = "Walking"
    df$activity[df$activity == 2] = "Walking_upstairs"
    df$activity[df$activity == 3] = "Walking_downstairs"
    df$activity[df$activity == 4] = "Sitting"
    df$activity[df$activity == 5] = "Standing"
    df$activity[df$activity == 6] = "Laying"
    df
}

# Main program
# Run this script to analyse the data
run_analysis = function() {
    # Download data
    downloaddata()
    
    # Step 1
    # merge training and test datasets. merge.datasets function returns a list
    # of three dataframes: X, y, and subject
    merged <- mergedata()
    
    # Step 2
    # Extract only the measurements of the mean and standard deviation for each
    # measurement
    cx <- extractmeanstd(merged$x)
    
    # Step 3
    # Name activities
    cy <- renameactivities(merged$y)
    
    # Step 4
    # Use descriptive column name for subjects
    colnames(merged$subject) <- c("subject")
    
    # Step 5
    # From the data set in step 4, creates a second, independent tidy data set 
    # with the average of each variable for each activity and each subject.
    # Combine mean-std values (x), activities (y) and subjects into one data frame.
    combined <- cbind(cx, cy, merged$subject)
    # Create tidy dataset
    tidy <- ddply(combined, .(subject, activity), function(x) colMeans(x[,1:60]))
    # Write tidy dataset as csv
    write.csv(tidy, "UCI_HAR_tidy.csv", row.names=FALSE)
    write.table(tidy, "UCI_HAR_tidy.txt", row.names=FALSE)
}
