library(data.table)
library(Metrics)

train <- fread('./project/volume/data/interim/train.csv')
test <- fread('./project/volume/data/interim/test.csv')

avg_sales <- mean(train$Weekly_Sales)

test$Weekly_Sales <- avg_sales

submit <- fread('./project/volume/data/raw/sampleSubmission.csv')

test$Id <- submit$Id
fwrite(test[, .(Id, Weekly_Sales)], './project/volume/data/processed/Null_model.csv')
