# Marketing Campaign Performance & Funnel Analysis


## Business Problem

A company runs marketing campaigns across different channels and customer segments. The marketing team wants to understand which campaigns and channels are performing well, where customers drop off in the marketing funnel, and which customer segments respond better to campaigns.

This project uses SQL to analyze campaign performance, customer interactions, conversion funnels, marketing channels, and customer segments to identify areas for improvement.


## Dataset

**Source:** Synthetic

| Table | Key Columns | Description |
|---|---|---|
| `campaigns` | `campaign_id`, `campaign_name`, `channel`, `budget`, `spend` | One row per campaign |
| `campaign_interactions` | `campaign_id`, `customer_id`, `interaction_type`, `converted_flag` | Customer touchpoints: Impression, Product Click, Add to Cart, Purchase |
| `conversions` | `campaign_id`, `customer_id`, `revenue_amount` | Revenue from converted customers |
| `customers` | `customer_id`, `customer_segment` | Customer attributes and segment |


## Analysis

**1. Campaign Performance**

**Business Question:**

Which marketing campaigns generate the highest revenue, ROAS, and conversion rate?

**SQL Query:**

```sql
WITH campaign_revenue AS (
	SELECT campaign_id, ROUND(SUM(revenue_amount)) AS Revenue
	FROM conversions
	GROUP BY campaign_id
),
campaign_customer_conversion AS (
	SELECT
		campaign_id,
		ROUND(COUNT(DISTINCT CASE WHEN converted_flag=1 THEN customer_id END)*100/COUNT(DISTINCT customer_id), 2) AS Conversion_Rate
	FROM campaign_interactions
	GROUP BY campaign_id
)
SELECT 
	c.campaign_name, c.Budget, c.Spend, r.Revenue, cv.Conversion_Rate, ROUND(r.revenue/c.spend, 2) AS ROAS
FROM campaigns c
LEFT JOIN campaign_revenue r ON c.campaign_id=r.campaign_id
LEFT JOIN campaign_customer_conversion cv ON c.campaign_id=cv.campaign_id;
```

**Output:**

<img width="627" height="476" alt="image" src="https://github.com/user-attachments/assets/ec81ff26-df73-4fab-98ba-d2bdec02c611" />

**2. Campaign Funnel Analysis**

**Business Question:**

Where do customers drop off in the funnel for different campaigns?

**SQL Query:**

```sql
WITH campaign_funnel AS (
	SELECT
			*,
			ROUND(Clicks*100/Impressions, 2) AS CTR,
			ROUND(Add_To_Cart*100/Clicks, 2) AS Add_To_Cart_Rate,
			ROUND(Purchases*100/Add_To_Cart, 2) AS Purchase_Rate
	FROM (
		SELECT
			campaign_id,
			COUNT(DISTINCT CASE WHEN interaction_type='Impression' THEN customer_id END) AS Impressions,
			COUNT(DISTINCT CASE WHEN interaction_type='Product Click' THEN customer_id END) AS Clicks,
			COUNT(DISTINCT CASE WHEN interaction_type='Add to Cart' THEN customer_id END) AS Add_To_Cart,
			COUNT(DISTINCT CASE WHEN interaction_type='Purchase' THEN customer_id END) AS Purchases
		FROM campaign_interactions
		GROUP BY campaign_id
	) t
)
SELECT 
	c.campaign_name, f.Impressions, f.Clicks, f.Add_To_Cart, f.Purchases, f.CTR, f.Add_To_Cart_Rate, f.Purchase_Rate
FROM campaigns c
LEFT JOIN campaign_funnel f ON c.campaign_id=f.campaign_id;
```

**Output:**

<img width="872" height="480" alt="image" src="https://github.com/user-attachments/assets/fae55432-75a2-4653-89d5-a082b7b96798" />

**3. Channel Performance**

**Business Question:**

Which marketing channels generate the best revenue, ROAS, and conversion rate?

**SQL Query:**

```sql
SELECT 
	t1.channel, t1.Spend, t2.Revenue, ROUND(t2.Revenue/t1.Spend, 2) AS ROAS, t3.Conversions_Rate 
FROM
	(SELECT channel, SUM(spend) AS Spend FROM campaigns GROUP BY channel) t1 
LEFT JOIN
	(SELECT c.channel, ROUND(SUM(cv.revenue_amount)) AS Revenue 
	FROM campaigns c LEFT JOIN conversions cv ON c.campaign_id=cv.campaign_id
	GROUP BY c.channel) t2
ON t1.channel=t2.channel
LEFT JOIN
	(SELECT c.channel, ROUND(COUNT(DISTINCT CASE WHEN converted_flag=1 THEN customer_id END)*100/COUNT(DISTINCT customer_id), 2) AS Conversions_Rate 
	FROM campaigns c LEFT JOIN campaign_interactions i ON c.campaign_id=i.campaign_id
	GROUP BY c.channel) t3
ON t1.channel=t3.channel;
```

**Output:**

<img width="495" height="180" alt="image" src="https://github.com/user-attachments/assets/d4441703-819d-4042-b921-118dc2299941" />

**4. Channel Funnel Analysis**

**Business Question:**

How does the customer funnel perform across different marketing channels?

**SQL Query:**

```sql
SELECT
	*, 
    ROUND(Clicks*100/Impressions, 2) AS CTR,
    ROUND(Add_To_Cart*100/Clicks, 2) AS Add_To_Cart_Rate,
    ROUND(Purchases*100/Add_To_Cart, 2) AS Purchase_Rate,
    ROUND(Purchases*100/Impressions, 2) AS Conversion_Rate
FROM (
	SELECT 
		c.channel, 
		COUNT(DISTINCT CASE WHEN interaction_type='Impression' THEN customer_id END) AS Impressions,
		COUNT(DISTINCT CASE WHEN interaction_type='Product Click' THEN customer_id END) AS Clicks,
		COUNT(DISTINCT CASE WHEN interaction_type='Add to Cart' THEN customer_id END) AS Add_To_Cart,
		COUNT(DISTINCT CASE WHEN interaction_type='Purchase' THEN customer_id END) AS Purchases
	FROM campaigns c 
	LEFT JOIN campaign_interactions i 
	ON c.campaign_id=i.campaign_id
	GROUP BY c.channel
) t;
```

**Output:**

<img width="932" height="186" alt="image" src="https://github.com/user-attachments/assets/e74f7d82-0c63-4bb9-9fb4-2ad923fc45f8" />

**5. Customer Segment Performance**

**Business Question:**

Which customer segments have the strongest engagement and conversion performance?

**SQL Query:**

```sql
SELECT
	t1.customer_segment, t1.Revenue, t2.CTR, t2.Add_To_Cart_Rate, t2.Purchase_Rate, t2.Conversion_Rate
FROM
	(SELECT
		c.customer_segment, ROUND(SUM(cv.revenue_amount)) AS Revenue
	FROM conversions cv
	JOIN customers c
	ON cv.customer_id=c.customer_id
	GROUP BY c.customer_segment) t1
LEFT JOIN
	(SELECT
		c.customer_segment, 
		ROUND(COUNT(DISTINCT CASE WHEN interaction_type='Product Click' THEN c.customer_id END)*100/
		COUNT(DISTINCT CASE WHEN interaction_type='Impression' THEN c.customer_id END), 2) AS CTR,
		ROUND(COUNT(DISTINCT CASE WHEN interaction_type='Add to Cart' THEN c.customer_id END)*100/
		COUNT(DISTINCT CASE WHEN interaction_type='Product Click' THEN c.customer_id END), 2) AS Add_To_Cart_Rate,
		ROUND(COUNT(DISTINCT CASE WHEN interaction_type='Purchase' THEN c.customer_id END)*100/
		COUNT(DISTINCT CASE WHEN interaction_type='Add to Cart' THEN c.customer_id END), 2) AS Purchase_Rate,
		ROUND(COUNT(DISTINCT CASE WHEN interaction_type='Purchase' THEN c.customer_id END)*100/
		COUNT(DISTINCT CASE WHEN interaction_type='Impression' THEN c.customer_id END), 2) AS Conversion_Rate
	FROM campaign_interactions i
	JOIN customers c
	ON i.customer_id=c.customer_id
	GROUP BY c.customer_segment) t2
ON t1.customer_segment=t2.customer_segment;
```

**Output:**

<img width="737" height="140" alt="image" src="https://github.com/user-attachments/assets/7f1d5cfa-3a12-4f69-8c1c-803818c6f116" />


## Key Insights

- **Campaign performance varied significantly:** Diwali Mega Sale generated 4.0 ROAS with a 14.49% conversion rate, while Clearance Campaign generated only 1.2 ROAS with a 4.99% conversion rate.

- **Strong campaigns had better early-funnel engagement:** Diwali Mega Sale achieved a 24.98% CTR and 59.94% Add-to-Cart Rate, compared with 12.99% CTR and 39.81% Add-to-Cart Rate for Clearance Campaign.

- **Channel efficiency differed by metric:** Google Ads achieved the highest conversion rate at 25%, while Email generated the highest ROAS at 3.25, showing that higher conversion did not necessarily result in higher ROAS.

- **Customer segments showed different conversion behavior:** Premium customers had the highest conversion rate at 52.96%, while Regular customers generated the highest revenue at ₹1.98M.

- **Purchase-stage conversion was strong even for weaker campaigns:** Clearance Campaign had a 96.47% Purchase Rate, close to Diwali Mega Sale's 96.77%, suggesting that the larger difference between these campaigns occurred earlier in the funnel.


## Recommendations

- Increase investment in high-performing campaigns such as Diwali Mega Sale and Loyalty Rewards, which generated stronger ROAS and conversion rates.
  
- Reduce or reconsider spending on low-performing campaigns such as Clearance and Winter Sale until their performance improves.
  
- Allocate more budget to efficient channels such as Email and Google Ads, while reviewing the budget assigned to lower-ROAS channels such as Display Ads.
  
- Improve campaign messaging and offers to increase early-funnel engagement, especially for campaigns with low CTR and Add-to-Cart Rates.
