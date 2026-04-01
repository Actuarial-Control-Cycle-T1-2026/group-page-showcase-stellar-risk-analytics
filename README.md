[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/FxAEmrI0)
# Risk Stellar Analytics SOA Report

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
Feature
Basic
Standard
Comprehensive
Catastrophe XL
Avg. expected loss/policy
$61,713
$124,853
$190,804
Portfolio tail
Avg. risk loading
29.8%
38.9%
48.3%
Separate XL premium
Avg. premium/policy
$80,838
$173,782
$283,899
—
Per-occurrence limit
$750,000
$1,100,000
$1,426,000
$5,000,000+
Ann. aggregate ded.
$2,000,000
$1,000,000
None
$15,000,000
Coverage trigger
72-hr downtime
48-hr downtime
24-hr downtime
Parametric declared event

b. Deductible Options
Policyholders may elect a per-occurrence deductible from the schedule below, priced using the Limited Expected Value function applied to the fitted Gamma severity distribution. A $150,000 deductible reduces the insured’s premium by 13.0%, aligning with the Basic tier structure.
Deductible
Exp. insured loss
% of coverage
Premium (30% load)
% change
$0 (nil)
$1,151,748
100.0%
$1,497,273
0.0%
$50,000
$1,101,748
95.7%
$1,432,273
4.3%
$100,000
$1,051,748
91.3%
$1,367,273
8.7%
$150,000
$1,001,748
87.0%
$1,302,273
13.0%
$200,000
$951,751
82.6%
$1,237,276
17.4%
$250,000
$901,764
78.3%
$1,172,293
21.7%

c. Annual Aggregate Deductible and Reinsurance
A $2B annual aggregate deductible (AAD) is recommended for the Standard tier and above, reducing the probability of portfolio losses exceeding the premium from 2.7% (no AAD) to 0.8%. An excess-of-loss reinsurance treaty of $15B xs $6B is further recommended to cap the net 99.5th-percentile loss at $15.1B, within premium capacity, thereby reducing the probability of an unprofitable year to 0.1%. Comparisons of alternative AAD and reinsurance structures are provided in Appendix Tables 3.1.2 and 3.1.3.
e. Exclusions
Losses arising from pre-existing defects are excluded, with annual re-inspections triggering re-underwriting where necessary. Planned maintenance shutdowns are not considered, as these represent expected operational downtime and can be verified through station telemetry logs. Policies with a supply chain index above 0.90 are excluded because this exceeds the model's calibrated range and introduces disproportionate risk. Business interruption losses extending beyond 180 days are excluded due to the long-tail nature of such exposures, although extended coverage may be offered through an additional premium endorsement. Finally, losses resulting from war, sanctions, or regulatory seizure are excluded, as these constitute uninsurable political risks and fall outside the scope of actuarial modelling.

## 2.4	Cargo Loss
Mean claim severity
8,358,368
Mean claim count
0.245
Variance of claim severity
5.14 × 10^14
Variance of claim count
0.350
95th percentile claim
44,768,437
Total claims
29,294
99th percentile claim
107,121,116
Total exposure
60,719

The product design for Cargo Loss Insurance is indemnity based with coverage triggers occurring from physical loss or damage of cargo during transit. Moreover, the above table providing summary statistics relating to claim severity highlights significant disparity between most claims and the tail, with claims in the 95% percentile being over five times larger than mean claims and claims in the 99th percentile being almost thirteen times as larger. Hence, it is evident that tail risk is the dominant factor within the claims portfolio, whereby a deductible can be employed to remove insignificant and attritional claims and reduce administrative costs. Given the scale of the claims data and the disparity between the mean and median claim severity (8.36 million versus 466 thousand), a baseline deductible of 10% of the mean claim size (836 thousand) should be implemented. Not only would this still provide coverage for large claims, but it would remove approximately 60 percent of claims based on historical data.
Statistic
1 Year Simulation
5 Year Simulation
Mean
280,779,353,755
1.687363 × 10^12
Standard deviation
18,592,262,340
49,212,511,842
95th percentile
311,715,631,484
1.768424 × 10^12
99th percentile
338,271,584,799
1.827439 × 10^12
VaR 95
311,715,631,484
1.768424 × 10^12
TVaR 95
330,061,000,000
1.809890 × 10^12
VaR 99
338,271,584,799
1.827439 × 10^12

As with previous computations, 100,000 Monte Carlo Simulations were employed to predict both short and long term aggregate losses. Claim frequency was modelled using a Poisson distribution with λ = 28,294 and a claim severity was modelled utilising a lognormal distribution with µ and σ2 derived from the historical data at 1.46 and 14.88 respectively. Moreover, a Poisson generalised linear model (GLM) with a log-link was also employed to simulate claim frequencies. This determined that key drivers in claim occurrences included route risk, debris density and solar radiation with pilot experience being a mitigating factor. Each simulation aggregated claim counts and severities across the 100,000 runs to obtain the VaR and TVaR with the 5-year model summing annual losses with compounded growth effects. The time value of money was further incorporated through the historical interest rates and inflation data provided, with the 1-year and 5-year spot rates computed at 1.8% and 2.9% respectively.
Using standard actuarial pricing formula with profit margin (m) of 10% and expense ratio (e) of 15%:

and the expected annual loss under the one-year simulation, the indicated annual portfolio premium amounts to approximately 363.523 billion. It is also crucial to note that premiums and deductibles can be adjusted based on specific solar systems or cargos. For example, the coefficient for solar radiation in the Poisson GLM model was 0.52 which equates to e^(0.52 )=1.68 under a log-link. Hence solar systems such a Bayesia and Epsilon could justify higher severity loadings of up to 70% in premiums. Moreover, the coefficient for gold in the severity GLM was approximately 3.75, implying that cargos carrying precious metals and more expensive commodities could also be charged higher premiums or greater deductibles.


# 3.0	CAPITAL MODELLING & PRICING
## 3.1 Equipment Failure
Aggregate losses for equipment failure were calculated in which claim frequency was modelled using a Poisson distribution (λ=1182.2) and the severity of claims was modelled using a Lognormal distribution  (𝜇 =10.961 , 𝜎 = 0.494). A Monte-Carlo simulation with 100,000 iterations was used to generate short and long term aggregate loss distributions.
Statistic
Short term (1 Year)
Long term (10 Year PV)
Expected Loss
87,213,946
863,831,595
Standard Deviation
3,002,910
9,452,234
Coefficient of Variation (CV)
0.034
0.011
95% VaR
92,186,792
879,396,048
99% VaR
94,316,293
885,726,239
99.5% VaR
95,093,604
888,125,238

Table 1: Aggregate Loss Statistics in Currency (Đ).
The aggregate loss results indicate a stable, well-diversified portfolio with low relative volatility. For the 1-year horizon, the expected loss is $87.2m with a standard deviation of $3.0m (CV: 3.4%), suggesting limited variability around the mean. Over the 10-year horizon, the expected loss increases to $863.8m, while the CV falls to 1.1%, reflecting the benefits of diversification over time and a more predictable aggregate outcome.
The VaR metrics reinforce this stability, with the 99.5% VaR only modestly above the mean for both horizons, indicating limited tail risk. From a pricing perspective, this supports relatively low risk margins above expected losses. From a capital perspective, the small gap between expected losses and extreme percentiles suggests modest capital requirements relative to portfolio size.
Scenario
99% VaR
(% Increase)
Baseline
94,316,293
—
+50% Frequency
139,461,560
47.8%
+50% Severity
141,474,440
50%
Frequency & Severity (+50% each)
209,192,340
121%
Frequency & Severity (+200% each)
368,984,749
291%

Table 2: Stress Testing Statistics in Currency (Đ).
The stress testing results demonstrate the sensitivity of aggregate losses to changes in both claim frequency and severity in a 1-in-100 year event in which the baseline level of $94.3m indicates limited tail risk under current assumptions. A 50% increase in frequency or severity individually raises the 99% VaR to approximately $139–141m, showing that both drivers have a similar impact on tail losses, with severity contributing marginally more to extreme outcomes. Under the combined stress (+50% frequency and severity), the 99% VaR increases sharply to $209.2m, more than doubling the baseline. This highlights a compounding effect, where simultaneous deterioration in both drivers materially amplifies tail risk. Overall, the results demonstrate that while baseline risk is well-contained, the portfolio is highly sensitive to joint increases in frequency and severity, with significant implications for capital requirements under adverse conditions.
As seen in Appendix Figure 3, the equipment loss portfolio is profitable in the short term but deteriorates over time. In year 1, the mean net revenue is $4.4m with only a 7% probability of loss, indicating adequate pricing. By year 5, profit falls to $2.3m and the probability of loss rises to 37%, and by year 10 the portfolio is loss-making on average (−$39.8m) with persistent downside risk. Tail metrics also worsen, reflecting the compounding impact of volatility over longer horizons. The results highlight that without repricing or additional margins, this approach may not be sufficient to sustain profitability over longer horizons.

## 3.2 Workers Compensation
Aggregate losses for workers compensation were derived from a frequency-severity framework from 134,947 worker years of exposure. Monte Carlo simulations with 100,000 iterations were utilised to generate both short and long term (1 & 10 year PV) aggregate loss distributions. The frequency was modelled using Poisson distribution (λ=508.2) and severity modelled with log normal (𝜇 = 5.132, 𝜎 = 0.114). The aggregated results are summarised in the following table.
Statistic
Short term (1-year)
Long term (10 Year PV)
Expected Loss
82,587
102,973
Standard Deviation
3,667
2,429
95% VaR
88,666
107,001
99% VaR
91,153 
108,501
99.5% VaR
92,069
109,099

Table 3: Aggregate Loss Statistics in Currency (Đ).
The long term coefficient shows even lower volatility likely from the smoothing effect of discounting over the 10 year horizon. The annual expected loss is 82,587 credits with a standard deviation of 3,667 credits. At the unlikely scenarios, 95% confidence level, losses are not expected to exceed 88,666 credits. The pure premium, calculated as the expected loss per worker (mean loss divided by number of workers) approximates to 2.31 credits per worker year. If we apply a standardised 25% loading for expenses and profits, we yield an annual premium of 2.89 credits per worker. This amounts to 103,234 credits across the workforce. 
Stress tests assess the financial impact of extreme scenarios with each scenario representing a very rare event. In a relatively conservative/plausible event where both severity and frequency have a 1.5x multiplier applied, the percent loss increases by 54% from the baseline loss.
Scenario
Frequency multiplier
Severity Multiplier
99.5% VaR
Increase from baseline
Baseline
1.0x
1.0x
92,069
–
Stressed
1.5x
1.5x
141,441
+ 53.06%

Table 4: Stress test table summary without exploration of scenarios (Full scenarios in appendix).
The baseline scenario represents a 1 in 200 year confidence level, indicating that a capital position of 92,069 credits is needed to insure this base event. In the stressed scenario, the VaR jumps by a moderate 49,372 credits. These results suggest that while the current capital position is sufficient for the baseline events, reinsurance may be needed for any event more catastrophic.
Time Horizon
Premium
Expected Loss
Net Revenue
Standard Deviation
99% VaR
1 Year
103,234
82,587
20,647
3,667
12,080
10 Years (PV)
20,242
102,973
(82,731)
2,429
(88,259)

Table 5: Net revenue, VaR & TVaR Summary (in credits)
In a single year, the expected revenue is positive (20,647) and the 99% VaR is 12,080 credits.
In a 10 year horizon, the expected net revenue is negative (82,731) and the 99% VaR is 88,259 credits.
These results indicate short term net revenue is positive and long term net revenue is negative under current inflation and discount rates. This suggests a new pricing or investment strategy is needed.

## 3.3 Business Interruption
Aggregate losses for Business Interruption were modelled using a frequency–severity framework. Claim frequency was estimated using a Negative Binomial GLM and exposure offset, with predictors selected via a stepwise procedure based on AIC. Claim severity was modelled using a Gamma GLM to reflect the right-skewed nature of claim amounts. Model selection across alternative specifications was based on AIC comparisons. Monte Carlo simulation (100,000 iterations) was used to generate short-term (1-year) and long-term (10-year present value) aggregate loss distributions at the policy level.
Statistic
Short term (1 Year)
Long term (10 Year PV)
Expected Loss
12,348,565,039
124,100,682,082
Standard Deviation
2,441,423,353
7,965,720,775
Coefficient of Variation (CV)
0.198
0.0642
95% VaR
16,479,519,339
137,865,896,826
99% VaR
18,736,121,604
143,766,053,995
99.5% VaR
19,621,183,926
146,613,128,641

Table 6: Aggregate Loss Statistics in Currency (Đ).
The short-term results show relatively high volatility, with a CV of 19.8%, and a clear gap between the mean and the 99.5% VaR, indicating a significant risk of extreme losses. In the long term, volatility decreases to a 6.4% CV due to diversification and discounting, although the gap between average and extreme outcomes remains. 
The larger scale of losses compared to other hazard classes is consistent with the underlying data, where Business Interruption claims are significantly higher in value. These results imply that capital requirements are driven primarily by tail risk rather than average losses, requiring pricing and capital buffers to be calibrated to extreme but plausible disruption scenarios.
Scenario
99.5% VaR
% increase from baseline
Baseline
21,291,237,176
-
+50% Frequency
32,065,219,031
50.6%
+50% Severity
30,880,227,141
45.0%
Frequency & Severity (+50% each)
46,722,353,109
119.4%
Frequency & Severity (+200% each)
193,674,395,328
809.6%

Table 7: Stress Testing Statistics in Currency (Đ).
The stress testing results highlight the portfolio’s strong sensitivity to changes in both claim frequency and severity. A 50% increase in either frequency or severity leads to a sizable rise in tail losses (approximately 45–51%), indicating that each driver independently contributes to risk. When both frequency and severity increase simultaneously by 50% each, we see losses more than double, at 119.4%, demonstrating a clear compounding effect. It can be seen from the non linear behaviour that aggregate risk is highly sensitive to joint deterioration rather than isolated shocks, highlighting significant exposure to correlated, system-wide disruption events. In the most extreme conditions (+200% in both drivers), losses increase dramatically by over 800%, highlighting significant exposure to severe tail events and the need for robust capital buffers against catastrophic scenarios. This highlights the importance of considering correlated shocks in capital modelling and pricing.
## 3.4 Cargo Loss
Capital modelling for cargo loss highlights the amount of risk capital which should be held by Galaxy General Insurance to cover potential losses through claims relating to cargo loss or damage. Two formulas were employed to approximate capital requirements in both short and long-term cases:
Capital=TVaR99​−E[L] and Capital=VaR99​−E[L].
Using the mean loss computed in the 1 and 5 year simulations as an estimation for expected loss as well as the TVaR and VaR figures, the short and long term capital requirements were calculated and displayed in the table below.
Capital Measure 
Capital Requirement
VaR (1 year)
58.370 billion
TVaR (1 year)
92.483 billion
VaR (5 years)
140 billion
TVaR (5 years)
207 billion

Though both formulas are valid, it is recommended that Galaxy General Insurance uses the TVaR-based figures as these more accurately represent tail risk beyond the 99th percentile. This is because VaR figures only highlight the cutoff loss at a specific threshold rather than considering the severity of losses beyond this point. Conversely, TVaR captures the average value of losses beyond this point which is more suitable for heavily tailed data like the Cargo Loss Claims Severity as it provides a stronger indication of extreme tail risk. This more closely aligns with the goal of capital modelling which is to act as a buffer against extreme losses which cannot be funded by premiums alone. 
# 4.0	RISK ASSESSMENT
## 4.1 Equipment Failure
Risk
Helionis Cluster
Bayesia System (Epsilon)
Oryn Delta(Zeta)
Total Expected Loss (Đ million)
2137
2176
837
Primary Equipment Type
Flux Rider
Flux Rider
Flux Rider
Main Age Band
10-14
10-14
<5
Average Risk Index
0.48
0.55
0.65

The Helionis Cluster has the lowest average risk index, yet produces the highest total loss, indicating that risk is driven by scale and ageing Flux Rider equipment (10–14 years) rather than inherent per-unit hazard. The Bayesia System shows a similar loss profile but a higher risk index, suggesting that harsher environmental conditions amplify the risk of the same ageing equipment. In contrast, the Oryn Delta has the lowest total loss but the highest risk index, implying that while exposure is smaller, per-unit risk is greatest due to a more volatile environment, which outweighs the benefits of its younger asset base.
As seen in the threat table (Appendix Figure 5), the most severe scenario is the extreme correlated shock, where both frequency and severity increase by 200%, resulting in a 291% increase in the 99% VaR (Figure 5). This highlights the portfolio’s vulnerability to extreme, system-wide events, where simultaneous deterioration in both drivers leads to a compounding effect on tail risk. A more moderate system-wide disruption, such as a solar storm increasing both frequency and severity by 50%, still produces a substantial 121% increase in VaR. This reflects the portfolio’s sensitivity to common-cause shocks, particularly given the concentration of exposure across Helionis, Bayesia, and Oryn Delta. At the equipment level, Flux Riders represent a key vulnerability. Another correlated scenario is a equipment specific defect in which an increase in severity by 50% leads to a 50% increase in VaR. Similarly, a 50% increase in frequency results in a 47.8% increase in VaR compared to baseline levels (Figure 5). 
## 4.2 Workers Compensation
Workers compensation claims are resulted from the interaction between occupational hazards, environmental conditions and workforce demographics. Out of all 35,809 employees, only 1,889 workers made 1 or more claims. With the historical data amongst the employees the following risk profile is generated. 
Risk
Helionis Cluster
Epsilon
Zeta
Gravity Level 
1.35-1.5g
0.85-1.15g
0.75-1.5g
Workers 
26,931
55,273
52,580
Frequency
0.0149
0.0129
0.0152
Expected annual claims
400
711
801
Primary injury types
Sprains, strains (37.9%)
Cut lacerations (34.6%)	
Sprains, strains (36.5% )

Of the 3 solar systems, Epsilon dominates with the number of workers (55,273) and low frequency (0.013) but has the second highest expected claims (711). This suggests that claims do not occur frequently, but when they do, they are often more severe. A likely reason may be from the lower range of gravity which may encourage complacency while simultaneously reducing the efficacy of producing appropriate safeguards. Zeta appears to be the leading cause of losses with the highest claim frequency (0.015) and expected annual claims (801) with strains and sprains being the dominating injury type. Helionis cluster, with the lowest worker count, has the second lowest frequency (0.015) despite having the highest gravity minimum and maximum level. 
There are 2 possible correlated risk scenarios that CQMC should be wary of. The first being an increase in musculoskeletal claims from higher gravity. Helionis cluster exhibits relatively the highest gravity which affects its high claim frequency (0.0149 claims per work year). An increase in workload intensity or even shift duration in this solar system can trigger a correlated spike in sprain and strain claims which is already the second most common injury type, accounting for 31% of the total. In Helionis alone, the 99% VaR would increase losses up to 91,153 credits (about a 10.4% increase) in the 1 year horizon. The second correlated risk scenario is the psychological stress from extended periods of isolation. Psychological and stress related injuries simultaneously account for 19.3% of all workers compensation claims. These particular injury types are sensitive and intrinsically related to factors like isolation and deployment length. Extended deployment cycles would both increase the quantity of workers exposed to isolation stress across all systems and compound fatigue related stress. With the highest claim frequency (0.0152 per worker year), they are most vulnerable to psychological injury claims but all systems are all susceptible to this risk. Under the stressed scenario model, the 99.5% VaR would increase aggregate losses from 92,069 to 141,441 credits (53.6% increase). The below table illustrates the results of a stress test using monte carlo simulation.

Scenario
Description
Value (credits)
Best case
5th percentile of loss distribution
76,612
Moderate case
Expected loss
82,587
Worst case
99.5% VaR
92,069
Catastrophic case
+50% frequency and severity
141,441

Based on aggregating all historical data across the 3 solar systems, the top 5 injuries by risk score were derived (table in appendix). Across the solar systems, cut lacerations and strains are the most dominant injuries suggesting more emphasis on employees safety equipment and posture should be in place for prevention.

## 4.3 Business Interruption
Risk
Helionis Cluster 
Epsilon
Zeta
Total Modelled Loss ($)
2.41bn
4.88bn
4.92bn
Share of Portfolio (%)
19.7%
39.9%
40.3%
Number of Policies
19,388
38,818
38,876

Business interruption risk is concentrated in Epsilon and Zeta, which makes up 80% of total modelled losses, primarily driven by their larger number of policies, resulting in greater exposure to disruption events across these systems. While Helionis represents a smaller share of the portfolio (19.7%), it still generates substantial losses of $2.41bn, indicating that risk is not solely driven by scale but also by underlying operational characteristics.
The similar loss contributions of Epsilon and Zeta suggest that both systems carry comparable exposure levels, although differences in operational conditions and system resilience may influence the nature of disruptions. Overall, the results indicate that business interruption risk is driven by a combination of exposure (portfolio size) and system-specific factors affecting disruption frequency and severity.
Threat
Metric
Value
Impact
Extreme correlated shock
% increase in 99.5% VaR (+200% each)
809.6%
Very High
System-wide disruption
% increase in 99.5% VaR (freq + sev +50%)
119.4%
Very High
Portfolio concentration
Share of total loss (Epsilon + Zeta)
80.2%
High
Supply chain disruption
Frequency relativity
1.1187
High
Maintenance failure
Frequency relativity
0.9858
Moderate

Table 8: Threat table in descending order.
Business interruption risk is dominated by correlated shocks, with joint increases in frequency and severity driving extreme tail losses. Supply chain dependence is the strongest individual driver, while systemic risks outweigh individual factors overall.
## 4.4 Cargo Loss
Scenario
Mean Loss
Standard Deviation
VaR (99%)
TVaR (99%)
Increase in VaR (99%)
Increase in TVaR (99%)
Baseline
280,903,780,485
19,183,595,868
339,273,319,184
373,386,680,078
0.00%
0.00%
+50% Frequency
421,210,237,178
23,532,510,304
491,422,992,165
530,330,963,512
44.85%
42.03%
+50% Severity
421,268,450,482
28,338,486,939
507,723,867,142
557,374,782,696
49.65%
49.28%
Frequency & Severity (+50%)
631,963,543,634
35,834,279,671
735,373,999,112
797,763,681,769
116.75%
113.66%
Frequency & Severity (+200%)
2,526,567,704,481
107,468,022,757
2,831,444,012,558
3,025,586,605,688
734.56%
710.31%

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

