# Dimensional Modeling (Kimball Star Schema)

This dbt project implements a classic Kimball-style dimensional model with star schema design.

## Schema Design

### Fact Tables
- `fact_line_item`: Grain is one row per line item (most granular)
- `fact_orders`: Grain is one row per order (aggregated)

### Dimension Tables
- `dim_customer`: Customer attributes with geographic hierarchy
- `dim_part`: Product/part catalog
- `dim_supplier`: Supplier information with geographic hierarchy
- `dim_date`: Date dimension for time-based analysis

## Setup

1. Install dependencies:
```bash
pip install dbt-duckdb
```

2. Initialize DuckDB with TPC-H data:
```bash
# Create an init script to load TPC-H extension
cat > init_tpch.sql << 'EOF'
INSTALL tpch;
LOAD tpch;
CALL dbgen(sf = 0.1);
EOF

# Run it in DuckDB
duckdb dimensional_modeling.duckdb < init_tpch.sql
```

3. Run dbt:
```bash
dbt run --profiles-dir .
```

## Querying the Model

Example queries to try:

### 1. Total revenue by customer region
```sql
SELECT
    dc.region_name,
    SUM(f.total_price) as total_revenue,
    COUNT(DISTINCT f.order_key) as order_count
FROM fact_line_item f
JOIN dim_customer dc ON f.customer_id = dc.customer_id
GROUP BY dc.region_name
ORDER BY total_revenue DESC;
```

### 2. Top 10 products by revenue
```sql
SELECT
    dp.part_name,
    dp.brand,
    dp.part_type,
    SUM(f.total_price) as revenue
FROM fact_line_item f
JOIN dim_part dp ON f.part_id = dp.part_id
GROUP BY dp.part_name, dp.brand, dp.part_type
ORDER BY revenue DESC
LIMIT 10;
```

### 3. Monthly revenue trend
```sql
SELECT
    dd.year,
    dd.month,
    dd.month_name,
    SUM(f.total_price) as monthly_revenue,
    COUNT(DISTINCT f.order_key) as order_count
FROM fact_line_item f
JOIN dim_date dd ON f.order_date_id = dd.date_day
GROUP BY dd.year, dd.month, dd.month_name
ORDER BY dd.year, dd.month;
```

### 4. Customer analysis with multiple dimensions
```sql
SELECT
    dc.market_segment,
    dc.nation_name,
    dp.brand,
    COUNT(DISTINCT f.order_key) as order_count,
    SUM(f.quantity) as total_quantity,
    SUM(f.total_price) as total_revenue
FROM fact_line_item f
JOIN dim_customer dc ON f.customer_id = dc.customer_id
JOIN dim_part dp ON f.part_id = dp.part_id
GROUP BY dc.market_segment, dc.nation_name, dp.brand
ORDER BY total_revenue DESC
LIMIT 20;
```

## Key Observations

**Strengths:**
- Queries are intuitive and easy to understand
- Joins are straightforward (fact to dimensions)
- Business logic is clear
- Good performance for typical analytical queries

**Consider:**
- How many joins do you typically need?
- How easy is it to answer ad-hoc questions?
- What happens if a dimension changes over time?
