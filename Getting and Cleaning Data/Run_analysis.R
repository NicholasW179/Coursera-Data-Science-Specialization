fileurl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileurl, destfile = 'dataset.zip')
unzip('dataset.zip')

library(data.table); library(dplyr); library(dtplyr)

activitylabels <- fread('UCI HAR Dataset/activity_labels.txt', col.names = c('classlabels', 'activityname' ))
features <- fread('UCI HAR Dataset/features.txt', col.names = c('index', 'featurenames'))
wanted <- grepl('(mean|std)\\(\\)', features[, featurenames])
measure <- features[wanted, featurenames]
measure <- gsub('[()]', '', measure)
train <- fread('UCI HAR Dataset/train/X_train.txt')[, wanted, with = F]
setnames(train, colnames(train), measure)
tactivities <- fread('UCI HAR Dataset/train/y_train.txt', col.names = 'Activity')
tsubjects <- fread('UCI HAR Dataset/train/subject_train.txt', col.names = 'Subject')

train <- cbind(train, tactivities, tsubjects)

test <- fread('UCI HAR Dataset/test/X_test.txt')[, wanted, with = F]
setnames(test, colnames(test), measure)
test_activity <- fread('UCI HAR Dataset/test/y_test.txt', col.names = 'Activity')
test_subjects <- fread('UCI HAR Dataset/test/subject_test.txt', col.names = 'Subject')
test <- cbind(test, test_activity, test_subjects)
combine <- rbind(train, test)
write.table(combine, file = 'tidy.txt', quote = F)
