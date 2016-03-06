##set working directory to the folder where the smartphone data has been unzipped
setwd("C:/Users/saurav/Documents/R/SmartPhoneData")

##load all the libraries
library(dplyr)
library(tidyr)

##read feature dataset
ftres <- read.table("features.txt", header = FALSE)
features <- tbl_df(ftres)
features$V2 <- gsub("\\)","",as.character(features$V2))
features$V2 <- gsub("\\(","",as.character(features$V2))
features$V2 <- gsub("\\-","",as.character(features$V2))

##read activity labels
als <-  read.table("activity_labels.txt", header = FALSE)
activity.labels <- tbl_df(als)

##read train datasets
#x table and assign column names
trn.xdata <- read.table("./train/X_train.txt")
names(trn.xdata) <- features$V2
train.xdata <- tbl_df(trn.xdata)

# y table and assign column names
trn.ydata <- read.table("./train/y_train.txt")
names(trn.ydata) <- "activity"
train.ydata <- tbl_df(trn.ydata)

#subject train
trn.subdata <- read.table("./train/subject_train.txt")
names(trn.subdata) <- "rowID"
train.subdata <- tbl_df(trn.subdata)

##read test datasets
tst.xdata <- read.table("./test/X_test.txt")
names(tst.xdata) <- features$V2
test.xdata <- tbl_df(tst.xdata)

tst.ydata <- read.table("./test/y_test.txt")
names(tst.ydata) <- "activity"
test.ydata <- tbl_df(tst.ydata)

#subject test
tst.subdata <- read.table("./test/subject_test.txt")
names(tst.subdata) <- "rowID"
test.subdata <- tbl_df(tst.subdata)

##merge train datasets into a single table
train.ds <- bind_cols(train.subdata, train.ydata, train.xdata)

##save train dataset to csv
write.csv(train.ds,paste("Train",".csv" ,sep=""))

##merge test datasets into a single table
test.ds <- bind_cols(test.subdata, test.ydata, test.xdata)

##save train dataset to csv
write.csv(test.ds,paste("Test",".csv" ,sep=""))

##merge train and test datasets
final.ds <- rbind.data.frame(train.ds,test.ds)
fin.ds <- tbl_df(final.ds)
##assign labels to activity
fin.ds$activity <- factor(fin.ds$activity,levels=activity.labels$V1,labels=activity.labels$V2)

##save final.ds to csv file
write.csv(fin.ds,paste("Train_Test_Combined",".csv" ,sep=""))


##extract columns with mean and sd
meancols <- grep("mean", colnames(final.ds))
stdcols <- grep("std", colnames(final.ds))
filtered.ds <- fin.ds[,c(1,2,stdcols,meancols)]
filtered.ds <- arrange(filtered.ds, rowID)

##save the filtered.ds to csv file
write.csv(filtered.ds,paste("Filtered",".csv" ,sep=""))

##summarize filtered.ds
mean.ds <- filtered.ds %>% group_by(rowID,activity) %>% summarize_each(funs(mean))

##save the mean.ds to csv file
write.csv(mean.ds,paste("Mean",".csv" ,sep=""))

write.table(mean.ds, file = "meanData.txt", col.names = TRUE)

