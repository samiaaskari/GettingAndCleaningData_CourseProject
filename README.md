#Getting and Cleaning Data, Course Project
=========================================

###Project Objective:
---------------------

 1. Merge the training and the test sets to create one data set.
 2. Extract only the measurements on the mean and standard deviation for each measurement. 
 3. Use descriptive activity names to name the activities in the data set
 4. Appropriately label the data set with descriptive activity names. 
 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

###Steps to Follow:
-------------------

 1. Download data from site: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
 2. Downloaded file has folder "UCI HAR Dataset"
 3. Create an R-Script in R-Studio and name it "run_analysis.R"
 4. Copy the entire script "run_analysis.R" from my repository and paste it in your newly created script, save the script
 5. Script "run_analysis.R" is a function that takes location of folder "UCI HAR Dataset" on your computer as an input parameter and create working directory
 6. Find the path to folder "UCI HAR Dataset" on your computer
 7. Run function "run_analysis.R" by passing this path as input parameter to function
 8. This function will create file TidyData.txt in the same "UCI HAR Dataset" folder
 9. This is the required output file as described in project objective
 10. To view the file run script: #### checkData <- read.table("TidyData.txt", header = TRUE); View(checkData)
 11. Codebook.md has step-by-step explnation on code and work performed to achieve all project objectives
