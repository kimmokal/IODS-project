# Kimmo Kallonen - 3/12/2020
# Code for wrangling "BPRS" and "Rats" data sets

library(dplyr)
library(tidyr)

# Load the data sets
bprs <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header=TRUE)
rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt")

# Take a look at them while they are in the wide form
str(bprs)
str(rats)

summary(bprs)
summary(rats)

# Convert the categorical variables to factors
bprs$treatment <- factor(bprs$treatment)
bprs$subject <- factor(bprs$subject)

rats$ID <- factor(rats$ID)
rats$Group <- factor(rats$Group)

# Convert the data sets to long form
bprsl <- bprs %>% gather(key = weeks, value = bprs, -treatment, -subject)
bprsl <- bprsl %>% mutate(week = as.integer(substr(bprsl$weeks, 5, 5)))

ratsl <- rats %>% gather(key = WD, value = Weight, -ID, -Group)
ratsl <- ratsl %>% mutate(Time = as.integer(substr(WD, 3,4))) 

# Take a "serious look" at the data sets now that they are in the long form
glimpse(bprsl)
glimpse(ratsl)

# The main difference is that in the long form every row corresponds to one observation
# whereas in the wide form each row corresponds to a subject and contains all observations
# related to that subject

# Write the data sets to files
write.table(bprsl, file="bprsl.csv", sep=",")
write.table(ratsl, file="ratsl.csv", sep=",")