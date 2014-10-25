#*****************************************************************************************
#*****************************************************************************************

### Beginning of R script file "run_analysis.R"

#*****************************************************************************************

# run_analysis.R
# By: JHUDSSJC
# Coursera: Getting and Cleaning Data Course (2014-008)
# Instructor: Jeff Leek, et al
# Course project - Peer Assessment

# The R script:
# 	1. Merges the training and the test sets to create one data set.
# 	2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 	3. Uses descriptive activity names to name the activities in the data set
# 	4. Appropriately labels the data set with descriptive variable names. 
# 	5. From the data set in step 4, creates a second, independent tidy data set with the 
#		average of each variable for each activity and each subject.
#
#	It also deletes data frame objects to recapture memory (optional) when with them.

# Inputs: 	"UCI HAR Dataset" in the local GIT working directory with the following 
#				REQUIRED contents:
#
#				activity_labels.txt
#				features.txt
#
#				"test" sub-directory containing:
#					subject_test.txt
#					X_test.txt
#					y_test.txt
#
#				"train" sub-directory containing:
#					subject_train.txt
#					X_train.txt
#					y_train.txt
#
# Output:	tidy_data.txt into the local GIT working directory
#			tidy_data.txt is a tidy data set as derived by the five steps above
#

# Required packages:	None

#*****************************************************************************************

###	Part I SetUp: set working directory and read all required data files listed above

# Main data directory:

setwd("/JHUDSSJC/GettingandCleaningDataCourseProject/UCI HAR Dataset")
lables<-read.table("activity_labels.txt")
features<-read.table("features.txt")

# Training data directory:

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

# Test data directory:

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

# verify intermediate test and train data sets
# rows = 7352, columns = 565 (562+3 new)
dim(traindata)
# rows = 2947, columns = 565 (562+3 new)
dim(testdata)

# merge (rowbind) the test and training data frames into one master data frame
HARmasterDF<-rbind(traindata,testdata)
# verify row count = 76352+2947=10,299, col count is same (565) 
dim(HARmasterDF)
# get length of rows for for-loop
len<-dim(traindata)[1]+dim(testdata)[1]
# test the count of rows, warn user if errors
if (dim(HARmasterDF)[1] == len) print("row count correct!")	else print("rows do not add up!")
if (anyNA(HARmasterDF)) print("Error: NAs exist in dataset!") else print("data is complete.")

### Part II
# Extracts only the measurements on the mean and standard deviation for each measurement

# - select subset of master data frame that are "mean" and standard deviation "std" measures
# -	see codebook for discussion of reasons for the selection criteria
HARmean_and_stdDF<-cbind(HARmasterDF[,1:3],
	HARmasterDF[,grep("mean\\()",names(HARmasterDF))], 
	HARmasterDF[,grep("std",names(HARmasterDF))])
# aggregate by subject and activity as per instructions
byActivityBySubject<-aggregate(HARmean_and_stdDF, by=list(HARmean_and_stdDF$subject, HARmean_and_stdDF$activity), FUN=mean)
# remove duplicate columns
TidyPre1<-byActivityBySubject[,-c(1,3,5)]

### Part III
# Use descriptive activity names to name the activities in the data set

# change all variable values in activity to lower case to improve readability
TidyPre1[,1]<-tolower(TidyPre1[,1])
# change "laying" to "reclining" as "laying" is a transitive motion verb
# for the correct meaning of "laying" see the Oxford Dictionary of English
TidyPre1[,1]<-gsub("laying","lying down",TidyPre1[,1])
# remove underscores to improve readability
TidyPre1[,1]<-gsub("_"," ",TidyPre1[,1])

### Parts IV and V
# 4. Appropriately label the data set with descriptive variable names
# 		change all remaining column names to improve readability
# and
# 5. From the data set in step 4, create a second, independent tidy data set with the 
#		average of each variable for each activity and each subject.

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
# write the tidy data set to the local GIT working directory, drop row names explicitly
#	per spec
setwd("/JHUDSSJC/GettingandCleaningDataCourseProject")
write.table(TidyPre1, file = "tidy_data.txt", sep = ",", row.names=FALSE)

#*****************************************************************************************

### End of R script file

#*****************************************************************************************
#*****************************************************************************************