# Database Schema Documentation

## Entity-Relationship Diagram (Text-Based)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          E-COMMERCE DATABASE                            │
│                          (mini_project)                                 │
└─────────────────────────────────────────────────────────────────────────┘


    ┌──────────────────────────┐
    │      CUSTOMERS           │
    ├──────────────────────────┤
    │ PK  customer_id (INT)    │
    │     name (VARCHAR 100)   │
    │ UQ  email (VARCHAR 100)  │
    │     phone (VARCHAR 15)   │
    │     created_at (DATETIME)│
    └──────────┬───────────────┘
               │
               │ One-to-Many
               │
    ┌──────────▼────────────────────────┐
    │         ORDERS                    │
    ├─────────────────────────────────┤
    │ PK  order_id (INT)              │
    │ FK  customer_id (INT)           │ ◄──┐
    │     order_date (DATETIME)       │    │
    │     status (VARCHAR 20)         │    │
    │     total_amount (DECIMAL)      │    │
    └──────────┬────────┬─────────────┘    │
               │        │                   │
               │        │ One-to-Many       │
               │        │                   │
    ┌──────────▼──┐  ┌──▼──────────────────┴─┐
    │ ORDER_ITEMS │  │  PAYMENTS            │
    ├─────────────┤  ├──────────────────────┤
    │PK order_    │  │PK payment_id (INT)  │
    │   item_id   │  │FK order_id (INT)    │
    │FK order_id  │  │  payment_date (DT)  │
    │FK product_id│  │  amount_paid (DEC)  │
    │  quantity   │  │  method (VARCHAR 20)│
    │  item_price │  └──────────────────────┘
    └──────────┬──┘
               │
               │ Many-to-One
               │
    ┌──────────▼──────────────────┐
    │      PRODUCTS               │
    ├─────────────────────────────┤
    │ PK  product_id (INT)        │
    │     name (VARCHAR 100)      │
    │     category (VARCHAR 50)   │
    │     price (DECIMAL 10,2)    │
    │     stock_quantity (INT)    │
    │     added_on (DATETIME)     │
    │                             │
    └──────────┬──────────────────┘
               │
               │ One-to-Many
               │
    ┌──────────▼──────────────────┐
    │  PRODUCT_REVIEWS            │
    ├─────────────────────────────┤
    │ PK  review_id (INT)         │
    │ FK  product_id (INT)        │
    │ FK  customer_id (INT)       │ ◄── Also linked to CUSTOMERS
    │     rating (INT)            │
    │     review_text (TEXT)      │
    │     review_date (DATETIME)  │
    └─────────────────────────────┘
```

---

## Detailed Table Specifications

### 1. CUSTOMERS Table
**Purpose:** Stores all customer information for the e-commerce platform.

```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| `customer_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| `name` | VARCHAR(100) | NOT NULL | Customer full name |
| `email` | VARCHAR(100) | NOT NULL, UNIQUE | Email for contact (duplicate prevention) |
| `phone` | VARCHAR(15) | Optional | Phone number for communications |
| `created_at` | DATETIME | DEFAULT CURRENT_TIMESTAMP | Registration timestamp |

**Indexes Recommended:**
- PRIMARY KEY on `customer_id`
- UNIQUE on `email`

**Data Stats:** 30 customers

---

### 2. PRODUCTS Table
**Purpose:** Maintains the product catalog with pricing and inventory.

```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    added_on DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| `product_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier |
| `name` | VARCHAR(100) | NOT NULL | Product name |
| `category` | VARCHAR(50) | NOT NULL | Product category (Home, Clothing, Electronics, Toys, Books) |
| `price` | DECIMAL(10,2) | NOT NULL | Selling price in rupees |
| `stock_quantity` | INT | NOT NULL, DEFAULT 0 | Available units in inventory |
| `added_on` | DATETIME | DEFAULT CURRENT_TIMESTAMP | When product was added |

**Indexes Recommended:**
- PRIMARY KEY on `product_id`
- INDEX on `category` (for category filtering)
- INDEX on `price` (for price range queries)

**Data Stats:** 50 products across 5 categories

**Categories:** Home, Clothing, Electronics, Toys, Books

---

### 3. ORDERS Table
**Purpose:** Records all customer orders and their status.

```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending',
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| `order_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique order identifier |
| `customer_id` | INT | FOREIGN KEY | Links to customer who placed order |
| `order_date` | DATETIME | DEFAULT CURRENT_TIMESTAMP | When order was placed |
| `status` | VARCHAR(20) | DEFAULT 'Pending' | Order status (Pending, Shipped, Delivered, Cancelled) |
| `total_amount` | DECIMAL(10,2) | Optional | Total order value |

**Indexes Recommended:**
- PRIMARY KEY on `order_id`
- FOREIGN KEY on `customer_id`
- INDEX on `order_date` (for date range queries)
- INDEX on `status` (for status filtering)

**Data Stats:** 400 orders

**Status Values:**
- `Pending` - Order placed, awaiting processing
- `Shipped` - Order dispatched
- `Delivered` - Order received by customer
- `Cancelled` - Order cancelled

---

### 4. ORDER_ITEMS Table
**Purpose:** Details of products in each order (order line items).

```sql
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    item_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| `order_item_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique line item identifier |
| `order_id` | INT | FOREIGN KEY | Links to orders table |
| `product_id` | INT | FOREIGN KEY | Links to products table |
| `quantity` | INT | NOT NULL, CHECK (> 0) | Number of units ordered |
| `item_price` | DECIMAL(10,2) | NOT NULL | Price per unit at time of order |

**Indexes Recommended:**
- PRIMARY KEY on `order_item_id`
- FOREIGN KEY on `order_id`
- FOREIGN KEY on `product_id`

**Data Stats:** 400+ order items

---

### 5. PAYMENTS Table
**Purpose:** Records payment transactions for each order.

```sql
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount_paid DECIMAL(10,2) NOT NULL CHECK (amount_paid > 0),
    method VARCHAR(20) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
```

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| `payment_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique payment identifier |
| `order_id` | INT | FOREIGN KEY | Links to orders table |
| `payment_date` | DATETIME | DEFAULT CURRENT_TIMESTAMP | When payment was received |
| `amount_paid` | DECIMAL(10,2) | NOT NULL, CHECK (> 0) | Payment amount |
| `method` | VARCHAR(20) | NOT NULL | Payment method used |

**Indexes Recommended:**
- PRIMARY KEY on `payment_id`
- FOREIGN KEY on `order_id`
- INDEX on `method` (for payment method analysis)

**Data Stats:** 400 payments

**Payment Methods:**
- `Credit Card`
- `Debit Card`
- `Net Banking`
- `UPI`

---

### 6. PRODUCT_REVIEWS Table
**Purpose:** Stores customer reviews and ratings for products.

```sql
CREATE TABLE product_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    customer_id INT,
    rating INT NOT NULL,
    review_text TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| `review_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique review identifier |
| `product_id` | INT | FOREIGN KEY | Links to products table |
| `customer_id` | INT | FOREIGN KEY | Links to customers table |
| `rating` | INT | NOT NULL | Star rating (1-5) |
| `review_text` | TEXT | Optional | Written review content |
| `review_date` | DATETIME | DEFAULT CURRENT_TIMESTAMP | When review was posted |

**Indexes Recommended:**
- PRIMARY KEY on `review_id`
- FOREIGN KEY on `product_id`
- FOREIGN KEY on `customer_id`
- INDEX on `rating` (for rating analysis)

**Data Stats:** 50 reviews

**Rating Scale:** 1-5 stars

---

## Relationships Overview

### One-to-Many Relationships

1. **CUSTOMERS → ORDERS**
   - One customer can place multiple orders
   - Foreign Key: `orders.customer_id` → `customers.customer_id`

2. **ORDERS → ORDER_ITEMS**
   - One order can have multiple line items
   - Foreign Key: `order_items.order_id` → `orders.order_id`

3. **PRODUCTS → ORDER_ITEMS**
   - One product can appear in multiple orders
   - Foreign Key: `order_items.product_id` → `products.product_id`

4. **ORDERS → PAYMENTS**
   - One order can have multiple payments (refunds, partial payments)
   - Foreign Key: `payments.order_id` → `orders.order_id`

5. **PRODUCTS → PRODUCT_REVIEWS**
   - One product can have multiple reviews
   - Foreign Key: `product_reviews.product_id` → `products.product_id`

6. **CUSTOMERS → PRODUCT_REVIEWS**
   - One customer can write multiple reviews
   - Foreign Key: `product_reviews.customer_id` → `customers.customer_id`

---

## Data Constraints & Integrity

### Primary Keys (PK)
- Ensure unique identification for each record
- Automatically indexed for fast lookups

### Foreign Keys (FK)
- Maintain referential integrity
- Prevent deletion of parent records with related children

### Unique Constraints
- `customers.email` - Prevents duplicate email registrations

### Check Constraints
- `order_items.quantity > 0` - Ensures positive quantities
- `payments.amount_paid > 0` - Ensures positive payments

### NOT NULL Constraints
- Enforces required fields (name, email, price, etc.)

### Default Values
- `created_at` → Current timestamp
- `order_date` → Current timestamp
- `order_status` → 'Pending'
- `stock_quantity` → 0

---

## Database Statistics

| Metric | Value |
|--------|-------|
| Total Tables | 6 |
| Total Records | 1,250+ |
| Customers | 30 |
| Products | 50 |
| Orders | 400 |
| Order Items | 400+ |
| Payments | 400 |
| Reviews | 50 |
| Date Range | 2023-06-01 to 2025-06-30 |
| Total Revenue | ~₷7,000,000+ |
| Avg Order Value | ~₹17,500 |

---

## Common Join Patterns

### Customer with Orders and Payments
```sql
SELECT c.customer_id, c.name, o.order_id, o.order_date, 
       p.payment_id, p.amount_paid, p.method
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id;
```

### Products with Sales Information
```sql
SELECT p.product_id, p.name, p.category, 
       COUNT(oi.order_item_id) AS TimesSold,
       SUM(oi.quantity) AS TotalQuantity,
       SUM(oi.quantity * oi.item_price) AS TotalSales
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id;
```

### Complete Transaction Details
```sql
SELECT c.name AS Customer, o.order_id, o.order_date,
       GROUP_CONCAT(p.name) AS Products,
       o.total_amount, pay.amount_paid, pay.method
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN payments pay ON o.order_id = pay.order_id;
```

---

## Performance Optimization Tips

1. **Add Indexes on Foreign Keys** - Speeds up JOIN operations
   ```sql
   CREATE INDEX idx_orders_customer ON orders(customer_id);
   CREATE INDEX idx_order_items_order ON order_items(order_id);
   CREATE INDEX idx_order_items_product ON order_items(product_id);
   ```

2. **Index Frequently Filtered Columns**
   ```sql
   CREATE INDEX idx_orders_status ON orders(status);
   CREATE INDEX idx_products_category ON products(category);
   CREATE INDEX idx_orders_date ON orders(order_date);
   ```

3. **Use EXPLAIN to Analyze Queries**
   ```sql
   EXPLAIN SELECT * FROM orders WHERE customer_id = 5;
   ```

4. **Consider Denormalization for Reports** - If heavy aggregation queries slow down

---

## Backup and Recovery

### Regular Backups
```bash
mysqldump -u root -p mini_project > backup_mini_project.sql
```

### Restore from Backup
```bash
mysql -u root -p mini_project < backup_mini_project.sql
```

---

## Schema Design Rationale

✅ **Normalized Structure** - Reduces data redundancy  
✅ **Clear Relationships** - Foreign keys maintain data integrity  
✅ **Scalability** - Can handle growing order volumes  
✅ **Query Flexibility** - Supports complex analytics  
✅ **Real-world Patterns** - Reflects actual e-commerce scenarios  
✅ **Educational Value** - Teaches proper database design principles  

---

**Last Updated:** 2025  
**Database Version:** MySQL 5.7+  
**Schema Version:** 1.0
