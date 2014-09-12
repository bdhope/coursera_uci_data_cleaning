rm(list=ls())
setwd("c:/data/clean")
#clear worksapce and set WD


fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile="UCI_HAR_data.zip"
download.file(fileURL, destfile=zipfile)

unzip(zipfile, exdir="data")
#download and unzip data


time<-Sys.time()
write.csv(time, file = "mostrecentdatadownload.csv")
# record time of download
#read raw data
message("reading X_train.txt")
training.x <- read.table("data/UCI HAR Dataset/train/X_train.txt")
message("reading y_train.txt")
training.y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
message("reading subject_train.txt")
training.subject <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
message("reading X_test.txt")
test.x <- read.table("data/UCI HAR Dataset/test/X_test.txt")
message("reading y_test.txt")
test.y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
message("reading subject_test.txt")
test.subject <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
# Merge data sets
merged.x <- rbind(training.x, test.x)
merged.y <- rbind(training.y, test.y)
merged.subject <- rbind(training.subject, test.subject)
# merge train and test datasets and return
features <- read.table("data/UCI HAR Dataset/features.txt")

featuresa<-unlist(features[,2])

colnames(merged.x) <- featuresa
colnames(merged.y)<-"activity"
colnames(merged.subject)<- "subject"

mean.col <- sapply(featuresa, function(x) grepl("mean()", x, fixed=T))
std.col <- sapply(featuresa, function(x) grepl("std()", x, fixed=T))

keepsmeans <- mean.col
means.keeps<-merged.x[,keepsmeans,drop=FALSE]

keepsstd <- std.col
std.keeps<-merged.x[,keepsstd,drop=FALSE]

combined<-cbind(merged.subject,merged.y, means.keeps,std.keeps)


#calculate means

tidy <- ddply(combined, .(subject, activity), function(x) colMeans(x[,1:62]))


rm(training.x, test.x, training.y, test.y,training.subject, test.subject,merged.subject,merged.y, merged.x, features)


#rename row one to descriptive term instead of numercial code
tidy$activity[tidy$activity == 1] = "WALKING"
tidy$activity[tidy$activity == 2] = "WALKING_UPSTAIRS"
tidy$activity[tidy$activity == 3] = "WALKING_DOWNSTAIRS"
tidy$activity[tidy$activity == 4] = "SITTING"
tidy$activity[tidy$activity == 5] = "STANDING"
tidy$activity[tidy$activity == 6] = "LAYING"

write.table(tidy, file = "cleaneddata_UCI_final.txt", row.names=FALSE)
#remove junk
rm(list=ls())
