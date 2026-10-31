# Load VDEM and keep relevant variables only

# Set working directory
username <- Sys.info()["user"]
if (username == "konst") {
  setwd("C:/Users/konst/Dropbox/Research/work-with-anders/JEL_data-analysis/")
} else if (username == "konstantinpoensgen") {
  setwd("/Users/konstantinpoensgen/Library/CloudStorage/Dropbox/Research/work-with-anders/JEL_data-analysis")
}

# Libraries 
library(dplyr)

# Load data
VDEM <- read.csv("input/V-Dem-CD-v14_csv_5jzTg6X/V-Dem-CY-Full+Others-v14.csv", header = TRUE, sep = ",")

# Keep relevant variables only
VDEM_reduced <- VDEM %>%
    select("country_name","country_text_id","country_id","year","historical_date", 
           "v2clrspct_osp", "v2stcritrecadm_osp", "v3ststeecap_osp", "v2x_accountability_osp", 
           "v2x_jucon", "v2xlg_legcon") %>%
    filter(year>=2018 & year<=2021)

# Write as CSV
write.csv(VDEM_reduced, "input/V-Dem-CD-v14_csv_5jzTg6X/VDEM_short.csv", row.names = FALSE)
rm(VDEM, VDEM_reduced)

