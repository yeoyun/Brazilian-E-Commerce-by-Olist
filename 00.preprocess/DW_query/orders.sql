DROP TABLE IF EXISTS olist_orders;

CREATE TABLE olist_orders AS
SELECT *
FROM olist_orders_raw
WHERE order_status NOT IN ('created', 'invoiced')
  AND (
        order_approved_at IS NULL OR
        order_approved_at >= order_purchase_timestamp
      )
  AND (
        order_delivered_customer_date IS NULL OR
        order_delivered_customer_date >= order_delivered_carrier_date
      );
