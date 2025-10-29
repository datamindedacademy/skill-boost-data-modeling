# Project Summary: Data Modeling Skill Boost

## Overview

This training project provides a hands-on comparison of three data modeling techniques using TPC-H benchmark data and dbt with DuckDB.

## What Was Created

### 1. Main Documentation
- **README.md** - Comprehensive overview with theory and references
- **QUICKSTART.md** - Step-by-step setup instructions
- **PROJECT_SUMMARY.md** - This file

### 2. Dimensional Modeling Project (`dimensional-modeling/`)

A Kimball-style star schema implementation with:

**Staging Models** (7 files):
- `stg_customer.sql`, `stg_orders.sql`, `stg_lineitem.sql`
- `stg_part.sql`, `stg_supplier.sql`, `stg_nation.sql`, `stg_region.sql`

**Dimension Models** (4 files):
- `dim_customer.sql` - With geographic hierarchy
- `dim_part.sql` - Product catalog
- `dim_supplier.sql` - With geographic hierarchy
- `dim_date.sql` - Time dimension

**Fact Models** (2 files):
- `fact_line_item.sql` - Grain: line item
- `fact_orders.sql` - Grain: order (aggregated)

**Configuration**:
- `dbt_project.yml` - Project configuration
- `profiles.yml` - DuckDB connection
- `README.md` - Project-specific guide with example queries

### 3. Data Vault 2.0 Project (`data-vault-20/`)

A Data Vault 2.0 implementation with raw vault and business vault:

**Hub Models** (4 files):
- `hub_customer.sql`, `hub_order.sql`, `hub_part.sql`, `hub_supplier.sql`
- Each stores business keys with hash keys

**Link Models** (2 files):
- `link_order_customer.sql` - Order-Customer relationship
- `link_lineitem.sql` - Order-Part-Supplier relationship

**Satellite Models** (4 files):
- `sat_customer.sql`, `sat_order.sql`, `sat_part.sql`, `sat_lineitem.sql`
- Each stores descriptive attributes with hashdiff for change detection

**Business Vault** (1 file):
- `bv_order_details.sql` - Denormalized view joining all components

**Configuration**:
- `dbt_project.yml` - Project configuration
- `profiles.yml` - DuckDB connection
- `README.md` - Data Vault concepts and query examples

### 4. One Big Table Project (`one-big-table/`)

A fully denormalized single table approach:

**Model** (1 file):
- `obt_orders.sql` - All data pre-joined with 60+ columns including:
  - Order attributes with date parts
  - Customer attributes with geography
  - Part/product attributes
  - Supplier attributes with geography
  - Line item details
  - Pre-calculated measures
  - Shipping metrics

**Configuration**:
- `dbt_project.yml` - Project configuration
- `profiles.yml` - DuckDB connection
- `README.md` - OBT philosophy and simple query examples

### 5. Training Materials (`questions/`)

**Main Guide**:
- `README.md` - 8 business questions with comparison framework

**Sample Answers**:
- `dimensional/question1.sql`, `dimensional/question8.sql`
- `data-vault/question1.sql`
- `obt/question1.sql`, `obt/question8.sql`

Questions cover:
1. Revenue by region
2. Product performance
3. Time-based analysis
4. Customer segmentation
5. Multi-dimensional slicing
6. Shipping performance
7. Supplier analysis
8. Ad-hoc requirements (tests flexibility)

### 6. GitHub Codespaces Support (`.devcontainer/`)

**Configuration**:
- `devcontainer.json` - VS Code dev container setup with:
  - Python 3.11 base image
  - dbt and DuckDB extensions
  - Python linting and formatting

**Setup Script**:
- `setup.sh` - Automated environment initialization:
  - Installs dbt-duckdb
  - Creates three DuckDB databases
  - Loads TPC-H data (scale factor 0.1)
  - Ready to run dbt

## Key Features

### Realistic Dataset
- Uses TPC-H benchmark data (standard for database testing)
- Contains orders, customers, parts, suppliers with realistic relationships
- Scale factor 0.1 = ~60,000 orders, ~600,000 line items

### Complete dbt Projects
- Each modeling technique is a fully functional dbt project
- Can be run independently
- Production-ready structure with staging → transform layers

### Hands-On Learning
- 8 progressively complex business questions
- Sample answers provided for comparison
- Comparison matrix to track observations
- Discussion questions for deeper thinking

### Zero Setup (with Codespaces)
- Click and go - no local installation needed
- Everything pre-configured
- Start querying immediately

## Learning Objectives

By completing this training, participants will:

1. **Understand** the philosophy behind each modeling approach
2. **Experience** query complexity differences firsthand
3. **Evaluate** flexibility for ad-hoc requirements
4. **Compare** trade-offs in real scenarios
5. **Make informed decisions** about which approach to use when

## Technical Stack

- **dbt**: Transformation framework
- **DuckDB**: In-process SQL OLAP database
- **TPC-H**: Standard benchmark dataset
- **Python**: Runtime environment
- **GitHub Codespaces**: Cloud development environment

## File Statistics

- **Total SQL Models**: 30+ dbt models
- **Documentation**: 7 markdown files
- **Sample Queries**: 5 query examples
- **Configuration Files**: 8 YAML/JSON files

## Usage Scenarios

This training is ideal for:

- Data engineering teams evaluating modeling approaches
- Data architects designing new data warehouses
- Analytics engineers learning data modeling
- Teams transitioning between modeling paradigms
- Educational institutions teaching data warehousing

## Next Steps After Training

1. Apply learnings to your actual data sources
2. Consider hybrid approaches (e.g., Data Vault + dimensional marts)
3. Evaluate based on your specific requirements:
   - Data volume
   - Change frequency
   - User technical level
   - Auditability needs
   - Performance requirements

## Customization Ideas

This framework can be extended:

- Add more modeling techniques (Anchor Modeling, 3NF)
- Use different datasets (e-commerce, healthcare, etc.)
- Add BI tool integration examples
- Include performance benchmarking
- Add incremental loading examples
- Include data quality tests

## License and Attribution

This training material is provided for educational purposes. Feel free to adapt and extend for your organization's needs.

TPC-H is a trademark of the Transaction Processing Performance Council.
