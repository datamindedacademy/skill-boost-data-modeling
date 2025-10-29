# Data Vault 2.0

This dbt project implements a Data Vault 2.0 model with hubs, links, and satellites.

## Schema Design

### Raw Vault

**Hubs** (Business Keys):
- `hub_customer`: Customer business keys
- `hub_order`: Order business keys
- `hub_part`: Part business keys
- `hub_supplier`: Supplier business keys

**Links** (Relationships):
- `link_order_customer`: Order-Customer relationship
- `link_lineitem`: Order-Part-Supplier relationship (line items)

**Satellites** (Descriptive Attributes):
- `sat_customer`: Customer attributes
- `sat_order`: Order attributes
- `sat_part`: Part attributes
- `sat_lineitem`: Line item attributes and measures

### Business Vault
- `bv_order_details`: Denormalized view joining all components for analysis

## Key Data Vault Concepts

1. **Hubs**: Store unique business keys only
2. **Links**: Store relationships between hubs (many-to-many)
3. **Satellites**: Store descriptive attributes and track history via hashdiff
4. **Hash Keys**: MD5 hashes used for joining (deterministic, consistent)
5. **Load Date**: Every record tracks when it was loaded
6. **Record Source**: Every record tracks where it came from

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

duckdb data_vault_20.duckdb < init_tpch.sql
```

3. Run dbt:
```bash
dbt run --profiles-dir .
```

## Querying the Model

Data Vault models are designed for flexibility but require more joins. Use the business vault for simpler queries:

### 1. Total revenue by customer market segment (using business vault)
```sql
SELECT
    market_segment,
    SUM(line_total) as total_revenue,
    COUNT(DISTINCT order_key) as order_count
FROM bv_order_details
GROUP BY market_segment
ORDER BY total_revenue DESC;
```

### 2. Top 10 products by revenue (using business vault)
```sql
SELECT
    part_name,
    brand,
    part_type,
    SUM(line_total) as revenue
FROM bv_order_details
GROUP BY part_name, brand, part_type
ORDER BY revenue DESC
LIMIT 10;
```

### 3. Query the raw vault directly (more complex)
```sql
-- Example: Customer order count
SELECT
    hc.customer_key,
    sc.customer_name,
    COUNT(DISTINCT ho.order_key) as order_count
FROM hub_customer hc
JOIN sat_customer sc ON hc.customer_hashkey = sc.customer_hashkey
JOIN link_order_customer loc ON hc.customer_hashkey = loc.customer_hashkey
JOIN hub_order ho ON loc.order_hashkey = ho.order_hashkey
GROUP BY hc.customer_key, sc.customer_name
ORDER BY order_count DESC
LIMIT 10;
```

### 4. Historical tracking example (if we had multiple loads)
```sql
-- See how customer attributes changed over time
SELECT
    hc.customer_key,
    sc.customer_name,
    sc.account_balance,
    sc.load_date,
    sc.hashdiff
FROM hub_customer hc
JOIN sat_customer sc ON hc.customer_hashkey = sc.customer_hashkey
WHERE hc.customer_key = 12345
ORDER BY sc.load_date;
```

## Key Observations

**Strengths:**
- Highly flexible and adaptable to source changes
- Built-in audit trail (load_date, record_source)
- Can track full history (with proper loading processes)
- Parallel loading capabilities
- Separation of business keys from attributes

**Challenges:**
- More complex queries (many joins required)
- Steeper learning curve
- Need business vault or mart layer for BI tools
- More tables to manage
- Hash key generation adds processing overhead

**When to Use:**
- Enterprise data warehouses with many sources
- When auditability is critical
- When data structures change frequently
- When you need complete historical tracking
- When parallel loading is important
