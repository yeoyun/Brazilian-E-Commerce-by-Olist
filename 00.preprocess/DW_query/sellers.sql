-- 1. 정제 테이블 생성
CREATE TABLE IF NOT EXISTS olist_sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

-- 2. 정제 테이블로 데이터 복사
INSERT INTO olist_sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state)
SELECT seller_id, seller_zip_code_prefix, seller_city, seller_state
FROM olist_sellers_raw;
