DROP TABLE IF EXISTS dm_customer_rfm;

CREATE TABLE dm_customer_rfm AS
SELECT
    c.customer_unique_id,
    MAX(o.order_purchase_timestamp) AS last_purchase_date,
    DATEDIFF('2018-10-17', MAX(o.order_purchase_timestamp)) AS recency,
    COUNT(DISTINCT o.order_id) AS frequency,
    SUM(oi.price) AS monetary,
    SUM(oi.freight_value) AS shipping,
    cu.customer_state
FROM olist_orders o
JOIN olist_order_items oi ON o.order_id = oi.order_id
JOIN olist_customers c ON o.customer_id = c.customer_id
LEFT JOIN olist_customers cu ON o.customer_id = cu.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, cu.customer_state;