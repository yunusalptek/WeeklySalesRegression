library(caret)
library(data.table)
library(Metrics)

set.seed(770)

train <- fread('./project/volume/data/interim/train.csv')
test <- fread('./project/volume/data/interim/test.csv')
submit <- fread('./project/volume/data/raw/sampleSubmission.csv')

train_y <- train$Weekly_Sales
test$Weekly_Sales <- 0

master <- rbind(train, test)

dummies <- dummyVars(Weekly_Sales ~ ., data = master)
train <- predict(dummies, newdata = train)
test <- predict(dummies, newdata = test)

train <- data.table(train)
train$Weekly_Sales <- train_y
test <- data.table(test)

lm_model <- lm(Weekly_Sales ~ ., data = train)

summary(lm_model)

saveRDS(dummies, "./project/volume/models/WeeklySales_lm.dummies")
saveRDS(lm_model, "./project/volume/models/WeeklySales_lm.model")

test$Weekly_Sales <- predict(lm_model, newdata = test)

submit$Weekly_Sales <- test$Weekly_Sales

sum(is.na(submit$Weekly_Sales))
submit$Weekly_Sales[is.na(submit$Weekly_Sales)] <- mean(train$Weekly_Sales, na.rm = TRUE)

fwrite(submit, './project/volume/data/processed/submit_lm.csv')

test_y <- fread('./project/volume/data/raw/sampleSubmission.csv')$Weekly_Sales
rmse(test_y, mean(train_y))  # Null model RMSE
rmse(test_y, test$Weekly_Sales)  # Linear model RMSE

