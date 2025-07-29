-- 1. olist_orders
CREATE TABLE IF NOT EXISTS olist_orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

-- 2. olist_order_items
CREATE TABLE IF NOT EXISTS olist_order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price FLOAT,
    freight_value FLOAT,
    PRIMARY KEY (order_id, order_item_id)
);

-- 3. olist_customers
CREATE TABLE IF NOT EXISTS olist_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

-- 4. olist_order_reviews
CREATE TABLE IF NOT EXISTS olist_order_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

-- 5. olist_order_payments
CREATE TABLE IF NOT EXISTS olist_order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value FLOAT
);

-- 6. olist_products
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

-- 7. product_category_name_translation
CREATE TABLE IF NOT EXISTS product_category_name_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

-- 8. olist_sellers
CREATE TABLE IF NOT EXISTS olist_sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

-- 9. olist_geolocation
CREATE TABLE IF NOT EXISTS olist_geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

-- 10. olist_marketing_qualified_leads
CREATE TABLE IF NOT EXISTS olist_marketing_qualified_leads (
    mql_id VARCHAR(50) PRIMARY KEY,
    first_contact_date DATE,
    landing_page_id VARCHAR(50),
    origin VARCHAR(50)
);

-- 11. olist_closed_deals
CREATE TABLE IF NOT EXISTS olist_closed_deals (
    salesman_id VARCHAR(50),
    seller_id VARCHAR(50),
    won_date DATE,
    business_segment VARCHAR(50),
    lead_type VARCHAR(50),
    lead_behaviour_profile VARCHAR(50),
    has_company INT,
    has_gtin INT,
    average_stock FLOAT,
    business_type VARCHAR(50),
    declared_product_catalog_size INT,
    declared_monthly_revenue FLOAT
);
