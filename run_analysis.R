# Getting and Cleaning Data Course Project
# Assignment
# Data location: 
#        https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# You should create one R script called run_analysis.R that does the following.
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# You will be required to submit: 
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis,  
# 3) a code book that describes the variables, the data, and any transformations 
#    or work that you performed to clean up the data called CodeBook.md. 
# You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected.

#load the library we will use
library(dplyr)

#####################
#Set some variables:
#####################

#URL location of data:
URL="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#get current directory location:
ProjDir = getwd()
#here is where we'll put the data that we download:
DataDir = "UCI HAR Dataset/"
#destZipFile
destZipFile="data.zip"

#download, unzip then delete zip file.
if (!file.exists(DataDir)) {
        download.file(url=URL, destfile = destZipFile)
        unzip("data.zip")
        file.remove("data.zip")
        #note, after unzipping, we have 4 text files (README, features,
        #features_info and activity_labels; and 2 directories: test and train)
}


#change our working directory to where we just unzipped:
setwd(DataDir)

#now, load the data from the unzipped text files:

#get feature names:
f <- read.table("features.txt", sep = "")
attributeNames =  f$V2


#First, get the "X_" files:
Xtrain <- read.table("train/X_train.txt", sep = "")
Xtest <- read.table("test/x_test.txt", sep = "")

#combine them into 1:
data <- rbind(Xtest, Xtrain)

#remove the individual ones:
rm(list =c("Xtrain", "Xtest"))


#now get the y_ files (activity):
ytrain <- read.table("train/y_train.txt", sep = "")
ytest <- read.table("test/y_test.txt", sep = "")
activity <- rbind(ytest, ytrain)
colnames(activity) <- "activity"

#remove the individual ones:
rm(list =c("ytrain", "ytest"))

#now the subjects
subjectTrain = read.table("train/subject_train.txt", sep = "")
subjectTest = read.table("test/subject_test.txt", sep = "")

subject <- rbind(subjectTrain, subjectTest)
colnames(subject) <- "subject"

#remove the individual ones:
rm(list =c("subjectTrain", "subjectTest"))


# #but per instructions, we only want "std( & mean(" so just those:
# #use our dataset 'f'; f$V2 will have the cleaned up name:
f<-filter(f,grepl("mean\\(", V2) | grepl("std\\(", V2))

#clean up text:
f$V2 <- tolower(f$V2)
f$V2 <- gsub("-", "", f$V2)
f$V2 <- gsub("\\(", "", f$V2)
f$V2 <- gsub("\\)", "", f$V2)
f$V2 <- gsub("std", "standarddeviation", f$V2)
f$V2 <- gsub("tbody", "timebody", f$V2)
f$V2 <- gsub("tgravity", "timegravity", f$V2)
f$V2 <- gsub("acc", "acceleration", f$V2)
f$V2 <- gsub("fbody", "frequencybody", f$V2)
f$V2 <- gsub("mag", "magnitude", f$V2)


#now, f$v2 has a cleaned up name we want and f$V1 has the index
data <- select(data, f$V1)

#name them right:
colnames(data) <- f$V2

#now we have 3 sets -- put them together for 1:
finaldata <- cbind(subject, activity, data)

#delete stuff we don't need:
rm(list =c("data", "subject", "activity", "f"))

#update the activity:
finaldata$activity[finaldata$activity == 1] <- "walking"
finaldata$activity[finaldata$activity == 2] <- "walking upstairs"
finaldata$activity[finaldata$activity == 3] <- "walking downstairs"
finaldata$activity[finaldata$activity == 4] <- "sitting"
finaldata$activity[finaldata$activity == 5] <- "standing"
finaldata$activity[finaldata$activity == 6] <- "laying"

#now,average of each variable for each activity and each subject.
library(reshape2)
#change it to be tall & skinny
melted <- melt(finaldata, id.vars=c("activity", "subject"))

grouped <- group_by(melted, activity, subject)
newDS <- summarize(grouped, mean=mean(value))

#final cleanup:
rm(list =c( "grouped"))


#go back to where we were originally at
setwd(ProjDir)


