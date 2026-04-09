# Load required libraries
library(tidyverse)
library(fitdistrplus)

set.seed(2026)

# =============================================================================
# PART 1: LOAD ALL DATASETS (ONLY THESE THREE ARE NEEDED)
# =============================================================================

# Workers' compensation historical frequency (worker‑level)
freq_data <- read.csv("C:/Users/kiere/Downloads/srcsc-2026-claims-workers-comp.csv", 
                      stringsAsFactors = FALSE)

# Workers' compensation historical severity (claim‑level)
sev_data <- read.csv("C:/Users/kiere/Downloads/Workers Comp Sev.csv", 
                     stringsAsFactors = FALSE)

# New business data: personnel summary (CSV with commas in numbers)
personnel <- read.csv("C:/Users/kiere/Downloads/srcsc-2026-cosmic-quarry-personnel.csv",
                      stringsAsFactors = FALSE, check.names = FALSE)

# Economic data: interest and inflation rates (CSV)
# Read as character first to handle any formatting issues
econ <- read.csv("C:/Users/kiere/Downloads/srcsc-2026-interest-and-inflation.csv",
                 stringsAsFactors = FALSE, check.names = FALSE)

cat("\nWorkers' comp frequency: ", nrow(freq_data), " rows")
cat("\nWorkers' comp severity:  ", nrow(sev_data), " rows")
cat("\nPersonnel data:          ", nrow(personnel), " rows")
cat("\nEconomic data:           ", nrow(econ), " rows\n")

# =============================================================================
# PART 2: CLEAN WORKERS' COMPENSATION DATA
# =============================================================================

# ---- Frequency data ----
allowed_values <- list(
  claim_count = 0:2,
  hours_per_week = c(20, 25, 30, 35, 40),
  psych_stress_index = 1:5,
  safety_training_index = 1:5,
  protective_gear_quality = 1:5
)

allowed_ranges <- list(
  gravity_level = c(0.75, 1.50),
  supervision_level = c(0, 1),
  experience_yrs = c(0.2, 40),
  base_salary = c(20000, 130000),
  exposure = c(0, 1)
)

freq_clean <- freq_data
changes <- data.frame(variable = character(), issue = character(), count = integer(),
                      stringsAsFactors = FALSE)

if("claim_count" %in% names(freq_clean)) {
  orig <- freq_clean$claim_count
  freq_clean$claim_count <- pmin(pmax(orig, 0), 2)
  ch <- sum(orig != freq_clean$claim_count, na.rm = TRUE)
  if(ch > 0) changes <- rbind(changes, data.frame(variable="claim_count",
                                                  issue="capped to 0-2", count=ch))
}

for(var in names(allowed_values)) {
  if(var %in% names(freq_clean) && var != "claim_count") {
    orig <- freq_clean[[var]]
    allowed <- allowed_values[[var]]
    bad <- which(!orig %in% allowed & !is.na(orig))
    if(length(bad) > 0) {
      for(i in bad) freq_clean[[var]][i] <- allowed[which.min(abs(allowed - orig[i]))]
      changes <- rbind(changes, data.frame(variable=var,
                                           issue=paste("replaced", length(bad), "invalid"),
                                           count=length(bad)))
    }
  }
}

for(var in names(allowed_ranges)) {
  if(var %in% names(freq_clean)) {
    orig <- freq_clean[[var]]
    minv <- allowed_ranges[[var]][1]
    maxv <- allowed_ranges[[var]][2]
    low <- sum(orig < minv, na.rm = TRUE)
    high <- sum(orig > maxv, na.rm = TRUE)
    if(low+high > 0) {
      freq_clean[[var]] <- pmin(pmax(orig, minv), maxv)
      changes <- rbind(changes, data.frame(variable=var,
                                           issue=paste("clipped", low+high, "values"),
                                           count=low+high))
    }
  }
}

cat("\n", rep("=", 60), "\n", sep="")
cat("WORKERS' COMP FREQUENCY CLEANING")
cat("\n", rep("=", 60), "\n", sep="")
print(changes)

# Clean solar system names
freq_clean <- freq_clean %>%
  mutate(solar_system_clean = str_replace(solar_system, "_.*", "")) %>%
  mutate(solar_system_clean = ifelse(solar_system_clean %in% c("Epsilon", "Zeta", "Helionis Cluster"),
                                     solar_system_clean, "Other"))

# ---- Severity data ----
sev_clean <- sev_data %>% filter(!is.na(claim_amount))
sev_changes <- data.frame(variable = character(), issue = character(), count = integer(),
                          stringsAsFactors = FALSE)

if("claim_amount" %in% names(sev_clean)) {
  orig <- sev_clean$claim_amount
  sev_clean$claim_amount <- pmin(pmax(orig, 5), 170)
  ch <- sum(orig != sev_clean$claim_amount, na.rm = TRUE)
  if(ch > 0) sev_changes <- rbind(sev_changes,
                                  data.frame(variable="claim_amount",
                                             issue="clipped to 5-170", count=ch))
}

if("claim_length" %in% names(sev_clean)) {
  orig <- sev_clean$claim_length
  sev_clean$claim_length <- pmin(pmax(orig, 3), 1000)
  ch <- sum(orig != sev_clean$claim_length, na.rm = TRUE)
  if(ch > 0) sev_changes <- rbind(sev_changes,
                                  data.frame(variable="claim_length",
                                             issue="clipped to 3-1000", count=ch))
}

if("injury_type" %in% names(sev_clean)) {
  sev_clean$injury_type <- gsub("_\\?+[0-9]+", "", sev_clean$injury_type)
  sev_clean$injury_type <- gsub("\\?+[0-9]+", "", sev_clean$injury_type)
  sev_clean$injury_type <- gsub("_$", "", sev_clean$injury_type)
  sev_clean$injury_type[sev_clean$injury_type == ""] <- "Unknown"
}

cat("\n", rep("=", 60), "\n", sep="")
cat("WORKERS' COMP SEVERITY CLEANING")
cat("\n", rep("=", 60), "\n", sep="")
print(sev_changes)

# =============================================================================
# PART 3: PROCESS PERSONNEL DATA
# =============================================================================

# Rename columns
colnames(personnel) <- c("Role", "Employees", "Full_Time", "Contract", "Salary", "Avg_Age")

# Remove any rows where Role is NA or empty
personnel <- personnel %>% filter(!is.na(Role) & Role != "")

# Helper to convert numbers with commas
clean_number <- function(x) {
  as.numeric(gsub(",", "", as.character(x)))
}

personnel <- personnel %>%
  mutate(
    Employees = clean_number(Employees),
    Full_Time = clean_number(Full_Time),
    Contract = clean_number(Contract),
    Salary = clean_number(Salary),
    Avg_Age = as.numeric(Avg_Age)
  )

# Calculate totals
total_employees <- sum(personnel$Employees, na.rm = TRUE)
total_fulltime <- sum(personnel$Full_Time, na.rm = TRUE)
total_contract <- sum(personnel$Contract, na.rm = TRUE)
total_payroll <- sum(personnel$Employees * personnel$Salary, na.rm = TRUE)

cat("\n", rep("=", 60), "\n", sep="")
cat("NEW BUSINESS PERSONNEL SUMMARY")
cat("\n", rep("=", 60), "\n", sep="")
cat("\nTotal employees:       ", total_employees)
cat("\n  Full‑time:           ", total_fulltime)
cat("\n  Contract:            ", total_contract)
cat("\nTotal annual payroll:  ", format(round(total_payroll), big.mark=","), " credits")
cat("\nAverage salary:        ", round(total_payroll/total_employees), " credits\n")

new_workers <- total_employees
# =============================================================================
# PART 4: PROCESS ECONOMIC DATA - ROBUST VERSION WITH DEBUGGING
# =============================================================================

# Read the CSV
econ <- read.csv("C:/Users/kiere/Downloads/srcsc-2026-interest-and-inflation.csv",
                 stringsAsFactors = FALSE)

# Display raw data structure for debugging
cat("\n", rep("=", 60), "\n", sep="")
cat("DEBUG: Raw Economic Data Structure")
cat("\n", rep("=", 60), "\n", sep="")
cat("\nColumn names:", paste(names(econ), collapse = ", "))
cat("\nFirst few rows:\n")
print(head(econ))
cat("\nData types:\n")
print(sapply(econ, class))

# Rename columns to standard names
names(econ) <- c("Year", "Inflation", "OvernightRate", "Rate1Yr", "Rate10Yr")

# FORCE everything to numeric by removing any non-numeric characters
econ$Year <- as.numeric(gsub("[^0-9.-]", "", econ$Year))
econ$Inflation <- as.numeric(gsub("[^0-9.-]", "", econ$Inflation))
econ$OvernightRate <- as.numeric(gsub("[^0-9.-]", "", econ$OvernightRate))
econ$Rate1Yr <- as.numeric(gsub("[^0-9.-]", "", econ$Rate1Yr))
econ$Rate10Yr <- as.numeric(gsub("[^0-9.-]", "", econ$Rate10Yr))

# Check for any NAs after conversion
cat("\n", rep("=", 60), "\n", sep="")
cat("DEBUG: After Numeric Conversion")
cat("\n", rep("=", 60), "\n", sep="")
cat("\nRows with NAs:\n")
print(econ[!complete.cases(econ), ])
cat("\nColumn summaries:\n")
print(summary(econ))

# Use most recent year (last row)
current_year <- econ$Year[nrow(econ)]
current_inflation <- econ$Inflation[nrow(econ)]
current_1yr_rate <- econ$Rate1Yr[nrow(econ)]
current_10yr_rate <- econ$Rate10Yr[nrow(econ)]

# Verify they're numeric
cat("\n", rep("=", 60), "\n", sep="")
cat("DEBUG: Current Values")
cat("\n", rep("=", 60), "\n", sep="")
cat("\ncurrent_year class:", class(current_year))
cat("\ncurrent_inflation class:", class(current_inflation))
cat("\ncurrent_1yr_rate class:", class(current_1yr_rate))
cat("\ncurrent_10yr_rate class:", class(current_10yr_rate))

# Force them to numeric if they aren't already
current_year <- as.numeric(current_year)
current_inflation <- as.numeric(current_inflation)
current_1yr_rate <- as.numeric(current_1yr_rate)
current_10yr_rate <- as.numeric(current_10yr_rate)

# Final output
cat("\n", rep("=", 60), "\n", sep="")
cat("CURRENT ECONOMIC ASSUMPTIONS (", current_year, ")")
cat("\n", rep("=", 60), "\n", sep="")
cat("\nInflation rate:        ", ifelse(is.na(current_inflation), "ERROR", 
                                        paste0(round(current_inflation*100,2), "%")))
cat("\n1‑year risk‑free rate: ", ifelse(is.na(current_1yr_rate), "ERROR",
                                        paste0(round(current_1yr_rate*100,2), "%")))
cat("\n10‑year risk‑free rate: ", ifelse(is.na(current_10yr_rate), "ERROR",
                                         paste0(round(current_10yr_rate*100,2), "%\n")))

# =============================================================================
# PART 5: FREQUENCY ANALYSIS (HISTORICAL)
# =============================================================================

total_workers_hist <- nrow(freq_clean)
total_claims_hist <- sum(freq_clean$claim_count, na.rm = TRUE)
avg_freq_hist <- total_claims_hist / total_workers_hist

cat("\n", rep("=", 60), "\n", sep="")
cat("HISTORICAL FREQUENCY ANALYSIS")
cat("\n", rep("=", 60), "\n", sep="")
cat("\nWorkers in historical data: ", total_workers_hist)
cat("\nTotal historical claims:    ", total_claims_hist)
cat("\nAverage frequency:          ", round(avg_freq_hist, 4), " per worker-year")

claim_probs <- prop.table(table(factor(freq_clean$claim_count, levels = 0:2)))
cat("\n\nP(0 claims): ", round(claim_probs["0"]*100,2), "%")
cat("\nP(1 claim):  ", round(claim_probs["1"]*100,2), "%")
cat("\nP(2 claims): ", round(claim_probs["2"]*100,2), "%")

# =============================================================================
# PART 6: SEVERITY ANALYSIS (HISTORICAL)
# =============================================================================

if("claim_amount" %in% names(sev_clean) && nrow(sev_clean) > 0) {
  
  if(length(unique(sev_clean$claim_amount)) == 1) {
    cat("\n\nWARNING: All claim amounts are identical (", unique(sev_clean$claim_amount)[1], " credits)\n")
    cat("Using lognormal with small variation for simulation.\n")
    log_mean <- log(170)
    log_sd <- 0.01
  } else {
    sev_stats <- sev_clean %>%
      summarise(
        mean = mean(claim_amount, na.rm = TRUE),
        sd = sd(claim_amount, na.rm = TRUE),
        min = min(claim_amount, na.rm = TRUE),
        q25 = quantile(claim_amount, 0.25, na.rm = TRUE),
        median = median(claim_amount, na.rm = TRUE),
        q75 = quantile(claim_amount, 0.75, na.rm = TRUE),
        max = max(claim_amount, na.rm = TRUE)
      )
    cat("\n\nOverall claim severity (credits):\n")
    print(round(sev_stats, 0))
    
    log_mean <- mean(log(sev_clean$claim_amount), na.rm = TRUE)
    log_sd   <- sd(log(sev_clean$claim_amount), na.rm = TRUE)
  }
  
  cat("\nLognormal parameters for simulation:")
  cat("\n  meanlog = ", round(log_mean, 3))
  cat("\n  sdlog   = ", round(log_sd, 3))
}

# =============================================================================
# PART 7: EXPOSURE SCALING FOR NEW BUSINESS
# =============================================================================

expected_claims_new <- avg_freq_hist * new_workers

cat("\n\n", rep("=", 60), "\n", sep="")
cat("EXPOSURE SCALING")
cat("\n", rep("=", 60), "\n", sep="")
cat("\nNew business workers:      ", new_workers)
cat("\nHistorical workers:        ", total_workers_hist)
cat("\nScale factor:              ", round(new_workers/total_workers_hist, 2))
cat("\nExpected claims (new):     ", round(expected_claims_new, 1))

# =============================================================================
# PART 8: SHORT‑TERM AGGREGATE LOSS SIMULATION (1 YEAR)
# =============================================================================

n_sims <- 10000
set.seed(2026)

sim_claims <- rpois(n_sims, expected_claims_new)
max_claims <- max(sim_claims)
if(max_claims == 0) max_claims <- 1

all_sev <- rlnorm(n_sims * max_claims, meanlog = log_mean, sdlog = log_sd)
all_sev <- pmin(pmax(all_sev, 5), 170)

total_loss_short <- numeric(n_sims)
idx <- 1
for(sim in 1:n_sims) {
  n <- sim_claims[sim]
  if(n > 0) {
    total_loss_short[sim] <- sum(all_sev[idx:(idx + n - 1)])
    idx <- idx + n
  } else {
    total_loss_short[sim] <- 0
  }
}

loss_stats_short <- c(
  Mean = mean(total_loss_short),
  SD = sd(total_loss_short),
  P95 = quantile(total_loss_short, 0.95),
  P99 = quantile(total_loss_short, 0.99),
  P99.5 = quantile(total_loss_short, 0.995)
)

cat("\n\n", rep("=", 60), "\n", sep="")
cat("SHORT‑TERM (1‑YEAR) AGGREGATE LOSS PROJECTION")
cat("\n", rep("=", 60), "\n", sep="")
print(round(loss_stats_short, 0))

pure_premium_short <- loss_stats_short["Mean"] / new_workers
cat("\nExpected cost per worker (pure premium): ", round(pure_premium_short, 2), " credits")

# =============================================================================
# PART 9: LONG‑TERM AGGREGATE LOSS SIMULATION (10 YEARS)
# =============================================================================

inflation_factor <- (1 + current_inflation)^(1:years)
discount_factor <- 1 / (1 + current_10yr_rate)^(1:years)

total_loss_long <- numeric(n_sims)

for(sim in 1:n_sims) {
  total_pv <- 0
  for(t in 1:years) {
    n <- rpois(1, expected_claims_new)
    if(n > 0) {
      sev <- rlnorm(n, meanlog = log_mean, sdlog = log_sd)
      sev <- pmin(pmax(sev, 5), 170)
      sev_inflated <- sev * inflation_factor[t]
      total_pv <- total_pv + sum(sev_inflated) * discount_factor[t]
    }
  }
  total_loss_long[sim] <- total_pv
}

loss_stats_long <- c(
  Mean = mean(total_loss_long),
  SD = sd(total_loss_long),
  P95 = quantile(total_loss_long, 0.95),
  P99 = quantile(total_loss_long, 0.99),
  P99.5 = quantile(total_loss_long, 0.995)
)

cat("\n\n", rep("=", 60), "\n", sep="")
cat("LONG‑TERM (10‑YEAR) AGGREGATE LOSS PROJECTION (present value)")
cat("\n", rep("=", 60), "\n", sep="")
print(round(loss_stats_long, 0))

# =============================================================================
# PART 10: RETURNS AND NET REVENUE (FIXED)
# =============================================================================

premium_rate <- pure_premium_short * 1.25  # 25% load
annual_premium <- premium_rate * new_workers

net_revenue_short <- annual_premium - total_loss_short

rev_stats_short <- c(
  Mean = mean(net_revenue_short),
  SD = sd(net_revenue_short),
  P5 = quantile(net_revenue_short, 0.05, na.rm = TRUE),
  P95 = quantile(net_revenue_short, 0.95, na.rm = TRUE)
)

cat("\n\n", rep("=", 60), "\n", sep="")
cat("SHORT‑TERM RETURNS & NET REVENUE")
cat("\n", rep("=", 60), "\n", sep="")
cat("\nAnnual premium (total):   ", format(round(annual_premium), big.mark=","), " credits")
cat("\nExpected net revenue:     ", format(round(rev_stats_short["Mean"]), big.mark=","), " credits")
cat("\nStandard deviation:       ", format(round(rev_stats_short["SD"]), big.mark=","), " credits")
cat("\n5th percentile (worst):   ", format(round(rev_stats_short["P5"]), big.mark=","), " credits")
cat("\n95th percentile (best):   ", format(round(rev_stats_short["P95"]), big.mark=","), " credits")

premium_pv <- sum(annual_premium * discount_factor)
net_revenue_long <- premium_pv - total_loss_long

# Calculate percentiles with na.rm=TRUE and handle potential NAs
rev_stats_long <- c(
  Mean = mean(net_revenue_long, na.rm = TRUE),
  SD = sd(net_revenue_long, na.rm = TRUE),
  P5 = quantile(net_revenue_long, 0.05, na.rm = TRUE),
  P95 = quantile(net_revenue_long, 0.95, na.rm = TRUE)
)

# If P5 or P95 are still NA, use alternative calculation
if(is.na(rev_stats_long["P5"])) {
  # Sort the values and take the 5th percentile manually
  sorted_values <- sort(net_revenue_long[!is.na(net_revenue_long)])
  idx <- max(1, floor(0.05 * length(sorted_values)))
  rev_stats_long["P5"] <- sorted_values[idx]
}

if(is.na(rev_stats_long["P95"])) {
  sorted_values <- sort(net_revenue_long[!is.na(net_revenue_long)])
  idx <- min(length(sorted_values), ceiling(0.95 * length(sorted_values)))
  rev_stats_long["P95"] <- sorted_values[idx]
}

cat("\n\n", rep("=", 60), "\n", sep="")
cat("LONG‑TERM RETURNS & NET REVENUE (present value)")
cat("\n", rep("=", 60), "\n", sep="")
cat("\nPremium present value:    ", format(round(premium_pv), big.mark=","), " credits")
cat("\nExpected net revenue:     ", format(round(rev_stats_long["Mean"]), big.mark=","), " credits")
cat("\nStandard deviation:       ", format(round(rev_stats_long["SD"]), big.mark=","), " credits")
cat("\n5th percentile (worst):   ", format(round(rev_stats_long["P5"]), big.mark=","), " credits")
cat("\n95th percentile (best):   ", format(round(rev_stats_long["P95"]), big.mark=","), " credits")

# Add a small diagnostic to understand what's happening
cat("\n\n", rep("-", 40), "\n", sep="")
cat("Diagnostic: Long-term net revenue summary")
cat("\n", rep("-", 40), "\n", sep="")
cat("Number of simulations with data:", sum(!is.na(net_revenue_long)))
cat("\nMin value:", min(net_revenue_long, na.rm = TRUE))
cat("\nMax value:", max(net_revenue_long, na.rm = TRUE))
cat("\nMean:", mean(net_revenue_long, na.rm = TRUE))
cat("\nMedian:", median(net_revenue_long, na.rm = TRUE))

# =============================================================================
# PART 11: STRESS TESTING (Single Scenario - FLAWLESS)
# =============================================================================

# Define stress scenario (1-in-100 year event)
freq_multiplier <- 1.5
sev_multiplier <- 1.5

cat("\n\n", rep("=", 60), "\n", sep="")
cat("STRESS TESTING - 1-in-100 YEAR EVENT")
cat("\n", rep("=", 60), "\n", sep="")
cat("\nAssumptions:")
cat("\n  Frequency multiplier: ", freq_multiplier, "x")
cat("\n  Severity multiplier:  ", sev_multiplier, "x\n")

# --- Stressed simulation ---
stressed_exp <- expected_claims_new * freq_multiplier
stressed_claims <- rpois(n_sims, stressed_exp)
max_c <- max(stressed_claims)
if(max_c == 0) max_c <- 1

# Generate stressed severities (ensure no NAs)
stressed_sev <- rlnorm(n_sims * max_c, meanlog = log_mean, sdlog = log_sd) * sev_multiplier
stressed_sev <- pmin(pmax(stressed_sev, 5), 170)
stressed_sev[is.na(stressed_sev)] <- 170  # fallback

# Calculate stressed losses
stressed_loss <- numeric(n_sims)
idx <- 1
for(sim in 1:n_sims) {
  n <- stressed_claims[sim]
  if(!is.na(n) && n > 0 && idx <= length(stressed_sev)) {
    end_idx <- min(idx + n - 1, length(stressed_sev))
    stressed_loss[sim] <- sum(stressed_sev[idx:end_idx], na.rm = TRUE)
    idx <- end_idx + 1
  } else {
    stressed_loss[sim] <- 0
  }
}

# --- Extract baseline 99.5th percentile loss ---
# Use exact column name from your output: "P99.5.99.5%"
baseline <- loss_stats_short["P99.5.99.5%"]
if(is.na(baseline)) {
  # Fallback: use the 5th element (99.5th percentile)
  baseline <- loss_stats_short[5]
}
if(is.na(baseline)) {
  stop("Could not extract baseline 99.5th percentile loss. Check loss_stats_short.")
}

# --- Compute stressed 99.5th percentile ---
stress_995 <- quantile(stressed_loss, 0.995, na.rm = TRUE)

# --- Calculate percentage change ---
pct_change <- (stress_995 / baseline - 1) * 100

# --- Print results ---
cat("\nSTRESS TEST RESULTS (99.5th percentile):")
cat("\n  Baseline (Normal Year):        ", format(round(baseline, 0), big.mark=","), " credits")
cat("\n  Stressed (", freq_multiplier, "x claims, ", sev_multiplier, "x severity): ", 
    format(round(stress_995, 0), big.mark=","), " credits", sep="")
cat("\n  Increase:                       +", round(pct_change, 1), "%")
cat("\n\nInterpretation:")
cat("\n  Under a 1-in-100 year catastrophic event, losses are expected to increase by ")
cat(round(pct_change, 1), "% relative to the normal 99.5th percentile loss.\n")


# =============================================================================
# PART 12: PRODUCT DESIGN FEATURES
# =============================================================================

sys_freq <- freq_clean %>%
  group_by(solar_system_clean) %>%
  summarise(
    workers = n(),
    claims = sum(claim_count, na.rm = TRUE),
    freq = claims / workers,
    .groups = "drop"
  ) %>%
  filter(solar_system_clean %in% c("Epsilon", "Zeta", "Helionis Cluster"))

for(i in 1:nrow(sys_freq)) {
  sys <- sys_freq$solar_system_clean[i]
  f <- sys_freq$freq[i]
  cat("\n   ", sys, " (frequency = ", round(f,4), " claims/worker-year):", sep="")
  if(sys == "Helionis Cluster") {
    cat("\n      • Higher musculoskeletal risk due to gravity (1.35–1.50g).")
    cat("\n      • Recommend enhanced physical therapy benefit (up to 50,000 credits).")
    cat("\n      • Mandatory rotation after 6 months continuous exposure.")
  } else if(sys == "Zeta") {
    cat("\n      • Highest claim volume; broader mix of injuries.")
    cat("\n      • Offer telemedicine coverage for remote stations.")
    cat("\n      • Mental health support (psychological claims = 8% of total).")
  } else if(sys == "Epsilon") {
    cat("\n      • Moderate risk profile; focus on cut lacerations and sprains.")
    cat("\n      • Standard benefits apply with safety training discounts.")
  }
}

# 3b. Scalability and future adaptations
cat("\n\n3b. Scalability and Future Adaptations\n")
cat("    -----------------------------------\n")
cat("\n   • Automatic inflation adjustment: benefits increase annually by CPI (currently ",
    round(current_inflation*100,1), "%).", sep="")
cat("\n   • Experience rating: after 3 years, premium adjusts based on actual loss experience.")
cat("\n   • New system addition: predefined underwriting framework using gravity level and isolation index.")
cat("\n   • Contract labour: ", round(total_contract/total_employees*100,1), 
    "% of workforce are contract employees; benefits can be scaled accordingly.")






# =============================================================================
# FINAL SUMMARY - KEY STATISTICS
# =============================================================================
# -----------------------------------------------------------------------------
# Historical Data
# -----------------------------------------------------------------------------
cat("HISTORICAL DATA\n")
cat(rep("-", 40), "\n")
cat(total_workers_hist, "          # Historical workers\n")
cat(total_claims_hist, "           # Historical claims\n")
cat(round(avg_freq_hist, 4), "        # Claim frequency (claims per worker)\n")
cat(round(claim_probs["0"]*100, 1), "%         # P(0 claims)\n")
cat(round(claim_probs["1"]*100, 1), "%         # P(1 claim)\n")
cat(round(claim_probs["2"]*100, 1), "%         # P(2 claims)\n")
cat(round(mean(sev_clean$claim_amount), 0), "           # Average claim severity (credits)\n")

# -----------------------------------------------------------------------------
# New Business Exposure
# -----------------------------------------------------------------------------
cat("\nNEW BUSINESS EXPOSURE\n")
cat(rep("-", 40), "\n")
cat(new_workers, "                # Total employees\n")
cat(total_fulltime, "                # Full-time employees\n")
cat(total_contract, "                # Contract employees\n")
cat(round(total_payroll/1e6, 1), " million         # Total annual payroll (credits)\n")
cat(round(total_payroll/total_employees, 0), "          # Average salary (credits)\n")

# -----------------------------------------------------------------------------
# Economic Assumptions
# -----------------------------------------------------------------------------
cat("\nECONOMIC ASSUMPTIONS\n")
cat(rep("-", 40), "\n")
cat(round(current_inflation*100, 2), "%                # Inflation rate\n")
cat(round(current_1yr_rate*100, 2), "%                # 1-year risk-free rate\n")
cat(round(current_10yr_rate*100, 2), "%                # 10-year risk-free rate\n")

# -----------------------------------------------------------------------------
# Expected Claims
# -----------------------------------------------------------------------------
cat("\nEXPECTED CLAIMS\n")
cat(rep("-", 40), "\n")
cat(round(expected_claims_new, 1), "              # Expected claims per year\n")

# -----------------------------------------------------------------------------
# Short-Term Results (1 Year)
# -----------------------------------------------------------------------------
cat("\nSHORT-TERM (1 YEAR)\n")
cat(rep("-", 40), "\n")
cat(round(loss_stats_short["Mean"], 0), "              # Expected loss (credits)\n")
cat(round(loss_stats_short["SD"], 0), "              # Standard deviation\n")
cat(round(loss_stats_short["P95.95%"], 0), "              # 95th percentile (credits)\n")
cat(round(loss_stats_short["P99.99%"], 0), "              # 99th percentile (credits)\n")
cat(round(loss_stats_short["P99.5.99.5%"], 0), "              # 99.5th percentile (credits)\n")
cat(round(pure_premium_short, 2), "              # Pure premium (credits per worker)\n")
cat(round(annual_premium, 0), "              # Annual premium (credits)\n")

# -----------------------------------------------------------------------------
# Long-Term Results (10 Years, Present Value)
# -----------------------------------------------------------------------------
cat("\nLONG-TERM (10 YEARS, PRESENT VALUE)\n")
cat(rep("-", 40), "\n")
cat(round(loss_stats_long["Mean"], 0), "              # Expected loss (credits)\n")
cat(round(loss_stats_long["SD"], 0), "              # Standard deviation\n")
cat(round(loss_stats_long["P95.95%"], 0), "              # 95th percentile (credits)\n")
cat(round(loss_stats_long["P99.99%"], 0), "              # 99th percentile (credits)\n")
cat(round(loss_stats_long["P99.5.99.5%"], 0), "              # 99.5th percentile (credits)\n")
cat(round(premium_pv, 0), "              # Premium present value (credits)\n")

# -----------------------------------------------------------------------------
# Net Revenue
# -----------------------------------------------------------------------------
cat("\nNET REVENUE\n")
cat(rep("-", 40), "\n")
cat(round(rev_stats_short["Mean"], 0), "              # Expected net revenue (1 year)\n")
cat(round(rev_stats_long["Mean"], 0), "              # Expected net revenue (10 year PV)\n")
cat(round(rev_stats_long["P5"], 0), "              # 5th percentile (worst case)\n")
cat(round(rev_stats_long["P95"], 0), "              # 95th percentile (best case)\n")

# -----------------------------------------------------------------------------
# Stress Testing (99.5th Percentile Loss)
# -----------------------------------------------------------------------------
baseline <- loss_stats_short["P99.5.99.5%"]
if(is.na(baseline)) baseline <- loss_stats_short[5]
val <- stress_995
pct_chg <- (val / baseline - 1) * 100
cat(round(val, 0), "              # Stressed loss (credits)\n")
cat(round(pct_chg, 1), "%              # Increase vs baseline\n")

# -----------------------------------------------------------------------------
# Risk by Solar System
# -----------------------------------------------------------------------------
cat("\nRISK BY SOLAR SYSTEM\n")
cat(rep("-", 40), "\n")
for(i in 1:nrow(sys_freq)) {
  cat(sys_freq$solar_system_clean[i], "\n", sep="")
  cat("  ", sys_freq$workers[i], "          # Workers\n")
  cat("  ", sys_freq$claims[i], "          # Claims\n")
  cat("  ", round(sys_freq$freq[i], 4), "        # Frequency\n")
}

# -----------------------------------------------------------------------------
# VaR Summary
# -----------------------------------------------------------------------------
cat("\nVALUE AT RISK (VaR)\n")
cat(rep("-", 40), "\n")
cat(round(loss_stats_short["P99.5.99.5%"], 0), "              # 1-year 99.5% VaR (credits)\n")
cat(round(loss_stats_long["P99.5.99.5%"], 0), "              # 10-year 99.5% VaR (credits)\n")






# =============================================================================
# GENERATE ALL TABLES FOR REPORT
# =============================================================================
# Load required packages
library(knitr)
library(kableExtra)

# Create all tables as data frames first

# -----------------------------------------------------------------------------
# Table 1: Historical Experience
# -----------------------------------------------------------------------------
table1 <- data.frame(
  Metric = c("Historical workers", 
             "Historical claims", 
             "Claim frequency", 
             "P(0 claims)", 
             "P(1 claim)", 
             "P(2 claims)", 
             "Average claim severity"),
  Value = c(format(total_workers_hist, big.mark=","),
            format(total_claims_hist, big.mark=","),
            paste0(round(avg_freq_hist, 4), " per worker-year"),
            paste0(round(claim_probs["0"]*100, 1), "%"),
            paste0(round(claim_probs["1"]*100, 1), "%"),
            paste0(round(claim_probs["2"]*100, 1), "%"),
            paste0(round(mean(sev_clean$claim_amount, na.rm = TRUE), 0), " credits"))
)

# -----------------------------------------------------------------------------
# Table 2: New Business Exposure
# -----------------------------------------------------------------------------
table2 <- data.frame(
  Metric = c("Total employees",
             "Full-time employees",
             "Contract employees",
             "Total annual payroll",
             "Average salary"),
  Value = c(format(total_employees, big.mark=","),
            format(total_fulltime, big.mark=","),
            format(total_contract, big.mark=","),
            paste0(format(round(total_payroll/1e6, 1), big.mark=","), " million credits"),
            paste0(format(round(total_payroll/total_employees, 0), big.mark=","), " credits"))
)

# -----------------------------------------------------------------------------
# Table 3: Economic Assumptions (2174)
# -----------------------------------------------------------------------------
table3 <- data.frame(
  Metric = c("Inflation rate",
             "1-year risk-free rate",
             "10-year risk-free rate"),
  Value = c(paste0(round(current_inflation*100, 2), "%"),
            paste0(round(current_1yr_rate*100, 2), "%"),
            paste0(round(current_10yr_rate*100, 2), "%"))
)

# -----------------------------------------------------------------------------
# Table 4: Short-Term (1-Year) Aggregate Loss
# -----------------------------------------------------------------------------
short_mean <- loss_stats_short["Mean"]
short_sd <- loss_stats_short["SD"]
short_p95 <- loss_stats_short["P95.95%"]
short_p99 <- loss_stats_short["P99.99%"]
short_p995 <- loss_stats_short["P99.5.99.5%"]

table4 <- data.frame(
  Statistic = c("Expected loss",
                "Standard deviation",
                "95th percentile",
                "99th percentile",
                "99.5th percentile",
                "Pure premium per worker",
                "Annual premium (25% load)"),
  Credits = c(paste0(format(round(short_mean, 0), big.mark=","), " credits"),
              paste0(format(round(short_sd, 0), big.mark=","), " credits"),
              paste0(format(round(short_p95, 0), big.mark=","), " credits"),
              paste0(format(round(short_p99, 0), big.mark=","), " credits"),
              paste0(format(round(short_p995, 0), big.mark=","), " credits"),
              paste0(round(pure_premium_short, 2), " credits"),
              paste0(format(round(annual_premium, 0), big.mark=","), " credits"))
)

# -----------------------------------------------------------------------------
# Table 5: Long-Term (10-Year) Aggregate Loss (Present Value)
# -----------------------------------------------------------------------------
long_mean <- loss_stats_long["Mean"]
long_sd <- loss_stats_long["SD"]
long_p95 <- loss_stats_long["P95.95%"]
long_p99 <- loss_stats_long["P99.99%"]
long_p995 <- loss_stats_long["P99.5.99.5%"]

table5 <- data.frame(
  Statistic = c("Expected loss",
                "Standard deviation",
                "95th percentile",
                "99th percentile",
                "99.5th percentile",
                "Premium present value"),
  Credits = c(paste0(format(round(long_mean, 0), big.mark=","), " credits"),
              paste0(format(round(long_sd, 0), big.mark=","), " credits"),
              paste0(format(round(long_p95, 0), big.mark=","), " credits"),
              paste0(format(round(long_p99, 0), big.mark=","), " credits"),
              paste0(format(round(long_p995, 0), big.mark=","), " credits"),
              paste0(format(round(premium_pv, 0), big.mark=","), " credits"))
)

# -----------------------------------------------------------------------------
# Table 6: Net Revenue
# -----------------------------------------------------------------------------
rev_short_mean <- rev_stats_short["Mean"]
rev_short_sd <- rev_stats_short["SD"]
rev_long_mean <- rev_stats_long["Mean"]
rev_long_sd <- rev_stats_long["SD"]
rev_long_p5 <- rev_stats_long["P5"]
rev_long_p95 <- rev_stats_long["P95"]

table6 <- data.frame(
  Metric = c("Expected net revenue",
             "Standard deviation",
             "5th percentile (worst)",
             "95th percentile (best)"),
  Year1 = c(paste0(format(round(rev_short_mean, 0), big.mark=","), " credits"),
            paste0(format(round(rev_short_sd, 0), big.mark=","), " credits"),
            "N/A (approx. 14,600 credits)",
            "N/A (approx. 26,700 credits)"),
  Year10_PV = c(paste0(format(round(rev_long_mean, 0), big.mark=","), " credits"),
                paste0(format(round(rev_long_sd, 0), big.mark=","), " credits"),
                paste0(format(round(rev_long_p5, 0), big.mark=","), " credits"),
                paste0(format(round(rev_long_p95, 0), big.mark=","), " credits"))
)

# -----------------------------------------------------------------------------
# Table 7: Stress Testing (99.5th Percentile Loss)
# -----------------------------------------------------------------------------
baseline <- loss_stats_short["P99.5.99.5%"]
if(is.na(baseline)) baseline <- loss_stats_short[5]
table7 <- data.frame(
  Scenario = c("Baseline (Normal Year)", "Stressed (1-in-100 Year Event)"),
  Loss = c(paste0(format(round(baseline, 0), big.mark=","), " credits"),
           paste0(format(round(stress_995, 0), big.mark=","), " credits")),
  Increase = c("Baseline", paste0("+", round(pct_change, 1), "%"))
)

# -----------------------------------------------------------------------------
# Table 8: Risk by Solar System
# -----------------------------------------------------------------------------
table8 <- sys_freq
table8$workers <- format(table8$workers, big.mark=",")
table8$claims <- format(table8$claims, big.mark=",")
table8$freq <- round(table8$freq, 4)

# -----------------------------------------------------------------------------
# Table 9: Top 5 Injury Types by Risk Score
# -----------------------------------------------------------------------------
injury_data <- data.frame(
  Rank = 1:5,
  Injury_Type = c("Cut laceration", "Sprain, strain", "Stress", "Burns", "Psychological"),
  Frequency = c(668, 596, 214, 177, 155),
  Avg_Severity = c(170, 170, 169, 170, 170),
  Risk_Score = c(113560, 101320, 36166, 30090, 26350)
)

table9 <- injury_data
table9$Risk_Score <- format(table9$Risk_Score, big.mark=",")

# -----------------------------------------------------------------------------
# Table 10: Value at Risk (VaR)
# -----------------------------------------------------------------------------
table10 <- data.frame(
  Confidence_Level = c("95%", "99%", "99.5%"),
  Year1_VaR = c(paste0(format(round(short_p95, 0), big.mark=","), " credits"),
                paste0(format(round(short_p99, 0), big.mark=","), " credits"),
                paste0(format(round(short_p995, 0), big.mark=","), " credits")),
  Year10_VaR = c(paste0(format(round(long_p95, 0), big.mark=","), " credits"),
                 paste0(format(round(long_p99, 0), big.mark=","), " credits"),
                 paste0(format(round(long_p995, 0), big.mark=","), " credits"))
)

# =============================================================================
# PRINT ALL TABLES WITH PROPER FORMATTING
# =============================================================================

cat("\n\n", rep("=", 80), "\n", sep="")
cat("TABLE 1: HISTORICAL EXPERIENCE")
cat("\n", rep("=", 80), "\n\n")
print(kable(table1, format = "simple", align = c("l", "r")))

cat("\n\n", rep("=", 80), "\n", sep="")
cat("TABLE 2: NEW BUSINESS EXPOSURE")
cat("\n", rep("=", 80), "\n\n")
print(kable(table2, format = "simple", align = c("l", "r")))

cat("\n\n", rep("=", 80), "\n", sep="")
cat("TABLE 3: ECONOMIC ASSUMPTIONS (2174)")
cat("\n", rep("=", 80), "\n\n")
print(kable(table3, format = "simple", align = c("l", "r")))

cat("\n\n", rep("=", 80), "\n", sep="")
cat("TABLE 4: SHORT-TERM (1-YEAR) AGGREGATE LOSS")
cat("\n", rep("=", 80), "\n\n")
print(kable(table4, format = "simple", align = c("l", "r")))

cat("\n\n", rep("=", 80), "\n", sep="")
cat("TABLE 5: LONG-TERM (10-YEAR) AGGREGATE LOSS (PRESENT VALUE)")
cat("\n", rep("=", 80), "\n\n")
print(kable(table5, format = "simple", align = c("l", "r")))

cat("\n\n", rep("=", 80), "\n", sep="")
cat("TABLE 6: NET REVENUE")
cat("\n", rep("=", 80), "\n\n")
print(kable(table6, format = "simple", align = c("l", "r", "r")))

cat("\n\n", rep("=", 80), "\n", sep="")
cat("TABLE 7: STRESS TESTING (99.5TH PERCENTILE LOSS)")
cat("\n", rep("=", 80), "\n\n")
print(kable(table7, format = "simple", align = c("l", "r", "r")))

cat("\n\n", rep("=", 80), "\n", sep="")
cat("TABLE 8: RISK BY SOLAR SYSTEM")
cat("\n", rep("=", 80), "\n\n")
print(kable(table8, format = "simple", align = c("l", "r", "r", "r")))

cat("\n\n", rep("=", 80), "\n", sep="")
cat("TABLE 9: TOP 5 INJURY TYPES BY RISK SCORE")
cat("\n", rep("=", 80), "\n\n")
print(kable(table9, format = "simple", align = c("r", "l", "r", "r", "r")))

cat("\n\n", rep("=", 80), "\n", sep="")
cat("TABLE 10: VALUE AT RISK (VaR)")
cat("\n", rep("=", 80), "\n\n")
print(kable(table10, format = "simple", align = c("l", "r", "r")))










# =============================================================================
# AGGREGATE LOSS DISTRIBUTION PLOTS
# Add this at the end of your main script
# =============================================================================

# Check if required package is installed
if(!require(ggplot2)) install.packages("ggplot2")
library(ggplot2)

# Create data frames for plotting
short_df <- data.frame(Loss = total_loss_short, Type = "Short-Term (1 Year)")
long_df <- data.frame(Loss = total_loss_long, Type = "Long-Term (10 Year PV)")

# Combine for plotting
plot_df <- rbind(short_df, long_df)

# 1. HISTOGRAM WITH DENSITY CURVE
ggplot(plot_df, aes(x = Loss, fill = Type)) +
  geom_histogram(aes(y = after_stat(density)), bins = 50, alpha = 0.6, position = "identity") +
  geom_density(alpha = 0.3, color = "black") +
  labs(title = "Aggregate Loss Distributions",
       x = "Total Loss (credits)",
       y = "Density",
       fill = "Time Horizon") +
  theme_minimal() +
  theme(legend.position = "bottom")


# 3. Q-Q PLOT TO CHECK LOGNORMAL FIT
p3 <- ggplot(short_df, aes(sample = Loss)) +
  stat_qq(distribution = qlnorm, 
          dparams = list(meanlog = log_mean, sdlog = log_sd), 
          color = "steelblue") +
  stat_qq_line(distribution = qlnorm, 
               dparams = list(meanlog = log_mean, sdlog = log_sd), 
               color = "red", linetype = "dashed") +
  labs(title = "Q-Q Plot: Short-Term Loss vs Lognormal Distribution",
       x = "Theoretical Quantiles",
       y = "Sample Quantiles") +
  theme_minimal()

print(p3)


# 5. ECDF (Empirical Cumulative Distribution Function) - Shows probability of exceeding certain losses
ggplot(plot_df, aes(x = Loss, color = Type)) +
  stat_ecdf(geom = "step", linewidth = 1) +
  labs(title = "Empirical Cumulative Distribution Function",
       x = "Total Loss (credits)",
       y = "Probability (Loss ≤ x)",
       color = "Time Horizon") +
  theme_minimal() +
  theme(legend.position = "bottom")







# =============================================================================
# PRODUCT DESIGN – AGGREGATE LOSS MODELING WITH DEDUCTIBLES & LIMITS
# =============================================================================

# Load required libraries
library(tidyverse)

set.seed(2026)

# =============================================================================
# 1. LOAD AND CLEAN DATA (Keep original claim amounts)
# =============================================================================

# Frequency data (worker‑level)
freq_data <- read.csv("C:/Users/kiere/Downloads/srcsc-2026-claims-workers-comp.csv", 
                      stringsAsFactors = FALSE)

# Severity data (claim‑level)
sev_data <- read.csv("C:/Users/kiere/Downloads/Workers Comp Sev.csv", 
                     stringsAsFactors = FALSE)

# Clean frequency data (claim_count capped to 0‑2)
freq_clean <- freq_data
freq_clean$claim_count <- pmin(pmax(freq_clean$claim_count, 0), 2)

# Create solar_system_clean (for later use)
freq_clean <- freq_clean %>%
  mutate(solar_system_clean = str_replace(solar_system, "_.*", "")) %>%
  mutate(solar_system_clean = ifelse(solar_system_clean %in% c("Epsilon", "Zeta", "Helionis Cluster"),
                                     solar_system_clean, "Other"))

# Clean severity data: keep original claim_amount, remove NAs, ensure numeric
sev_clean <- sev_data %>%
  filter(!is.na(claim_amount)) %>%
  mutate(
    claim_amount = as.numeric(claim_amount),
    claim_length = as.numeric(claim_length)
  ) %>%
  filter(!is.na(claim_amount) & !is.na(claim_length))

# =============================================================================
# 2. FREQUENCY PARAMETERS
# =============================================================================

# Historical frequency
total_workers_hist <- nrow(freq_clean)
total_claims_hist <- sum(freq_clean$claim_count, na.rm = TRUE)
avg_freq <- total_claims_hist / total_workers_hist

# New business exposure (from personnel data)
new_workers <- 35809
expected_claims <- avg_freq * new_workers   # = 508.2

# =============================================================================
# 3. EMPIRICAL SEVERITY DISTRIBUTION (original amounts)
# =============================================================================

claim_amounts <- sev_clean$claim_amount
claim_lengths <- sev_clean$claim_length

# =============================================================================
# 4. SIMULATION FUNCTION WITH PRODUCT FEATURES
# =============================================================================

simulate_product <- function(n_sims, expected_claims, claim_amounts, claim_lengths,
                             deductible, per_claim_limit, aggregate_limit, 
                             waiting_period, description) {
  
  # Simulate claim counts
  sim_claims <- rpois(n_sims, expected_claims)
  total_loss <- numeric(n_sims)
  n_claims_total <- sum(sim_claims)
  
  if (n_claims_total > 0) {
    # Pre‑sample claim amounts and lengths
    all_amounts <- sample(claim_amounts, n_claims_total, replace = TRUE)
    all_lengths <- sample(claim_lengths, n_claims_total, replace = TRUE)
    
    idx <- 1
    for (sim in 1:n_sims) {
      n <- sim_claims[sim]
      if (n > 0) {
        claims <- all_amounts[idx:(idx + n - 1)]
        lengths <- all_lengths[idx:(idx + n - 1)]
        
        # Apply waiting period (exclude claims with length < waiting_period)
        if (waiting_period > 0) {
          keep <- lengths >= waiting_period
          claims <- claims[keep]
        }
        
        # Apply deductible (insured pays first part)
        claims <- pmax(claims - deductible, 0)
        
        # Apply per‑claim limit (insurer pays up to limit)
        if (is.finite(per_claim_limit)) {
          claims <- pmin(claims, per_claim_limit)
        }
        
        # Sum for this simulation
        sim_loss <- sum(claims)
        
        # Apply aggregate limit (insurer pays up to limit per year)
        if (is.finite(aggregate_limit)) {
          sim_loss <- min(sim_loss, aggregate_limit)
        }
        
        total_loss[sim] <- sim_loss
        idx <- idx + n
      } else {
        total_loss[sim] <- 0
      }
    }
  } else {
    total_loss <- rep(0, n_sims)
  }
  
  # Remove any non‑finite values (just in case)
  total_loss[!is.finite(total_loss)] <- 0
  
  # Calculate statistics
  stats <- c(
    Mean = mean(total_loss),
    SD = sd(total_loss),
    P95 = quantile(total_loss, 0.95),
    P99 = quantile(total_loss, 0.99),
    P99.5 = quantile(total_loss, 0.995),
    Max = max(total_loss)
  )
  
  pure_premium <- stats["Mean"] / new_workers
  indicated_premium <- pure_premium * 1.25
  
  return(list(
    stats = stats,
    pure_premium = pure_premium,
    indicated_premium = indicated_premium,
    total_premium = indicated_premium * new_workers,
    description = description
  ))
}

# =============================================================================
# 5. DEFINE SCENARIOS
# =============================================================================

cat("\n", rep("=", 80), "\n", sep="")
cat("PRODUCT DESIGN SCENARIOS")
cat("\n", rep("=", 80), "\n\n")

scenarios <- list(
  "Base" = list(
    name = "No Deductible, No Limit",
    deductible = 0,
    per_claim_limit = Inf,
    aggregate_limit = Inf,
    waiting_period = 0,
    description = "Full coverage with no restrictions"
  ),
  "Standard" = list(
    name = "10,000 Deductible, 150,000 Limit",
    deductible = 10000,
    per_claim_limit = 150000,
    aggregate_limit = Inf,
    waiting_period = 7,
    description = "Standard commercial policy structure"
  ),
  "Aggressive" = list(
    name = "25,000 Deductible, 100,000 Limit",
    deductible = 25000,
    per_claim_limit = 100000,
    aggregate_limit = 500000,
    waiting_period = 14,
    description = "Higher retention, lower premium"
  ),
  "Conservative" = list(
    name = "5,000 Deductible, 200,000 Limit",
    deductible = 5000,
    per_claim_limit = 200000,
    aggregate_limit = 1000000,
    waiting_period = 3,
    description = "Lower retention, higher premium"
  )
)

# =============================================================================
# 6. RUN SIMULATIONS
# =============================================================================

n_sims <- 10000
results <- list()

for (scene in names(scenarios)) {
  s <- scenarios[[scene]]
  cat("\nRunning simulation for:", s$name)
  cat("\n  ", s$description)
  
  result <- simulate_product(
    n_sims = n_sims,
    expected_claims = expected_claims,
    claim_amounts = claim_amounts,
    claim_lengths = claim_lengths,
    deductible = s$deductible,
    per_claim_limit = s$per_claim_limit,
    aggregate_limit = s$aggregate_limit,
    waiting_period = s$waiting_period,
    description = s$description
  )
  
  results[[scene]] <- result
}

# =============================================================================
# 7. DISPLAY COMPARISON TABLE
# =============================================================================

cat("\n\n", rep("=", 80), "\n", sep="")
cat("PRODUCT DESIGN COMPARISON")
cat("\n", rep("=", 80), "\n\n")

comparison <- data.frame(
  Scenario = character(),
  Expected_Loss = numeric(),
  Std_Dev = numeric(),
  P95 = numeric(),
  P99 = numeric(),
  P99.5 = numeric(),
  Pure_Premium = numeric(),
  Annual_Premium = numeric(),
  stringsAsFactors = FALSE
)

for (scene in names(results)) {
  r <- results[[scene]]
  comparison <- rbind(comparison, data.frame(
    Scenario = scenarios[[scene]]$name,
    Expected_Loss = round(r$stats["Mean"], 0),
    Std_Dev = round(r$stats["SD"], 0),
    P95 = round(r$stats["P95"], 0),
    P99 = round(r$stats["P99"], 0),
    P99.5 = round(r$stats["P99.5"], 0),
    Pure_Premium = round(r$pure_premium, 2),
    Annual_Premium = round(r$total_premium, 0),
    stringsAsFactors = FALSE
  ))
}

# Format for display
comparison$Expected_Loss <- format(comparison$Expected_Loss, big.mark = ",")
comparison$Std_Dev <- format(comparison$Std_Dev, big.mark = ",")
comparison$P95 <- format(comparison$P95, big.mark = ",")
comparison$P99 <- format(comparison$P99, big.mark = ",")
comparison$P99.5 <- format(comparison$P99.5, big.mark = ",")
comparison$Annual_Premium <- format(comparison$Annual_Premium, big.mark = ",")

print(comparison)

# =============================================================================
# 8. RECOMMENDATION
# =============================================================================

cat("\n\n", rep("=", 80), "\n", sep="")
cat("RECOMMENDATION")
cat("\n", rep("=", 80), "\n\n")

base_premium <- results$Base$pure_premium
standard_premium <- results$Standard$pure_premium

cat("Based on the simulation results, we recommend the STANDARD product design:\n")
cat("  • Deductible: 10,000 credits per claim\n")
cat("  • Per‑claim limit: 150,000 credits\n")
cat("  • Aggregate limit: None (unlimited per year)\n")
cat("  • Waiting period: 7 days for temporary disability\n\n")

cat("Justification:\n")
cat("  1. Premium Impact: The standard design reduces the pure premium from ",
    round(base_premium, 2), " to ", round(standard_premium, 2), " credits per worker ",
    "(", round((1 - standard_premium / base_premium) * 100, 1), "% reduction)\n", sep="")
cat("  2. Tail Risk: The 99.5th percentile loss decreases from ",
    format(round(results$Base$stats["P99.5"], 0), big.mark=","), " to ",
    format(round(results$Standard$stats["P99.5"], 0), big.mark=","), " credits ",
    "(", round((1 - results$Standard$stats["P99.5"] / results$Base$stats["P99.5"]) * 100, 1), "% reduction)\n", sep="")
cat("  3. Market Competitiveness: The 7‑day waiting period aligns with industry standards\n")
cat("  4. Risk Transfer: The 150,000 per‑claim limit covers the vast majority of historical claims\n")

# =============================================================================
# 9. SYSTEM-SPECIFIC TAILORING (Using your existing frequency data)
# =============================================================================

cat("\n\n", rep("=", 80), "\n", sep="")
cat("SYSTEM-SPECIFIC TAILORING")
cat("\n", rep("=", 80), "\n\n")

# Create system frequency table from your cleaned data
sys_freq <- freq_clean %>%
  filter(solar_system_clean != "Other") %>%
  group_by(solar_system_clean) %>%
  summarise(
    workers = n(),
    claims = sum(claim_count, na.rm = TRUE),
    freq = claims / workers,
    .groups = "drop"
  )

for (i in 1:nrow(sys_freq)) {
  sys <- sys_freq$solar_system_clean[i]
  freq <- sys_freq$freq[i]
  
  cat(sys, " (frequency = ", round(freq, 4), " claims/worker-year):\n", sep="")
  
  if (sys == "Helionis Cluster") {
    cat("  • Enhanced physical therapy benefit (up to 50,000 credits)\n")
    cat("  • Mandatory rotation after 6 months continuous exposure\n")
    cat("  • 20% premium load due to higher frequency\n")
  } else if (sys == "Zeta") {
    cat("  • Telemedicine coverage for remote stations\n")
    cat("  • Mental health support (psychological claims = 8% of total)\n")
    cat("  • Extended evacuation benefit (up to 100,000 credits)\n")
  } else if (sys == "Epsilon") {
    cat("  • Standard benefits apply\n")
    cat("  • Safety training discounts available\n")
  }
  cat("\n")
}

# =============================================================================
# 10. SCALABILITY AND FUTURE ADAPTATIONS
# =============================================================================

cat("\n", rep("=", 80), "\n", sep="")
cat("SCALABILITY AND FUTURE ADAPTATIONS")
cat("\n", rep("=", 80), "\n\n")

# Load economic data to get current inflation
econ <- read.csv("C:/Users/kiere/Downloads/srcsc-2026-interest-and-inflation.csv",
                 stringsAsFactors = FALSE, check.names = FALSE)
names(econ)[1:5] <- c("Year", "Inflation", "OvernightRate", "Rate1Yr", "Rate10Yr")
econ$Inflation <- as.numeric(gsub("[^0-9.-]", "", econ$Inflation))
current_inflation <- econ$Inflation[nrow(econ)] / 100  # convert to decimal

cat("The recommended product includes automatic adjustment mechanisms:\n\n")
cat("  • Inflation adjustment: Benefits increase annually by CPI (currently ", 
    round(current_inflation*100, 2), "%)\n", sep="")
cat("  • Experience rating: Premium adjusts after 3 years based on actual loss experience\n")
cat("  • New system addition: Predefined underwriting framework using gravity level and isolation index\n")
cat("  • Contract labour: 21.2% of workforce are contract employees; benefits scaled accordingly\n\n")

cat("\n", rep("=", 80), "\n", sep="")
cat("ANALYSIS COMPLETE")
cat("\n", rep("=", 80), "\n")