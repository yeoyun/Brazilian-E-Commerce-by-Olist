-- 전체 건수 확인
SELECT COUNT(*) FROM olist_order_payments_raw;

-- NULL 존재 여부
SELECT
    SUM(payment_sequential IS NULL) AS null_payment_sequential,
    SUM(payment_type IS NULL) AS null_payment_type,
    SUM(payment_installments IS NULL) AS null_payment_installments,
    SUM(payment_value IS NULL) AS null_payment_value
FROM olist_order_payments_raw;

-- 이상값 확인: 음수, 0
SELECT *
FROM olist_order_payments_raw
WHERE payment_installments < 0 OR payment_value < 0;
