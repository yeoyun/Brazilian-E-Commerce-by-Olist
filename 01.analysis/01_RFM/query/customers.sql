-- customer_unique_id에 매핑되는 customer_id가 여러 개인지 확인
SELECT customer_unique_id, COUNT(DISTINCT customer_id) AS num_ids
FROM olist_customers
GROUP BY customer_unique_id
HAVING num_ids > 1
ORDER BY num_ids DESC
LIMIT 20;

-- 고객 지역 정보 확인
SELECT DISTINCT customer_state FROM olist_customers;

-- 고객별 마지막 구매일 
SELECT c.customer_unique_id, MAX(o.order_purchase_timestamp) AS last_purchase_date
FROM olist_orders o
JOIN olist_customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
LIMIT 100;
