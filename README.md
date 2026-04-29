# SQL Mini Project - E-Commerce Database

A comprehensive SQL learning project featuring a complete e-commerce database schema with 42 progressive SQL query solutions, organized from basic to advanced difficulty levels.

## 📋 Project Overview

This mini project provides a realistic e-commerce database with sample data and a structured progression of SQL exercises. It's ideal for:
- **Learning SQL** from basics to advanced concepts
- **Interview preparation** with progressive difficulty levels
- **Database design** study with proper relationships and constraints
- **Practical examples** of real-world e-commerce scenarios

## 🏗️ Database Schema

### Tables (6 core tables with relationships)

```
customers
├── customer_id (PK)
├── name
├── email (UNIQUE)
├── phone
└── created_at

products
├── product_id (PK)
├── name
├── category
├── price
├── stock_quantity
└── added_on

orders
├── order_id (PK)
├── customer_id (FK → customers)
├── order_date
├── status (Pending, Shipped, Delivered, Cancelled)
└── total_amount

order_items
├── order_item_id (PK)
├── order_id (FK → orders)
├── product_id (FK → products)
├── quantity
└── item_price

payments
├── payment_id (PK)
├── order_id (FK → orders)
├── payment_date
├── amount_paid
└── method (Credit Card, Debit Card, Net Banking, UPI)

product_reviews
├── review_id (PK)
├── product_id (FK → products)
├── customer_id (FK → customers)
├── rating
├── review_text
└── review_date
```

### Sample Data Included
- **30 customers** with contact details
- **50 products** across 5 categories (Home, Clothing, Electronics, Toys, Books)
- **400 orders** with various statuses
- **400+ order items** with detailed transaction records
- **400 payments** with different payment methods
- **50 product reviews** with ratings (1-5 stars)

## 📂 File Structure

```
sqlminiproject/
├── DataInsertionQueries.sql       # Schema + Sample Data (~2200 lines)
├── miniproject_solutions.sql      # 42 SQL Solutions (6 levels)
└── README.md                      # This file
```

## 🎯 Learning Progression - 42 Solutions

### **LEVEL 1: BASICS (10 Solutions)**
Foundation queries for retrieving and viewing data
- SELECT with WHERE conditions
- Filtering by price ranges
- LIKE pattern matching
- ORDER BY sorting
- Column aliasing

**Sample Queries:**
- Retrieve customer contact information
- View complete product catalog
- Display products priced above ₹1,000
- List products between price ranges

---

### **LEVEL 2: FILTERING & FORMATTING (6 Solutions)**
Data manipulation and presentation techniques
- NULL value handling
- Column aliases
- String concatenation
- Date extraction
- Data type conversions

**Sample Queries:**
- Identify orphaned/missing data
- Calculate line item totals
- Combine customer name and phone
- Extract date from timestamps

---

### **LEVEL 3: AGGREGATIONS (10 Solutions)**
Statistical analysis and grouping
- COUNT, SUM, AVG, MAX, MIN functions
- GROUP BY clauses
- HAVING conditions
- Aggregate with joins
- Multi-level grouping

**Sample Queries:**
- Total revenue across all orders
- Average order value calculation
- Orders per customer
- Sales by category
- Payment method analysis

---

### **LEVEL 4: MULTI-TABLE QUERIES - JOINS (7 Solutions)**
Combining data from multiple tables
- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- Multiple JOINs in single query
- Complex relationship queries

**Sample Queries:**
- Orders with customer names
- Products that were sold
- Orders with payment methods
- All customers and their order history

---

### **LEVEL 5: SUBQUERIES (7 Solutions)**
Nested queries and advanced filtering
- Scalar subqueries
- IN/NOT IN conditions
- EXISTS conditions
- Correlated subqueries
- Complex filtering logic

**Sample Queries:**
- Products above average price
- Active customers (those who ordered)
- Inactive customers (never ordered)
- Products never ordered
- Highest order value per customer

---

### **LEVEL 6: SET OPERATIONS (2 Solutions)**
Combining result sets
- UNION operations
- Intersection logic
- Engaged customer identification

**Sample Queries:**
- Customers who ordered OR reviewed
- Customers who ordered AND reviewed

---

## 🚀 Quick Start

### Prerequisites
- MySQL 5.7+ or higher
- MySQL CLI or any MySQL client (DBeaver, MySQL Workbench, etc.)

### Setup Instructions

#### **Step 1: Create the Database**
```sql
-- Run this first to set up the database and tables
SOURCE DataInsertionQueries.sql;
```

Or copy-paste the entire content of `DataInsertionQueries.sql` into your MySQL client and execute.

#### **Step 2: Verify Installation**
```sql
USE mini_project;
SELECT COUNT(*) as total_customers FROM customers;
SELECT COUNT(*) as total_orders FROM orders;
```

Expected output:
- `total_customers`: 30
- `total_orders`: 400

#### **Step 3: Practice with Solutions**
```sql
-- Example: Run a Level 1 query
SELECT name, email FROM customers;

-- Example: Run a Level 3 query
SELECT SUM(total_amount) AS TotalRevenue FROM orders;

-- Example: Run a Level 4 query
SELECT o.order_id, c.name, o.total_amount 
FROM orders o 
INNER JOIN customers c ON o.customer_id = c.customer_id;
```

## 📊 Query Categories by Use Case

### E-Commerce Operations
- Customer management queries
- Product inventory tracking
- Order fulfillment queries
- Payment processing reports

### Business Analytics
- Revenue analysis
- Customer segmentation
- Category performance
- Payment method preferences

### Data Quality
- Identifying orphaned records
- Finding inactive customers
- Stock availability checks
- Transaction validation

## 💡 Learning Tips

1. **Start with Level 1** - Understand basic SELECT syntax
2. **Progress sequentially** - Each level builds on previous concepts
3. **Modify queries** - Try changing conditions, adding filters, or combining multiple levels
4. **Experiment** - Create your own queries using the schema
5. **Use comments** - Every solution includes PURPOSE statements explaining business context

## 🔧 Common Queries to Extend

Try enhancing these queries:

```sql
-- Find top 5 customers by order count
SELECT customer_id, COUNT(*) as order_count 
FROM orders 
GROUP BY customer_id 
ORDER BY order_count DESC 
LIMIT 5;

-- Calculate order fulfillment rate
SELECT 
    status,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) as percentage
FROM orders
GROUP BY status;

-- Find products with low stock
SELECT * FROM products 
WHERE stock_quantity < 50 
ORDER BY stock_quantity ASC;
```

## 📈 Database Statistics

| Metric | Value |
|--------|-------|
| Total Customers | 30 |
| Total Products | 50 |
| Product Categories | 5 |
| Total Orders | 400 |
| Order Items | 400+ |
| Payments Processed | 400 |
| Product Reviews | 50 |
| Date Range | 2023-2025 |
| Average Order Value | ~₹17,500 |

## 🎓 Topics Covered

✅ Data Definition Language (DDL) - CREATE TABLE  
✅ Data Manipulation Language (DML) - SELECT, INSERT  
✅ Filtering & Conditions - WHERE, BETWEEN, IN, LIKE  
✅ Sorting & Organization - ORDER BY, GROUP BY  
✅ Aggregation Functions - COUNT, SUM, AVG, MAX, MIN  
✅ String Functions - CONCAT, DATE extraction  
✅ Joins - INNER, LEFT, RIGHT  
✅ Subqueries - Correlated and scalar  
✅ Set Operations - UNION  
✅ Database Relationships - Primary Keys, Foreign Keys  
✅ Constraints - UNIQUE, CHECK, NOT NULL, DEFAULT  

## 🔐 Data Integrity Features

- **Primary Keys** on all tables
- **Foreign Key Relationships** maintaining referential integrity
- **CHECK Constraints** on quantity and payment amounts
- **UNIQUE Constraints** on customer emails
- **DEFAULT VALUES** for timestamps and order status
- **NOT NULL Constraints** on critical fields

## 📝 How to Use This Repository

1. **Clone or download** the files
2. **Execute DataInsertionQueries.sql** to set up the database
3. **Refer to miniproject_solutions.sql** for 42 progressive solutions
4. **Practice** by running queries and understanding the results
5. **Modify** queries to deepen your learning

## 🤝 Suggested Use Cases

### For Learning:
- Follow the 6-level progression
- Run each query and analyze the results
- Modify conditions to understand behavior
- Combine techniques from different levels

### For Interviews:
- Level 1-2: Warm-up questions
- Level 3-4: Mid-level interview questions
- Level 5-6: Senior/advanced positions

### For Portfolio:
- Demonstrate SQL proficiency
- Show understanding of database design
- Showcase query optimization thinking
- Display ability to work with real-world scenarios

## 🐛 Troubleshooting

**Error: "No database selected"**
```sql
USE mini_project;
```

**Error: "Table doesn't exist"**
- Ensure DataInsertionQueries.sql has been fully executed
- Verify with: `SHOW TABLES;`

**No results returned**
- Check the WHERE conditions
- Verify table contents: `SELECT COUNT(*) FROM table_name;`

## 📚 Resources for Further Learning

- [MySQL Official Documentation](https://dev.mysql.com/doc/)
- [SQL Best Practices](https://dev.mysql.com/doc/refman/8.0/en/optimization.html)
- [Database Design Principles](https://dev.mysql.com/doc/refman/8.0/en/designing-databases.html)

## 📄 License

This project is open for educational purposes. Feel free to use, modify, and share for learning.

## ✨ Features of This Mini Project

- ✅ **Real-world scenario** - E-commerce database structure
- ✅ **Progressive difficulty** - 6 levels from basics to advanced
- ✅ **Well-documented** - Every query includes purpose statements
- ✅ **Sample data** - 30+ customers with 400+ transactions
- ✅ **Complete schema** - Proper relationships and constraints
- ✅ **Interview ready** - Perfect for SQL interview preparation
- ✅ **Beginner friendly** - Clear progression with explanations
- ✅ **Extensible** - Easy to add more data or queries

---

**Created for:** SQL Learning & Practice  
**Difficulty:** Beginner to Advanced  
**Time to Complete:** 8-12 hours (all levels)  
**Database:** MySQL 5.7+

**Happy Learning! 🚀**
