---
title: "ReadMe"
author: "JHUDSSJC"
date: "27 October 2014"
output: html_document
---

=================================  

##Data Analysis ReadMe 
###Getting and Cleaning Data Course Project

Coursera: Getting and Cleaning Data Course (2014-008)

Instructor: Jeff Leek, et al

Course project - Peer Assessment

###  Part I
SetUp: set working directory and read all required data files listed above

### Step 1: 
Set local repository to current working directory

```{r}
setwd("/JHUDSSJC/GettingandCleaningDataCourseProject/UCI HAR Dataset")
getwd()
```

### Step 2: 
Read common data files into session and assign to data frames in local workspace with similar names

```r
# read files in main data directory
lables<-read.table("activity_labels.txt")
features<-read.table("features.txt")
```

### Step 3: 
Read training data files into session and assign to data frames in local workspace with similar names

Merge data into a single training data set

```r
# change to training data directory and read in the training data files:
setwd("/JHUDSSJC/GettingandCleaningDataCourseProject/UCI HAR Dataset/train")
subjtrain<-read.table("subject_train.txt")
# duplicate column to add temporary col variable for (data)set variable
subjtrain$V2<-subjtrain$V1
# rename columns to reasonable names
names(subjtrain)<-c("set","subject")
# initialise set column to "train"
subjtrain$set<-"train"
# read in primary x_train data with 7352 rows of 561 columns
xtrain<-read.table("X_train.txt")
# assign provided variable names from features.txt file, pivot to row format
names(xtrain)<-t(features[,2])
# read single column y training data file, 7352 rows
ytrain<-read.table("y_train.txt")
# duplicate single column to reassign later
ytrain$V2<-ytrain$V1
# assign factor lables from features to match the integer code in this data frame
ytrain$V1<-factor(ytrain$V2,levels=c(1,2,3,4,5,6), labels=lables$V2)
# change column names to what they represent in plain English
names(ytrain)<-c("activity","Y")
# create a table to verify that the integer code and acitvity match up perfectly
table(ytrain)
# bind the subject, activity and main variables together to single training dataset
traindata<-cbind(subjtrain,ytrain,xtrain)
```

### Step 4: 
Read test data files into session and assign to data frames in local workspace with similar names

Merge data into a single test data set

```r
# change to test data directory and read in the test data files:
setwd("/JHUDSSJC/GettingandCleaningDataCourseProject/UCI HAR Dataset/test")
subjtest<-read.table("subject_test.txt")
# duplicate column to add temporary col variable for (data)set variable
subjtest$V2<-subjtest$V1
# rename columns to reasonable names
names(subjtest)<-c("set","subject")
# initialise set column to "test"
subjtest$set<-"test"
# read in primary x_train data with 7352 rows of 561 columns
xtest<-read.table("X_test.txt")
# assign provided variable names from features.txt file, pivot to row format
names(xtest)<-t(features[,2])
# read single column y training data file, 2947 rows
ytest<-read.table("y_test.txt")
# duplicate single column to reassign later
ytest$V2<-ytest$V1
# assign factor lables from features to match the integer code in this data frame
ytest$V1<-factor(ytest$V2,levels=c(1,2,3,4,5,6), labels=lables$V2)
# change column names to what they represent in plain English
names(ytest)<-c("activity","Y")
# create a table to verify that the integer code and acitvity match up perfectly
table(ytest)
# bind the subject, activity and main variables together to single training dataset
testdata<-cbind(subjtest,ytest,xtest)
```

### Step 5:
Verify main training and test data

```r
# verify intermediate test and train data sets
# rows = 7352, columns = 565 (562+3 new)
dim(traindata)
# rows = 2947, columns = 565 (562+3 new)
dim(testdata)
```

### Step 6:
Create on master combined data file for analysis

```r
# merge (rowbind) the test and training data frames into one master data frame
HARmasterDF<-rbind(traindata,testdata)
# verify row count = 76352+2947=10,299, col count is same (565) 
dim(HARmasterDF)
# get length of rows for for-loop
len<-dim(traindata)[1]+dim(testdata)[1]
# test the count of rows, warn user if errors
if (dim(HARmasterDF)[1] == len) print("row count correct!")  else print("rows do not add up!")
if (anyNA(HARmasterDF)) print("Error: NAs exist in dataset!") else print("data is complete.")
```

### Part II
Process the combined source data to extract only the measurements on the mean and standard deviation for each measurement

### Step 6:
Select subset of master data frame that are "mean" and standard deviation "std" measures

* see codebook for discussion of reasons for the selection criteria

```r
HARmean_and_stdDF<-cbind(HARmasterDF[,1:3],
	HARmasterDF[,grep("mean\\()",names(HARmasterDF))], 
	HARmasterDF[,grep("std",names(HARmasterDF))])
```

### Step 6:
Aggregate by subject and activity as per instructions and remove duplicate columns

```r
byActivityBySubject<-aggregate(HARmean_and_stdDF, by=list(HARmean_and_stdDF$subject, HARmean_and_stdDF$activity), FUN=mean)
TidyPre1<-byActivityBySubject[,-c(1,3,5)]
```

### Part III
Use descriptive activity names to name the activities in the data set
Create pre-final Tidy Data Set

### Step 7:
Change variable names to lower case and remove non-alphanumeric characters

```r
# change all variable values in activity to lower case to improve readability
TidyPre1[,1]<-tolower(TidyPre1[,1])
# change "laying" to "reclining" as "laying" is a transitive motion verb
# for the correct meaning of "laying" see the Oxford Dictionary of English
TidyPre1[,1]<-gsub("laying","lying down",TidyPre1[,1])
# remove underscores to improve readability
TidyPre1[,1]<-gsub("_"," ",TidyPre1[,1])
```

### Part IV
Appropriately label the data set with descriptive variable names

Change all remaining column names to improve readability

### Step 8:
change source variable names to be more obvious

```r
# create a character list of the column names
nameslist<-names(TidyPre1)
# store the length for the for-loop
len<-length(nameslist)
# append "-Avg" on all column names that are not subject/activity
for (i in 3:len) nameslist[i]<-paste(nameslist[i],"-Avg",sep="")
# change activity column to the correct name
nameslist<-gsub("Group.2","activity",nameslist)
# expand "tBody" to include "time"
nameslist<-gsub("tBody","timeBody",nameslist)
# expand "fBody" to include "freq"
nameslist<-gsub("fBody","freqBody",nameslist)
# expand "tGrav" to include "time"
nameslist<-gsub("tGrav","timeGrav",nameslist)
# remove duplicate "Body" from double name "BodyBody"
nameslist<-gsub("BodyBody","Body",nameslist)
# remove all parentheses
nameslist<-gsub("\\(\\)","",nameslist)
# assign modified names list to column names of pre-"tidy_data" set
names(TidyPre1)<-nameslist
```

### Part V
From the data set in part IV, create a second, independent tidy data set with the average of each variable for each activity and each subject.

### Step 9:
Write the tidy data set to the local GIT working directory, and drop row names explicitly per spec.

Write data frame to tidy data text file.

```r
setwd("/JHUDSSJC/GettingandCleaningDataCourseProject")
write.table(TidyPre1, file = "tidy_data.txt", sep = ",", row.names=FALSE)
```