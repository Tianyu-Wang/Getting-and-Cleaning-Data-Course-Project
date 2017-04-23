library(plyr)


#1 Merge the training and the test sets to create one data set

# Read in data files
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")

x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")

# Create combined x/y/subject data set from test and training sets
x_data <- rbind(x_test, x_train)
y_data <- rbind(y_test, y_train)
subject_data <- rbind(subject_test, subject_train)



#2 Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table("features.txt")

# Get all mean() and std() features only
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# Subset x data set for mean() and std() columns
x_data <- x_data[, mean_and_std_features]

# Label x data set correctly
names(x_data) <- features[mean_and_std_features, 2]



#3 Uses descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")

# Replace activity values with full activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# Label y data set correctly
names(y_data) <- "activity"



#4 Appropriately label the data set with descriptive variable names

# Label subject data set correctly
names(subject_data) <- "subject"

# Combine x/y/subject data into one data set
data <- cbind(x_data, y_data, subject_data)



#5 Create a second, independent tidy data set with the average of each variable for each activity and each subject

# Custom colMeans function to apply colMeans only to the appropriate variables
colMeans_avg_data <- function(x) {
    colMeans(x[1:66])
}

# Create new data set with averages of each variable
avg_data <- ddply(data, .(activity, subject), colMeans_avg_data)

# Export data set into separate text file
write.table(avg_data, "averages by activity and subject.txt", row.names = FALSE)