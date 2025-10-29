# Project Structure

```
skill-boost-data-modeling/
│
├── README.md                          # Main overview and introduction
├── QUICKSTART.md                      # Setup and getting started guide
├── PROJECT_SUMMARY.md                 # Detailed project summary
├── STRUCTURE.md                       # This file
│
├── .devcontainer/                     # GitHub Codespaces configuration
│   ├── devcontainer.json             # VS Code dev container settings
│   └── setup.sh                      # Automated setup script
│
├── dimensional-modeling/              # Kimball Star Schema Implementation
│   ├── README.md                     # Dimensional modeling guide
│   ├── dbt_project.yml               # dbt configuration
│   ├── profiles.yml                  # DuckDB connection
│   └── models/
│       ├── staging/                  # Source data staging
│       │   ├── stg_tpch_sources.yml
│       │   ├── stg_customer.sql
│       │   ├── stg_orders.sql
│       │   ├── stg_lineitem.sql
│       │   ├── stg_part.sql
│       │   ├── stg_supplier.sql
│       │   ├── stg_nation.sql
│       │   └── stg_region.sql
│       ├── dimensions/               # Dimension tables
│       │   ├── dim_customer.sql      # Customer + geography
│       │   ├── dim_part.sql          # Product catalog
│       │   ├── dim_supplier.sql      # Supplier + geography
│       │   └── dim_date.sql          # Date dimension
│       └── facts/                    # Fact tables
│           ├── fact_line_item.sql    # Line item grain
│           └── fact_orders.sql       # Order grain (aggregated)
│
├── data-vault-20/                     # Data Vault 2.0 Implementation
│   ├── README.md                     # Data Vault concepts guide
│   ├── dbt_project.yml               # dbt configuration
│   ├── profiles.yml                  # DuckDB connection
│   └── models/
│       ├── staging/
│       │   └── stg_tpch_sources.yml
│       ├── raw_vault/                # Core Data Vault structures
│       │   ├── hubs/                 # Business keys
│       │   │   ├── hub_customer.sql
│       │   │   ├── hub_order.sql
│       │   │   ├── hub_part.sql
│       │   │   └── hub_supplier.sql
│       │   ├── links/                # Relationships
│       │   │   ├── link_order_customer.sql
│       │   │   └── link_lineitem.sql
│       │   └── satellites/           # Descriptive attributes
│       │       ├── sat_customer.sql
│       │       ├── sat_order.sql
│       │       ├── sat_part.sql
│       │       └── sat_lineitem.sql
│       └── business_vault/           # Query-friendly views
│           └── bv_order_details.sql  # Denormalized view
│
├── one-big-table/                     # One Big Table Implementation
│   ├── README.md                     # OBT philosophy guide
│   ├── dbt_project.yml               # dbt configuration
│   ├── profiles.yml                  # DuckDB connection
│   └── models/
│       ├── tpch_sources.yml
│       └── obt_orders.sql            # Single denormalized table
│
└── questions/                         # Training exercises
    ├── README.md                     # Exercise guide & comparison matrix
    └── sample-answers/               # Example queries
        ├── dimensional/
        │   ├── question1.sql
        │   └── question8.sql
        ├── data-vault/
        │   └── question1.sql
        └── obt/
            ├── question1.sql
            └── question8.sql
```

## Model Counts by Project

### Dimensional Modeling
- **Staging**: 7 models
- **Dimensions**: 4 models
- **Facts**: 2 models
- **Total**: 13 models

### Data Vault 2.0
- **Hubs**: 4 models
- **Links**: 2 models
- **Satellites**: 4 models
- **Business Vault**: 1 model
- **Total**: 11 models

### One Big Table
- **Models**: 1 model (comprehensive)
- **Total**: 1 model

## Key Files Explained

### Root Level

- **README.md**: Start here! Explains all three modeling techniques with theory and references
- **QUICKSTART.md**: Step-by-step setup for local or Codespaces
- **PROJECT_SUMMARY.md**: Detailed breakdown of what was built
- **STRUCTURE.md**: This file - visual project organization

### Configuration Files

Each dbt project has:
- **dbt_project.yml**: Project name, model paths, materialization settings
- **profiles.yml**: Database connection (DuckDB path, threads)
- **README.md**: Project-specific guide with query examples

### Model Files

- **Staging models** (`stg_*.sql`): Clean and rename source columns
- **Dimension models** (`dim_*.sql`): Business entities with attributes
- **Fact models** (`fact_*.sql`): Measurements and metrics
- **Hub models** (`hub_*.sql`): Business keys with hash keys
- **Link models** (`link_*.sql`): Relationships between hubs
- **Satellite models** (`sat_*.sql`): Descriptive attributes with history
- **Business Vault** (`bv_*.sql`): Query-friendly denormalized views
- **OBT model** (`obt_*.sql`): All data in one wide table

### Training Materials

- **questions/README.md**: 8 business questions + comparison framework
- **sample-answers/**: Example SQL for each technique
  - Shows different levels of query complexity
  - Includes comments on observations

### Codespaces Setup

- **.devcontainer/devcontainer.json**: VS Code configuration
  - Python 3.11
  - dbt and SQL extensions
  - Auto-formatting settings
- **.devcontainer/setup.sh**: Initialization script
  - Installs dbt-duckdb
  - Creates databases
  - Loads TPC-H data

## Data Flow

### Dimensional Modeling
```
TPC-H Source → Staging → Dimensions → Facts → BI Tool
                                    ↗
```

### Data Vault 2.0
```
TPC-H Source → Hubs/Links/Satellites (Raw Vault) → Business Vault → BI Tool
```

### One Big Table
```
TPC-H Source → OBT (everything pre-joined) → BI Tool
```

## Database Files (Created After Setup)

After running setup, you'll have:
- `dimensional-modeling/dimensional_modeling.duckdb`
- `data-vault-20/data_vault_20.duckdb`
- `one-big-table/one_big_table.duckdb`

Each contains TPC-H data at scale factor 0.1:
- ~1,500 customers
- ~15,000 orders
- ~60,000 line items
- ~2,000 parts
- ~100 suppliers
- 25 nations
- 5 regions

## Usage Patterns

### For Learners
1. Start with README.md
2. Run through QUICKSTART.md
3. Explore each project's README
4. Answer questions/ exercises
5. Compare your queries with sample-answers/

### For Instructors
1. Fork/clone this repository
2. Customize questions for your audience
3. Add more sample queries
4. Extend with organization-specific scenarios
5. Use as workshop material

### For Teams Evaluating Approaches
1. Run all three implementations
2. Time query writing
3. Measure query performance
4. Discuss trade-offs in team meetings
5. Map to your actual use cases

## Extending This Project

Easy additions:
- Add more sample queries
- Include performance benchmarks
- Add data quality tests
- Create BI tool examples (Metabase, Tableau, etc.)
- Add incremental loading patterns
- Include CI/CD examples

Advanced additions:
- Add other modeling techniques (Anchor, 3NF)
- Use real company data
- Add machine learning feature stores
- Include streaming data examples
- Add data governance examples

## File Conventions

- **SQL files**: Lowercase with underscores (e.g., `fact_line_item.sql`)
- **Config files**: Standard dbt naming (`dbt_project.yml`, `profiles.yml`)
- **Documentation**: Uppercase markdown (e.g., `README.md`, `QUICKSTART.md`)
- **Directories**: Lowercase with hyphens (e.g., `dimensional-modeling/`)

## Version Control

Included in repository:
- All SQL models
- Configuration files
- Documentation
- Setup scripts

Not included (in .gitignore):
- `*.duckdb` - Database files
- `target/` - dbt build artifacts
- `dbt_packages/` - Installed packages
- `__pycache__/` - Python cache

## Getting Help

- Check project-specific README files
- Review sample-answers/ for query examples
- See QUICKSTART.md for setup issues
- Open GitHub issues for bugs or suggestions
