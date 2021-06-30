library(tidyverse)
library(tidymodels)
library(textrecipes)
library(lubridate)
library(doMC)
library(finetune)
library(beepr)

air_folds_log <- read_rds("air_folds_log.rds")
sliced_set_log <- read_rds("sliced_set_log.rds")

registerDoMC(cores = 7)

# Tune

race_log <-
  sliced_set_log %>% 
  workflow_map(
    "tune_race_anova",
    seed = 33,
    resamples = air_folds_log,
    grid = 5,
    metrics = metric_set(rmse),
    control = control_race(
      save_pred = TRUE,
      save_workflow = FALSE,
      parallel_over = "everything"
    )
  )
beep()