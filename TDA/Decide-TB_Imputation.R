rm(list = ls())

library(dplyr)
library(ggplot2)
library(tidyverse)

#### Multiple imputation

# For TB-Speed we are missing a few variables. In fact, for the HIV cohort we are missing night sweats 
# To solve this, I will try and impute night sweats based on the HIV positive information from RaPaed and Umoya. 

# The Ben Marais paper found 7/1415 (0.3%) prevalence in high burden communities 
# (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1720178/pdf/v090p01166.pdf)

library(mice)
load("/users/leylasophielarsson/Desktop/Studies/Decide-TB/Analysis/Data/Decide-TB_TB-Speed_HIVDataset.Rda")
load("/users/leylasophielarsson/Desktop/Studies/Decide-TB/Analysis/Data/Decide-TB_TB-Speed_CohortDataset.Rda")
load("/users/leylasophielarsson/Desktop/Studies/Decide-TB/Analysis/Data/Decide-TB_RaPaedDataset.Rda")
load("/users/leylasophielarsson/Desktop/Studies/Decide-TB/Analysis/Data/Decide-TB_UMOYADataset.Rda")

# Remove those who don't have a final diagnostic classification (HIV)
hiv <- subset(hiv, !is.na(DiagnClass_TDA))
hiv <- subset(hiv, !is.na(age_cat))

# Replace missing MTB results to negative 
hiv <- hiv %>% mutate(MTb_result = if_else(is.na(MTb_result), "MTB Negative", MTb_result),
                      Xpert_result = if_else(is.na(Xpert_result), "MTB Negative", Xpert_result),
                      BinaryResult = if_else(is.na(BinaryResult), "MTB Negative", BinaryResult))

# Replace no to NA
hiv_test <- hiv %>% mutate(nightsweats = if_else(nightsweats == "No", NA, nightsweats))

# Combine umoya and rapaed for HIV positive individuals
combined <- rbind(
  umoya[umoya$hivstatus == "HIV positive", ],
  rapaed[rapaed$hivstatus == "HIV positive", ],
  hiv_test
)

# Impute using the simputation package
library(simputation)

# Here, we are using a decision tree approach to predict night sweats status, using all other variables in the data
set.seed(1234)

combined_imp <- combined %>% impute_cart(nightsweats ~ age + TBContact + sam + 
                                       cough_2weeks + weightloss + fever_2weeks + 
                                       BinaryResult + CXR_cavitations)
hiv_imp <- subset(combined_imp, study=="HIV")

# Make a dataset where we said all no's and all yes's to night sweats to do sensitivity analyses 
hiv_no <- hiv 
hiv_yes <- hiv %>% mutate(nightsweats = if_else(nightsweats == "No", "Yes", nightsweats))

save(hiv_imp,file="/users/leylasophielarsson/Desktop/Studies/Decide-TB/Analysis/Data/Decide-TB_TB-Speed_HIVDataset_Imputed.Rda")
save(hiv_no,file="/users/leylasophielarsson/Desktop/Studies/Decide-TB/Analysis/Data/Decide-TB_TB-Speed_HIVDataset_noNS.Rda")
save(hiv_yes,file="/users/leylasophielarsson/Desktop/Studies/Decide-TB/Analysis/Data/Decide-TB_TB-Speed_HIVDataset_yesNS.Rda")

