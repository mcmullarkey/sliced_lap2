library(tidyverse)
library(tidymodels)
library(textrecipes)
library(lubridate)
library(doMC)
library(finetune)
library(beepr)

air_folds <- read_rds("air_folds.rds")
sliced_set <- read_rds("sliced_set.rds")

registerDoMC(cores = 7)

# Tune

race <-
  sliced_set %>% 
  workflow_map(
    "tune_race_anova",
    seed = 33,
    resamples = air_folds,
    grid = 5,
    metrics = metric_set(rmse),
    control = control_race(
      save_pred = TRUE,
      save_workflow = FALSE,
      parallel_over = "everything"
    )
  )
beep()