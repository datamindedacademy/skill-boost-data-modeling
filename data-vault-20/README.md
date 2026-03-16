# Data Vault 2.0

This dbt project implements a Data Vault 2.0 model with hubs, links, and satellites.

## Philosophy

Create a flexible, auditable, and scalable enterprise data warehouse that preserves history. Data Vault separates business keys (hubs), relationships (links), and descriptive attributes (satellites) to enable maximum flexibility and auditability.

## Benefits

- Highly flexible and adaptable to change
- Complete historical tracking
- Parallel loading capabilities
- Audit trail built-in

## Drawbacks

- More complex queries (many joins required)
- Steeper learning curve
- Need business vault or mart layer for BI tools
- More tables to manage

## References

- [Building a Scalable Data Warehouse with Data Vault 2.0](https://danlinstedt.com/) by Dan Linstedt
- [Data Vault 2.0 Overview](https://www.data-vault.co.uk/what-is-data-vault/)
- [dbt Data Vault Package](https://github.com/Datavault-UK/automate-dv)

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
- `sat_customer`: Customer attributes (source: TPC-H)
- `sat_customer_crm`: Customer loyalty data (source: CRM) - tracks loyalty tier changes over time with `load_date` and `valid_to`
- `sat_order`: Order attributes
- `sat_part`: Part attributes
- `sat_supplier`: Supplier attributes
- `sat_lineitem`: Line item attributes and measures

### Seed Data
- `crm_customers`: Customer loyalty data from a simulated CRM system

### Multi-Source Integration

This project demonstrates a key Data Vault strength: integrating data from multiple source systems. `hub_customer` unifies customer keys from both TPC-H and CRM, while each source has its own satellite (`sat_customer` for TPC-H attributes, `sat_customer_crm` for loyalty data). This separation means new sources can be added without modifying existing structures.

## Key Data Vault Concepts

1. **Hubs**: Store unique business keys only
2. **Links**: Store relationships between hubs (many-to-many)
3. **Satellites**: Store descriptive attributes and track history via hashdiff
4. **Hash Keys**: SHA-256 hashes used for joining (deterministic, collision-resistant)
5. **Load Date**: Every record tracks when it was loaded
6. **Record Source**: Every record tracks where it came from

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

duckdb data_vault_20.duckdb < init_tpch.sql
```

3. Run dbt:
```bash
dbt run --profiles-dir .
```
