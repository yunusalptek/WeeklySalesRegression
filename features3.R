library(data.table)
library(lubridate)

set.seed(77)

features <- fread("./project/volume/data/raw/features.csv")
sampleSubmission <- fread("./project/volume/data/raw/sampleSubmission.csv")
stores <- fread("./project/volume/data/raw/stores.csv")
test <- fread("./project/volume/data/raw/test.csv")
train <- fread("./project/volume/data/raw/train.csv")

train$train <- 1
test$train <- 0

master <- rbind(train, test, fill = TRUE)

master$Date <- as.Date(master$Date, "%m/%d/%Y")
master$Year <- year(master$Date)
master$Week <- week(master$Date)

master <- master[order(Store, Dept, Date)]
master[, Previous_Year_Sales := shift(Weekly_Sales, 52), by = .(Store, Dept)]

master[, Previous_Year_Sales := ifelse(is.na(Previous_Year_Sales), mean(Weekly_Sales, na.rm = TRUE), Previous_Year_Sales), by = .(Store, Dept)]

train <- master[train == 1, .(Store, Dept, Date, IsHoliday, Previous_Year_Sales, Weekly_Sales)]
test <- master[train == 0, .(Store, Dept, Date, IsHoliday, Previous_Year_Sales)]

fwrite(train, './project/volume/data/interim/train.csv')
fwrite(test, './project/volume/data/interim/test.csv')
