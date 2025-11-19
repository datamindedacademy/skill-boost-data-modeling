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
    echo -e "${RED}Error: Superset directory not found.${NC}"
    exit 1
fi

cd "$SUPERSET_DIR"

echo -e "${BLUE}=== Stopping Apache Superset ===${NC}"

docker compose -f docker-compose-image-tag.yml -f docker-compose-duckdb.yml down

echo -e "${GREEN}✓ Superset stopped successfully${NC}"
echo ""
echo -e "To start again: ${YELLOW}./superset-cli start{NC}"
echo ""
echo -e "To completely reset Superset (remove all data):"
echo -e "  ${YELLOW}cd $SUPERSET_DIR${NC}"
echo -e "  ${YELLOW}docker compose -f docker-compose-image-tag.yml -f docker-compose-duckdb.yml down -v${NC}"
