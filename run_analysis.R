####### 
# step 0: Downloading and unzipping: 
# note: I just manually downloaded and unzipped files. 

# step 1. Merge trainign and test test to create one data set 

# Reading training tables: 
x_train <- read.table('/Users/iangingerich/Desktop/R_course/Data_cleaning/week4/UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('/Users/iangingerich/Desktop/R_course/Data_cleaning/week4/UCI HAR Dataset/train/y_train.txt')
subject_train <- read.table('/Users/iangingerich/Desktop/R_course/Data_cleaning/week4/UCI HAR Dataset/train/subject_train.txt')

# read test variables 
x_test <- read.table('/Users/iangingerich/Desktop/R_course/Data_cleaning/week4/UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('/Users/iangingerich/Desktop/R_course/Data_cleaning/week4/UCI HAR Dataset/test/y_test.txt')
subject_test <- read.table('/Users/iangingerich/Desktop/R_course/Data_cleaning/week4/UCI HAR Dataset/test/subject_test.txt')

#read feature vectors 
features <- read.table('/Users/iangingerich/Desktop/R_course/Data_cleaning/week4/UCI HAR Dataset/features.txt')

# activity labels
activityLabels <- read.table('/Users/iangingerich/Desktop/R_course/Data_cleaning/week4/UCI HAR Dataset/activity_labels.txt')

# column names. Assign features to x train and test 
colnames(x_train) <- features[,2]
colnames(x_test) <- features[,2]

# acivity ID to the y train and test 
colnames(y_train) <- 'activityID'
colnames(y_test) <- 'activityID'

#subject col name 
colnames(subject_train) <- 'subjectID'
colnames(subject_test) <- 'subjectID'

# labels for activity labels df 
colnames(activityLabels) <- c('activityID','activityType')

# Merge data together using column binding 
mrg_train <- cbind(y_train,subject_train,x_train)
mrg_test <- cbind(y_test,subject_test,x_test)
#merge all
setAll <- rbind(mrg_train,mrg_test)

#step 2: Get mean and std for each measurement 
colNames <- colnames(setAll)

# Create boolean vector containing mean and std cols. 
# accomplished using grepl 

mean_std <- (grepl('activityID',colNames)|
                     grepl('subjectID',colNames)|
                     grepl('mean..',colNames)|
                     grepl('std..',colNames))

# Subject data bases on above vector
setMeanStd <- setAll[,mean_std==TRUE]

# label everything using the activityLabels table 
descriptiveNames <- merge(setMeanStd,activityLabels,
                          by ='activityID',
                          all.x = TRUE)

# make independant tidy dataset 
TidySet <- aggregate(.~subjectID+activityID,descriptiveNames,mean)
TidySet <- TidySet[order(TidySet$subjectID,TidySet$activityID),]

# write to text 
write.table(TidySet,'TidySet',row.name=FALSE)

