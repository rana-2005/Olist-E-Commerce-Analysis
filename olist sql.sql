SELECT 'orders' AS tbl, COUNT(*) AS n FROM olist_orders_dataset
UNION ALL SELECT 'order_items', COUNT(*) FROM olist_order_items_dataset
UNION ALL SELECT 'products', COUNT(*) FROM olist_products_dataset
UNION ALL SELECT 'customers', COUNT(*) FROM olist_customers_dataset
UNION ALL SELECT 'category_translation', COUNT(*) FROM product_category_name_translation;

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN (
    'orders',
    'order_items',
    'products',
    'customers',
    'category_translation'
)
ORDER BY TABLE_NAME, ORDINAL_POSITION;

SELECT
    YEAR(o.order_purchase_timestamp) AS Sales_Year,
    MONTH(o.order_purchase_timestamp) AS Sales_Month,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    SUM(oi.price) AS Total_Sales
FROM olist_orders_dataset AS o
JOIN olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    Sales_Year,
    Sales_Month;


SELECT TOP 10
    p.product_id,
    SUM(oi.price) AS Total_Sales,
    SUM(oi.order_item_id * 0 + 1) AS Items_Sold
FROM olist_products_dataset AS p
JOIN olist_order_items_dataset AS oi
    ON p.product_id = oi.product_id
JOIN olist_orders_dataset AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.product_id
ORDER BY Total_Sales DESC;


WITH Order_Sales AS (
    SELECT
        o.order_id,
        SUM(oi.price) AS Order_Total
    FROM dbo.olist_orders_dataset AS o
    JOIN dbo.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.order_id
)
SELECT
    COUNT(*) AS Total_Orders,
    SUM(Order_Total) AS Total_Sales,
    AVG(Order_Total) AS Average_Order_Value
FROM Order_Sales;


SELECT TOP 10
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    SUM(oi.price) AS Total_Spending
FROM dbo.olist_customers_dataset AS c
JOIN dbo.olist_orders_dataset AS o
    ON c.customer_id = o.customer_id
JOIN dbo.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY Total_Spending DESC;


SELECT TOP 10
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    SUM(oi.price) AS Total_Spending,
    AVG(oi.price) AS Average_Item_Price
FROM dbo.olist_customers_dataset AS c
JOIN dbo.olist_orders_dataset AS o
    ON c.customer_id = o.customer_id
JOIN dbo.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY Total_Orders DESC, Total_Spending DESC;


SELECT TOP 10
    oi.product_id,
    SUM(oi.price) AS Total_Sales,
    COUNT(*) AS Items_Sold
FROM dbo.olist_order_items_dataset AS oi
JOIN dbo.olist_orders_dataset AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.product_id
ORDER BY Total_Sales DESC;




SELECT
    order_status,
    COUNT(*) AS Total_Orders
FROM dbo.olist_orders_dataset
GROUP BY order_status
ORDER BY Total_Orders DESC;



SELECT
    COUNT(*) AS Total_Orders,
    SUM(CASE
        WHEN order_status = 'delivered' THEN 1
        ELSE 0
    END) AS Delivered_Orders,
    CAST(
        100.0 * SUM(CASE
            WHEN order_status = 'delivered' THEN 1
            ELSE 0
        END) / COUNT(*) AS DECIMAL(5,2)
    ) AS Delivery_Rate
FROM dbo.olist_orders_dataset;



SELECT
    COUNT(*) AS Items_Sold,
    MIN(price) AS Lowest_Item_Price,
    MAX(price) AS Highest_Item_Price,
    AVG(price) AS Average_Item_Price
FROM dbo.olist_order_items_dataset AS oi
JOIN dbo.olist_orders_dataset AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';


