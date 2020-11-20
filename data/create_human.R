# Kimmo Kallonen - 19/11/2020
# Code for wrangling "Human Development" and "Gender Inequality" data sets

library(dplyr)

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
hd <- rename(hd, HDIrank=HDI.Rank, HDI=Human.Development.Index..HDI., lifeExp=Life.Expectancy.at.Birth,
             expEd=Expected.Years.of.Education, meanEd=Mean.Years.of.Education, GNI=Gross.National.Income..GNI..per.Capita,
             rankDiff=GNI.per.Capita.Rank.Minus.HDI.Rank)
gii <- rename(gii, GIIrank=GII.Rank, GII=Gender.Inequality.Index..GII., mortality=Maternal.Mortality.Ratio,
              birthrate=Adolescent.Birth.Rate, parliament=Percent.Representation.in.Parliament,
              edu2F=Population.with.Secondary.Education..Female., edu2M=Population.with.Secondary.Education..Male.,
              labF=Labour.Force.Participation.Rate..Female., labM=Labour.Force.Participation.Rate..Male.)

# Add new columns for labour force participation and secondary education ratios between genders
gii <- mutate(gii, labRatio = (labF/labM), edu2Ratio = (edu2F/edu2M))

# Join the two data sets by country
human <- inner_join(hd, gii, by = c("Country"))

# Let's have a look at the data
glimpse(human)
# There are 195 data points and 19 variables, as there should be

# Write the data to a file
write.table(human, file="human.csv", sep=",")
