-- 주문 상태 확인
SELECT DISTINCT order_status FROM olist_orders;

-- 주문 상태별 수량
SELECT order_status, COUNT(*) AS cnt
FROM olist_orders
GROUP BY order_status
ORDER BY cnt DESC;

-- 주문 샘플 확인
SELECT order_id, customer_id, order_status, order_purchase_timestamp
FROM olist_orders
LIMIT 100;