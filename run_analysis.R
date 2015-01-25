library(data.table)
library(plyr)
library(dplyr)

######################################################################################################################
#Part 1
#Merges the training and the test sets to create one data set.

X_train = read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="")
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep="")
y_train = read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="")

X_test = read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="")
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep="")
y_test = read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE, sep="")

merged_train = cbind(X_train, subject_train, y_train, deparse.level=1)
colnames(merged_train)[ncol(merged_train)-1] = 'subject'
colnames(merged_train)[ncol(merged_train)] = 'y'

remove(subject_train,y_train,X_train)

merged_test = cbind(X_test, subject_test, y_test, deparse.level=1)
colnames(merged_test)[ncol(merged_test)-1] = 'subject'
colnames(merged_test)[ncol(merged_test)] = 'y'

remove(subject_test,y_test,X_test)

full_data = rbind(merged_train,merged_test)

remove(merged_train,merged_test)

#####################################################################################################################
#Part 2
#Extracts only the measurements on the mean and standard deviation for each measurement.

features = read.table("UCI HAR Dataset/features.txt", header=FALSE, sep="")
features$V2 = as.character(features$V2)
logic_mean = grepl("mean()",features$V2, fixed=T)
logic_std = grepl("std()",features$V2, fixed=T)
logic_mean_std = logic_mean | logic_std
logic_mean_std[c(length(logic_mean_std)+1,length(logic_mean_std)+2)] = c(T,T)
mean_std_data = full_data[logic_mean_std]

remove(full_data,logic_mean,logic_std)

######################################################################################################################
#Part 3
#Uses descriptive activity names to name the activities in the data set

activity_labels = read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE, sep="")
activity_labels$V2 = as.character(activity_labels$V2)

for (inc in 1:nrow(activity_labels))
{
  mean_std_data$y[mean_std_data$y == activity_labels$V1[inc]] = activity_labels$V2[inc]
}

#######################################################################################################################
#Part 4
#Appropriately labels the data set with descriptive variable names. 

names(mean_std_data)[names(mean_std_data)=="y"] = "activity_label"
names(mean_std_data)[names(mean_std_data)=="subject"] = "individual_ID"

mean_std_features = features$V2[logic_mean_std]

for (inc in 1:(length(mean_std_features)-2))
{
  temp = mean_std_features[inc]
  colnames(mean_std_data)[inc] = gsub("[\\(\\)]","",gsub("[\\-]","_",temp))
}

#######################################################################################################################
#Part 5
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
#for each activity and each subject.

unique_ID = unique(mean_std_data$individual_ID)
unique_activity = unique(mean_std_data$activity_label)

count = 0

for (incIndID in 1:(length(unique_ID)))
{
  for (incActivity in 1:length(unique_activity))
  {
    count = count + 1
    print(count)
    if (count==1)
    {
      temp = colMeans(mean_std_data[mean_std_data$activity_label == unique_activity[incActivity] & mean_std_data$individual_ID == unique_ID[incIndID],
                                      seq(1,66)])
      meanByIdActivity = data.frame(matrix(unlist(temp), ncol=66))
      names(meanByIdActivity) = names(temp)
      meanByIdActivity$individual_ID = unique_ID[incIndID]
      meanByIdActivity$activity_label = unique_activity[incActivity]
    }
    else 
    {
      temp = colMeans(mean_std_data[mean_std_data$activity_label == unique_activity[incActivity] & mean_std_data$individual_ID == unique_ID[incIndID],
                                    seq(1,66)])
      transfertDF = data.frame(matrix(unlist(temp), ncol=66))
      names(transfertDF) = names(temp)
      transfertDF$individual_ID = unique_ID[incIndID]
      transfertDF$activity_label = unique_activity[incActivity]
      meanByIdActivity = rbind(meanByIdActivity,transfertDF)
    }
  }
}

meanByIdActivity = meanByIdActivity[c("individual_ID","activity_label",names(meanByIdActivity)[c(-67,-68)])]

remove(activity_labels,features,mean_std_data,transfertDF,count,inc,incActivity,incIndID,logic_mean_std,mean_std_features,
       temp, unique_activity,unique_ID)

write.table(meanByIdActivity,"meanByIdActivity.txt", sep = ",", row.names = F)
