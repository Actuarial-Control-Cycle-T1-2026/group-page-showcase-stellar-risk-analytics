############################## DATA PREPARATION ################################
### Download Packages
install.packages("readxl")
install.packages("dplyr")
install.packages("stringr")
install.packages("janitor")
install.packages("purrr")
install.packages("tidyr")
install.packages("MASS")
install.packages("rlang")
install.packages("gamlss")
install.packages("ggplot2")

library(readxl)
library(dplyr)
library(stringr)
library(janitor)
library(purrr)
library(tidyr)
library(MASS)
library(rlang)
library(gamlss)
library(ggplot2)

# File paths
bus_freq <- read_xlsx("srcsc-2026-claims-business-interruption.xlsx", sheet = "freq")
bus_sev <- read_xlsx("srcsc-2026-claims-business-interruption.xlsx",sheet = "sev")
econ <- read_xlsx("srcsc-2026-interest-and-inflation.xlsx")

options(scipen = 999) 

# Basic text cleaning
clean_text <- function(x) {
  x %>%
    as.character() %>%
    str_trim() %>%
    str_squish()
}

# Clean frequency data
bus_freq_clean <- bus_freq %>%
  clean_names() %>%
  mutate(across(where(is.character), clean_text)) %>%
  mutate(across(where(is.character), ~na_if(.x, ""))) %>%
  distinct() %>%
  filter(
    !is.na(policy_id),
    is.na(production_load)    | (production_load >= 0 & production_load <= 1),
    is.na(supply_chain_index) | (supply_chain_index >= 0 & supply_chain_index <= 1),
    is.na(avg_crew_exp)       | (avg_crew_exp >= 1 & avg_crew_exp <= 30),
    is.na(maintenance_freq)   | (maintenance_freq >= 0 & maintenance_freq <= 6),
    is.na(exposure)           | (exposure > 0 & exposure <= 1),
    is.na(claim_count)        | (claim_count >= 0 & claim_count <= 4),
    is.na(solar_system) | solar_system %in% c("Helionis Cluster", "Epsilon", "Zeta"),
    is.na(station_id) | str_detect(station_id, "^[A-Z][0-9]+$")
  ) %>%
  dplyr::mutate(
    energy_backup_score = as.numeric(as.character(energy_backup_score)),
    safety_compliance   = as.numeric(as.character(safety_compliance))
  ) %>%
  dplyr::mutate(
    energy_backup_score = round(energy_backup_score),
    safety_compliance   = round(safety_compliance)
  ) %>%
  dplyr::filter(
    energy_backup_score %in% 1:5,
    safety_compliance %in% 1:5
  ) %>%
  dplyr::mutate(
    energy_backup_score = factor(energy_backup_score),
    safety_compliance   = factor(safety_compliance)
  )

bus_freq_clean <- bus_freq_clean %>%
  mutate(
    solar_system = factor(solar_system, 
                          levels = c("Helionis Cluster", "Epsilon", "Zeta")),
    energy_backup_score = factor(energy_backup_score, levels = 1:5),
    safety_compliance   = factor(safety_compliance,   levels = 1:5)
  )

# Clean severity data
bus_sev_clean <- bus_sev %>%
  clean_names() %>%
  mutate(across(where(is.character), clean_text)) %>%
  mutate(across(where(is.character), ~na_if(.x, ""))) %>%
  distinct() %>%
  mutate(
    station_id   = str_to_upper(station_id),
    solar_system = str_squish(solar_system)
  ) %>%
  mutate(
    claim_amount         = as.numeric(claim_amount),
    claim_seq            = as.numeric(claim_seq),
    production_load      = as.numeric(production_load),
    exposure             = as.numeric(exposure),
    energy_backup_score  = as.numeric(as.character(energy_backup_score)),
    safety_compliance    = as.numeric(as.character(safety_compliance))
  ) %>%
  
  filter(
    !is.na(policy_id),      
    !is.na(claim_amount), 
    claim_amount >= 0,
    is.na(claim_seq) | (claim_seq >= 1 & claim_seq <= 4),
    is.na(production_load) | (production_load >= 0 & production_load <= 1),
    is.na(exposure) | (exposure > 0 & exposure <= 1),
    is.na(solar_system) | solar_system %in% c("Helionis Cluster", "Epsilon", "Zeta"),
    is.na(station_id) | str_detect(station_id, "^[A-Z][0-9]+$")
  )  %>%            
  
  mutate(
    energy_backup_score = round(energy_backup_score),
    safety_compliance   = round(safety_compliance)
  ) %>%
  filter(
    energy_backup_score %in% 1:5,
    safety_compliance %in% 1:5
  ) %>%
  mutate(
    energy_backup_score = factor(energy_backup_score, levels = 1:5),
    safety_compliance   = factor(safety_compliance, levels = 1:5),
    solar_system        = factor(solar_system, levels = c("Helionis Cluster", "Epsilon", "Zeta"))
  )

############################## DATA CALIBRATION ################################
# calculate IQR bounds
Q1 <- quantile(bus_sev_clean$claim_amount, 0.25, na.rm = TRUE)
Q3 <- quantile(bus_sev_clean$claim_amount, 0.75, na.rm = TRUE)
IQR_val <- Q3 - Q1

lower_bound <- Q1 - 1.5 * IQR_val
upper_bound <- Q3 + 1.5 * IQR_val

# remove extreme outliers
bus_sev_filtered <- bus_sev_clean %>%
  filter(claim_amount >= lower_bound,
         claim_amount <= upper_bound)

# calibrate to given range (data dictionary)
bus_sev_final <- bus_sev_filtered %>%
  mutate(
    claim_amount = pmax(pmin(claim_amount, 1426000), 28000)
  )

common_policies <- intersect(
  bus_freq_clean$policy_id,
  bus_sev_final$policy_id
)

bus_sev_final <- bus_sev_final %>%
  filter(policy_id %in% common_policies)


# comparison
n_before <- nrow(bus_sev_clean)
n_after  <- nrow(bus_sev_final)

n_before - n_after

summary(bus_sev_final$claim_amount)

boxplot(bus_sev_clean$claim_amount, main = "Before Cleaning")
boxplot(bus_sev_final$claim_amount, main = "After Cleaning")

############################## MODEL DATASETS ################################

# frequency dataset
bus_freq_model <- bus_freq_clean %>%
  dplyr::filter(!is.na(exposure), exposure > 0) %>%
  dplyr::select(
    policy_id,
    claim_count,
    exposure,
    production_load,
    energy_backup_score,
    supply_chain_index,
    avg_crew_exp,
    maintenance_freq,
    safety_compliance,
    solar_system
  ) %>%
  na.omit()

# severity dataset 
bus_sev_model <- bus_sev_final %>%
  left_join(
    bus_freq_clean %>%
      dplyr::select(policy_id, supply_chain_index, avg_crew_exp, maintenance_freq),
    by = "policy_id"
  ) %>%
  dplyr::select(
    claim_amount,
    production_load,
    energy_backup_score,
    supply_chain_index,
    avg_crew_exp,
    maintenance_freq,
    safety_compliance,
    solar_system
  ) %>%
  na.omit()

############################## FREQUENCY MODEL ################################

glm_freq_poisson <- glm(
  claim_count ~ production_load + energy_backup_score +
    supply_chain_index + avg_crew_exp +
    maintenance_freq + safety_compliance + solar_system,
  family = poisson(link = "log"),
  offset = log(exposure),
  data = bus_freq_model
)

summary(glm_freq_poisson)

# overdispersion check
overdispersion_ratio <- sum(residuals(glm_freq_poisson, type = "pearson")^2) / glm_freq_poisson$df.residual
overdispersion_ratio

# Negative Binomial
glm_freq_nb <- glm.nb(
  claim_count ~ production_load + energy_backup_score +
    supply_chain_index + avg_crew_exp +
    maintenance_freq + safety_compliance + solar_system +
    offset(log(exposure)),
  data = bus_freq_model
)

summary(glm_freq_nb)

# Fit your full model
bus_freq_full <- glm.nb(
  claim_count ~ production_load + energy_backup_score +
    supply_chain_index + avg_crew_exp + maintenance_freq +
    safety_compliance + solar_system + offset(log(exposure)),
  data = bus_freq_model,
  link = log
)

# Stepwise in both directions 
bus_freq_step <- stepAIC(bus_freq_full, direction = "both", trace = FALSE)

# See what survived
summary(bus_freq_step)

# Check the reduction in parameters
length(coef(bus_freq_full))
length(coef(bus_freq_step))

############################## SEVERITY MODEL ################################

bus_sev_gamma <- glm(
  claim_amount ~ production_load + energy_backup_score +
    supply_chain_index + avg_crew_exp +
    maintenance_freq + safety_compliance + solar_system,
  family = Gamma(link = "log"),
  data = bus_sev_model
)

summary(bus_sev_gamma)

# Gaussian GLM on log-transformed response
bus_sev_lognormal <- glm(
  log(claim_amount) ~ production_load + energy_backup_score +
    supply_chain_index + avg_crew_exp + maintenance_freq +
    safety_compliance + solar_system,
  family = gaussian(link = "identity"),
  data = bus_sev_model
)

# Extract residual variance 
sigma2 <- summary(bus_sev_lognormal)$dispersion

# Predicted claim amounts with bias correction
bus_sev_model$pred_lognormal <- exp(
  predict(bus_sev_lognormal, type = "response") + sigma2 / 2
)

bus_sev_invgauss <- glm(
  claim_amount ~ production_load + energy_backup_score +
    supply_chain_index + avg_crew_exp + maintenance_freq +
    safety_compliance + solar_system,
  family = inverse.gaussian(link = "log"),
  data = bus_sev_model
)

summary(bus_sev_invgauss)

# Compute a corrected log-likelihood
n <- nrow(bus_sev_model)
sigma2 <- summary(bus_sev_lognormal)$dispersion

ll_lognormal_corrected <- logLik(bus_sev_lognormal) -
  sum(log(bus_sev_model$claim_amount))

aic_lognormal_corrected <- -2 * as.numeric(ll_lognormal_corrected) +
  2 * length(coef(bus_sev_lognormal))

aic_lognormal_corrected
AIC(bus_sev_gamma)
AIC(bus_sev_invgauss)

############################## RELATIVITIES ################################
freq_coefs <- coef(bus_freq_step)
sev_coefs  <- coef(bus_sev_gamma)

freq_relativities <- data.frame(
  factor     = names(freq_coefs),
  coefficient = freq_coefs,
  relativity  = exp(freq_coefs)
)

sev_relativities <- data.frame(
  factor      = names(sev_coefs),
  coefficient = sev_coefs,
  relativity  = exp(sev_coefs)
)

# Key pricing relativities narrative
maint_relativity <- exp(coef(bus_freq_step)["maintenance_freq"]) 
sci_relativity   <- exp(coef(bus_freq_step)["supply_chain_index"])

maint_relativity #Maintenance freq relativity per unit
sci_relativity #Supply chain index relativity

energy_rels <- exp(c(0,
                     coef(bus_freq_step)["energy_backup_score2"],
                     coef(bus_freq_step)["energy_backup_score3"],
                     coef(bus_freq_step)["energy_backup_score4"],
                     coef(bus_freq_step)["energy_backup_score5"]
))
names(energy_rels) <- paste0("Score ", 1:5)
round(energy_rels, 3)

freq_relativities
sev_relativities

############################## DIAGNOSTIC PLOTS ################################

dev.off() 

par(mfrow = c(2,2), mar = c(3,3,2,1))
plot(bus_sev_gamma)

par(mfrow = c(1,1)) 

############################## PREDICTIONS ################################

# severity predictions
bus_sev_model$pred_sev <- predict(bus_sev_gamma , type = "response")
summary(bus_sev_model$pred_sev)

# frequency predictions (using NB)
bus_freq_model$pred_freq <- predict(bus_freq_step, type = "response")
summary(bus_freq_model$pred_freq)

# combine to get expected loss
loss_model <- bus_freq_model %>%
  mutate(
    pred_sev = predict(bus_sev_gamma, newdata = bus_freq_model, type = "response"),
    pred_loss_cost = pred_freq * pred_sev
  )

summary(loss_model$pred_loss_cost)

# Check all severity predictors exist in freq data
sev_predictors <- c("production_load", "energy_backup_score",
                    "supply_chain_index", "avg_crew_exp",
                    "maintenance_freq", "safety_compliance", "solar_system")

all(sev_predictors %in% names(bus_freq_model))  # must return TRUE

############################## RISK-DIFFERENTIATED PRICING ################################
base_loading <- 0.30

# Compute individual policy relativities from model coefficients
# Base policy: energy_backup_score=1, maintenance_freq=0, supply_chain_index=0
loss_model <- loss_model %>%
  mutate(
    # Frequency relativity vs base policy
    freq_relativity = pred_freq / mean(pred_freq),
    
    # Risk-adjusted loading: higher risk policies get higher loading
    # Policies with freq_relativity > 1 are riskier than average
    risk_loading = base_loading * (0.7 + 0.6 * freq_relativity),
    # This scales loading between ~0.37 (low risk) and ~0.43+ (high risk)
    # 0.7 + 0.6*1 = 1.3 → base_loading*1.3... adjust weights as needed
    
    # Final premium
    premium        = pred_loss_cost * (1 + risk_loading),
    
    # Flag policy tier based on loss cost
    policy_tier = case_when(
      pred_loss_cost <= quantile(pred_loss_cost, 0.33) ~ "Basic",
      pred_loss_cost <= quantile(pred_loss_cost, 0.67) ~ "Standard",
      TRUE                                              ~ "Comprehensive"
    )
  )

total_premium <- sum(loss_model$premium)

# Summary by tier
tier_summary <- loss_model %>%
  group_by(policy_tier) %>%
  summarise(
    n_policies       = n(),
    avg_loss_cost    = mean(pred_loss_cost),
    avg_loading      = mean(risk_loading),
    avg_premium      = mean(premium),
    total_premium    = sum(premium)
  )

tier_summary

############################## DEDUCTIBLE PRICING ################################
phi_sev_ded   <- summary(bus_sev_gamma)$dispersion
mu_sev_ded    <- mean(bus_sev_model$pred_sev)
shape_ded     <- 1 / phi_sev_ded
scale_ded     <- mu_sev_ded / shape_ded

lev_gamma <- function(limit, shape, scale) {
  mu <- shape * scale
  mu * pgamma(limit, shape + 1, scale = scale) +
    limit * (1 - pgamma(limit, shape, scale = scale))
}

excess_ev <- function(deductible, shape, scale) {
  mu <- shape * scale
  mu - lev_gamma(deductible, shape, scale)
}

deductibles <- c(0, 50000, 100000, 150000, 200000, 250000)

deductible_table <- data.frame(
  Deductible = deductibles,
  Expected_Insured_Loss = sapply(deductibles, excess_ev,
                                 shape = shape_ded, scale = scale_ded),
  Pct_of_Full_Coverage  = sapply(deductibles, excess_ev,
                                 shape = shape_ded, scale = scale_ded) /
    (shape_ded * scale_ded)
)

deductible_table$Premium_base_load <- 
  deductible_table$Expected_Insured_Loss * 1.30

deductible_table$Discount_vs_nil_ded <- 
  1 - deductible_table$Premium_base_load / deductible_table$Premium_base_load[1]

deductible_table

############################## SHORT-TERM MONTE CARLO ################################
set.seed(2026)

phi_sev    <- summary(bus_sev_gamma)$dispersion
shape_sev  <- 1 / phi_sev
theta_freq <- bus_freq_step$theta
n_sim      <- 10000

aggregate_losses_st      <- numeric(n_sim)
aggregate_losses_aad1b   <- numeric(n_sim)  # $1B AAD
aggregate_losses_aad2b   <- numeric(n_sim)  # $2B AAD

for (s in 1:n_sim) {
  total_loss_s <- 0
  shock <- rlnorm(1, meanlog = 0, sdlog = 0.2)
  
  for (i in 1:nrow(loss_model)) {
    n_claims_i <- rnbinom(1, size = theta_freq,
                          mu = loss_model$pred_freq[i])
    if (n_claims_i > 0) {
      mu_i    <- loss_model$pred_sev[i] * shock
      scale_i <- mu_i / shape_sev
      sev_i   <- rgamma(n_claims_i, shape = shape_sev, scale = scale_i)
      total_loss_s <- total_loss_s + sum(sev_i)
    }
  }
  
  aggregate_losses_st[s]    <- total_loss_s
  # AAD variants: insurer only pays above the AAD
  aggregate_losses_aad1b[s] <- pmax(total_loss_s - 1e9,  0)
  aggregate_losses_aad2b[s] <- pmax(total_loss_s - 2e9,  0)
}

aggregate_return_st     <- rep(total_premium, n_sim)
aggregate_net_revenue_st <- aggregate_return_st - aggregate_losses_st

# AAD impact summary
aad_comparison <- data.frame(
  Structure   = c("No AAD", "$1B AAD", "$2B AAD"),
  Mean_Loss   = c(mean(aggregate_losses_st),
                  mean(aggregate_losses_aad1b),
                  mean(aggregate_losses_aad2b)),
  P99_5_Loss  = c(quantile(aggregate_losses_st,    0.995),
                  quantile(aggregate_losses_aad1b, 0.995),
                  quantile(aggregate_losses_aad2b, 0.995)),
  Prob_Loss_Exceeds_Premium = c(
    mean(aggregate_losses_st    > total_premium),
    mean(aggregate_losses_aad1b > total_premium),
    mean(aggregate_losses_aad2b > total_premium)
  )
)

aad_comparison

############################## SHORT-TERM RESULTS ################################

short_term_cost_summary <- data.frame(
  metric = c("Mean", "SD", "Median", "CV", "95th percentile", "99th percentile", "99.5th percentile"),
  value = c(
    mean(aggregate_losses_st),
    sd(aggregate_losses_st),
    median(aggregate_losses_st),
    sd(aggregate_losses_st) / mean(aggregate_losses_st),
    quantile(aggregate_losses_st, 0.95),
    quantile(aggregate_losses_st, 0.99),
    quantile(aggregate_losses_st, 0.995)
  )
)

short_term_return_summary <- data.frame(
  metric = c("Mean", "SD", "Median", "CV", "95th percentile", "99th percentile", "99.5th percentile"),
  value = c(
    mean(aggregate_return_st),
    sd(aggregate_return_st),
    median(aggregate_return_st),
    sd(aggregate_return_st) / mean(aggregate_return_st),
    quantile(aggregate_return_st, 0.95),
    quantile(aggregate_return_st, 0.99),
    quantile(aggregate_return_st, 0.995)
  )
)

short_term_netrev_summary <- data.frame(
  metric = c("Mean", "SD", "Median", "CV", "5th percentile", "1st percentile", "0.5th percentile"),
  value = c(
    mean(aggregate_net_revenue_st),
    sd(aggregate_net_revenue_st),
    median(aggregate_net_revenue_st),
    sd(aggregate_net_revenue_st) / mean(aggregate_net_revenue_st),
    quantile(aggregate_net_revenue_st, 0.05),
    quantile(aggregate_net_revenue_st, 0.01),
    quantile(aggregate_net_revenue_st, 0.005)
  )
)

short_term_cost_summary
short_term_return_summary
short_term_netrev_summary

hist(
  aggregate_losses_st,
  breaks = 50,
  main = "Short-Term Aggregate BI Loss Distribution",
  xlab = "Aggregate Loss"
)

############################## ECONOMIC ASSUMPTIONS ################################
avg_inflation <- mean(econ$Inflation, na.rm = TRUE)
avg_r1 <- mean(econ$Rate1, na.rm = TRUE)
avg_r10 <- mean(econ$Rate10, na.rm = TRUE)

avg_inflation
avg_r1
avg_r10

############################## LONG-TERM MONTE CARLO ################################
set.seed(2026)

# Re-use model parameters
phi_sev    <- summary(bus_sev_gamma)$dispersion
shape_sev  <- 1 / phi_sev
theta_freq <- bus_freq_step$theta

years      <- 1:10
n_sim_lt   <- 10000

# Storage vectors
aggregate_losses_lt    <- numeric(n_sim_lt)
aggregate_losses_lt_aad1b <- numeric(n_sim_lt)  # $1B AAD variant
aggregate_losses_lt_aad2b <- numeric(n_sim_lt)  # $2B AAD variant

# Deterministic term structure (linear interpolation)
spot_rate_fn <- function(year, r1, r10) {
  if (year <= 1) {
    return(r1)
  } else if (year <= 10) {
    return(r1 + (r10 - r1) * (year - 1) / 9)
  } else {
    return(r10)
  }
}

# Pre-compute deterministic discount and inflation factors per year
year_factors <- data.frame(
  year               = years,
  inflation_factor   = (1 + avg_inflation)^years,
  discount_factor    = sapply(years, function(t)
    1 / (1 + spot_rate_fn(t, avg_r1, avg_r10))^t),
  spot_rate          = sapply(years, function(t)
    spot_rate_fn(t, avg_r1, avg_r10))
)

for (s in 1:n_sim_lt) {
  
  total_pv_loss_s <- 0
  
  for (t in years) {
    
    # Year-specific factors (pre-computed)
    inflation_factor_t <- year_factors$inflation_factor[t]
    discount_factor_t  <- year_factors$discount_factor[t]
    
    # Independent systemic shock per year
    # Models year-specific events e.g. solar storms, supply chain disruptions
    shock_t <- rlnorm(1, meanlog = 0, sdlog = 0.2)
    
    total_loss_t <- 0
    
    for (i in 1:nrow(loss_model)) {
      
      # Simulate claim count for policy i in year t
      n_claims_i <- rnbinom(
        1,
        size = theta_freq,
        mu   = loss_model$pred_freq[i]
      )
      
      if (n_claims_i > 0) {
        
        # Inflate severity by cumulative inflation and systemic shock
        mu_i_t    <- loss_model$pred_sev[i] * inflation_factor_t * shock_t
        scale_i_t <- mu_i_t / shape_sev
        
        sev_i <- rgamma(n_claims_i, shape = shape_sev, scale = scale_i_t)
        
        total_loss_t <- total_loss_t + sum(sev_i)
      }
    }
    
    # Discount annual loss back to present value
    pv_loss_t       <- total_loss_t * discount_factor_t
    total_pv_loss_s <- total_pv_loss_s + pv_loss_t
  }
  
  aggregate_losses_lt[s]       <- total_pv_loss_s
  aggregate_losses_lt_aad1b[s] <- pmax(total_pv_loss_s - 1e9,  0)
  aggregate_losses_lt_aad2b[s] <- pmax(total_pv_loss_s - 2e9,  0)
}

############################## LONG-TERM RETURN (STOCHASTIC) ################################

# PV of premium stream with stochastic retention and growth
aggregate_return_lt <- numeric(n_sim_lt)

set.seed(2026)  

for (s in 1:n_sim_lt) {
  pv_premium_s <- 0
  
  for (t in years) {
    inflation_factor_t <- year_factors$inflation_factor[t]
    discount_factor_t  <- year_factors$discount_factor[t]
    
    # Stochastic retention: beta distributed, mean ~90%
    retention_t <- rbeta(1, shape1 = 18, shape2 = 2)
    
    # Stochastic portfolio growth rate: normally distributed
    growth_t <- (1 + rnorm(1, mean = 0.03, sd = 0.01))^t
    
    pv_premium_s <- pv_premium_s +
      total_premium * inflation_factor_t * discount_factor_t *
      retention_t * growth_t
  }
  
  aggregate_return_lt[s] <- pv_premium_s
}

# Net revenue
aggregate_net_revenue_lt <- aggregate_return_lt - aggregate_losses_lt

############################## LONG-TERM RESULTS ################################

long_term_cost_summary <- data.frame(
  metric = c("Mean", "SD", "Median", "CV",
             "95th percentile", "99th percentile", "99.5th percentile"),
  value  = c(
    mean(aggregate_losses_lt),
    sd(aggregate_losses_lt),
    median(aggregate_losses_lt),
    sd(aggregate_losses_lt) / mean(aggregate_losses_lt),
    quantile(aggregate_losses_lt, 0.95),
    quantile(aggregate_losses_lt, 0.99),
    quantile(aggregate_losses_lt, 0.995)
  )
)

long_term_return_summary <- data.frame(
  metric = c("Mean", "SD", "Median", "CV",
             "95th percentile", "99th percentile", "99.5th percentile"),
  value  = c(
    mean(aggregate_return_lt),
    sd(aggregate_return_lt),
    median(aggregate_return_lt),
    sd(aggregate_return_lt) / mean(aggregate_return_lt),
    quantile(aggregate_return_lt, 0.95),
    quantile(aggregate_return_lt, 0.99),
    quantile(aggregate_return_lt, 0.995)
  )
)

long_term_netrev_summary <- data.frame(
  metric = c("Mean", "SD", "Median", "CV",
             "5th percentile", "1st percentile", "0.5th percentile"),
  value  = c(
    mean(aggregate_net_revenue_lt),
    sd(aggregate_net_revenue_lt),
    median(aggregate_net_revenue_lt),
    sd(aggregate_net_revenue_lt) / mean(aggregate_net_revenue_lt),
    quantile(aggregate_net_revenue_lt, 0.05),
    quantile(aggregate_net_revenue_lt, 0.01),
    quantile(aggregate_net_revenue_lt, 0.005)
  )
)

# AAD comparison 
lt_aad_comparison <- data.frame(
  Structure         = c("No AAD", "$1B AAD", "$2B AAD"),
  Mean_PV_Loss      = c(mean(aggregate_losses_lt),
                        mean(aggregate_losses_lt_aad1b),
                        mean(aggregate_losses_lt_aad2b)),
  P99_5_PV_Loss     = c(quantile(aggregate_losses_lt,       0.995),
                        quantile(aggregate_losses_lt_aad1b, 0.995),
                        quantile(aggregate_losses_lt_aad2b, 0.995)),
  Prob_Unprofitable = c(
    mean(aggregate_losses_lt       > mean(aggregate_return_lt)),
    mean(aggregate_losses_lt_aad1b > mean(aggregate_return_lt)),
    mean(aggregate_losses_lt_aad2b > mean(aggregate_return_lt))
  )
)

long_term_cost_summary
long_term_return_summary
long_term_netrev_summary
lt_aad_comparison

hist(
  aggregate_losses_lt,
  breaks = 50,
  main   = "Long-Term Aggregate BI PV Loss Distribution",
  xlab   = "Present Value Aggregate Loss ($)"
)

hist(
  aggregate_net_revenue_lt,
  breaks = 50,
  main   = "Long-Term Net Revenue Distribution",
  xlab   = "Net Revenue ($)",
  col    = ifelse(
    hist(aggregate_net_revenue_lt, breaks = 50, plot = FALSE)$mids < 0,
    "red", "steelblue"
  )
)

abline(v = 0, col = "red", lwd = 2, lty = 2)


################################ STRESS TESTING ################################
base_short_mean <- mean(aggregate_losses_st)
base_short_p995 <- quantile(aggregate_losses_st, 0.995)

base_long_mean <- mean(aggregate_losses_lt)
base_long_p995 <- quantile(aggregate_losses_lt, 0.995)

run_bi_stress <- function(freq_mult = 1, sev_mult = 1, n_sim = 10000) {
  
  stressed_losses <- numeric(n_sim)
  
  for (s in 1:n_sim) {
    total_loss_s <- 0
    shock_sev  <- rlnorm(1, meanlog = 0, sdlog = 0.20)
    shock_freq <- rlnorm(1, meanlog = 0, sdlog = 0.10)
    for (i in 1:nrow(loss_model)) {
      n_claims_i <- rnbinom(
        1,
        size = theta_freq,
        mu = loss_model$pred_freq[i] * freq_mult * shock_freq
      )
      
      if (n_claims_i > 0) {
        mu_i <- loss_model$pred_sev[i] * sev_mult * shock_sev
        scale_i <- mu_i / shape_sev
        
        sev_i <- rgamma(n_claims_i, shape = shape_sev, scale = scale_i)
        total_loss_s <- total_loss_s + sum(sev_i)
      }
    }
    
    stressed_losses[s] <- total_loss_s
  }
  
  c(
    Mean = mean(stressed_losses),
    SD = sd(stressed_losses),
    P95 = quantile(stressed_losses, 0.95),
    P99 = quantile(stressed_losses, 0.99),
    P99.5 = quantile(stressed_losses, 0.995)
  )
}

stress_base      <- run_bi_stress(1.0, 1.0, n_sim = 10000)
stress_freq      <- run_bi_stress(1.5, 1.0, n_sim = 10000)
stress_sev       <- run_bi_stress(1.0, 1.5, n_sim = 10000)
stress_combined  <- run_bi_stress(1.5, 1.5, n_sim = 10000)
stress_extreme   <- run_bi_stress(3.0, 3.0, n_sim = 10000)

stress_table <- data.frame(
  Scenario = c(
    "Baseline",
    "+50% Frequency",
    "+50% Severity",
    "Frequency & Severity (+50% each)",
    "Frequency & Severity (+200% each)"
  ),
  VaR_99_5 = c(
    stress_base[5],
    stress_freq[5],
    stress_sev[5],
    stress_combined[5],
    stress_extreme[5]
  ),
  change = c(
  stress_base[5]/stress_base[5]-1,
  stress_freq[5]/stress_base[5]-1,
  stress_sev[5]/stress_base[5]-1,
  stress_combined[5]/stress_base[5]-1,
  stress_extreme[5]/stress_base[5]-1  )
)

stress_table

############################## REINSURANCE STRUCTURING ################################
run_xl_reinsurance <- function(retention, xl_limit, n_sim = 10000) {
  insurer_net <- numeric(n_sim)
  
  for (s in 1:n_sim) {
    gross_loss <- 0
    shock <- rlnorm(1, meanlog = 0, sdlog = 0.2)
    
    for (i in 1:nrow(loss_model)) {
      n_claims_i <- rnbinom(1, size = theta_freq,
                            mu = loss_model$pred_freq[i])
      if (n_claims_i > 0) {
        mu_i    <- loss_model$pred_sev[i] * shock
        scale_i <- mu_i / shape_sev
        sev_i   <- rgamma(n_claims_i, shape = shape_sev, scale = scale_i)
        gross_loss <- gross_loss + sum(sev_i)
      }
    }
    
    reins_recovery <- pmin(pmax(gross_loss - retention, 0), xl_limit)
    insurer_net[s] <- gross_loss - reins_recovery
  }
  
  data.frame(
    Retention  = retention / 1e9,
    XL_Limit   = xl_limit  / 1e9,
    Net_Mean   = mean(insurer_net),
    Net_P99_5  = quantile(insurer_net, 0.995),
    Prob_Unprofitable = mean(insurer_net > total_premium)
  )
}

xl_results <- bind_rows(
  run_xl_reinsurance(retention = 15e9, xl_limit = 6e9),
  run_xl_reinsurance(retention = 12e9, xl_limit = 9e9),
  run_xl_reinsurance(retention = 18e9, xl_limit = 5e9)
)

xl_results

# Recommended structure based on results
cat("\nRecommended XL: retention $15B xs $6B\n")
cat("Reduces 99.5% VaR from", 
    round(quantile(aggregate_losses_st, 0.995)/1e9, 1), "B to",
    round(xl_results$Net_P99_5[1]/1e9, 1), "B\n")


############################## PER-POLICY RESULTS ################################
# deterministic expected loss
total_expected_loss <- sum(loss_model$pred_loss_cost)
avg_expected_loss_per_policy <- mean(loss_model$pred_loss_cost)

# number of policies
n_policies <- nrow(loss_model)

# TRUE per-policy expected loss (pricing view)
# this comes directly from the fitted frequency × severity model
summary(loss_model$pred_loss_cost)

per_policy_summary <- data.frame(
  metric = c("Mean", "SD", "Median", "75th percentile", "95th percentile", "99th percentile"),
  value = c(
    mean(loss_model$pred_loss_cost),
    sd(loss_model$pred_loss_cost),
    median(loss_model$pred_loss_cost),
    quantile(loss_model$pred_loss_cost, 0.75),
    quantile(loss_model$pred_loss_cost, 0.95),
    quantile(loss_model$pred_loss_cost, 0.99)
  )
)

per_policy_summary
############################## SOLAR SYSTEM SEGMENTATION ################################

# Build solar_summary as a plain data frame
solar_summary <- loss_model %>%
  group_by(solar_system) %>%
  summarise(
    n_policies    = n(),
    avg_pred_freq = mean(pred_freq),
    avg_pred_sev  = mean(pred_sev),
    avg_loss      = mean(pred_loss_cost),
    total_loss    = sum(pred_loss_cost),
    cv_loss       = sd(pred_loss_cost) / mean(pred_loss_cost)
  ) %>%
  ungroup()  # important — removes grouping so mutate works correctly

# Add the new columns separately
solar_summary$loss_share       <- solar_summary$total_loss / sum(solar_summary$total_loss)
solar_summary$tail_loading     <- (quantile(aggregate_losses_st, 0.995) - 
                                     mean(aggregate_losses_st)) * solar_summary$loss_share
solar_summary$risk_adj_premium <- solar_summary$total_loss + solar_summary$tail_loading
solar_summary$implied_loading  <- solar_summary$risk_adj_premium / solar_summary$total_loss - 1

solar_summary[, c("solar_system", "n_policies", "total_loss", 
                  "loss_share", "tail_loading", 
                  "risk_adj_premium", "implied_loading")]

############################## PORTFOLIO RESULTS ################################

# portfolio-level deterministic expected loss
total_expected_loss <- sum(loss_model$pred_loss_cost)

# portfolio stochastic summaries from Monte Carlo
short_term_portfolio_summary <- data.frame(
  metric = c("Mean", "SD", "Median", "CV", "95th percentile", "99th percentile", "99.5th percentile"),
  value = c(
    mean(aggregate_losses_st),
    sd(aggregate_losses_st),
    median(aggregate_losses_st),
    (sd(aggregate_losses_st) / mean(aggregate_losses_st)),
    quantile(aggregate_losses_st, 0.95),
    quantile(aggregate_losses_st, 0.99),
    quantile(aggregate_losses_st, 0.995)
  )
)

long_term_portfolio_summary <- data.frame(
  metric = c("Mean PV", "SD PV", "Median PV", "CV", "95th percentile PV", "99th percentile PV", "99.5th percentile PV"),
  value = c(
    mean(aggregate_losses_lt),
    sd(aggregate_losses_lt),
    median(aggregate_losses_lt),
    (sd(aggregate_losses_lt) / mean(aggregate_losses_lt)),
    quantile(aggregate_losses_lt, 0.95),
    quantile(aggregate_losses_lt, 0.99),
    quantile(aggregate_losses_lt, 0.995)
  )
)

short_term_portfolio_summary
long_term_portfolio_summary

############################## COMPARISON TABLE ################################

comparison_table <- data.frame(
  Measure = c(
    "Deterministic expected portfolio loss",
    "Average per-policy expected loss",
    "Short-term mean portfolio loss",
    "Short-term 99.5% VaR",
    "Long-term mean PV portfolio loss",
    "Long-term 99.5% VaR PV"
  ),
  Value = c(
    total_expected_loss,
    mean(loss_model$pred_loss_cost),
    mean(aggregate_losses_st),
    quantile(aggregate_losses_st, 0.995),
    mean(aggregate_losses_lt),
    quantile(aggregate_losses_lt, 0.995)
  )
)

comparison_table

