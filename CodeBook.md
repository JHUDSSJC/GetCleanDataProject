---
title: "CodeBook"
author: "JHUDSSJC"
date: "27 October 2014"
output: html_document
---

=================================  

##Data Analysis CodeBook
###Getting and Cleaning Data Course Project

Coursera: Getting and Cleaning Data Course (2014-008)

Instructor: Jeff Leek, et al

Course project - Peer Assessment

### Part I data and variables

Note: All numeric variables/values are considered to be raw. This includes the source data as well as the final tidy data set.

#### General Data Frames
"lables" is the local data frame object for activity_labels.txt and onclude the descriptive terms for
the activities as follows:

1 WALKING

2 WALKING_UPSTAIRS

3 WALKING_DOWNSTAIRS

4 SITTING

5 STANDING

6 LAYING

"features" is the local data frame object for features.txt and includes the 561 column names
for the X_train and X_test data


#### Training Data Frames
"subjtrain" is the local data frame object for subject_train.txt

The generic column names were changed to "set" and "subject" respectively

"xtrain" is the local data frame object for X_train.txt

Column names (561 altogther) were assigned from the file features.txt

"ytrain" is the local data frame object for y_train.txt

"traindata" is the dplyr table_df name for the column-combined frames: subjtrain, ytrain, xtrain



##### Test Data Frames

"subjtest" is the local data frame object for subject_test.txt

The generic column names were changed to "set" and "subject" respectively

"xtest" is the local data frame object for X_test.txt

Column names (561 altogther) were assigned from the file features.txt

"ytest" is the local data frame object for y_test.txt

"testdata" is the dplyr table_df name for the column-combined frames: subjtest, ytest, xtest



#### Source data variable names
For this segment, the variable names are the same as the source (features_info.txt) as follows:

tBodyAcc-XYZ

tGravityAcc-XYZ

tBodyAccJerk-XYZ

tBodyGyro-XYZ

tBodyGyroJerk-XYZ

tBodyAccMag

tGravityAccMag

tBodyAccJerkMag

tBodyGyroMag

tBodyGyroJerkMag

fBodyAcc-XYZ

fBodyAccJerk-XYZ

fBodyGyro-XYZ

fBodyAccMag

fBodyAccJerkMag

fBodyGyroMag

fBodyGyroJerkMag



The set of variables that were estimated from these signals are: 



mean(): Mean value

std(): Standard deviation

mad(): Median absolute deviation 

max(): Largest value in array

min(): Smallest value in array

sma(): Signal magnitude area

energy(): Energy measure. Sum of the squares divided by the number of values. 

iqr(): Interquartile range 

entropy(): Signal entropy

arCoeff(): Autorregresion coefficients with Burg order equal to 4

correlation(): correlation coefficient between two signals

maxInds(): index of the frequency component with largest magnitude

meanFreq(): Weighted average of the frequency components to obtain a mean frequency

skewness(): skewness of the frequency domain signal 

kurtosis(): kurtosis of the frequency domain signal 

bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.

angle(): Angle between to vectors.



Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean

tBodyAccMean

tBodyAccJerkMean

tBodyGyroMean

tBodyGyroJerkMean


The complete list of variables of each feature vector is available in 'features.txt'

However, the source file does not include a descritive explanation.

The following assumptions were made from reading the source documentation and discussion forums:

"t" as a prefix means "time"

"f" as a prefix means "frequency"

### Part II
Extracted data and variables for the measurements on the mean and standard deviation

In his part, a simple "grep" or text search on all column names in the combined data frames from Part I
was conducted for the text "mean()" or "std"

The "mean()" text fragment selects only the mean measurements and not the aggregated mean variable "meanFreq"
There was a good discussion about this in the forums.

"HARmean_and_stdDF" is the intermediate data frame to which these selections were saved

"byActivityBySubject" is the aggregate of "HARmean_and_stdDF" based on a grouping of the activities (WALKING, etc.)
which calculates the mean for all the numeric selected columns in "HARmean_and_stdDF"

"TidyPre1" is the final intermediate data frame which eliminates three extraneous columns with duplicate information

No changes were made to any variable names in this part.

### Part III
Use descriptive activity names to name the activities in the data set
Create pre-final Tidy Data Set

Three changes were made to the intermediate data frame "TidyPre1":

1. All activity names were changed to lower case to improve readability:

e.g.,: "WALKING" -> "walking"

2. The activity "laying" was changed to "lying down"

The Oxford English Dictionary defines "laying" as a transitive verb, and its meanings are not appropriate.

lay 1 |leɪ|
verb (past and past participlelaid |leɪd| )
1 [ with obj. and adverbial of place ] put (something) down gently or carefully: she laid the baby in his cot.
• [ with obj. ] prevent (something) from rising off the ground: there may have been the odd light shower just to lay the dust.
2 [ with obj. ] put down and set in position for use: it is advisable to have your carpet laid by a professional.
• Brit.set cutlery, crockery, etc. on (a table) in preparation for a meal: she laid the table for dinner.
• (often be laid with) cover (a surface) with objects or a substance: the floor was laid with mattresses.
• put the material for (a fire) in place and arrange it. he was making newspaper knots before laying a fire in the fireplace.
• prepare (a trap) for someone: she wouldn't put it past him to lay a trap for her.
• work out (an idea or suggestion) in detail ready for use or presentation: I'd like more time to lay my plans.
• (lay something before) present information or suggestions to be considered and acted upon by (someone): he laid before Parliament proposals for the establishment of the committee.
• locate (an episode in a play, novel, etc.) in a particular place: no one who knew the area could be in doubt where the scene was laid.
• [ with obj. ] stake (an amount of money) in a bet: she suspected he was pulling her leg, but she wouldn't have laid money on it.
3 [ with obj. ] used with an abstract noun so that the phrase formed has the same meaning as the verb related to the noun used, e.g. ‘lay the blame on’ means ‘to blame’: she laid great stress on little courtesies.
4 [ with obj. ] (of a female bird, insect, reptile, or amphibian) produce (an egg) from inside the body: flamingos lay only one egg | [ no obj. ] : the hens were laying at the same rate as usual.
5 [ with obj. ] vulgar slang have sexual intercourse with.
6 [ with obj. ] Nautical follow (a specified course). I'm going to lay a course for Ibiza harbour.
7 [ with obj. ] trim (a hedge) back, cutting the branches half through, bending them down, and interweaving them. most hedges are no longer laid.

3. All underscores were removed from the activity lables (e.g., "walking_downstairs" becomes "walking downstairs")

### Part IV
Appropriately label the data set with descriptive variable names

In this part, all column/variable names for the x_data fields (561) were modified as follows to improve readability

1. "t' was changed to "time" based on source documentation to improve readability

2. "f" was changed to "freq" based on source documentation to improve readability

3. "BodyBody" is considered a error was changed to just "Body" based to improve readability

4. All parenthesis characters were removed from variable names to improve readability

