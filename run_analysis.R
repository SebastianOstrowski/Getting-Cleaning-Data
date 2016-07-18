# First thing to do is set the correct working directory 
setwd("/Users/sebastianostrowski/Desktop/UCI HAR Dataset")

library(data.table)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./UCI HAR Dataset.zip")){download.file(fileUrl,"./UCI HAR Dataset.zip", method = "curl")
      unzip("UCI HAR Dataset.zip")
}

# Taking in the data from the unzipped file and converting it into single data frame.

# Run features
features <- read.csv("./UCI HAR Dataset/features.txt")
features <- as.character(features[,2])

X_Train<- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_Train <- read.csv("./UCI HAR Dataset/train/y_train.txt")
Subject_Train <- read.csv("./UCI HAR Dataset/train/subject_train.txt")

Train <-  data.frame(Subject_Train, Y_Train, X_Train)
names(Train) <- c(c("subject", "activity"), features)

X_Test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_Test <- read.csv("./UCI HAR Dataset/test/y_test.txt")
Subject_Test <- read.csv("./UCI HAR Dataset/test/subject_test.txt")

Test <-  data.frame(Subject_Test, Y_Test, X_Test)
names(Test) <- c(c("subject", "activity"), features)

# 1. Merges the training and the test sets to create one data set. 

data.all <- rbind(Train, Test)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

ExtractMean_StandardDeviation <- grep("mean|std", features)
Subject_Data <- data.all[,c(1,2,ExtractMean_StandardDeviation + 2)]


# 3. Uses descriptive activity names to name the activities in the data set.

Activity_Labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
Activity_Labels <- as.character(Activity_Labels[,2])
data.sub$activity <- Activity_Labels[data.sub$activity]


# 4.  Appropriately labels the data set with descriptive variable names.

name.new <- names(data.sub)
name.new <- gsub("[(][)]", "", name.new)
name.new <- gsub("^t", "TimeDomain_", name.new)
name.new <- gsub("^f", "FrequencyDomain_", name.new)
name.new <- gsub("Acc", "Accelerometer", name.new)
name.new <- gsub("Gyro", "Gyroscope", name.new)
name.new <- gsub("Mag", "Magnitude", name.new)
name.new <- gsub("-mean-", "_Mean_", name.new)
name.new <- gsub("-std-", "_StandardDeviation_", name.new)
name.new <- gsub("-", "_", name.new)
names(data.sub) <- name.new

# 5.  From the data set in step 4, creates a second, independent 
#     tidy data set with the average of each variable for each activity and each subject.

Tidy_Data <- aggregate(data.sub[,3:81], by = list(activity = data.sub$activity, subject = data.sub$subject),FUN = mean)
write.table(x = Tidy_Data, file = "Tidy_Data_Set.txt", row.names = FALSE)






