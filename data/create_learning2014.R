# Kimmo Kallonen - 05/11/2020
# Code for wrangling the data (downloaded from http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt)

library(dplyr)

# Load the dataset
learning2014 <- read.table("JYTOPKYS3-data.txt", sep="\t", header=TRUE)

## Data exploration ###

str(learning2014) # First thing to note is that the data set contains 183 subjects (i.e. data points)
                  # with 60 explanatory features for each


dim(filter(learning2014, gender == "F"))[1] / dim(learning2014)[1]
                  # It appears two thirds of the subjects are female

summary(learning2014$Age) # The age range is quite large from 17 to 55, with the median being 22


### Data wrangling ####
# Merge the questions into three categories
deep_q <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surf_q <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
stra_q <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

deep_columns <- select(learning2014, one_of(deep_q))
surf_columns <- select(learning2014, one_of(surf_q))
stra_columns <- select(learning2014, one_of(stra_q))

# Add columns to the data frame and scale them
learning2014$deep <- rowMeans(deep_columns)
learning2014$surf <- rowMeans(surf_columns)
learning2014$stra <- rowMeans(stra_columns)

# Drop the irrelevant columns
select_cols <- c("gender", "Age", "Attitude", "deep", "stra", "surf", "Points")
learning2014 <- select(learning2014, one_of(select_cols))

# Change column names to lowercase
colnames(learning2014)[2] <- "age"
colnames(learning2014)[3] <- "attitude"
colnames(learning2014)[7] <- "points"

# Filter out students who didn't attend the exam
learning2014 <- filter(learning2014, points > 0)

# Write the data frame to a file
write.table(learning2014, file="learning2014.txt", sep="\t")


### Check that it works ###
lrn14 <- read.table("learning2014.txt", sep="\t", header=TRUE)
str(lrn14)
head(lrn14) # Yes, the data and the strucutre are correct
