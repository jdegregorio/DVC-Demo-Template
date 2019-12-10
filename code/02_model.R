# The purpose of this script is to train a classifier model.

# SETUP -----------------------------------------------------------------------

# Clear memory
rm(list = ls())

# Load packages
library(tidyverse)
library(here)
library(feather)
library(caret)

# Load training data
df.train <- read_feather(here("data", "data_train.feather"))
df.test <- read_feather(here("data", "data_test.feather"))

# Configure training parameters
param.train <- trainControl(
  method = "repeatedcv",
  number = 5,
  repeats = 10,
  classProbs = TRUE
)

# TRAIN MODEL -----------------------------------------------------------------

# Fit model
fit <- train(
  x = df.train %>% select(-target),
  y = df.train$target,
  method = "rpart",
  tuneLength = 5
)

# Print fit
print(fit)

# EVALUATE MODEL --------------------------------------------------------------

# Create dataframe with observed vs. predicted
df.res <- 
  data.frame(
    obs = df.test$target, 
    pred = predict(fit, newdata = df.test)
  )

# Evaluate metrics on test data
confusion <- confusionMatrix(df.res$obs, df.res$pred)
df.eval <- 
  bind_rows(
    confusion$overall %>% enframe(),
    confusion$byClass %>% enframe()
  ) %>%
  spread(name, value)

# SAVE DATA -------------------------------------------------------------------

write_rds(fit, here("data", "model.rds"))
write_csv(df.eval, here("data", "eval.csv"))
