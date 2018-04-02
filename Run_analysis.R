gcd.zip <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "gcd.zip")
unzip("gcd.zip")
library(dplyr)
library(data.table)
library(stringr)   

## read data files from home directory

setwd("~/Documents/ContImprove/R Programming/Getting-and-Cleaning-Data-Project/UCI HAR Dataset")

mytestdataX <- read.table(file = "test/X_test.txt", header = FALSE, sep = "")
mytestdataY <- read.table("test/Y_test.txt", header = FALSE)
Subject_Test <- read.table("test/subject_test.txt", header = FALSE)

mytraindataX <- read.table(file = "train/X_train.txt", header = FALSE, sep = "")
mytraindataY <- read.table("train/Y_train.txt", header = FALSE)
Subject_Train <- read.table("train/subject_train.txt", header = FALSE)

features <- read.table("features.txt", stringsAsFactors = FALSE)
activity <- read.table("activity_labels.txt")

## bind rows of test and train 

X <- rbind(mytestdataX, mytraindataX)
Y <- rbind(mytestdataY, mytraindataY)

Subject <- rbind(Subject_Test, Subject_Train)

## delete files that are not needed any longer

rm(mytestdataX, mytestdataY, mytraindataX, 
   mytraindataY, Subject_Test, Subject_Train)

## delete special characters

features$V2 <- str_replace_all(features$V2,"[-()]","")

## delete duplicate word 
features$V2 <- str_replace_all(features$V2,"BodyBody","Body")

## add descriptive variable names
features$V2 <- str_replace_all(features$V2,"t","time")
features$V2 <- str_replace_all(features$V2,"f","frequency")


## select names with mean and std

names(X) <- make.names(features$V2, unique = TRUE)
X <- select(X, matches("mean|std"))
X <- select(X, -ends_with("gravityMean"))##
X <- select(X, -ends_with("meanFreq"))
X <- select(X, -ends_with("meanFreqX"))
X <- select(X, -ends_with("meanFreqY"))
X <- select(X, -ends_with("meanFreqZ"))
X <- select(X, -ends_with("gravity"))

## add Subject column

X$Subject <- Subject$V1

X$V1 <- Y$V1

X <- left_join(X, activity)

X <- select(X, Subject, V2, 1:66, -V1)

## name X[2] activity

names(X)[2] <- "activity"

tidy <- X %>% group_by(Subject, activity) %>% summarise_all(mean)

write.table(tidy,"tidy.txt",row.name = FALSE)
