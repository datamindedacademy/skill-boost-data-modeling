# One Big Table (OBT)

This dbt project implements a single, fully denormalized table containing all order and line item data.

## Philosophy

Denormalize everything into a single wide table for maximum query simplicity. The OBT approach prioritizes query simplicity over normalization, pre-joining all data and pre-calculating metrics for zero-join analytical queries.

## Benefits

- Simplest possible queries (SELECT * FROM...)
- No joins required
- Fast for specific analytical patterns
- Works well with modern columnar databases

## Drawbacks

- Data duplication
- More complex ETL
- Potential for stale data

## References

- [One Big Table](https://www.holistics.io/blog/one-big-table-obt/) - Holistics Blog
- [The Wide Table Paradigm](https://www.startdataengineering.com/post/when-to-use-wide-tables/)

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

1. Install dependencies (from the repository root):
```bash
uv sync
source .venv/bin/activate
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
