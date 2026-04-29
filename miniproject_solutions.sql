

USE mini_project;

-- ================================================================
-- LEVEL 1: BASICS (10 SOLUTIONS)
-- ================================================================

-- L1.1: Retrieve customer names and emails for email marketing
-- PURPOSE: Extract basic customer contact details for marketing campaigns
SELECT name, email FROM customers;

-- ================================================================

-- L1.2: View complete product catalog with all available details
-- PURPOSE: Review all product listings in one go
SELECT * FROM products;

-- ================================================================

-- L1.3: List all unique product categories
-- PURPOSE: Analyze the range of departments/categories available
SELECT DISTINCT category FROM products;

-- ================================================================

-- L1.4: Show all products priced above ₹1,000
-- PURPOSE: Identify high-value items for premium promotions
SELECT * FROM products WHERE price > 1000;

-- ================================================================

-- L1.5: Display products within mid-range price bracket (₹2,000 to ₹5,000)
-- PURPOSE: Create mid-tier pricing campaigns
SELECT * FROM products WHERE price BETWEEN 2000 AND 5000;

-- ================================================================

-- L1.6: Fetch data for specific customer IDs (e.g., from loyalty program list)
-- PURPOSE: Get specific customer information for selected IDs
SELECT * FROM customers WHERE customer_id IN (1, 5, 10);

-- ================================================================

-- L1.7: Identify customers whose names start with the letter 'A'
-- PURPOSE: Alphabetical segmentation for targeted outreach
SELECT * FROM customers WHERE name LIKE 'A%';

-- ================================================================

-- L1.8: List electronics products priced under ₹3,000
-- PURPOSE: Showcase budget electronics for merchandising
SELECT * FROM products 
WHERE category = 'Electronics' AND price < 3000;

-- ================================================================

-- L1.9: Display product names and prices in descending order of price
-- PURPOSE: View and compare top-priced items easily
SELECT name, price FROM products 
ORDER BY price DESC;

-- ================================================================

-- L1.10: Display product names and prices, sorted by price and then by name
-- PURPOSE: List products from expensive to cheapest with alphabetical clarity
SELECT name, price FROM products 
ORDER BY price DESC, name ASC;

-- ================================================================
-- LEVEL 2: FILTERING AND FORMATTING (6 SOLUTIONS)
-- ================================================================

-- L2.1: Retrieve orders where customer information is missing
-- PURPOSE: Identify orphaned orders or test data issues
SELECT * FROM orders 
WHERE customer_id IS NULL;

-- ================================================================

-- L2.2: Display customer names and emails using column aliases for frontend readability
-- PURPOSE: User-friendly labels for frontend displays or report headings
SELECT name AS CustomerName, email AS CustomerEmail 
FROM customers;

-- ================================================================

-- L2.3: Calculate total value per item ordered by multiplying quantity and item price
-- PURPOSE: Generate per-line item bill details or invoice breakdowns
SELECT order_item_id, order_id, product_id, quantity, item_price, 
       (quantity * item_price) AS TotalItemValue 
FROM order_items;

-- ================================================================

-- L2.4: Combine customer name and phone number in a single column
-- PURPOSE: Show brief customer summaries or contact lists
SELECT CONCAT(name, ' - ', phone) AS CustomerContact 
FROM customers;

-- ================================================================

-- L2.5: Extract only the date part from order timestamps for date-wise reporting
-- PURPOSE: Group or filter orders by date without considering time
SELECT order_id, DATE(order_date) AS OrderDate, status 
FROM orders;

-- ================================================================

-- L2.6: List products that do not have any stock left
-- PURPOSE: Inventory team identify out-of-stock items
SELECT * FROM products 
WHERE stock_quantity = 0;

-- ================================================================
-- LEVEL 3: AGGREGATIONS (10 SOLUTIONS)
-- ================================================================

-- L3.1: Count the total number of orders placed
-- PURPOSE: Track order volume over time
SELECT COUNT(*) AS TotalOrders 
FROM orders;

-- ================================================================

-- L3.2: Calculate the total revenue collected from all orders
-- PURPOSE: Overall sales value assessment
SELECT SUM(total_amount) AS TotalRevenue 
FROM orders;

-- ================================================================

-- L3.3: Calculate the average order value
-- PURPOSE: Understand customer spending patterns
SELECT AVG(total_amount) AS AverageOrderValue 
FROM orders;

-- ================================================================

-- L3.4: Count the number of customers who have placed at least one order
-- PURPOSE: Identify active customer base
SELECT COUNT(DISTINCT customer_id) AS ActiveCustomers 
FROM orders;

-- ================================================================

-- L3.5: Find the number of orders placed by each customer
-- PURPOSE: Identify top or repeat customers
SELECT customer_id, COUNT(*) AS NumberOfOrders 
FROM orders 
GROUP BY customer_id 
ORDER BY NumberOfOrders DESC;

-- ================================================================

-- L3.6: Find total sales amount made by each customer
-- PURPOSE: Customer lifetime value analysis
SELECT customer_id, SUM(total_amount) AS TotalSales 
FROM orders 
GROUP BY customer_id 
ORDER BY TotalSales DESC;

-- ================================================================

-- L3.7: List the number of products sold per category
-- PURPOSE: Category managers assess performance by department
SELECT p.category, COUNT(oi.order_item_id) AS ProductsSold 
FROM order_items oi 
JOIN products p ON oi.product_id = p.product_id 
GROUP BY p.category 
ORDER BY ProductsSold DESC;

-- ================================================================

-- L3.8: Find the average item price per category
-- PURPOSE: Compare pricing across departments
SELECT p.category, AVG(oi.item_price) AS AverageItemPrice 
FROM order_items oi 
JOIN products p ON oi.product_id = p.product_id 
GROUP BY p.category 
ORDER BY AverageItemPrice DESC;

-- ================================================================

-- L3.9: Show number of orders placed per day
-- PURPOSE: Track daily business activity and demand trends
SELECT DATE(order_date) AS OrderDate, COUNT(*) AS NumberOfOrders 
FROM orders 
GROUP BY DATE(order_date) 
ORDER BY OrderDate DESC;

-- ================================================================

-- L3.10: List total payments received per payment method
-- PURPOSE: Finance team understand preferred transaction modes
SELECT method, SUM(amount_paid) AS TotalPaymentReceived, COUNT(*) AS TransactionCount 
FROM payments 
GROUP BY method 
ORDER BY TotalPaymentReceived DESC;

-- ================================================================
-- LEVEL 4: MULTI-TABLE QUERIES - JOINS (7 SOLUTIONS)
-- ================================================================

-- L4.1: Retrieve order details along with the customer name (INNER JOIN)
-- PURPOSE: Display which customer placed each order
SELECT o.order_id, c.name, o.order_date, o.status, o.total_amount 
FROM orders o 
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- ================================================================

-- L4.2: Get list of products that have been sold (INNER JOIN with order_items)
-- PURPOSE: Find which products were actually included in orders
SELECT DISTINCT p.product_id, p.name, p.category, p.price 
FROM products p 
INNER JOIN order_items oi ON p.product_id = oi.product_id;

-- ================================================================

-- L4.3: List all orders with their payment method (INNER JOIN)
-- PURPOSE: Finance/audit teams see how each order was paid for
SELECT o.order_id, o.customer_id, o.order_date, p.method, p.amount_paid 
FROM orders o 
INNER JOIN payments p ON o.order_id = p.order_id;

-- ================================================================

-- L4.4: Get list of customers and their orders (LEFT JOIN)
-- PURPOSE: Find all customers and see who has or hasn't placed orders
SELECT c.customer_id, c.name, c.email, o.order_id, o.order_date, o.total_amount 
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- ================================================================

-- L4.5: List all products along with order item quantity (LEFT JOIN)
-- PURPOSE: Inventory teams track what sold and what hasn't
SELECT p.product_id, p.name, p.category, p.price, SUM(oi.quantity) AS TotalQuantitySold 
FROM products p 
LEFT JOIN order_items oi ON p.product_id = oi.product_id 
GROUP BY p.product_id, p.name, p.category, p.price;

-- ================================================================

-- L4.6: List all payments including those with no matching orders (RIGHT JOIN)
-- PURPOSE: Ensure all payments are mapped correctly (data validation)
SELECT p.payment_id, p.order_id, p.payment_date, p.amount_paid, p.method, o.order_id 
FROM payments p 
RIGHT JOIN orders o ON p.order_id = o.order_id;

-- ================================================================

-- L4.7: Combine data from three tables: customer, order, and payment
-- PURPOSE: Generate detailed transaction reports
SELECT c.customer_id, c.name, c.email, o.order_id, o.order_date, o.total_amount, 
       p.payment_id, p.amount_paid, p.method 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
JOIN payments p ON o.order_id = p.order_id;

-- ================================================================
-- LEVEL 5: SUBQUERIES - INNER QUERIES (7 SOLUTIONS)
-- ================================================================

-- L5.1: List all products priced above the average product price
-- PURPOSE: Pricing analysts identify premium-priced products
SELECT * FROM products 
WHERE price > (SELECT AVG(price) FROM products);

-- ================================================================

-- L5.2: Find customers who have placed at least one order
-- PURPOSE: Identify active customers for loyalty campaigns
SELECT * FROM customers 
WHERE customer_id IN (SELECT DISTINCT customer_id FROM orders);

-- ================================================================

-- L5.3: Show orders whose total amount is above the average for that customer
-- PURPOSE: Detect unusually high purchases per customer
SELECT o.order_id, o.customer_id, o.order_date, o.total_amount 
FROM orders o 
WHERE o.total_amount > (SELECT AVG(total_amount) FROM orders WHERE customer_id = o.customer_id);

-- ================================================================

-- L5.4: Display customers who haven't placed any orders
-- PURPOSE: Re-engagement campaigns targeting inactive users
SELECT * FROM customers 
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);

-- ================================================================

-- L5.5: Show products that were never ordered
-- PURPOSE: Inventory clearance decisions or product deactivation
SELECT * FROM products 
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM order_items);

-- ================================================================

-- L5.6: Show highest value order per customer
-- PURPOSE: Identify the largest transaction made by each customer
SELECT customer_id, MAX(total_amount) AS HighestOrderValue 
FROM orders 
GROUP BY customer_id;

-- ================================================================

-- L5.7: Highest Order Per Customer (Including Names)
-- PURPOSE: Identify largest transaction with customer details
SELECT c.customer_id, c.name, MAX(o.total_amount) AS HighestOrderValue 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
GROUP BY c.customer_id, c.name;

-- ================================================================
-- LEVEL 6: SET OPERATIONS (2 SOLUTIONS)
-- ================================================================

-- L6.1: List all customers who have either placed an order or written a product review
-- PURPOSE: Identify engaged customers from different activity areas
SELECT DISTINCT customer_id FROM orders 
UNION 
SELECT DISTINCT customer_id FROM product_reviews;

-- ================================================================

-- L6.2: List all customers who have placed an order as well as reviewed a product
-- PURPOSE: Identify highly engaged customers for rewards programs
SELECT DISTINCT o.customer_id 
FROM orders o 
WHERE EXISTS (SELECT 1 FROM product_reviews pr WHERE pr.customer_id = o.customer_id);
