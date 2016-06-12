
features <- read.table('features.txt')
features_mean_std <- grep("mean|std", features$V2)
features_mean_std_names <- features[features_mean_std, "V2"]

activities <- read.table('activity_labels.txt', col.names = c("ActivityId", "Activity"))

X_train <- read.table("train/X_train.txt")
X_train = X_train[features_mean_std]
names(X_train) = features_mean_std_names
X_train$Subject <- read.table("train/subject_train.txt")$V1
X_train$ActivityId <- read.table("train/y_train.txt")$V1

X_test <- read.table("test/X_test.txt")
X_test = X_test[features_mean_std]
names(X_test) = features_mean_std_names
X_test$Subject <- read.table("test/subject_test.txt")$V1
X_test$ActivityId <- read.table("test/y_test.txt")$V1

X <- rbind(X_train, X_test)

data <- aggregate(x = X, by = list(Sub = X$Subject, Act = X$ActivityId), FUN = mean)

data <- merge(data, activities, by = "ActivityId")

data <- subset(data, select = -c(Sub, Act, ActivityId))

write.table(data, file = "data.txt", row.names = F)
