# Dimensional Modeling (Kimball Star Schema)

This dbt project implements a classic Kimball-style dimensional model with star schema design.

## Philosophy

Organize data into facts (measurements) and dimensions (context). The star schema design places fact tables at the center with dimension tables surrounding them, creating an intuitive structure for analytical queries.

## Benefits

- Intuitive for business users
- Optimized for analytical queries
- Well-understood by BI tools

## Drawbacks

- Limited historical tracking (requires SCD patterns)
- Schema changes require careful planning
- Grain changes can be complex

## References

- [The Data Warehouse Toolkit](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/books/data-warehouse-dw-toolkit/) by Ralph Kimball
- [Kimball Dimensional Modeling Techniques](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/)

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

1. Install dependencies (from the repository root):
```bash
uv sync
source .venv/bin/activate
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
