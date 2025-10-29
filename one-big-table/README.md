# One Big Table (OBT)

This dbt project implements a single, fully denormalized table containing all order and line item data.

## Schema Design

### Single Table
- `obt_orders`: One wide table with all data pre-joined
  - Grain: One row per line item
  - Contains all customer, order, part, supplier, and geographic attributes
  - All measures and calculated fields included

## The OBT Philosophy

The One Big Table approach prioritizes query simplicity over normalization:
- **Zero joins required** for most queries
- **Pre-calculated metrics** for common calculations
- **Denormalized dimensions** - all attributes in one place
- **Optimized for specific analytical patterns**

## Setup

1. Install dependencies:
```bash
pip install dbt-duckdb
```

2. Initialize DuckDB with TPC-H data:
```bash
cat > init_tpch.sql << 'EOF'
INSTALL tpch;
LOAD tpch;
CALL dbgen(sf = 0.1);
EOF

duckdb one_big_table.duckdb < init_tpch.sql
```

3. Run dbt:
```bash
dbt run --profiles-dir .
```

## Querying the Model

With OBT, queries are extremely simple - no joins needed!

### 1. Total revenue by customer region
```sql
SELECT
    customer_region,
    SUM(total_price) as total_revenue,
    COUNT(DISTINCT order_key) as order_count
FROM obt_orders
GROUP BY customer_region
ORDER BY total_revenue DESC;
```

### 2. Top 10 products by revenue
```sql
SELECT
    part_name,
    part_brand,
    part_type,
    SUM(total_price) as revenue
FROM obt_orders
GROUP BY part_name, part_brand, part_type
ORDER BY revenue DESC
LIMIT 10;
```

### 3. Monthly revenue trend
```sql
SELECT
    order_year,
    order_month,
    SUM(total_price) as monthly_revenue,
    COUNT(DISTINCT order_key) as order_count,
    AVG(total_price) as avg_line_value
FROM obt_orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month;
```

### 4. Complex multi-dimensional analysis (still no joins!)
```sql
SELECT
    customer_market_segment,
    customer_nation,
    part_brand,
    supplier_region,
    order_quarter,
    COUNT(DISTINCT order_key) as order_count,
    SUM(quantity) as total_quantity,
    SUM(total_price) as total_revenue,
    AVG(discount) as avg_discount,
    SUM(discount_amount) as total_discount_amount
FROM obt_orders
WHERE order_year = 1995
GROUP BY
    customer_market_segment,
    customer_nation,
    part_brand,
    supplier_region,
    order_quarter
ORDER BY total_revenue DESC
LIMIT 50;
```

### 5. Delivery performance analysis
```sql
SELECT
    supplier_nation,
    ship_mode,
    delivery_status,
    COUNT(*) as shipment_count,
    AVG(days_to_receipt) as avg_delivery_days,
    AVG(days_early_late) as avg_days_vs_commit
FROM obt_orders
GROUP BY supplier_nation, ship_mode, delivery_status
ORDER BY shipment_count DESC;
```

### 6. Customer and product correlation
```sql
SELECT
    customer_market_segment,
    part_type,
    COUNT(*) as purchase_count,
    SUM(total_price) as total_spent,
    AVG(quantity) as avg_quantity
FROM obt_orders
GROUP BY customer_market_segment, part_type
ORDER BY total_spent DESC;
```

## Key Observations

**Strengths:**
- **Simplest possible queries** - usually just SELECT and GROUP BY
- **No join complexity** - everything is already joined
- **Fast for common queries** - especially with columnar storage (like DuckDB)
- **Easy for business users** - all columns in one place
- **Reduced mental model** - don't need to understand relationships

**Challenges:**
- **Data duplication** - customer info repeated for every line item
- **Storage overhead** - much larger than normalized schemas
- **Update complexity** - changing a customer's address requires updating many rows
- **Less flexible** - if you need different grains, you might need multiple OBTs
- **ETL complexity** - more complex to build and maintain
- **Stale data risk** - dimensions might get out of sync

**When to Use:**
- Modern columnar databases (DuckDB, BigQuery, Snowflake)
- Specific analytical use cases with known query patterns
- When query simplicity is more important than storage
- Self-service analytics for business users
- When your data volume is manageable
- Read-heavy workloads with infrequent updates

**When NOT to Use:**
- Frequently changing dimensional data
- Multiple competing grains needed
- Very high data volumes (billions of rows)
- Need for real-time updates
- Complex historical tracking requirements
