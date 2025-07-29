SELECT table_name, column_name
FROM information_schema.columns
WHERE table_schema = 'olist_dw'
  AND column_name LIKE '%\_id'
ORDER BY table_name;

-- orders 테이블의 order_id가 고유한지?
SELECT COUNT(DISTINCT order_id), COUNT(*) 
FROM olist_orders;

-- order_items.order_id → orders.order_id 관계 검증
SELECT COUNT(*) AS unmatched_count
FROM olist_order_items oi
LEFT JOIN olist_orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;
