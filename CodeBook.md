# CODE BOOK: Getting and Cleaning Data Course Project Assignment

## VARIABLES:
 * local variables are used to set the paths, file names, etc.
 * there should only be 3 remaining data sets.  all temp ones should be removed
        +finaldata should represent the final MERGED data.  It should have
        68 variables since only the STD and MEAN column are retained,
        along with the SUBJECT and ACTIVITY.
        +melted will represent a TIDY data set where each SUBJECT and ACTIVITY
        have a single row.  it will contain almost 680,000 rows.
        +newDS will represent the "Step 5" answer.  It will be the averages
        grouped by SUBJECT and ACTIVITY.  It is based on melted.
        
## DATA:
* the data is downloaded then unzipped from the referenced website: 
         https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* the unzipped directory contains several reference tables and other raw data files:
        +4 text files (README, features, features_info and activity_labels
        +2 directories: test and train contain the data we will load 

* NOTE -- **read the README.txt file included in the zip for more detailed 
descriptions.**

## TRANSFORMATIONS:
* several transformations occur during processing, including:
+ Combining (row-wise) the x train and x test files
+ Combining (row-wise) the y train and y test files
+ Combining (row-wise) the subject train and test files 
+ Removing columns from the combined X files -- we only keep mean & std columns
+ Renaming columns for better clarity
+ Updating codes for the activity to english descriptions

## UNITS
Base units from the raw files were maintained.

## CALCULATIONS
The only calculations of the raw data was for the Step 5 calculation for the means, grouped by the activity and the subject.