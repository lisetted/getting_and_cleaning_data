

##clear files in working directory
rm(list =ls())
setwd("/Users/Lisette/Data science")
list.files(getwd())


##more info about this data can be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#give file a name 
filename <- "getdata.zip"

#check if data file exists already, if not download
if (!file.exists(filename)){
  file1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
   download.file(file1, filename, method="curl")
  }  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
  }

#view files in UCI HAR Dataset
list.files("/Users/Lisette/Data science/UCI HAR Dataset")

#read files in
activity_labels<- read.table("UCI HAR Dataset/activity_labels.txt")
features<- read.table("UCI HAR Dataset/features.txt")
test1 <-read.table("UCI HAR Dataset/test/subject_test.txt")
xtest <-read.table("UCI HAR Dataset/test/X_test.txt")
ytest <-read.table("UCI HAR Dataset/test/y_test.txt")
train1 <-read.table("UCI HAR Dataset/train/subject_train.txt")
xtrain <-read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <-read.table("UCI HAR Dataset/train/y_train.txt")

#name the columns in test and train then combine x files and yfiles
#combine comes from gdata package
names(xtest) <- features[, 2]
names(xtrain) <- features [,2]
train <- cbind(subject=train1$V1, xtrain)
test <-cbind(subject=test1$V1, xtest)

xfiles <- combine(test, train, names= c("test", "train"))


#index columns mean and standard dev columns
mean_std<- grep("-(mean|std)\\(\\)", features[,2])
#subset xfiles for only the fields with mean and std
x_mean_std <- xfiles[,mean_std]

#properly identify activity names
yfiles <- combine(ytest, ytrain, names= c("train", "test"))
yfiles[, 1] <- activity_labels[yfiles[, 1], 2]

#merge x and y files
data1 <- cbind(activity=yfiles$V1, ysource=yfiles$source, x_mean_std)
data <-select(data1, -ysource)

#From the data set in step 4, creates a second, independent tidy 
#data set with the average of each variable for each activity and 
#each subject.
temp2 <- as.factor(data$subject)
temp1 <- factor(data$activity, levels = activity_labels[,1], labels = activity_labels[,2])

melt1 <- melt(data, id = c("subject", "activity"))
means <- dcast(melt1, subject + activity ~ variable, mean)

tidy <-write.table(means, "tidy.txt", row.names = FALSE, quote = FALSE)


