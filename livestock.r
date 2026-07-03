#=========================================================
# Theme 3: Livestock Emissions
# Data Cleaning and Preparation
#=========================================================

rm(list = ls())

setwd("/Users/ohnmarkyaw/Net_Zero_Project")
getwd()

library(tidyverse)
library(janitor)

#---------------------------------------------------------
# 1. Import livestock emissions datasets
#---------------------------------------------------------

livestock_raw <- read_csv("./raw_files/emissions_livestock.csv",
                          show_col_types = FALSE)

livestock_aggregate_raw <- read_csv("./raw_files/emissions_livestock_aggregate.csv",
                                    show_col_types = FALSE)

#---------------------------------------------------------
# 2. Clean column names and filter to UK
#---------------------------------------------------------

livestock_clean <- livestock_raw %>%
  clean_names() %>%
  filter(area == "United Kingdom of Great Britain and Northern Ireland") %>%
  select(area, item, element, year, unit, value)

livestock_aggregate_clean <- livestock_aggregate_raw %>%
  clean_names() %>%
  filter(area == "United Kingdom of Great Britain and Northern Ireland") %>%
  select(area, item, element, year, unit, value)

#---------------------------------------------------------
# 3. Data quality checks
#---------------------------------------------------------

str(livestock_clean)
colSums(is.na(livestock_clean))
sum(duplicated(livestock_clean))
unique(livestock_clean$item)
unique(livestock_clean$element)

str(livestock_aggregate_clean)
colSums(is.na(livestock_aggregate_clean))
sum(duplicated(livestock_aggregate_clean))
unique(livestock_aggregate_clean$item)
unique(livestock_aggregate_clean$element)

livestock_aggregate_clean %>%
  distinct(element, unit)

#---------------------------------------------------------
# 4. Export cleaned files for Tableau
#---------------------------------------------------------

write_csv(livestock_clean,
          "./clean_files/emissions_livestock_clean.csv")

write_csv(livestock_aggregate_clean,
          "./clean_files/emissions_livestock_aggregate_clean.csv")

install.packages("summarytools")
library("summarytools")

dfSummary(livestock_clean, style = 'grid', graph.col = FALSE)

dfSummary(livestock_aggregate_clean, style = 'grid', graph.col = FALSE)