#=========================================================
# Theme 1: Total Emissions
# Data Cleaning and Preparation
#=========================================================

ls()

# Set working directory
setwd("/Users/ohnmarkyaw/Net_Zero_Project")

getwd

# Cleaning FAOSTAT Emissions Total file
# install.packages(c("tidyverse", "janitor"))
library(tidyverse)
library(janitor)

# Import raw file
emissions_total_raw <- read_csv("./raw_files/emissions_total_aggregate.csv")


# Clean column names
emissions_total_aggre_clean <- emissions_total_raw %>%
  clean_names()

# Filter to UK only
emissions_total_aggre_clean <- emissions_total_aggre_clean %>%
  filter(area == "United Kingdom of Great Britain and Northern Ireland")

# Keep useful columns only
emissions_total_aggre_clean <- emissions_total_aggre_clean %>%
  select(
    area,
    item,
    element,
    year,
    unit,
    value
  )

# View structure
str(emissions_total_aggre_clean)

# Check missing values
colSums(is.na(emissions_total_aggre_clean))

# Number of duplicate rows
sum(duplicated(emissions_total_aggre_clean))

# Check available items and elements
unique(emissions_total_aggre_clean$item) #29 items
unique(emissions_total_aggre_clean$element) #9 elements


# Save one cleaned file for Tableau
write_csv(emissions_total_aggre_clean, file = "./clean_files/emissions_total_aggre_clean.csv")

install.packages("summarytools")
library("summarytools")
dfSummary(emissions_total_aggre_clean, style = 'grid', graph.col = FALSE)