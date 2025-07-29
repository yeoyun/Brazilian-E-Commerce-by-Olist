
    SELECT 
        'olist_customers → olist_orders (customer_id)' AS relation_check,
        COUNT(*) AS unmatched_count
    FROM olist_customers s
    LEFT JOIN olist_orders t ON s.customer_id = t.customer_id
    WHERE t.customer_id IS NULL;
    
    
    SELECT 
        'olist_closed_deals → olist_marketing_qualified_leads (mql_id)' AS relation_check,
        COUNT(*) AS unmatched_count
    FROM olist_closed_deals s
    LEFT JOIN olist_marketing_qualified_leads t ON s.mql_id = t.mql_id
    WHERE t.mql_id IS NULL;
    
    
    SELECT 
        'olist_order_items → olist_order_payments (order_id)' AS relation_check,
        COUNT(*) AS unmatched_count
    FROM olist_order_items s
    LEFT JOIN olist_order_payments t ON s.order_id = t.order_id
    WHERE t.order_id IS NULL;
    
    
    SELECT 
        'olist_order_items → olist_order_reviews (order_id)' AS relation_check,
        COUNT(*) AS unmatched_count
    FROM olist_order_items s
    LEFT JOIN olist_order_reviews t ON s.order_id = t.order_id
    WHERE t.order_id IS NULL;
    
    
    SELECT 
        'olist_order_items → olist_orders (order_id)' AS relation_check,
        COUNT(*) AS unmatched_count
    FROM olist_order_items s
    LEFT JOIN olist_orders t ON s.order_id = t.order_id
    WHERE t.order_id IS NULL;
    
    
    SELECT 
        'olist_order_payments → olist_order_reviews (order_id)' AS relation_check,
        COUNT(*) AS unmatched_count
    FROM olist_order_payments s
    LEFT JOIN olist_order_reviews t ON s.order_id = t.order_id
    WHERE t.order_id IS NULL;
    
    
    SELECT 
        'olist_order_payments → olist_orders (order_id)' AS relation_check,
        COUNT(*) AS unmatched_count
    FROM olist_order_payments s
    LEFT JOIN olist_orders t ON s.order_id = t.order_id
    WHERE t.order_id IS NULL;
    
    
    SELECT 
        'olist_order_reviews → olist_orders (order_id)' AS relation_check,
        COUNT(*) AS unmatched_count
    FROM olist_order_reviews s
    LEFT JOIN olist_orders t ON s.order_id = t.order_id
    WHERE t.order_id IS NULL;
    
    
    SELECT 
        'olist_order_items → olist_products (product_id)' AS relation_check,
        COUNT(*) AS unmatched_count
    FROM olist_order_items s
    LEFT JOIN olist_products t ON s.product_id = t.product_id
    WHERE t.product_id IS NULL;
    
    
    SELECT 
        'olist_closed_deals → olist_order_items (seller_id)' AS relation_check,
        COUNT(*) AS unmatched_count
    FROM olist_closed_deals s
    LEFT JOIN olist_order_items t ON s.seller_id = t.seller_id
    WHERE t.seller_id IS NULL;
    
    
    SELECT 
        'olist_closed_deals → olist_sellers (seller_id)' AS relation_check,
        COUNT(*) AS unmatched_count
    FROM olist_closed_deals s
    LEFT JOIN olist_sellers t ON s.seller_id = t.seller_id
    WHERE t.seller_id IS NULL;
    
    
    SELECT 
        'olist_order_items → olist_sellers (seller_id)' AS relation_check,
        COUNT(*) AS unmatched_count
    FROM olist_order_items s
    LEFT JOIN olist_sellers t ON s.seller_id = t.seller_id
    WHERE t.seller_id IS NULL;
    