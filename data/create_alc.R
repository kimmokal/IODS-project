# Kimmo Kallonen - 12/11/2020
# Code for wrangling data containing student performance information and alcohol consumption (downloaded from https://archive.ics.uci.edu/ml/datasets/Student+Performance)

library(dplyr)

# Load the data sets
d_mat=read.table("student-mat.csv", sep=";", header=TRUE)
d_por=read.table("student-por.csv", sep=";", header=TRUE)

# Join the two data sets by common columns
joined_cols <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
d_joined <- inner_join(d_mat, d_por, by = joined_cols, suffix=c(".math", ".por"))

# Let's have a look at the data
glimpse(d_joined)
# There are 382 students, and for each student there are 53 attribute.
# 13 of those attributes are the common columns by which we joined the data sets, and from each of the two data sets there are 20 additional attributes. 


# Create a new data frame with only the joined columns
alc <- select(d_joined, one_of(joined_cols))

# Get the columns in the data sets which were not used for joining the data
notjoined_cols <- colnames(d_mat)[!colnames(d_mat) %in% joined_cols]

for(column_name in notjoined_cols) {
  # Select the two columns from the joined data set with the same original name
  two_columns <- select(d_joined, starts_with(column_name))
  
  # Separate the first column
  first_column <- select(two_columns, 1)[[1]]

  # If the column is numeric, we take the average of the two columns. If not, then just the first column taken.
  if(is.numeric(first_column)) {
    alc[column_name] <- round(rowMeans(two_columns))
  } else {
    alc[column_name] <- first_column
  }
}

# Add two new columns to the data set
# alc_use is an average of weekday & weekend alcohol use, high_use is defined as TRUE if alc_use > 2
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)
 
# Have a glimpse at the data
glimpse(alc) # There are indeed 382 observations of 35 variables


# Write the data frame to a file
write.table(alc, file="alc_data.csv", sep=",")


### Check that it works ###
alc_data <- read.table("alc_data.csv", sep=",", header=TRUE)
glimpse(alc_data)   # Yes, it is correct
