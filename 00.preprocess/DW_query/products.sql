-- 1. 테이블 먼저 생성
CREATE TABLE IF NOT EXISTS olist_products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- 2. 결측치 및 이상치 제거하고 정제 데이터 INSERT
INSERT INTO olist_products
SELECT *
FROM olist_products_raw
WHERE
    product_category_name IS NOT NULL AND
    product_name_lenght IS NOT NULL AND
    product_description_lenght IS NOT NULL AND
    product_photos_qty IS NOT NULL AND
    product_weight_g IS NOT NULL AND
    product_length_cm IS NOT NULL AND
    product_height_cm IS NOT NULL AND
    product_width_cm IS NOT NULL AND
    product_name_lenght >= 0 AND
    product_description_lenght >= 0 AND
    product_photos_qty >= 0 AND
    product_weight_g >= 0 AND
    product_length_cm >= 0 AND
    product_height_cm >= 0 AND
    product_width_cm >= 0;
