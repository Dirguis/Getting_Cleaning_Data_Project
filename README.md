# Getting_Cleaning_Data_Project
The repository contains a : R script, README.md and CodeBook files for peer review for the project from the course getting cleaning data

ReadMe, script run_analysis.R coded in R for the project in the course Getting and Cleaning Data
01/24/2015

The pupose of the script is to execute a series of steps listed below:

 You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set. 
2. Extracts only the measurements on the mean and standard deviation for each measurement.  
3. Uses descriptive activity names to name the activities in the data set 
4. Appropriately labels the data set with descriptive variable names.  
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

given the set of data available at this link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The data set represents data collected from the accelerometers from the Samsung Galaxy S smartphone. The online description of the data set can be found at this link: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The downloaded file should unzipped and the subsequent folder 'UCI HAR Dataset' should be renamed to  'UCI_HAR_Dataset'. The script, placed in the same folder as the renamed folder, will execute each of the 5 steps above, in order, and write the final tidy data set in a .txt file called 'meanByIdActivity .txt'.

Below, some more explanations for each step are given, labeled by the step number.

1) 
Six files in total are read, 3 from the training set and 3 from the test set.
UCI_HAR_Dataset/train/X_train.txt
UCI_HAR_Dataset/train/subject_train.txt
UCI_HAR_Dataset/train/y_train.txt
UCI_HAR_Dataset/test/X_test.txt
UCI_HAR_Dataset/test/subject_test.txt
UCI_HAR_Dataset/test/y_test.txt

The subject and y _train.txt and _test.txt have one column and are merged by column with their respective X_train.txt and X_test.txt into the data frames merged_train and merged_data. The column from the subject and y _train.txt and _test.txt are relabeled 'subject' and 'y', for clarity. Finally, both data frames are merged by rows in the data frame full_data, 10299 obs x 563 var.


2)
A list of all the features are given in UCI_HAR_Dataset/features.txt. This file is read in the variable features. Only the features in full_data containing the words mean() or std() are selected and put in the data frame mean_std_data, 10299 obs x 68 var.



3)
The file UCI_HAR_Dataset/activity_labels.txt gives the activity labels, which is the label matching the descriptive name. Each of the 6 labels are replaced with the corresponding proper decriptive name, the descriptive name being directly taken from the activity_label.txt file.


4)
The renaming of the labels is done by taking the name given in the features.txt file, loaded in the variable features (see step 2). The names are altered to replace any dash - by an underscore _ and removing the parentheses, this to ensure a proper call of the label without error.
In addition, 'subject' is renamed 'individual_ID' and 'y' is renamed 'activity_label', for clarity.



5)
A vector of unique IDs and activities is created. For each individual pair of (ID,activity), the corresponding subset of data is pulled out of the data set and the mean value for each feature is calculated with colMeans. The result is converted in a 1 obs x 68 var data frame (66 var + 1 ID + 1 activity) and appended to an already existing data frame, named meanByIdActivity of final dimensions 180 obs x 68 var.

Finally, the column in meanByIdActivity are rearranged to have the ID and the activity as th first 2 columns, followed by the remaining features. This was done for clarity since the data were grouped by ID and activity to calculate the mean.

The last step is to write the data frame meanByIdActivity in meanByIdActivity.txt using write.table().
