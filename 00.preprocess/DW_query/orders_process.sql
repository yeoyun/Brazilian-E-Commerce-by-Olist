-- 각 컬럼별 NULL 개수 확인
SELECT 
    COUNT(*) AS total_rows,
    SUM(order_status IS NULL) AS null_order_status,
    SUM(order_purchase_timestamp IS NULL) AS null_order_purchase_timestamp,
    SUM(order_approved_at IS NULL) AS null_order_approved_at,
    SUM(order_delivered_carrier_date IS NULL) AS null_order_delivered_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS null_order_delivered_customer_date,
    SUM(order_estimated_delivery_date IS NULL) AS null_order_estimated_delivery_date
FROM olist_orders_raw;

-- approved < purchase
SELECT COUNT(*) AS invalid_approval
FROM olist_orders_raw
WHERE order_approved_at < order_purchase_timestamp;

-- 배송일 < 출고일
SELECT COUNT(*) AS invalid_delivery_carrier
FROM olist_orders_raw
WHERE order_delivered_customer_date < order_delivered_carrier_date;

-- 예정보다 배송이 먼저 된 경우
SELECT COUNT(*) AS invalid_estimate
FROM olist_orders_raw
WHERE order_estimated_delivery_date < order_delivered_customer_date;

-- 전체 order_status 종류와 각 개수 확인
SELECT order_status, COUNT(*) AS cnt
FROM olist_orders_raw
GROUP BY order_status
ORDER BY cnt DESC;
