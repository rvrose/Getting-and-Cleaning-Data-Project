gcd.zip <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "gcd.zip")
unzip("gcd.zip")
library(dplyr)
library(data.table)

## read data files from home directory



mytestdataX <- read.table(file = "test/X_test.txt", header = FALSE, sep = "")
mytestdataY <- read.table("test/Y_test.txt", header = FALSE)
Subject_Test <- read.table("test/subject_test.txt", header = FALSE)

mytraindataX <- read.table(file = "train/X_train.txt", header = FALSE, sep = "")
mytraindataY <- read.table("train/Y_train.txt", header = FALSE)
Subject_Train <- read.table("train/subject_train.txt", header = FALSE)

features <- read.table("features.txt", stringsAsFactors = FALSE)
activity <- read.table("activity_labels.txt")

X <- rbind(mytestdataX,mytraindataX)
Y <- rbind(mytestdataY,mytraindataY)
Subject <- rbind(Subject_Test,Subject_Train)

X$Subject <- Subject$V1

names(X) <- make.names(features$V2, unique = TRUE)
X <- select(X, matches("mean|std"))

X$V1 <- Y$V1

X <- left_j
oin(X, activity)

X <- select(X, Subject,V2,1:86,-V1)

names(X)[2] <- "activity"

tidy <- X %>% group_by(Subject, activity) %>% summarise_all(mean)


write.table(tidy,"tidy.txt",row.name = FALSE)


##X <- X[,meanandstd[,1]]
##dim(X)