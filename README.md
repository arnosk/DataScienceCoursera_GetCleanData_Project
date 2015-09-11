## Project from Coursera Data Science capstone - Getting and cleaning data

This is a Coursera project for [Getting and Cleaning Data](https://www.coursera.org/course/getdata). The goal was to read the [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) data set, reorganise the data to make further analysis easyer.

# Steps to be done
1) Make a tidy data set, 
2) Provide a link to a Github repository with your script for performing the analysis 
3) A `CodeBook.md` that describes the variables, the data, and any transformations or work that you performed to clean up the data.
4) A `README.md` in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

5) `run_analysis.R` : 
	- Merges the training and the test sets to create one data set.
	- Extracts only the measurements on the mean and standard deviation for each measurement. 
	- Uses descriptive activity names to name the activities in the data set
	- Appropriately labels the data set with descriptive variable names. 
	- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


The `run_analysis.R` script has several functions to do the job.
When loaded in R, run analyse() to start the script

This will first download and unzips the dataset from internet, if not already done this. Must be present in a data folder
Then it will perform the steps by point 5.
Finally the scripts creates a new dataset and writes this to disk

