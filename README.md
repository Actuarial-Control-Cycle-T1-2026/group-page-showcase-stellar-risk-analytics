[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/FxAEmrI0)
# Risk Stellar Analytics SOA Report
## Table of Contents

- [1.0 Executive Summary](#10-executive-summary)
- [2.0 Product Design](#20-product-design)
  - [2.1 Equipment Failure](#21-equipment-failure)
  - [2.2 Workers Compensation](#22-workers-compensation)
  - [2.3 Business Interruption](#23-business-interruption)
  - [2.4 Cargo Loss](#24-cargo-loss)
- [3.0 Capital Modelling & Pricing](#30-capital-modelling--pricing)
  - [3.1 Equipment Failure](#31-equipment-failure)
  - [3.2 Workers Compensation](#32-workers-compensation)
  - [3.3 Business Interruption](#33-business-interruption)
  - [3.4 Cargo Loss](#34-cargo-loss)
- [4.0 Risk Assessment](#40-risk-assessment)
  - [4.1 Equipment Failure](#41-equipment-failure)
  - [4.2 Workers Compensation](#42-workers-compensation)
  - [4.3 Business Interruption](#43-business-interruption)
  - [4.4 Cargo Loss](#44-cargo-loss)
- [5.0 Assumptions](#50-assumptions)
- [6.0 Data and Data Limitations](#60-data-and-data-limitations)

Please find all code here:
- Equipment Failure: [Equipment Failure Code](https://github.com/Actuarial-Control-Cycle-T1-2026/group-page-showcase-stellar-risk-analytics/blob/main/ACTL4001%20Equipment%20Failure.Rmd)
- Workers Compensation: [Workers Compensation Code] (insert link in here)
- Business Interruption: [Business Interruption Code] (insert link in here)
- Cargo Loss: [Cargo Loss Code] (insert link in here)

# 1.0	EXECUTIVE SUMMARY
Stellar Risk Analytics recommends the following comprehensive products for Cosmic Quarry Mining Corporation’s (CQMC) equipment failure, workers compensation, business interruption and cargo loss hazards. The analysis is based on the operational characteristics of the Helionis Cluster, Bayesia System and Oryn Delta solar systems and performed on a 100,000 monte carlo simulation across all operational sectors.
The equipment failure product is structured as a tail risk solution, covering low-frequency, high-severity losses while high deductibles ensure routine losses are retained by the insured. Pricing is risk-differentiated based on equipment characteristics and location, aligning premiums with underlying risk while incentivising effective maintenance and risk management.
From the workers compensation perspective, out of our analysis of 35,809 employees, we expect 508 annual claims with an expected loss of 82,587 credits and 92,069 credits at 99.5% value at risk (VaR). Adding a 25% loading for profit and expenses, a recommended annual premium of 2.89 credits per worker is calculated. The total annual premium sums to 103,234 credits.
The business interruption product adopts a three-tier structure with parametric downtime triggers. Pricing is risk-differentiated based on key operational drivers, ensuring alignment with expected losses across tiers. Portfolio risk is managed through a $2B annual aggregate deductible and $15B xs $6B reinsurance, reducing tail risk and limiting the probability of an unprofitable year to approximately 0.1%.
The cargo loss product is structured as an indemnity-based cover, focusing on low-frequency, high-severity losses driven by a highly skewed claims profile. A deductible is applied to ensure coverage is targeted towards material losses. The pricing of the product is risk-differentiated based on key drivers such as route risk  and cargo type while portfolio risk is managed through capital buffers informed by tail risk measures, ensuring resilience against extreme loss events.
Cosmic Quarry can integrate these products into its ERM framework by mapping each policy to a specific risk category and embedding them within its risk appetite. For example, high-frequency losses are retained through deductibles, while low-frequency, high-severity risks are transferred via insurance. The outputs from our pricing and capital modelling can be used to set capital buffers, define risk limits, and inform stress testing for system-wide events such as solar storms. This ensures insurance is used strategically alongside operational controls to manage downside risk and ensure financial stability for CQMC.

# 2.0	PRODUCT DESIGN
## 2.1	Equipment Failure
The equipment failure product covers damages to the following types of equipment: Quantum Bore, Graviton Extractor, FluxStream Carrier, Mag-Lift Aggregator, Fusion Transport and Ion Pulverizer.
The deductible will be specific to each solar system and is determined at the flattening point of the Loss Elimination Ratio analysis (Appendix Fig 1), where further increases in the deductible yield a negligible reduction in expected loss eliminated. A deductible of $200,000 will be applied for equipment failure that occurs in the Helionis Cluster and Bayesia Systems and a deductible of $250,000 applies for equipment failure in Oryn Delta. At these levels of deductibles, the equipment failure product acts as a tail risk product in which the deductible eliminates 97-98% of the expected losses and limits exposure to the most severe claims as seen in the Appendix Fig 3. 
In the Helionis Cluster and Bayesia System, equipment failure coverage is conditional on the maintenance interval being less than 1200 hours as the solar system has the largest exposure of older equipment. This trigger encourages maintenance and age related failures. In the Oryn Delta, equipment failure coverage is conditional on usage intensity being less than 18 hours day to mitigate its elevated risk index on all equipment despite having the lowest aged equipment and most frequent maintenance intervals. In terms of scalability and adaptability, the threshold values for the coverage triggers can be adjusted annually based on updated frequency and severity models. All equipment that does not adhere to the coverage triggers are excluded.

## 2.2	Workers Compensation
The workers compensation product is tailored towards the unique resources and environments of each solar system. The base package includes (for all solar systems):
Medical coverage of a maximum of 250,00 credits per claim
Temporary total disability value at ⅔ of base salary with a 7-day waiting period.
Permanent partial disability with a range of 25,000 to 150,000 credits depending on injury type
Death benefit of maximum 50,000 credits
The Helionis Cluster is a high gravity environment (1.35-1.50g) with higher musculoskeletal injuries such as sprains. It is recommended to assign an extra 50,000 credits in rehabilitation for such injuries. To combat the effects of cumulative physical strain on workers, a mandatory rotation after 6 months of continuous exposure is required. A 20% premium loading is applied to reflect Helionis Cluster’s higher claim frequency.
For the system with the highest workforce (55,273) and lowest claim frequency (0.0129), Epsilon, workers receive a safety training discount. A 5% premium credit for achieving a frequency of less than 0.01 on top of the existing base benefits.
Zeta has the highest claim volume and highest gravity variation. It is advised that workers here should have access to telemedical coverage (unlimited virtual consultations) to combat their high isolation/psychological based claims and an extra evacuation benefit of up to 100,000 credits to address the higher and more unpredictable variations in gravity. 
For administrative simplicity, coverage triggers are equal across all 3 solar systems. These are: 
Occurrence trigger: covers injuries from and during employment. Under this trigger, the policy responds only when accidents occur, regardless of when the claim is reported.
All injuries include all acute physical injuries such as cut lacerations, sprains, burns, fractures, and amputation
Continuous trigger: covers psychological injuries and cumulative musculoskeletal strain from the first day of exposure. This trigger is relevant to injuries that develop overtime from continuous exposure.
This trigger is especially relevant to the Helionis Cluster and Zeta for their cumulative strain and psychological claims from isolation characteristics respectively.
The following exclusions apply to all solar systems to manage moral hazard and maintain good risk management. Purposeful self injury, injury while under the influence of prohibited substances, war or combat risks, unauthorised space walks. 
Finally, Stellar Risk Analytics recommends implementing extra features in the form of deductibles to remain competitive. Epsilon, with the lowest claim frequency, will have no deductibles to keep its premium competitive. The systems with higher claim frequencies, Helionis cluster and Zeta, both have a 10,000 credit deductible 

## 2.3	Business Interruption
a. Benefit structures
The Business interruption product offers three core tiers, which are Basic, Standard, and Comprehensive, alongside an optional catastrophe layer. Coverage is structured around parametric triggers based on operational downtime, eliminating the need for physical loss verification across solar systems.
<img width="703" height="186" alt="image" src="https://github.com/user-attachments/assets/e7b0926d-d89a-4a81-9588-121da5d99431" />


b. Deductible Options
Policyholders may elect a per-occurrence deductible from the schedule below, priced using the Limited Expected Value function applied to the fitted Gamma severity distribution. A $150,000 deductible reduces the insured’s premium by 13.0%, aligning with the Basic tier structure.
<img width="702" height="168" alt="image" src="https://github.com/user-attachments/assets/b902099f-dc02-416c-bc15-1c01705be1b7" />


c. Annual Aggregate Deductible and Reinsurance
A $2B annual aggregate deductible (AAD) is recommended for the Standard tier and above, reducing the probability of portfolio losses exceeding the premium from 2.7% (no AAD) to 0.8%. An excess-of-loss reinsurance treaty of $15B xs $6B is further recommended to cap the net 99.5th-percentile loss at $15.1B, within premium capacity, thereby reducing the probability of an unprofitable year to 0.1%. Comparisons of alternative AAD and reinsurance structures are provided in Appendix Tables 3.1.2 and 3.1.3.
e. Exclusions
Losses arising from pre-existing defects are excluded, with annual re-inspections triggering re-underwriting where necessary. Planned maintenance shutdowns are not considered, as these represent expected operational downtime and can be verified through station telemetry logs. Policies with a supply chain index above 0.90 are excluded because this exceeds the model's calibrated range and introduces disproportionate risk. Business interruption losses extending beyond 180 days are excluded due to the long-tail nature of such exposures, although extended coverage may be offered through an additional premium endorsement. Finally, losses resulting from war, sanctions, or regulatory seizure are excluded, as these constitute uninsurable political risks and fall outside the scope of actuarial modelling.

## 2.4	Cargo Loss
<img width="639" height="97" alt="image" src="https://github.com/user-attachments/assets/e3c2ade0-dd47-4024-ba6f-a32b56320202" />

The product design for Cargo Loss Insurance is indemnity based with coverage triggers occurring from physical loss or damage of cargo during transit. Moreover, the above table providing summary statistics relating to claim severity highlights significant disparity between most claims and the tail, with claims in the 95% percentile being over five times larger than mean claims and claims in the 99th percentile being almost thirteen times as larger. Hence, it is evident that tail risk is the dominant factor within the claims portfolio, whereby a deductible can be employed to remove insignificant and attritional claims and reduce administrative costs. Given the scale of the claims data and the disparity between the mean and median claim severity (8.36 million versus 466 thousand), a baseline deductible of 10% of the mean claim size (836 thousand) should be implemented. Not only would this still provide coverage for large claims, but it would remove approximately 60 percent of claims based on historical data.
<img width="507" height="174" alt="image" src="https://github.com/user-attachments/assets/a87af394-3005-4c1e-a4ba-985c6dd687b8" />


As with previous computations, 100,000 Monte Carlo Simulations were employed to predict both short and long term aggregate losses. Claim frequency was modelled using a Poisson distribution with λ = 28,294 and a claim severity was modelled utilising a lognormal distribution with µ and σ2 derived from the historical data at 1.46 and 14.88 respectively. Moreover, a Poisson generalised linear model (GLM) with a log-link was also employed to simulate claim frequencies. This determined that key drivers in claim occurrences included route risk, debris density and solar radiation with pilot experience being a mitigating factor. Each simulation aggregated claim counts and severities across the 100,000 runs to obtain the VaR and TVaR with the 5-year model summing annual losses with compounded growth effects. The time value of money was further incorporated through the historical interest rates and inflation data provided, with the 1-year and 5-year spot rates computed at 1.8% and 2.9% respectively.
Using standard actuarial pricing formula with profit margin (m) of 10% and expense ratio (e) of 15%:

and the expected annual loss under the one-year simulation, the indicated annual portfolio premium amounts to approximately 363.523 billion. It is also crucial to note that premiums and deductibles can be adjusted based on specific solar systems or cargos. For example, the coefficient for solar radiation in the Poisson GLM model was 0.52 which equates to e^(0.52 )=1.68 under a log-link. Hence solar systems such a Bayesia and Epsilon could justify higher severity loadings of up to 70% in premiums. Moreover, the coefficient for gold in the severity GLM was approximately 3.75, implying that cargos carrying precious metals and more expensive commodities could also be charged higher premiums or greater deductibles.


# 3.0	CAPITAL MODELLING & PRICING
## 3.1 Equipment Failure
Aggregate losses for equipment failure were calculated in which claim frequency was modelled using a Poisson distribution (λ=1182.2) and the severity of claims was modelled using a Lognormal distribution  (𝜇 =10.961 , 𝜎 = 0.494). A Monte-Carlo simulation with 100,000 iterations was used to generate short and long term aggregate loss distributions.
<img width="606" height="230" alt="image" src="https://github.com/user-attachments/assets/4acf0c30-57b0-48ff-bb5d-6c65eaf284b7" />

Table 1: Aggregate Loss Statistics in Currency (Đ).
The aggregate loss results indicate a stable, well-diversified portfolio with low relative volatility. For the 1-year horizon, the expected loss is $87.2m with a standard deviation of $3.0m (CV: 3.4%), suggesting limited variability around the mean. Over the 10-year horizon, the expected loss increases to $863.8m, while the CV falls to 1.1%, reflecting the benefits of diversification over time and a more predictable aggregate outcome.
The VaR metrics reinforce this stability, with the 99.5% VaR only modestly above the mean for both horizons, indicating limited tail risk. From a pricing perspective, this supports relatively low risk margins above expected losses. From a capital perspective, the small gap between expected losses and extreme percentiles suggests modest capital requirements relative to portfolio size.
<img width="496" height="212" alt="image" src="https://github.com/user-attachments/assets/23f9fd9b-4834-4a80-ae66-f5d3748a8723" />

Table 2: Stress Testing Statistics in Currency (Đ).
The stress testing results demonstrate the sensitivity of aggregate losses to changes in both claim frequency and severity in a 1-in-100 year event in which the baseline level of $94.3m indicates limited tail risk under current assumptions. A 50% increase in frequency or severity individually raises the 99% VaR to approximately $139–141m, showing that both drivers have a similar impact on tail losses, with severity contributing marginally more to extreme outcomes. Under the combined stress (+50% frequency and severity), the 99% VaR increases sharply to $209.2m, more than doubling the baseline. This highlights a compounding effect, where simultaneous deterioration in both drivers materially amplifies tail risk. Overall, the results demonstrate that while baseline risk is well-contained, the portfolio is highly sensitive to joint increases in frequency and severity, with significant implications for capital requirements under adverse conditions.
As seen in Appendix Figure 3, the equipment loss portfolio is profitable in the short term but deteriorates over time. In year 1, the mean net revenue is $4.4m with only a 7% probability of loss, indicating adequate pricing. By year 5, profit falls to $2.3m and the probability of loss rises to 37%, and by year 10 the portfolio is loss-making on average (−$39.8m) with persistent downside risk. Tail metrics also worsen, reflecting the compounding impact of volatility over longer horizons. The results highlight that without repricing or additional margins, this approach may not be sufficient to sustain profitability over longer horizons.

## 3.2 Workers Compensation
Aggregate losses for workers compensation were derived from a frequency-severity framework from 134,947 worker years of exposure. Monte Carlo simulations with 100,000 iterations were utilised to generate both short and long term (1 & 10 year PV) aggregate loss distributions. The frequency was modelled using Poisson distribution (λ=508.2) and severity modelled with log normal (𝜇 = 5.132, 𝜎 = 0.114). The aggregated results are summarised in the following table.
<img width="509" height="201" alt="image" src="https://github.com/user-attachments/assets/ccbec5f1-6847-43ff-8988-5e16b1842e40" />


Table 3: Aggregate Loss Statistics in Currency (Đ).
The long term coefficient shows even lower volatility likely from the smoothing effect of discounting over the 10 year horizon. The annual expected loss is 82,587 credits with a standard deviation of 3,667 credits. At the unlikely scenarios, 95% confidence level, losses are not expected to exceed 88,666 credits. The pure premium, calculated as the expected loss per worker (mean loss divided by number of workers) approximates to 2.31 credits per worker year. If we apply a standardised 25% loading for expenses and profits, we yield an annual premium of 2.89 credits per worker. This amounts to 103,234 credits across the workforce. 
Stress tests assess the financial impact of extreme scenarios with each scenario representing a very rare event. In a relatively conservative/plausible event where both severity and frequency have a 1.5x multiplier applied, the percent loss increases by 54% from the baseline loss.
<img width="699" height="101" alt="image" src="https://github.com/user-attachments/assets/bc0decd7-61f9-4a78-a46e-35fbf9fbc3d2" />


Table 4: Stress test table summary without exploration of scenarios (Full scenarios in appendix).
The baseline scenario represents a 1 in 200 year confidence level, indicating that a capital position of 92,069 credits is needed to insure this base event. In the stressed scenario, the VaR jumps by a moderate 49,372 credits. These results suggest that while the current capital position is sufficient for the baseline events, reinsurance may be needed for any event more catastrophic.
<img width="702" height="105" alt="image" src="https://github.com/user-attachments/assets/6533656d-177d-4e2b-bea7-5fb95bad6ee5" />


Table 5: Net revenue, VaR & TVaR Summary (in credits)
In a single year, the expected revenue is positive (20,647) and the 99% VaR is 12,080 credits.
In a 10 year horizon, the expected net revenue is negative (82,731) and the 99% VaR is 88,259 credits.
These results indicate short term net revenue is positive and long term net revenue is negative under current inflation and discount rates. This suggests a new pricing or investment strategy is needed.

## 3.3 Business Interruption
Aggregate losses for Business Interruption were modelled using a frequency–severity framework. Claim frequency was estimated using a Negative Binomial GLM and exposure offset, with predictors selected via a stepwise procedure based on AIC. Claim severity was modelled using a Gamma GLM to reflect the right-skewed nature of claim amounts. Model selection across alternative specifications was based on AIC comparisons. Monte Carlo simulation (100,000 iterations) was used to generate short-term (1-year) and long-term (10-year present value) aggregate loss distributions at the policy level.
<img width="605" height="235" alt="image" src="https://github.com/user-attachments/assets/d0e35f85-99b1-4d4e-a882-191bba861ef8" />

Table 6: Aggregate Loss Statistics in Currency
The short-term results show relatively high volatility, with a CV of 19.8%, and a clear gap between the mean and the 99.5% VaR, indicating a significant risk of extreme losses. In the long term, volatility decreases to a 6.4% CV due to diversification and discounting, although the gap between average and extreme outcomes remains. 
The larger scale of losses compared to other hazard classes is consistent with the underlying data, where Business Interruption claims are significantly higher in value. These results imply that capital requirements are driven primarily by tail risk rather than average losses, requiring pricing and capital buffers to be calibrated to extreme but plausible disruption scenarios.

<img width="608" height="211" alt="image" src="https://github.com/user-attachments/assets/ba8e5df0-e07d-4bcf-9f44-dc0b27e77b38" />


Table 7: Stress Testing Statistics in Currency (Đ).
The stress testing results highlight the portfolio’s strong sensitivity to changes in both claim frequency and severity. A 50% increase in either frequency or severity leads to a sizable rise in tail losses (approximately 45–51%), indicating that each driver independently contributes to risk. When both frequency and severity increase simultaneously by 50% each, we see losses more than double, at 119.4%, demonstrating a clear compounding effect. It can be seen from the non linear behaviour that aggregate risk is highly sensitive to joint deterioration rather than isolated shocks, highlighting significant exposure to correlated, system-wide disruption events. In the most extreme conditions (+200% in both drivers), losses increase dramatically by over 800%, highlighting significant exposure to severe tail events and the need for robust capital buffers against catastrophic scenarios. This highlights the importance of considering correlated shocks in capital modelling and pricing.
## 3.4 Cargo Loss
Capital modelling for cargo loss highlights the amount of risk capital which should be held by Galaxy General Insurance to cover potential losses through claims relating to cargo loss or damage. Two formulas were employed to approximate capital requirements in both short and long-term cases:
Capital=TVaR99​−E[L] and Capital=VaR99​−E[L].
Using the mean loss computed in the 1 and 5 year simulations as an estimation for expected loss as well as the TVaR and VaR figures, the short and long term capital requirements were calculated and displayed in the table below.
<img width="711" height="167" alt="image" src="https://github.com/user-attachments/assets/30719daa-61d4-42f3-bec4-827dd45a599e" />



Though both formulas are valid, it is recommended that Galaxy General Insurance uses the TVaR-based figures as these more accurately represent tail risk beyond the 99th percentile. This is because VaR figures only highlight the cutoff loss at a specific threshold rather than considering the severity of losses beyond this point. Conversely, TVaR captures the average value of losses beyond this point which is more suitable for heavily tailed data like the Cargo Loss Claims Severity as it provides a stronger indication of extreme tail risk. This more closely aligns with the goal of capital modelling which is to act as a buffer against extreme losses which cannot be funded by premiums alone. 
# 4.0	RISK ASSESSMENT
## 4.1 Equipment Failure
<img width="717" height="168" alt="image" src="https://github.com/user-attachments/assets/ca776678-6fcb-489a-bad7-c533be1cc4b9" />


The Helionis Cluster has the lowest average risk index, yet produces the highest total loss, indicating that risk is driven by scale and ageing Flux Rider equipment (10–14 years) rather than inherent per-unit hazard. The Bayesia System shows a similar loss profile but a higher risk index, suggesting that harsher environmental conditions amplify the risk of the same ageing equipment. In contrast, the Oryn Delta has the lowest total loss but the highest risk index, implying that while exposure is smaller, per-unit risk is greatest due to a more volatile environment, which outweighs the benefits of its younger asset base.
As seen in the threat table (Appendix Figure 5), the most severe scenario is the extreme correlated shock, where both frequency and severity increase by 200%, resulting in a 291% increase in the 99% VaR (Figure 5). This highlights the portfolio’s vulnerability to extreme, system-wide events, where simultaneous deterioration in both drivers leads to a compounding effect on tail risk. A more moderate system-wide disruption, such as a solar storm increasing both frequency and severity by 50%, still produces a substantial 121% increase in VaR. This reflects the portfolio’s sensitivity to common-cause shocks, particularly given the concentration of exposure across Helionis, Bayesia, and Oryn Delta. At the equipment level, Flux Riders represent a key vulnerability. Another correlated scenario is a equipment specific defect in which an increase in severity by 50% leads to a 50% increase in VaR. Similarly, a 50% increase in frequency results in a 47.8% increase in VaR compared to baseline levels (Figure 5). 
## 4.2 Workers Compensation
Workers compensation claims are resulted from the interaction between occupational hazards, environmental conditions and workforce demographics. Out of all 35,809 employees, only 1,889 workers made 1 or more claims. With the historical data amongst the employees the following risk profile is generated. 
<img width="717" height="194" alt="image" src="https://github.com/user-attachments/assets/0dd6dc9f-d8de-456b-b262-c55006bf7870" />


Of the 3 solar systems, Epsilon dominates with the number of workers (55,273) and low frequency (0.013) but has the second highest expected claims (711). This suggests that claims do not occur frequently, but when they do, they are often more severe. A likely reason may be from the lower range of gravity which may encourage complacency while simultaneously reducing the efficacy of producing appropriate safeguards. Zeta appears to be the leading cause of losses with the highest claim frequency (0.015) and expected annual claims (801) with strains and sprains being the dominating injury type. Helionis cluster, with the lowest worker count, has the second lowest frequency (0.015) despite having the highest gravity minimum and maximum level. 
There are 2 possible correlated risk scenarios that CQMC should be wary of. The first being an increase in musculoskeletal claims from higher gravity. Helionis cluster exhibits relatively the highest gravity which affects its high claim frequency (0.0149 claims per work year). An increase in workload intensity or even shift duration in this solar system can trigger a correlated spike in sprain and strain claims which is already the second most common injury type, accounting for 31% of the total. In Helionis alone, the 99% VaR would increase losses up to 91,153 credits (about a 10.4% increase) in the 1 year horizon. The second correlated risk scenario is the psychological stress from extended periods of isolation. Psychological and stress related injuries simultaneously account for 19.3% of all workers compensation claims. These particular injury types are sensitive and intrinsically related to factors like isolation and deployment length. Extended deployment cycles would both increase the quantity of workers exposed to isolation stress across all systems and compound fatigue related stress. With the highest claim frequency (0.0152 per worker year), they are most vulnerable to psychological injury claims but all systems are all susceptible to this risk. Under the stressed scenario model, the 99.5% VaR would increase aggregate losses from 92,069 to 141,441 credits (53.6% increase). The below table illustrates the results of a stress test using monte carlo simulation.

<img width="526" height="171" alt="image" src="https://github.com/user-attachments/assets/41c90330-406e-4555-9abe-72636ce27f44" />


Based on aggregating all historical data across the 3 solar systems, the top 5 injuries by risk score were derived (table in appendix). Across the solar systems, cut lacerations and strains are the most dominant injuries suggesting more emphasis on employees safety equipment and posture should be in place for prevention.

## 4.3 Business Interruption
<img width="703" height="132" alt="image" src="https://github.com/user-attachments/assets/80e88fe3-7d70-4a9d-8e9c-8c30abfa1eaf" />


Business interruption risk is concentrated in Epsilon and Zeta, which makes up 80% of total modelled losses, primarily driven by their larger number of policies, resulting in greater exposure to disruption events across these systems. While Helionis represents a smaller share of the portfolio (19.7%), it still generates substantial losses of $2.41bn, indicating that risk is not solely driven by scale but also by underlying operational characteristics.
The similar loss contributions of Epsilon and Zeta suggest that both systems carry comparable exposure levels, although differences in operational conditions and system resilience may influence the nature of disruptions. Overall, the results indicate that business interruption risk is driven by a combination of exposure (portfolio size) and system-specific factors affecting disruption frequency and severity.
<img width="699" height="219" alt="image" src="https://github.com/user-attachments/assets/0e600051-914b-46d9-b0e8-869f4fdd32e7" />


Table 8: Threat table in descending order.
Business interruption risk is dominated by correlated shocks, with joint increases in frequency and severity driving extreme tail losses. Supply chain dependence is the strongest individual driver, while systemic risks outweigh individual factors overall.
## 4.4 Cargo Loss
<img width="715" height="248" alt="image" src="https://github.com/user-attachments/assets/0a14dfef-97d0-480d-aac2-31ad8cec9a0b" />

The above results illustrate the substantial sensitivity of portfolio risk with respect to both claim frequency and severity. Whilst it can be observed that 50% increase in frequency or severity contributed to moderate increases of between 40% and 50% in VaR and TVaR figures, the combined effect of a 50% increase in both drivers leads to a highly non-linear impact with both risk measures more than doubling in size. This disproportional tail risk is further demonstrated in the extreme scenario of a 200% increase in both frequency and severity which precipitates an increase of over 700% in both risk measures. This substantial exposure in stress scenarios is indicative of strong tail dependence, emphasising the need for robust capital buffers and reinsurance structures to manage extreme downside risk.

# 5.0	ASSUMPTIONS
The historical data did not have any claims that occurred in the Bayesia System and Oryn Delta. Thus during capital modelling and price we assume the claim frequency and severity of Epsilon as a basis for the Bayesia system. This is because both solar systems are described as having high radiation, harsh environments, and challenging conditions for operations. 
Similarly, we assume the claim frequency and severity of Zeta as a basis for Oryn Delta. This is because solar systems have navigational hazards due to asteroid belts and chaotic orbits, with moderate flare activity.
The 14 years of historical data (2160–2174) are used to compute the average annual inflation rate and average spot rates for 1‑year and 10‑year maturities. These averages are assumed to be the most reasonable point estimates for future rates over the projection horizon. The average inflation rate was 2.4653%, average 1-year spot rate was 1.79 % and average 10-year spot rate 2.896 %.
Policies are assumed to be independent under normal conditions. The business interruption modelling introduced a dependence through multiplicative lognormal shocks to capture systematic risk, but idiosyncratic risk is not modelled.
Frequency–severity independence is assumed with no explicit dependence beyond shared covariates.

# 6.0	DATA AND DATA LIMITATIONS
To ensure data integrity and consistency while preserving maximum information, we implemented a standardised 2-stage cleaning process. First, outliers using the interquartile range (IQR) method in each data set were first found. Values falling outside the outlier bounds were removed to prevent distortion. Then any values remaining within the bounds were clipped to the nearest bound (either the maximum or minimum of the given ranges). This method balances data quality with retention. The analysis also uses a Monte Carlo simulation with 100,000 iterations. The following were also assumed as part of the project:
From the total number of claims, 14.59% of the frequency data and a third of the severity data were outliers according to the IQR method.
No variables had partial-year exposure. Full-year exposure for all workers is assumed.
Frequency estimates may be biased if actual exposures are varied.
Inflation/discount rates taken as constants from the most recent year
Ignores the stochastic nature of rates, so long-term projections may be less accurate 
For equipment failure, the data dictionary specifies equipment age between 0 and 10 years. However, approximately 45,000 (out of 95k) observations exceeded this limit in the frequency dataset, with values up to 20 years and an average of 10.34 years. Severity data  saw 5000 observations (out of 8.2k) exceed the maximum value. 
Removing these observations would result in substantial information loss as there is a substantial proportion outside the given range. Therefore, values above 10 were capped at 10 years to preserve the observations while aligning with the modelling assumptions in the data dictionary.

