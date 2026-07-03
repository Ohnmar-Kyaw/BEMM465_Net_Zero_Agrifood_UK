#=========================================================
# Theme 4: Pre- and Post-Production Emissions
# Data Cleaning and Preparation
#=========================================================

rm(list = ls())

setwd("/Users/ohnmarkyaw/Net_Zero_Project")
getwd()

library(tidyverse)
library(janitor)

# Import files
prepost_raw <- read_csv("./raw_files/emissions_prepost.csv",
                        show_col_types = FALSE)

prepost_aggregate_raw <- read_csv("./raw_files/emissions_prepost_aggregate.csv",
                                  show_col_types = FALSE)

# Clean detailed file
prepost_clean <- prepost_raw %>%
  clean_names() %>%
  filter(area == "United Kingdom of Great Britain and Northern Ireland") %>%
  select(area, item, element, year, unit, value)

# Clean aggregate file
prepost_aggregate_clean <- prepost_aggregate_raw %>%
  clean_names() %>%
  filter(area == "United Kingdom of Great Britain and Northern Ireland") %>%
  select(area, item, element, year, unit, value)

# Check available items and elements
unique(prepost_clean$item)
unique(prepost_clean$element)

unique(prepost_aggregate_clean$item)
unique(prepost_aggregate_clean$element)

# Check units
prepost_clean %>%
  distinct(element, unit)

prepost_aggregate_clean %>%
  distinct(element, unit)

# Export cleaned files
write_csv(prepost_clean,
          "./clean_files/emissions_prepost_clean.csv")

write_csv(prepost_aggregate_clean,
          "./clean_files/emissions_prepost_aggregate_clean.csv")

library("summarytools")

dfSummary(prepost_clean, style = 'grid', graph.col = FALSE)

dfSummary(prepost_aggregate_clean, style = 'grid', graph.col = FALSE)