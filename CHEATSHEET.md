# Data Modeling Cheat Sheet

Quick reference guide for the three modeling techniques.

## Setup Commands

### Initialize Database with TPC-H
```bash
# Run this in each project directory
cat > init_tpch.sql << 'EOF'
INSTALL tpch;
LOAD tpch;
CALL dbgen(sf = 0.1);
EOF

duckdb <database_name>.duckdb < init_tpch.sql
```

### Run dbt
```bash
cd <project-directory>
dbt run --profiles-dir .
```

### Query Database
```bash
duckdb <database_name>.duckdb
```

## Quick Query Reference

### Dimensional Modeling

**Basic Pattern:**
```sql
SELECT
    dim.attribute,
    SUM(fact.measure) as total
FROM fact_table fact
JOIN dim_table dim ON fact.dim_id = dim.dim_id
GROUP BY dim.attribute;
```

**Key Tables:**
- Facts: `fact_line_item`, `fact_orders`
- Dimensions: `dim_customer`, `dim_part`, `dim_supplier`, `dim_date`

**Example:**
```sql
-- Revenue by region
SELECT
    dc.region_name,
    SUM(f.total_price) as revenue
FROM fact_line_item f
JOIN dim_customer dc ON f.customer_id = dc.customer_id
GROUP BY dc.region_name;
```

### Data Vault 2.0

**Basic Pattern (using business vault):**
```sql
SELECT
    attribute,
    SUM(measure) as total
FROM bv_order_details
GROUP BY attribute;
```

**Raw Vault Pattern (complex):**
```sql
SELECT
    sat.attribute,
    SUM(link_sat.measure)
FROM link_table link
JOIN hub_table hub ON link.hashkey = hub.hashkey
JOIN sat_table sat ON hub.hashkey = sat.hashkey
GROUP BY sat.attribute;
```

**Key Tables:**
- Hubs: `hub_customer`, `hub_order`, `hub_part`, `hub_supplier`
- Links: `link_order_customer`, `link_lineitem`
- Satellites: `sat_customer`, `sat_order`, `sat_part`, `sat_lineitem`
- Business Vault: `bv_order_details` (use this for easier queries!)

**Example:**
```sql
-- Revenue by market segment (business vault)
SELECT
    market_segment,
    SUM(line_total) as revenue
FROM bv_order_details
GROUP BY market_segment;
```

### One Big Table

**Basic Pattern:**
```sql
SELECT
    any_attribute,
    SUM(any_measure) as total
FROM obt_orders
GROUP BY any_attribute;
```

**Key Table:**
- `obt_orders` - That's it! Everything is here.

**Example:**
```sql
-- Revenue by region
SELECT
    customer_region,
    SUM(total_price) as revenue
FROM obt_orders
GROUP BY customer_region;
```

## Common Metrics

### Total Revenue
```sql
-- Dimensional
SELECT SUM(total_price) FROM fact_line_item;

-- Data Vault
SELECT SUM(line_total) FROM bv_order_details;

-- OBT
SELECT SUM(total_price) FROM obt_orders;
```

### Order Count
```sql
-- Dimensional
SELECT COUNT(DISTINCT order_key) FROM fact_line_item;

-- Data Vault
SELECT COUNT(DISTINCT order_key) FROM bv_order_details;

-- OBT
SELECT COUNT(DISTINCT order_key) FROM obt_orders;
```

### Top Products
```sql
-- Dimensional
SELECT
    dp.part_name,
    SUM(f.total_price) as revenue
FROM fact_line_item f
JOIN dim_part dp ON f.part_id = dp.part_id
GROUP BY dp.part_name
ORDER BY revenue DESC
LIMIT 10;

-- Data Vault
SELECT
    part_name,
    SUM(line_total) as revenue
FROM bv_order_details
GROUP BY part_name
ORDER BY revenue DESC
LIMIT 10;

-- OBT
SELECT
    part_name,
    SUM(total_price) as revenue
FROM obt_orders
GROUP BY part_name
ORDER BY revenue DESC
LIMIT 10;
```

## Useful DuckDB Commands

```sql
-- List all tables
SHOW TABLES;

-- Describe table structure
DESCRIBE table_name;

-- Show first few rows
SELECT * FROM table_name LIMIT 10;

-- Count rows
SELECT COUNT(*) FROM table_name;

-- Show columns
PRAGMA table_info(table_name);

-- Exit DuckDB CLI
.exit
-- or
Ctrl+D
```

## dbt Commands

```bash
# Run all models
dbt run --profiles-dir .

# Run specific model
dbt run --models model_name --profiles-dir .

# Run models with dependencies
dbt run --models +model_name+ --profiles-dir .

# Test models
dbt test --profiles-dir .

# Generate documentation
dbt docs generate --profiles-dir .

# View dependency graph
dbt docs serve --profiles-dir .

# Clean build artifacts
dbt clean
```

## Quick Comparisons

### Join Count
- **Dimensional**: 1-4 joins typically
- **Data Vault**: 5-10+ joins (use business vault!)
- **OBT**: 0 joins (everything pre-joined)

### When to Use Each

**Dimensional Modeling:**
- ✅ Standard analytics use case
- ✅ Known query patterns
- ✅ BI tool integration
- ✅ Balance of flexibility and simplicity

**Data Vault 2.0:**
- ✅ Enterprise data warehouse
- ✅ Multiple source systems
- ✅ Audit trail required
- ✅ Frequent schema changes
- ✅ Historical tracking critical

**One Big Table:**
- ✅ Simple self-service analytics
- ✅ Columnar database (DuckDB, BigQuery, Snowflake)
- ✅ Known analytical patterns
- ✅ Query simplicity prioritized
- ❌ NOT for frequently changing dimensions

## Key Attributes Available

### Customer Attributes
- customer_key/id/hashkey
- customer_name
- market_segment
- account_balance
- nation_name (geography)
- region_name (geography)

### Product/Part Attributes
- part_key/id/hashkey
- part_name
- brand
- part_type
- manufacturer
- retail_price

### Order Attributes
- order_key/hashkey
- order_date
- order_status
- order_priority
- total_price

### Line Item Attributes
- line_number
- quantity
- extended_price
- discount
- tax
- ship_date
- ship_mode

## Troubleshooting

### "Table not found"
Run `dbt run --profiles-dir .` first

### "TPC-H not loaded"
Run the init_tpch.sql script in DuckDB

### "Connection error"
Check that you're in the correct directory and database file exists

### "Model doesn't exist"
Make sure you're querying the right database file for each project

## Training Flow

1. ✅ Read main README.md
2. ✅ Run QUICKSTART.md setup
3. ✅ Build all three projects (dbt run)
4. ✅ Answer question 1 in all three approaches
5. ✅ Compare query complexity
6. ✅ Continue with remaining questions
7. ✅ Fill out comparison matrix
8. ✅ Discuss with team

## Resources

- **dbt**: https://docs.getdbt.com/
- **DuckDB**: https://duckdb.org/docs/
- **Kimball**: https://www.kimballgroup.com/
- **Data Vault**: https://www.data-vault.co.uk/
- **TPC-H**: http://www.tpc.org/tpch/

## Tips

- Start with OBT for simplest queries
- Use business vault view in Data Vault for easier querying
- Time yourself - which approach is faster to write?
- Consider maintainability, not just query writing speed
- Think about your actual use case when comparing
