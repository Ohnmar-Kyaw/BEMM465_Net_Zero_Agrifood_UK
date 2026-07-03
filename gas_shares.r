# Load packages
library(tidyverse)
library(janitor)

# Import and clean aggregated emissions file
emissions_total_aggregate_clean <- read_csv(
  "./raw_files/emissions_total_aggregate.csv",
  show_col_types = FALSE
) %>%
  clean_names() %>%
  filter(area == "United Kingdom of Great Britain and Northern Ireland") %>%
  select(area, item, element, year, unit, value)

# Check it is a data frame
class(emissions_total_aggregate_clean)
glimpse(emissions_total_aggregate_clean)

# Find latest year
latest_year <- max(emissions_total_aggregate_clean$year, na.rm = TRUE)

# Create gas share table
gas_share <- emissions_total_aggregate_clean %>%
  filter(year == latest_year) %>%
  filter(element %in% c("Emissions (CH4)",
                        "Emissions (N2O)",
                        "Emissions (CO2)")) %>%
  filter(item %in% c("Emissions from crops",
                     "Emissions from livestock",
                     "Pre- and post-production")) %>%
  group_by(element) %>%
  mutate(share = value / sum(value, na.rm = TRUE) * 100) %>%
  ungroup()

# View result
gas_share

# Export for Tableau
write_csv(gas_share, "./clean_files/gas_share_latest_year.csv")