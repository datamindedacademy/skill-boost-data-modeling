# Skill Boost: Data Modeling Techniques

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new?repo=datamindedacademy/skill-boost-data-modeling)

## Overview

Welcome to the Data Modeling Skill Boost training session! This hands-on workshop explores three distinct data modeling techniques using the same dataset (TPC-H). You'll experience firsthand how different modeling approaches affect query complexity, maintainability, and analytical ease.

## What You'll Learn

This training uses the **TPC-H benchmark dataset** (a standard dataset for database benchmarking) to implement three different modeling techniques:

1. **Dimensional Modeling** (Kimball) - Star schema with facts and dimensions
2. **Data Vault 2.0** - Flexible, auditable enterprise data warehouse
3. **One Big Table (OBT)** - Fully denormalized approach

Each technique is implemented as a separate dbt project using DuckDB. You'll write queries against each model to answer business questions and compare the experience across approaches.

## Getting Started

### Option 1: GitHub Codespaces (Recommended)

Click the "Open in GitHub Codespaces" badge above. Everything is pre-configured and will be ready in 3-5 minutes!

The setup automatically:
- Installs uv and all dependencies
- Creates three DuckDB databases with TPC-H data
- Configures the Python environment

### Option 2: Local Setup

**Prerequisites:**
- Python 3.11 or higher
- Git

**Installation:**

```bash
# Clone the repository
git clone https://github.com/datamindedacademy/skill-boost-data-modeling
cd skill-boost-data-modeling

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install dependencies
uv sync

# Activate the virtual environment
source .venv/bin/activate

# Follow the setup instructions in each project directory to initialize data and run dbt
```

## Project Structure

```
.
├── dimensional-modeling/    # Star schema implementation
├── data-vault-20/          # Data Vault 2.0 implementation
├── one-big-table/          # Denormalized OBT implementation
├── questions/              # Business questions to answer
└── pyproject.toml          # Python dependencies
```

## The Three Modeling Techniques

Each modeling approach directory contains detailed information about the philosophy, benefits, drawbacks, and references. Explore each to understand the trade-offs:

- **dimensional-modeling/** - Star schema with facts and dimensions (Kimball approach)
- **data-vault-20/** - "Flexible", auditable enterprise warehouse with hubs, links, and satellites
- **one-big-table/** - Fully denormalized single table approach

## Training Exercises

Navigate to the `questions/` directory to find business questions to answer using each modeling technique. Compare:

- **Query Complexity**: How many joins? How readable is the SQL?
- **Performance**: How fast do queries execute?
- **Flexibility**: How easy is it to answer new questions?
- **Maintainability**: How would schema changes impact the model?

## Visualizing with Apache Superset

Explore your data models visually using Apache Superset with automatic DuckDB connections to all three modeling approaches.

### Quick Start

```bash
# One-time setup (first time only)
./superset-cli setup

# Start Superset
./superset-cli start

# Wait 1-2 minutes, then access at http://localhost:8088
# Login: admin / admin

# Add DuckDB database connections (if not already added)
./superset-cli connect

# Stop Superset when done
./superset-cli stop
```

Once connected, you can query and visualize data from all three models

**Tip:** Run `./superset-cli help` to see all available commands.

## Additional Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [DuckDB Documentation](https://duckdb.org/docs/)
- [TPC-H Benchmark](http://www.tpc.org/tpch/)
- [Apache Superset Documentation](https://superset.apache.org/docs/intro)

## Contributing

Found an issue or have suggestions? Open an issue or submit a pull request!

## License

This training material is provided for educational purposes.
