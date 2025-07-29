-- 정제 기준에 따라 olist_order_items로 덮어쓰기
DROP TABLE IF EXISTS olist_order_items;

CREATE TABLE olist_order_items AS
SELECT items.*
FROM olist_order_items_raw items
JOIN olist_orders orders ON items.order_id = orders.order_id
WHERE items.price >= 0
  AND items.freight_value >= 0
  AND items.shipping_limit_date >= orders.order_purchase_timestamp;
