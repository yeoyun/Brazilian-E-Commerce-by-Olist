SELECT * FROM olist_dw.olist_closed_deals_raw;

SELECT COUNT(*) AS total_rows
FROM olist_closed_deals_raw;

SELECT
  SUM(CASE WHEN business_segment IS NULL THEN 1 ELSE 0 END) AS null_business_segment,
  SUM(CASE WHEN lead_type IS NULL THEN 1 ELSE 0 END) AS null_lead_type,
  SUM(CASE WHEN lead_behaviour_profile IS NULL THEN 1 ELSE 0 END) AS null_lead_behaviour_profile,
  SUM(CASE WHEN has_company IS NULL THEN 1 ELSE 0 END) AS null_has_company,
  SUM(CASE WHEN has_gtin IS NULL THEN 1 ELSE 0 END) AS null_has_gtin,
  SUM(CASE WHEN average_stock IS NULL THEN 1 ELSE 0 END) AS null_average_stock,
  SUM(CASE WHEN business_type IS NULL THEN 1 ELSE 0 END) AS null_business_type,
  SUM(CASE WHEN declared_product_catalog_size IS NULL THEN 1 ELSE 0 END) AS null_catalog_size
FROM olist_closed_deals_raw;


-- ZIP 코드가 5자리 숫자가 아닌 경우
SELECT *
FROM olist_closed_deals_raw
WHERE LENGTH(seller_zip_code_prefix) != 5;

-- won_date가 1900년 이전 또는 2100년 이후인 경우
SELECT *
FROM olist_closed_deals_raw
WHERE won_date < '1900-01-01' OR won_date > '2100-01-01'
LIMIT 100;

-- 유효하지 않은 브라질 주 코드
SELECT DISTINCT seller_state
FROM olist_closed_deals_raw
WHERE LENGTH(seller_state) != 2;

