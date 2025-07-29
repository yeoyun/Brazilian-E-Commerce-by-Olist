-- 1. 정제 테이블 생성 (원본과 동일 구조)
CREATE TABLE IF NOT EXISTS olist_geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

-- 2. 데이터 삽입 (필터링 없이 전체 이관)
INSERT INTO olist_geolocation (
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
)
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
FROM olist_geolocation_raw;
