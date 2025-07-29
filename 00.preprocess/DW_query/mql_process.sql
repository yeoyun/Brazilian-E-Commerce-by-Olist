SELECT * FROM olist_dw.olist_marketing_qualified_leads_raw;

SELECT COUNT(*) AS total_rows
FROM olist_marketing_qualified_leads_raw;

SELECT
  SUM(CASE WHEN mql_id IS NULL THEN 1 ELSE 0 END) AS null_mql_id,
  SUM(CASE WHEN first_contact_date IS NULL THEN 1 ELSE 0 END) AS null_first_contact_date,
  SUM(CASE WHEN landing_page_id IS NULL THEN 1 ELSE 0 END) AS null_landing_page_id,
  SUM(CASE WHEN origin IS NULL THEN 1 ELSE 0 END) AS null_origin
FROM olist_marketing_qualified_leads_raw;

SELECT *
FROM olist_marketing_qualified_leads_raw
WHERE first_contact_date < '1900-01-01'
   OR first_contact_date > '2100-01-01';

SELECT DISTINCT origin
FROM olist_marketing_qualified_leads_raw
WHERE origin IS NULL OR TRIM(origin) = '';

SELECT *
FROM olist_marketing_qualified_leads_raw
WHERE origin IS NULL;


