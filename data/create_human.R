# Kimmo Kallonen - 19/11/2020
# Code for wrangling "Human Development" and "Gender Inequality" data sets

library(dplyr)
library(stringr)

# Load the data sets
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Look at the two data sets
str(hd)
str(gii)
summary(hd)
summary(gii)
# Each data set contains 195 data points, corresponding to different countries. Excluding "country",
# there are 7 and 9 explanatory variables in the Human Development and Gender Inequality data sets, respectively 

# Rename the variables to shorter ones
hd <- rename(hd, HDI=Human.Development.Index..HDI., Life.Exp=Life.Expectancy.at.Birth,
             Edu.Exp=Expected.Years.of.Education, Edu.Mean=Mean.Years.of.Education, GNI=Gross.National.Income..GNI..per.Capita,
             GNI.Minus.Rank=GNI.per.Capita.Rank.Minus.HDI.Rank)
gii <- rename(gii, GII=Gender.Inequality.Index..GII., Mat.Mor=Maternal.Mortality.Ratio,
              Ado.Birth=Adolescent.Birth.Rate, Parli.F=Percent.Representation.in.Parliament,
              Edu2.F=Population.with.Secondary.Education..Female., Edu2.M=Population.with.Secondary.Education..Male.,
              Labo.F=Labour.Force.Participation.Rate..Female., Labo.M=Labour.Force.Participation.Rate..Male.)

# Add new columns for labour force participation and secondary education ratios between genders
gii <- mutate(gii, Labo.FM = (Labo.F/Labo.M), Edu2.FM = (Edu2.F/Edu2.M))

# Join the two data sets by country
human <- inner_join(hd, gii, by = c("Country"))

# Remove rows, which are related to regions rather than countries
last <- nrow(human) - 7
human <- human[1:last,]

# Mutate GNI from string to numeric
human <- mutate(human, GNI=str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric)

# Remove unwanted features
keep_cols = c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- select(human, one_of(keep_cols))

# Remove rows containing NA values
human <- filter(human, complete.cases(human)==TRUE)

# Set the countries as the row names and remove the Country column
row.names(human) <- human$Country
human <- select(human, -Country)

# Let's have a look at the data
head(human)
glimpse(human) # With 155 rows and 8 columns, the data looks as it should

# Write the data to a file
write.table(human, file="human.csv", sep=",")
