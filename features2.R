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

master$Date <- ymd(master$Date)
master$Month <- month(master$Date)
master$Week <- week(master$Date)

master <- merge(master, features, by = c("Store", "Date"))

train <- master[train == 1]
test <- master[train == 0]

train <- train[, .(Store, Dept, Month, Week, Temperature, Fuel_Price, CPI, Unemployment, IsHoliday, Weekly_Sales)]
test <- test[, .(Store, Dept, Month, Week, Temperature, Fuel_Price, CPI, Unemployment, IsHoliday)]

fwrite(train, "./project/volume/data/interim/train.csv")
fwrite(test, "./project/volume/data/interim/test.csv")