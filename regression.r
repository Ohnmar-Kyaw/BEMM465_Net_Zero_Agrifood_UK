#=========================================================
# Regression Analysis: UK Agrifood Emissions
#=========================================================

rm(list = ls())

setwd("/Users/ohnmarkyaw/Net_Zero_Project")
getwd()

library(tidyverse)
library(janitor)

#---------------------------------------------------------
# 1. Import datasets
#---------------------------------------------------------

emissions_total <- read_csv("./clean_files/emissions_total_aggre_clean.csv",
                            show_col_types = FALSE)

crops_production <- read_csv("./raw_files/crops_production.csv",
                             show_col_types = FALSE) %>%
  clean_names()

livestock <- read_csv("./clean_files/emissions_livestock_clean.csv",
                      show_col_types = FALSE)

prepost <- read_csv("./clean_files/emissions_prepost_clean.csv",
                    show_col_types = FALSE)

#---------------------------------------------------------
# 2. Dependent variable: total agrifood emissions
#---------------------------------------------------------

y_total_emissions <- emissions_total %>%
  filter(
    item == "Agrifood systems",
    element == "Emissions (CO2eq) (AR5)",
    year >= 1990,
    year <= 2023
  ) %>%
  select(year, total_agrifood_emissions = value)

#---------------------------------------------------------
# 3. Crop predictor: wheat production quantity
#---------------------------------------------------------

x_wheat <- crops_production %>%
  filter(
    area == "United Kingdom of Great Britain and Northern Ireland",
    item == "Wheat",
    element == "Production",
    year >= 1990,
    year <= 2023
  ) %>%
  select(year, wheat_production_tonnes = value)

#---------------------------------------------------------
# 4. Livestock predictor: total cattle stocks
# Dairy cattle + non-dairy cattle
#---------------------------------------------------------

x_cattle <- livestock %>%
  filter(
    item %in% c("Cattle, dairy", "Cattle, non-dairy"),
    element == "Stocks",
    year >= 1990,
    year <= 2023
  ) %>%
  group_by(year) %>%
  summarise(
    cattle_stocks = sum(value, na.rm = TRUE),
    .groups = "drop"
  )

#---------------------------------------------------------
# 5. Pre/post predictor: food household consumption emissions
#---------------------------------------------------------

x_household <- prepost %>%
  filter(
    item == "Food Household Consumption",
    element == "Emissions (CO2eq) (AR5)",
    year >= 1990,
    year <= 2023
  ) %>%
  select(year, household_consumption_emissions = value)

#---------------------------------------------------------
# 6. Check each variable before merging
#---------------------------------------------------------

nrow(y_total_emissions)
nrow(x_wheat)
nrow(x_cattle)
nrow(x_household)

head(y_total_emissions)
head(x_wheat)
head(x_cattle)
head(x_household)

#---------------------------------------------------------
# 7. Merge regression dataset by year
#---------------------------------------------------------

regression_data <- y_total_emissions %>%
  inner_join(x_wheat, by = "year") %>%
  inner_join(x_cattle, by = "year") %>%
  inner_join(x_household, by = "year") %>%
  drop_na()

# Check merged dataset
nrow(regression_data)
glimpse(regression_data)
summary(regression_data)

# Save regression dataset
write_csv(regression_data, "./clean_files/regression_data.csv")

#---------------------------------------------------------
# 8. Run multiple linear regression
#---------------------------------------------------------

model <- lm(
  total_agrifood_emissions ~ wheat_production_tonnes +
    cattle_stocks +
    household_consumption_emissions,
  data = regression_data
)

summary(model)

#---------------------------------------------------------
# 9. Diagnostic plots
#---------------------------------------------------------

par(mfrow = c(2, 2))
plot(model)
par(mfrow = c(1, 1))

nrow(regression_data)

install.packages("car")

library(car)

vif(model)

shapiro.test(residuals(model))

