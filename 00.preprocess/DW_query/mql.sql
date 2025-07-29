DROP TABLE olist_marketing_qualified_leads;

CREATE TABLE olist_marketing_qualified_leads AS
SELECT
    mql_id,
    first_contact_date,
    landing_page_id,
    COALESCE(origin, 'unknown') AS origin
FROM olist_marketing_qualified_leads_raw;
