#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SUPERSET_DIR="$PROJECT_DIR/superset"

# Check if Superset is set up
if [ ! -d "$SUPERSET_DIR" ]; then
    echo -e "${RED}Error: Superset is not set up yet.${NC}"
    echo -e "Please run ${YELLOW}./setup_superset.sh${NC} first."
    exit 1
fi

cd "$SUPERSET_DIR"

echo -e "${BLUE}=== Starting Apache Superset ===${NC}"
echo -e "${YELLOW}This may take a few minutes on the first run...${NC}"
echo ""

# Start Superset
docker compose -f docker-compose-image-tag.yml -f docker-compose-duckdb.yml up -d

echo ""
echo -e "${GREEN}✓ Superset is starting!${NC}"
echo ""
echo -e "${BLUE}=== Access Information ===${NC}"
echo -e "URL: ${GREEN}http://localhost:8088${NC}"
echo -e "Username: ${GREEN}admin${NC}"
echo -e "Password: ${GREEN}admin${NC}"
echo ""
echo -e "${YELLOW}Note: It may take 1-2 minutes for Superset to be fully ready.${NC}"
echo ""
echo -e "To view logs:"
echo -e "  ${YELLOW}docker compose -f docker-compose-image-tag.yml -f docker-compose-duckdb.yml logs -f${NC}"
echo ""
echo -e "To stop Superset:"
echo -e "  ${YELLOW}./stop_superset.sh${NC}"
echo ""
echo -e "${BLUE}=== DuckDB Database URIs ===${NC}"
echo -e "After logging in, add these database connections:"
echo ""
echo -e "One Big Table:"
echo -e "  ${GREEN}duckdb:////app/data/one-big-table/one_big_table.duckdb${NC}"
echo ""
echo -e "Dimensional Modeling:"
echo -e "  ${GREEN}duckdb:////app/data/dimensional-modeling/dimensional_modeling.duckdb${NC}"
echo ""
echo -e "Data Vault 2.0:"
echo -e "  ${GREEN}duckdb:////app/data/data-vault-20/data_vault_20.duckdb${NC}"
