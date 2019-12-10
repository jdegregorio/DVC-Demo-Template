# The purpose of this script is to:
#  - Import raw data from CSV
#  - Modify data types and perform basic cleaning
#  - Extract features
#  - Split train/test data

# SETUP -----------------------------------------------------------------------

# Clear memory
rm(list = ls())

# Load packages
library(tidyverse)
library(here)
library(feather)
library(caret)

# LOAD DATA -------------------------------------------------------------------

df.all <- read_csv(
  here("data", "heart.csv"),
  col_types = cols(
    age = col_double(),
    sex = col_factor(),
    cp = col_factor(),
    trestbps = col_double(),
    chol = col_double(),
    fbs = col_factor(),
    restecg = col_factor(),
    thalach = col_double(),
    exang = col_factor(),
    oldpeak = col_double(),
    slope = col_double(),
    ca = col_double(),
    thal = col_factor(),
    target = col_factor()
  )
)


# SPLIT TRAIN AND TEST DATA ---------------------------------------------------

index.split <- createDataPartition(df.all$target, p = 0.7, list = FALSE)

df.train <- df.all[index.split,]
df.test <- df.all[-index.split,]

# SAVE DATA -------------------------------------------------------------------

# Save full prepared data
write_feather(df.all, here("data", "data_prepared.feather"))

# Save train/test data
write_feather(df.train, here("data", "data_train.feather"))
write_feather(df.test, here("data", "data_test.feather"))
