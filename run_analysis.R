#####################################

#Getting and Cleaning Data Course Project
#Date Created: 9-17-2014
#Created by: Samia Askari

# Project Objective:
## 1. Merge the training and the test sets to create one data set.
## 2. Extract only the measurements on the mean and standard deviation for each measurement. 
## 3. Use descriptive activity names to name the activities in the data set
## 4. Appropriately label the data set with descriptive activity names. 
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

#run_analysis.R: This script performs steps to achieve objectives above

# Prerequisites to run the script:
## 1. Download data from site: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## 2. Downloaded file has folder "UCI HAR Dataset"
## 3. Find the path to folder "UCI HAR Dataset" on your computer
## 4. Run function "run_analysis.R" by passing this path as input parameter to function

#####################################
  
run_analysis <- function(workingDirectory){

## Set working directory
  setwd(workingDirectory)
  
## Pre-work to create one data set

  # Clean up space
    rm(list=ls())
    
  # Reading train datasets
    x_train <- read.table('./train/X_train.txt',header=FALSE) #read x_train.txt
    y_train <- read.table('./train/y_train.txt',header=FALSE) #read y_train.txt
    subject_train <- read.table('./train/subject_train.txt',header=FALSE) #read subject_train.txt
    features <- read.table('./features.txt',header=FALSE) #read features.txt
    activityType <- read.table('./activity_labels.txt',header=FALSE) #read activity_labels.txt
    
  # Assigining column names to train data imported above
    colnames(x_train) <- features[,2] 
    colnames(y_train) <- "activityId"
    colnames(activityType) <- c('activityId','activityType')
    colnames(subject_train) <- "subjectId"
    
  # Merging x_train, y_train and subject_train to create final Train_Data    
    Train_Data <- cbind(y_train,subject_train,x_train)

  # Reading test datasets
    subject_test <- read.table('./test/subject_test.txt',header=FALSE) #read subject_test.txt
    x_test <- read.table('./test/X_test.txt',header=FALSE) #read X_test.txt
    y_test <- read.table('./test/y_test.txt',header=FALSE) #read y_test.txt

  # Assign column names to the test data imported above
    colnames(subject_test) <- "subjectId"
    colnames(x_test) <- features[,2] 
    colnames(y_test) <- "activityId"

  # Merging x_test, y_test and subject_test to create final Test_Data
    Test_Data <- cbind(y_test,subject_test,x_test)

#############
## 1: Merges the training and the test sets to create one data set.
############    
  
  # Merging Train_Data and Test_Data    
    Final_Data <- rbind(Train_Data, Test_Data)


#############
## 2: Extract only the measurements on the mean and standard deviation for each measurement. 
############
    
  # Creating a vector for the column names from the Final_Data to compute mean() & stddev() 
    colNames  <- colnames(Final_Data)
    
  # Create a vector that contains TRUE values for the ID, mean() & stddev() columns
  # and FALSE for the rest
    meanANDstd <- (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames))

  # Subset Final_Data table based on the meanANDstd to keep only desired columns
    Final_Data <- Final_Data[meanANDstd==TRUE]

    
#############
## 3: Use descriptive activity names to name the activities in the data set
############
    
  # Merge Final_Data table with acitivity_labels table to get descriptive activity names
    
    Final_Data <- merge(Final_Data, activityType, by='activityId', all.x=TRUE)

  # Updating the colNames vector to include the new column names after merge
    colNames  <- colnames(Final_Data)

#############
## 4: Appropriately label the data set with descriptive activity names.
#############    

  # Renaming variables
    for (i in 1:length(colNames)) 
    {
      colNames[i] <- gsub("\\()","",colNames[i])
      colNames[i] <- gsub("-std$","StdDev",colNames[i])
      colNames[i] <- gsub("-mean","Mean",colNames[i])
      colNames[i] <- gsub("^(t)","time",colNames[i])
      colNames[i] <- gsub("^(f)","freq",colNames[i])
      colNames[i] <- gsub("([Gg]ravity)","Gravity",colNames[i])
      colNames[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
      colNames[i] <- gsub("[Gg]yro","Gyro",colNames[i])
      colNames[i] <- gsub("AccMag","AccMagnitude",colNames[i])
      colNames[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
      colNames[i] <- gsub("JerkMag","JerkMagnitude",colNames[i])
      colNames[i] <- gsub("GyroMag","GyroMagnitude",colNames[i])
    };

  # Assigning new descriptive column names to the Final_Data table
    colnames(Final_Data) <- colNames

#############
## 5: Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
#############
    
  # Create a new table without the activityType column
    newData <- Final_Data[ ,names(Final_Data) != 'activityType']

  # Summarizing newData table to include only mean of each variable for each activity and each subject
    tidyData <- aggregate(newData[ ,names(newData) != c('activityId','subjectId')],by=list(activityId=newData$activityId,subjectId = newData$subjectId),mean)

  # Merging tidyData table with activityType table to include descriptive acitvity names
    tidyData <- merge(tidyData, activityType, by='activityId', all.x=TRUE)

  # Export the tidyData set 
    write.table(tidyData, './TidyData.txt',row.names=FALSE,sep='\t')

} #function end
