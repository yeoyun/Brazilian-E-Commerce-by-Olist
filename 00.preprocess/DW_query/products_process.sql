-- 컬럼별 결측치 확인
SELECT
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS null_name_len,
    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS null_desc_len,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS null_photos,
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS null_weight,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS null_len,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS null_height,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS null_width
FROM olist_products_raw;

-- 음수 이상값 확인
SELECT *
FROM olist_products_raw
WHERE
    product_name_lenght < 0 OR
    product_description_lenght < 0 OR
    product_photos_qty < 0 OR
    product_weight_g < 0 OR
    product_length_cm < 0 OR
    product_height_cm < 0 OR
    product_width_cm < 0;
