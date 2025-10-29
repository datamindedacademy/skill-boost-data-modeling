# Skill Boost: Data Modeling Techniques

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new?repo=datamindedacademy/skill-boost-data-modeling)

## Overview

Welcome to the Data Modeling Skill Boost training session! This hands-on workshop explores three distinct data modeling techniques using the same dataset (TPC-H). You'll experience firsthand how different modeling approaches affect query complexity, maintainability, and analytical ease.

## What You'll Learn

This training uses the **TPC-H benchmark dataset** (a standard dataset for database benchmarking) to implement three different modeling techniques:

1. **Dimensional Modeling** (Kimball)
2. **Data Vault 2.0**
3. **One Big Table (OBT)**

Each technique is implemented as a separate dbt project using DuckDB with the TPC-H extension. You'll write queries against each model to answer business questions and compare the experience across approaches.

## Prerequisites

- Basic understanding of SQL
- Familiarity with data warehousing concepts (helpful but not required)
- No local setup needed - use GitHub Codespaces!

## Getting Started

### Option 1: GitHub Codespaces (Recommended)
Click the "Open in GitHub Codespaces" badge above. Everything is pre-configured!

### Option 2: Local Setup
```bash
# Install dbt-duckdb
pip install dbt-duckdb

# Each modeling technique has its own directory
cd dimensional-modeling
dbt deps
dbt seed
dbt run
```

## Project Structure

```
.
├── dimensional-modeling/    # Star schema implementation
├── data-vault-20/          # Data Vault 2.0 implementation
├── one-big-table/          # Denormalized OBT implementation
└── questions/              # Business questions to answer
```

## The Three Modeling Techniques

### 1. Dimensional Modeling (Kimball Approach)

**Philosophy**: Organize data into facts (measurements) and dimensions (context).

**Structure**:
- Fact tables: Store quantitative metrics (e.g., orders, line items)
- Dimension tables: Store descriptive attributes (e.g., customers, products, dates)
- Star schema: Facts at center, dimensions surround

**Benefits**:
- Intuitive for business users
- Optimized for analytical queries
- Well-understood by BI tools

**References**:
- [The Data Warehouse Toolkit](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/books/data-warehouse-dw-toolkit/) by Ralph Kimball
- [Kimball Dimensional Modeling Techniques](https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/)

### 2. Data Vault 2.0

**Philosophy**: Create a flexible, auditable, and scalable enterprise data warehouse that preserves history.

**Structure**:
- **Hubs**: Unique business keys (e.g., Customer, Product)
- **Links**: Relationships between hubs (e.g., Order to Customer)
- **Satellites**: Descriptive attributes with history tracking

**Benefits**:
- Highly flexible and adaptable to change
- Complete historical tracking
- Parallel loading capabilities
- Audit trail built-in

**References**:
- [Building a Scalable Data Warehouse with Data Vault 2.0](https://danlinstedt.com/) by Dan Linstedt
- [Data Vault 2.0 Overview](https://www.data-vault.co.uk/what-is-data-vault/)
- [dbt Data Vault Package](https://github.com/Datavault-UK/automate-dv)

### 3. One Big Table (OBT)

**Philosophy**: Denormalize everything into a single wide table for maximum query simplicity.

**Structure**:
- Single table with all dimensions and facts combined
- Pre-joined for analysis
- Column-oriented storage optimized

**Benefits**:
- Simplest possible queries (SELECT * FROM...)
- No joins required
- Fast for specific analytical patterns
- Works well with modern columnar databases

**Drawbacks**:
- Data duplication
- More complex ETL
- Potential for stale data

**References**:
- [One Big Table](https://www.holistics.io/blog/one-big-table-obt/) - Holistics Blog
- [The Wide Table Paradigm](https://www.startdataengineering.com/post/when-to-use-wide-tables/)

## Training Exercises

Navigate to the `questions/` directory to find business questions to answer using each modeling technique. Compare:

- **Query Complexity**: How many joins? How readable is the SQL?
- **Performance**: How fast do queries execute?
- **Flexibility**: How easy is it to answer new questions?
- **Maintainability**: How would schema changes impact the model?

## TPC-H Dataset

The TPC-H dataset simulates a wholesale supplier database with:
- **Customers**: Customer information
- **Orders**: Order header information
- **LineItem**: Individual items in orders
- **Part**: Parts/products catalog
- **Supplier**: Supplier information
- **PartSupp**: Parts supplied by suppliers with pricing
- **Nation**: Nations/countries
- **Region**: Geographic regions

## Additional Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [DuckDB Documentation](https://duckdb.org/docs/)
- [TPC-H Benchmark](http://www.tpc.org/tpch/)

## Contributing

Found an issue or have suggestions? Open an issue or submit a pull request!

## License

This training material is provided for educational purposes.
