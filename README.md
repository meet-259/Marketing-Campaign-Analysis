# Marketing Campaign Performance & Funnel Analysis


## Business Problem

A company runs marketing campaigns across different channels and customer segments. The marketing team wants to understand which campaigns and channels are performing well, where customers drop off in the marketing funnel, and which customer segments respond better to campaigns.

This project uses SQL to analyze campaign performance, customer interactions, conversion funnels, marketing channels, and customer segments to identify areas for improvement.


## Analysis

**1. Campaign Performance**

**Business Question:**

Which marketing campaigns generate the highest revenue, ROAS, and conversion rate?

**SQL Query:**

<img width="1221" height="451" alt="image" src="https://github.com/user-attachments/assets/c26d84c4-473b-4c6a-8f0b-acf1a329972a" />

**Output:**

<img width="607" height="472" alt="image" src="https://github.com/user-attachments/assets/496f83bf-2a95-4b3a-9a02-2930fd9c5b95" />

**2. Campaign Funnel Analysis**

**Business Question:**

Where do customers drop off in the funnel for different campaigns?

**SQL Query:**

<img width="1167" height="555" alt="image" src="https://github.com/user-attachments/assets/4d03834b-4d21-41ac-8262-71ed6b6f25e9" />

**Output:**

<img width="872" height="480" alt="image" src="https://github.com/user-attachments/assets/fae55432-75a2-4653-89d5-a082b7b96798" />

**3. Channel Performance**

**Business Question:**

Which marketing channels generate the best revenue, ROAS, and conversion rate?

**SQL Query:**

<img width="1227" height="367" alt="image" src="https://github.com/user-attachments/assets/b1dbb917-4d2f-4d66-9167-9d737997db94" />

**Output:**

<img width="495" height="180" alt="image" src="https://github.com/user-attachments/assets/d4441703-819d-4042-b921-118dc2299941" />

**4. Channel Funnel Analysis**

**Business Question:**

How does the customer funnel perform across different marketing channels?

**SQL Query:**

<img width="1076" height="472" alt="image" src="https://github.com/user-attachments/assets/5ff13ef6-c357-43e4-9424-125b66efc590" />

**Output:**

<img width="932" height="186" alt="image" src="https://github.com/user-attachments/assets/e74f7d82-0c63-4bb9-9fb4-2ad923fc45f8" />

**5. Customer Segment Performance**

**Business Question:**

Which customer segments have the strongest engagement and conversion performance?

**SQL Query:**

<img width="1136" height="667" alt="image" src="https://github.com/user-attachments/assets/07f56349-6a45-456a-8d6f-6194baf6f65c" />

**Output:**

<img width="737" height="140" alt="image" src="https://github.com/user-attachments/assets/7f1d5cfa-3a12-4f69-8c1c-803818c6f116" />


## Key Insights

- **Campaign performance varied significantly:** Diwali Mega Sale and Loyalty Rewards achieved strong ROAS and conversion rates, while Clearance and Winter Sale generated much lower returns.

- **Early-funnel engagement was a key difference:** Strong campaigns had higher CTR and Add-to-Cart Rates, while weaker campaigns lost more customers before the purchase stage.

- **Channel performance differed by metric:** Google Ads had the highest conversion rate at 25%, while Email generated the highest ROAS at 3.25.

- **Customer segments behaved differently:** Premium customers showed the highest conversion rate, while Regular customers generated the highest overall revenue.

- **High conversion does not always mean higher ROAS:** The channel with the highest conversion rate was not the channel with the highest return on advertising spend.


## Recommendations

- Increase investment in high-performing campaigns such as Diwali Mega Sale and Loyalty Rewards, which generated stronger ROAS and conversion rates.
  
- Reduce or reconsider spending on low-performing campaigns such as Clearance and Winter Sale until their performance improves.
  
- Allocate more budget to efficient channels such as Email and Google Ads, while reviewing the budget assigned to lower-ROAS channels such as Display Ads.
  
- Improve campaign messaging and offers to increase early-funnel engagement, especially for campaigns with low CTR and Add-to-Cart Rates.
