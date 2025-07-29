-- 전체 행 수
SELECT COUNT(*) AS total_rows FROM olist_geolocation_raw;

-- NULL 값 확인
SELECT
  SUM(CASE WHEN geolocation_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_zip,
  SUM(CASE WHEN geolocation_lat IS NULL THEN 1 ELSE 0 END) AS null_lat,
  SUM(CASE WHEN geolocation_lng IS NULL THEN 1 ELSE 0 END) AS null_lng,
  SUM(CASE WHEN geolocation_city IS NULL THEN 1 ELSE 0 END) AS null_city,
  SUM(CASE WHEN geolocation_state IS NULL THEN 1 ELSE 0 END) AS null_state
FROM olist_geolocation_raw;

-- 위도/경도 이상치 확인 (브라질 기준)
SELECT *
FROM olist_geolocation_raw
WHERE geolocation_lat < -34 OR geolocation_lat > 6
   OR geolocation_lng < -75 OR geolocation_lng > -30
LIMIT 100;
