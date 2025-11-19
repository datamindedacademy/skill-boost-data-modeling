#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

SUPERSET_URL="http://localhost:8088"
USERNAME="admin"
PASSWORD="admin"
COOKIE_JAR="/tmp/superset_cookies.txt"

echo -e "${BLUE}=== Adding DuckDB Database Connections to Superset ===${NC}"
echo ""

# Clean up old cookies
rm -f "$COOKIE_JAR"

# Function to get access token
get_access_token() {
    local response=$(curl -s -c "$COOKIE_JAR" -X POST "$SUPERSET_URL/api/v1/security/login" \
        -H "Content-Type: application/json" \
        -d "{\"username\": \"$USERNAME\", \"password\": \"$PASSWORD\", \"provider\": \"db\", \"refresh\": \"true\"}")
    echo "$response" | jq -r '.access_token'
}

# Function to get CSRF token
get_csrf_token() {
    local token=$1
    curl -s -b "$COOKIE_JAR" -c "$COOKIE_JAR" -X GET "$SUPERSET_URL/api/v1/security/csrf_token/" \
        -H "Authorization: Bearer $token" | jq -r '.result'
}

# Function to add database
add_database() {
    local token=$1
    local csrf=$2
    local db_name=$3
    local sqlalchemy_uri=$4

    echo -e "${YELLOW}Adding database: $db_name${NC}"

    local payload=$(cat <<EOF
{
    "database_name": "$db_name",
    "sqlalchemy_uri": "$sqlalchemy_uri",
    "expose_in_sqllab": true,
    "allow_ctas": true,
    "allow_cvas": true,
    "allow_dml": true,
    "allow_run_async": true,
    "cache_timeout": null,
    "extra": "{\"allows_virtual_table_explore\": true}",
    "impersonate_user": false,
    "encrypted_extra": "{}"
}
EOF
)

    local response=$(curl -s -w "\n%{http_code}" -b "$COOKIE_JAR" -X POST "$SUPERSET_URL/api/v1/database/" \
        -H "X-CSRFToken: $csrf" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -H "Referer: $SUPERSET_URL" \
        -d "$payload")

    local http_code=$(echo "$response" | tail -n1)
    local body=$(echo "$response")

    if [ "$http_code" = "201" ]; then
        echo -e "${GREEN}✓ Successfully added: $db_name${NC}"
    elif echo "$body" | grep -q "already exists"; then
        echo -e "${YELLOW}⚠ Database already exists: $db_name${NC}"
    else
        echo -e "${RED}✗ Failed to add: $db_name${NC}"
        echo -e "${RED}HTTP Code: $http_code${NC}"
        echo -e "${RED}Response: $body${NC}"
    fi
}

# Check if Superset is running
if ! curl -s "$SUPERSET_URL/health" > /dev/null 2>&1; then
    echo -e "${RED}Error: Superset is not running or not accessible at $SUPERSET_URL${NC}"
    echo -e "Please start Superset first: ${YELLOW}./start_superset.sh${NC}"
    exit 1
fi

echo -e "${BLUE}Logging in to Superset...${NC}"
ACCESS_TOKEN=$(get_access_token)

if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" = "null" ]; then
    echo -e "${RED}Error: Failed to get access token. Please check credentials.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Successfully logged in${NC}"
echo ""

echo -e "${BLUE}Getting CSRF token...${NC}"
CSRF_TOKEN=$(get_csrf_token "$ACCESS_TOKEN")

if [ -z "$CSRF_TOKEN" ] || [ "$CSRF_TOKEN" = "null" ]; then
    echo -e "${RED}Error: Failed to get CSRF token.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Got CSRF token${NC}"
echo ""

# Add databases
add_database "$ACCESS_TOKEN" "$CSRF_TOKEN" "One Big Table" "duckdb:////app/data/one-big-table/one_big_table.duckdb"
add_database "$ACCESS_TOKEN" "$CSRF_TOKEN" "Dimensional Modeling" "duckdb:////app/data/dimensional-modeling/dimensional_modeling.duckdb"
add_database "$ACCESS_TOKEN" "$CSRF_TOKEN" "Data Vault 2.0" "duckdb:////app/data/data-vault-20/data_vault_20.duckdb"

echo ""
echo -e "${GREEN}✓ Database setup complete!${NC}"
echo ""
echo -e "You can now:"
echo -e "1. Visit ${GREEN}$SUPERSET_URL${NC}"
echo -e "2. Go to SQL → SQL Lab to query your databases"
echo -e "3. Create datasets and dashboards"
