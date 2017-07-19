install.packages("data.table")

install.packages("reshape2")

library(data.table)
library(reshape2)

##read features table file and assign it to features variable .
features <- read.table("C:/Users/dell/Desktop/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/features.txt")[,2]

##Exploring the mean and standered deviation in features table and load it into new variable called mean_std_features.
mean_std_features <- grepl("mean|std", features)

##read activity labels table file and a
activity_labels <- read.table("C:/Users/dell/Desktop/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")[,2]

##read the three tests table file  and load it into new variables .
subject_test <- read.table("C:/Users/dell/Desktop/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

test_y <- read.table("C:/Users/dell/Desktop/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

test_x <- read.table("C:/Users/dell/Desktop/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/X_test.txt") 
##assign the features table to the variables names of test_x table
names(test_x) = features

## specify only mean and standered deviation from features table and load it into test_x columns.
test_x = test_x[, grepl("mean|std", features)]

##get activity labels and load it into test_y table
test_y[,2] = activity_labels[test_y[,1]]
names(test_y) = c("id", "label")
names(subject_test) = "subject"
test_data <- cbind(as.data.table(subject_test), test_y, test_x)

##read training sets files and load it into new variables and apply the same steps of tests to the training sets .
subject_train <- read.table("C:/Users/dell/Desktop/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
train_x <- read.table("C:/Users/dell/Desktop/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
train_y<- read.table("C:/Users/dell/Desktop/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")

names(train_x) = features
train_x = train_x[,extract_features]
train_y[,2] = activity_labels[train_y[,1]]
names(train_y) = c("id", "label")
names(subject_train) = "subject"
train_data <- cbind(as.data.table(subject_train), train_y, train_x)

## merging test set and training set 
train_test_data = rbind(test_data, train_data)
## creaing new vector of labels .
id_labels   = c("subject", "id", "label")

data_labels = setdiff(colnames(train_test_data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
##write tidy data set into text file in specific directory

write.table(tidy_data, file = "C:/Users/dell/Desktop/getdata%2Fprojectfiles%2FUCI HAR Dataset/tidy_data.txt",row.names = FALSE)

