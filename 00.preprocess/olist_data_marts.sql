
	CREATE TABLE dm_sales_summary AS
	SELECT 
		o.order_id,
		o.customer_id,
		o.order_purchase_timestamp,
		SUM(oi.price + oi.freight_value) AS total_gmv,
		SUM(oi.price) AS product_total,
		SUM(oi.freight_value) AS total_shipping,
		COUNT(DISTINCT oi.product_id) AS num_products
	FROM olist_orders o
	JOIN olist_order_items oi ON o.order_id = oi.order_id
	GROUP BY o.order_id, o.customer_id, o.order_purchase_timestamp;


    CREATE TABLE dm_product_performance AS
    SELECT 
        p.product_id,
        p.product_category_name,
        COUNT(oi.order_id) AS total_orders,
        SUM(oi.price) AS total_sales
    FROM olist_products p
    JOIN olist_order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id;
    


    CREATE TABLE dm_category_gmv AS
    SELECT 
        pt.product_category_name_english AS category,
        SUM(oi.price + oi.freight_value) AS total_gmv
    FROM olist_order_items oi
    JOIN olist_products p ON oi.product_id = p.product_id
    JOIN product_category_name_translation pt
      ON p.product_category_name = pt.product_category_name
    GROUP BY pt.product_category_name_english;
    


    CREATE TABLE dm_seller_performance AS
    SELECT 
        s.seller_id,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        SUM(oi.price) AS total_sales,
        AVG(r.review_score) AS avg_review_score
    FROM olist_order_items oi
    JOIN olist_sellers s ON oi.seller_id = s.seller_id
    LEFT JOIN olist_order_reviews r ON oi.order_id = r.order_id
    GROUP BY s.seller_id;
    


    CREATE TABLE dm_review_quality AS
    SELECT 
        r.order_id,
        r.review_score,
        CHAR_LENGTH(r.review_comment_title) AS title_length,
        CHAR_LENGTH(r.review_comment_message) AS msg_length
    FROM olist_order_reviews r;
    


    CREATE TABLE dm_customer_rfm AS
    SELECT 
        o.customer_id,
        MAX(o.order_purchase_timestamp) AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price) AS monetary
    FROM olist_orders o
    JOIN olist_order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id;
    


    CREATE TABLE dm_customer_lifecycle AS
    SELECT 
        customer_id,
        MIN(order_purchase_timestamp) AS first_order_date,
        MAX(order_purchase_timestamp) AS last_order_date,
        COUNT(DISTINCT order_id) AS total_orders,
        DATEDIFF(MAX(order_purchase_timestamp), MIN(order_purchase_timestamp)) AS lifecycle_days,
        CASE 
            WHEN COUNT(DISTINCT order_id) = 1 THEN 'one-time'
            WHEN DATEDIFF(MAX(order_purchase_timestamp), MIN(order_purchase_timestamp)) < 90 THEN 'short-term'
            ELSE 'long-term'
        END AS lifecycle_type
    FROM olist_orders
    GROUP BY customer_id;
    


    CREATE TABLE dm_customer_churn_flag AS
    SELECT 
        customer_id,
        MAX(order_purchase_timestamp) AS last_order_date,
        CASE 
            WHEN MAX(order_purchase_timestamp) < DATE_SUB('2018-10-01', INTERVAL 90 DAY)
            THEN 1 ELSE 0
        END AS is_churned
    FROM olist_orders
    GROUP BY customer_id;
    


    CREATE TABLE dm_customer_recency_segment AS
    SELECT 
        customer_id,
        DATEDIFF('2018-10-01', MAX(order_purchase_timestamp)) AS days_since_last_order,
        CASE 
            WHEN DATEDIFF('2018-10-01', MAX(order_purchase_timestamp)) <= 30 THEN 'active'
            WHEN DATEDIFF('2018-10-01', MAX(order_purchase_timestamp)) <= 90 THEN 'warm'
            ELSE 'cold'
        END AS recency_group
    FROM olist_orders
    GROUP BY customer_id;
    


    CREATE TABLE dm_lead_conversion AS
    SELECT 
        m.mql_id,
        m.origin,
        m.first_contact_date,
        c.won_date,
        CASE WHEN c.won_date IS NOT NULL THEN 1 ELSE 0 END AS is_converted
    FROM olist_marketing_qualified_leads m
    LEFT JOIN olist_closed_deals c ON m.mql_id = c.mql_id;
    


    CREATE TABLE dm_funnel_stages AS
    SELECT 
        m.mql_id,
        m.origin,
        m.first_contact_date,
        CASE WHEN c.seller_id IS NOT NULL THEN 1 ELSE 0 END AS contacted,
        CASE WHEN c.won_date IS NOT NULL THEN 1 ELSE 0 END AS converted
    FROM olist_marketing_qualified_leads m
    LEFT JOIN olist_closed_deals c ON m.mql_id = c.mql_id;
    


    CREATE TABLE dm_cohort_retention AS
    SELECT 
        customer_id,
        DATE_FORMAT(MIN(order_purchase_timestamp), '%Y-%m') AS cohort_month,
        DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
        COUNT(order_id) AS order_count
    FROM olist_orders
    GROUP BY customer_id, order_month;
    


    CREATE TABLE dm_ad_hoc_simulation AS
    SELECT 
        m.origin,
        COUNT(*) AS total_leads,
        SUM(CASE WHEN c.won_date IS NOT NULL THEN 1 ELSE 0 END) AS converted_leads,
        ROUND(SUM(CASE WHEN c.won_date IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 4) AS conversion_rate
    FROM olist_marketing_qualified_leads m
    LEFT JOIN olist_closed_deals c ON m.mql_id = c.mql_id
    GROUP BY m.origin;
    