-- 주문 금액 및 배송비 이상치 확인
SELECT price, freight_value
FROM olist_order_items
ORDER BY price DESC
LIMIT 100;

-- 주문별 금액 합계 확인
SELECT order_id, SUM(price + freight_value) AS total_value
FROM olist_order_items
GROUP BY order_id
ORDER BY total_value DESC
LIMIT 100;