# Load necessary libraries
library(dplyr)
library(here)

# Set the root directory for the project
here::i_am("R/data_importation.R")

# Load the dataset
swiss_dataset <- read.csv(here("data", "house_prices_switzerland.csv"), stringsAsFactors = FALSE)

# Convert the price into millions for better interpretability
swiss_dataset$PriceMillion <- round(swiss_dataset$Price / 1e6, 2)

# Create subsets of the data for different analyses
price_housetype_year <- swiss_dataset %>%
  filter(PriceMillion > 0) %>%
  select(PriceMillion, HouseType, YearBuilt) %>%
  na.omit()

price_housetype_size <- swiss_dataset %>%
  filter(PriceMillion > 0) %>%
  select(PriceMillion, HouseType, Size) %>%
  na.omit()

size_price_balcony <- swiss_dataset %>%
  filter(PriceMillion > 0) %>%
  select(Size, PriceMillion, Balcony) %>%
  na.omit()

price_loc_size_space_size <- swiss_dataset %>%
  filter(Locality %in% c('Lugano', 'Zürich', 'Basel', 'Lausanne', 'Sion') & PriceMillion > 0) %>%
  select(PriceMillion, Locality, Size, LivingSpace) %>%
  na.omit()

price_rooms_loc_space <- swiss_dataset %>%
  filter(Locality %in% c('Lugano', 'Zürich', 'Basel', 'Lausanne', 'Sion') & PriceMillion > 0) %>%
  select(PriceMillion, NumberRooms, Locality, LivingSpace) %>%
  na.omit()

# Convert NumberRooms to a factor
price_rooms_loc_space$NumberRooms <- as.factor(price_rooms_loc_space$NumberRooms)