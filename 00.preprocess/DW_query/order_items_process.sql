-- 음수 가격, 배송비 확인
SELECT * FROM olist_order_items_raw
WHERE price < 0 OR freight_value < 0;

-- 배송 제한일이 주문일보다 빠름
SELECT i.*
FROM olist_order_items_raw i
JOIN olist_orders o ON i.order_id = o.order_id
WHERE i.shipping_limit_date < o.order_purchase_timestamp;
