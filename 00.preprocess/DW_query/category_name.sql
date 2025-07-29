-- 기존 정제 테이블이 존재한다면 삭제
DROP TABLE IF EXISTS product_category_name_translation;

-- 정제 테이블 생성 및 데이터 복사
CREATE TABLE product_category_name_translation AS
SELECT *
FROM product_category_name_translation_raw;
