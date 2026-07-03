#=========================================================
# Theme 2: Crop Emissions
# Data Cleaning and Preparation
#=========================================================

rm(list = ls())

setwd("/Users/ohnmarkyaw/Net_Zero_Project")
getwd()

library(tidyverse)
library(janitor)

#---------------------------------------------------------
# 1. Import raw crop emissions datasets
#---------------------------------------------------------

crops_raw <- read_csv("./raw_files/emissions_crops.csv",
                      show_col_types = FALSE)

crops_aggregate_raw <- read_csv("./raw_files/emissions_crops_aggregate.csv",
                                show_col_types = FALSE)

#---------------------------------------------------------
# 2. Clean column names and filter to UK
#---------------------------------------------------------

crops_clean <- crops_raw %>%
  clean_names() %>%
  filter(area == "United Kingdom of Great Britain and Northern Ireland") %>%
  select(area, item, element, year, unit, value)

crops_aggregate_clean <- crops_aggregate_raw %>%
  clean_names() %>%
  filter(area == "United Kingdom of Great Britain and Northern Ireland") %>%
  select(area, item, element, year, unit, value)

#---------------------------------------------------------
# 3. Data quality checks
#---------------------------------------------------------

str(crops_clean)
colSums(is.na(crops_clean))
sum(duplicated(crops_clean))
unique(crops_clean$item)
unique(crops_clean$element)

str(crops_aggregate_clean)
colSums(is.na(crops_aggregate_clean))
sum(duplicated(crops_aggregate_clean))
unique(crops_aggregate_clean$item)
unique(crops_aggregate_clean$element)

# Checking units
crops_aggregate_clean %>%
  distinct(element, unit) %>%
  arrange(unit) #found out three unit differences: kg, kt, t

crops_clean %>%
  distinct(element, unit) %>%
  arrange(unit)

#---------------------------------------------------------
# 4. Export cleaned files for Tableau
#---------------------------------------------------------

write_csv(crops_clean, "./clean_files/emissions_crops_clean.csv")

write_csv(crops_aggregate_clean,
          "./clean_files/emissions_crops_aggregate_clean.csv")

install.packages("summarytools")
library("summarytools")

dfSummary(crops_clean, style = 'grid', graph.col = FALSE)

dfSummary(crops_aggregate_clean, style = 'grid', graph.col = FALSE)