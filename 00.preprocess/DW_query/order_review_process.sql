-- 1. 전체 건수
SELECT COUNT(*) AS total FROM olist_order_reviews_raw;

-- 2. 결측치 확인
SELECT
  COUNT(*) AS total,
  SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) AS null_review_id,
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
  SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END) AS null_review_score,
  SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END) AS null_creation_date,
  SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END) AS null_answer_timestamp
FROM olist_order_reviews_row;

-- 3. 리뷰 점수 범위 이상치
SELECT review_score, COUNT(*) AS cnt
FROM olist_order_reviews_row
GROUP BY review_score
ORDER BY review_score;

-- 4. 날짜 순서 이상치 (생성일 > 응답일인 경우)
SELECT *
FROM olist_order_reviews_row
WHERE review_creation_date > review_answer_timestamp;
