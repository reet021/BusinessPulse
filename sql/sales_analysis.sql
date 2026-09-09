-- BusinessPulse: Sales Analysis

-- 1. Total Sales
SELECT
    SUM(amount) AS total_sales
FROM sales;


-- 2. Total Profit
SELECT
    SUM(profit) AS total_profit
FROM sales;


-- 3. Overall Profit Margin
SELECT
    ROUND(
        SUM(profit) * 100.0 / NULLIF(SUM(amount), 0),
        2
    ) AS profit_margin_percentage
FROM sales;


-- 4. Category Performance
SELECT
    category,
    SUM(amount) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) * 100.0 / NULLIF(SUM(amount), 0),
        2
    ) AS profit_margin_percentage
FROM sales
GROUP BY category
ORDER BY total_sales DESC;


-- 5. Sub-Category Performance
SELECT
    category,
    sub_category,
    SUM(amount) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) * 100.0 / NULLIF(SUM(amount), 0),
        2
    ) AS profit_margin_percentage
FROM sales
GROUP BY category, sub_category
ORDER BY total_profit DESC;


-- 6. Monthly Sales and Profit
SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    SUM(amount) AS total_sales,
    SUM(profit) AS total_profit
FROM sales
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;


-- 7. Customer Performance
SELECT
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(amount) AS total_sales,
    SUM(profit) AS total_profit
FROM sales
GROUP BY customer_name
ORDER BY total_sales DESC;


-- 8. State Performance
SELECT
    state,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(amount) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) * 100.0 / NULLIF(SUM(amount), 0),
        2
    ) AS profit_margin_percentage
FROM sales
GROUP BY state
ORDER BY total_sales DESC;


-- 9. City Performance
SELECT
    city,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(amount) AS total_sales,
    SUM(profit) AS total_profit
FROM sales
GROUP BY city
ORDER BY total_sales DESC;

-- 10. Monthly Actual Sales vs Target

WITH monthly_sales AS (
    SELECT
        TO_CHAR(order_date, 'Mon-YY') AS month,
        category,
        SUM(amount) AS actual_sales
    FROM sales
    GROUP BY
        TO_CHAR(order_date, 'Mon-YY'),
        category
)

SELECT
    ms.month,
    ms.category,
    ms.actual_sales,
    st.target,
    ms.actual_sales - st.target AS variance,
    ROUND(
        ms.actual_sales * 100.0 / NULLIF(st.target, 0),
        2
    ) AS achievement_percentage
FROM monthly_sales ms
JOIN sales_target st
    ON ms.month = st.month_of_order_date
    AND ms.category = st.category
ORDER BY
    TO_DATE(ms.month, 'Mon-YY'),
    ms.category;