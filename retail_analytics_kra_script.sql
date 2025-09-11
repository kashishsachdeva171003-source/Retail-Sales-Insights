
-- 1. Collected, cleaned, and pre-processed raw retail data
DELETE FROM orders
WHERE order_id NOT IN (
  SELECT MIN(order_id)
  FROM orders
  GROUP BY customer_id, order_date
);

UPDATE customers
SET city = 'Unknown'
WHERE city IS NULL;

-- 2. Designed and developed interactive sales dashboards (Power BI-ready SQL views)
CREATE OR REPLACE VIEW monthly_sales_summary AS
SELECT 
  DATE_TRUNC('month', order_date) AS month,
  SUM(total_amount) AS total_sales,
  COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
GROUP BY 1
ORDER BY 1;

-- 3. Analyzed customer purchasing patterns and seasonal trends
SELECT
  EXTRACT(MONTH FROM order_date) AS month,
  product_id,
  COUNT(*) AS sales_count
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
GROUP BY 1, 2
ORDER BY month, sales_count DESC
LIMIT 5;

-- 4. Wrote complex SQL queries to extract and merge data
SELECT
  c.customer_id,
  c.name,
  o.order_id,
  o.order_date,
  p.product_name,
  oi.quantity,
  oi.price
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- 5. Conducted A/B tests to assess discount strategies
SELECT 
  group_type,
  AVG(total_amount) AS avg_sales
FROM (
  SELECT 
    customer_id,
    total_amount,
    CASE 
      WHEN customer_id % 2 = 0 THEN 'Control'
      ELSE 'Test'
    END AS group_type
  FROM orders
) sub
GROUP BY group_type;

-- 6. Automated sales reports using SQL scripts
SELECT
  CURRENT_DATE AS report_date,
  COUNT(order_id) AS total_orders,
  SUM(total_amount) AS daily_revenue
FROM orders
WHERE order_date = CURRENT_DATE;

-- 7. Documented and presented analysis for stakeholders
SELECT
  COUNT(DISTINCT customer_id) AS total_customers,
  COUNT(order_id) AS total_orders,
  ROUND(SUM(total_amount), 2) AS total_revenue,
  ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders;

-- 8. Validated data before Power BI integration
SELECT *
FROM orders
WHERE customer_id IS NULL OR total_amount IS NULL;

SELECT *
FROM orders
WHERE total_amount < 0;

-- 9. Suggested insights for promotions
SELECT 
  promo_name,
  MIN(start_date) AS start,
  MAX(end_date) AS end,
  SUM(o.total_amount) AS total_sales
FROM discounts d
JOIN orders o ON o.order_date BETWEEN d.start_date AND d.end_date
GROUP BY promo_name;

-- 10. Weekly KPIs: Customer retention
SELECT 
  customer_id,
  COUNT(order_id) AS num_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

-- 11. Mentored on real-time retail analytics practices
SELECT 
  p.product_name,
  SUM(oi.quantity * oi.price) AS product_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;

-- 12. Weekly insights and dashboard data
SELECT
  DATE_TRUNC('week', order_date) AS week,
  COUNT(order_id) AS weekly_orders
FROM orders
GROUP BY week
ORDER BY week;

-- 13. Leads referred in support of analytics initiatives
SELECT 
  referred_by,
  COUNT(lead_id) AS total_leads
FROM leads
WHERE referral_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY referred_by;
