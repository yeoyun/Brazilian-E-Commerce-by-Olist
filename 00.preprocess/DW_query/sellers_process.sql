-- 전체 건수
SELECT COUNT(*) FROM olist_sellers_raw;

-- 각 컬럼별 결측치 수 확인
SELECT
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS null_seller_id,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_zip,
    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS null_state
FROM olist_sellers_raw;

-- 이상치 예시: zip code prefix가 0보다 작거나 너무 짧은 경우
SELECT * FROM olist_sellers_raw
WHERE seller_zip_code_prefix <= 0
   OR LENGTH(seller_state) <> 2;