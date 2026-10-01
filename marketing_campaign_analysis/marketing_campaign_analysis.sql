-- Campaign Performance
WITH campaign_revenue AS (
	SELECT campaign_id, ROUND(SUM(revenue_amount)) AS revenue
	FROM conversions
	GROUP BY campaign_id
),
campaign_customer_conversion AS (
	SELECT
		campaign_id,
		ROUND(COUNT(DISTINCT CASE WHEN converted_flag=1 THEN customer_id END)*100/COUNT(DISTINCT customer_id), 2) AS conversions
	FROM campaign_interactions
	GROUP BY campaign_id
)
SELECT 
	c.campaign_name, c.budget, c.spend, r.revenue, cv.conversions, ROUND(r.revenue/c.spend, 2) AS ROAS
FROM campaigns c
LEFT JOIN campaign_revenue r ON c.campaign_id=r.campaign_id
LEFT JOIN campaign_customer_conversion cv ON c.campaign_id=cv.campaign_id;



-- Campaign Funnel
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



-- Channel Performance
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



-- Channel Funnel
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



-- Customer Segment Performance
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