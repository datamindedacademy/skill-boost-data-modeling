#!/bin/bash
set -e

echo "🚀 Setting up Data Modeling Skill Boost environment..."

# Install uv
echo "📦 Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

# Install DuckDB
echo "📦 Installing DuckDB..."
curl https://install.duckdb.org | sh
echo 'PATH='/home/vscode/.duckdb/cli/latest':$PATH' >> ~/.bashrc

# Install dependencies with uv
echo "📦 Installing dependencies with uv..."
uv sync

# Add venv activation to bashrc
echo 'source /workspaces/skill-boost-data-modeling/.venv/bin/activate' >> ~/.bashrc
source ~/.bashrc

# Initialize TPC-H data for each project
echo "🗄️  Initializing TPC-H data..."

# Dimensional Modeling
echo "  → Setting up dimensional-modeling database..."
cd dimensional-modeling
cat > init_tpch.sql << 'EOF'
INSTALL tpch;
LOAD tpch;
CALL dbgen(sf = 0.1);
EOF
duckdb dimensional_modeling.duckdb < init_tpch.sql
rm init_tpch.sql
dbt seed --profiles-dir .
cd ..

# Data Vault 2.0
echo "  → Setting up data-vault-20 database..."
cd data-vault-20
cat > init_tpch.sql << 'EOF'
INSTALL tpch;
LOAD tpch;
CALL dbgen(sf = 0.1);
EOF
duckdb data_vault_20.duckdb < init_tpch.sql
rm init_tpch.sql
dbt seed --profiles-dir .
cd ..

# One Big Table
echo "  → Setting up one-big-table database..."
cd one-big-table
cat > init_tpch.sql << 'EOF'
INSTALL tpch;
LOAD tpch;
CALL dbgen(sf = 0.1);
EOF
duckdb one_big_table.duckdb < init_tpch.sql
rm init_tpch.sql
dbt seed --profiles-dir .
cd ..

echo "✅ Environment setup complete!"
echo ""
echo "📚 Next steps:"
echo "  1. Read the main README.md for an overview"
echo "  2. Explore each modeling technique directory"
echo "  3. Run dbt for each project:"
echo "     cd dimensional-modeling && dbt seed --profiles-dir . && dbt run --profiles-dir ."
echo "     cd data-vault-20 && dbt seed --profiles-dir . && dbt run --profiles-dir ."
echo "     cd one-big-table && dbt seed --profiles-dir . && dbt run --profiles-dir ."
echo "  4. Try the exercises in the questions/ directory"
echo ""
echo "Happy modeling! 🎉"
