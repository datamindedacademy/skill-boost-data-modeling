# Quick Start Guide

Get started with the Data Modeling Skill Boost training in just a few minutes!

## Option 1: GitHub Codespaces (Easiest!)

1. Click the "Open in GitHub Codespaces" button in the main README
2. Wait for the environment to build (3-5 minutes)
3. The setup script will automatically:
   - Install dbt-duckdb
   - Create three DuckDB databases with TPC-H data
   - Set up all dependencies
4. Start exploring!

## Option 2: Local Setup

### Prerequisites
- Python 3.8 or higher
- pip

### Setup Steps

1. Clone this repository:
```bash
git clone <your-repo-url>
cd skill-boost-data-modeling
```

2. Install dbt-duckdb:
```bash
pip install dbt-duckdb
```

3. Initialize each project:

**Dimensional Modeling:**
```bash
cd dimensional-modeling
cat > init_tpch.sql << 'EOF'
INSTALL tpch;
LOAD tpch;
CALL dbgen(sf = 0.1);
EOF
duckdb dimensional_modeling.duckdb < init_tpch.sql
dbt run --profiles-dir .
cd ..
```

**Data Vault 2.0:**
```bash
cd data-vault-20
cat > init_tpch.sql << 'EOF'
INSTALL tpch;
LOAD tpch;
CALL dbgen(sf = 0.1);
EOF
duckdb data_vault_20.duckdb < init_tpch.sql
dbt run --profiles-dir .
cd ..
```

**One Big Table:**
```bash
cd one-big-table
cat > init_tpch.sql << 'EOF'
INSTALL tpch;
LOAD tpch;
CALL dbgen(sf = 0.1);
EOF
duckdb one_big_table.duckdb < init_tpch.sql
dbt run --profiles-dir .
cd ..
```

## Running the Models

Each directory is an independent dbt project. To build the models:

```bash
# Dimensional Modeling
cd dimensional-modeling
dbt run --profiles-dir .

# Data Vault 2.0
cd data-vault-20
dbt run --profiles-dir .

# One Big Table
cd one-big-table
dbt run --profiles-dir .
```

## Querying the Data

### Using DuckDB CLI

```bash
# Query dimensional model
duckdb dimensional-modeling/dimensional_modeling.duckdb
```

Then run SQL:
```sql
SELECT * FROM fact_line_item LIMIT 10;
```

### Using Python

```python
import duckdb

# Connect to dimensional model
conn = duckdb.connect('dimensional-modeling/dimensional_modeling.duckdb')
result = conn.execute('SELECT * FROM fact_line_item LIMIT 10').fetchdf()
print(result)
```

## Training Flow

1. **Read the README.md** - Understand the three approaches
2. **Explore each project's README** - See the schema designs
3. **Run the models** - Build all three implementations
4. **Try the questions** - Go to `questions/README.md`
5. **Write queries** - Answer questions using each model
6. **Compare** - Fill out the comparison matrix
7. **Discuss** - Talk through trade-offs with your team

## Troubleshooting

### dbt command not found
```bash
pip install --upgrade dbt-duckdb
```

### TPC-H extension not loading
Make sure you're running the init script in the project directory and that DuckDB can access the database file.

### Models not building
Check that you ran the TPC-H initialization first:
```bash
duckdb <project>.duckdb < init_tpch.sql
```

## Getting Help

- See `questions/README.md` for exercise details
- Check individual project READMEs for specific guidance
- Review `questions/sample-answers/` for example queries
- Open an issue if you encounter problems

## Project Structure

```
.
├── README.md                    # Main overview
├── QUICKSTART.md               # This file
├── dimensional-modeling/       # Kimball star schema
│   ├── models/
│   ├── dbt_project.yml
│   └── README.md
├── data-vault-20/             # Data Vault 2.0
│   ├── models/
│   ├── dbt_project.yml
│   └── README.md
├── one-big-table/             # Denormalized OBT
│   ├── models/
│   ├── dbt_project.yml
│   └── README.md
├── questions/                  # Training exercises
│   ├── README.md
│   └── sample-answers/
└── .devcontainer/             # Codespaces config
```

## Tips for Success

1. **Don't skip the reading** - Understanding the philosophy helps
2. **Write queries yourself first** - Don't jump to sample answers
3. **Time yourself** - Notice which approach is faster to write
4. **Think about maintenance** - Consider long-term implications
5. **Discuss with others** - Different perspectives are valuable

Ready to start? Head to `questions/README.md`! 🚀
