#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Apache Superset Setup Script ===${NC}"

# Get the absolute path to the project directory (one level up from this script)
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SUPERSET_DIR="$PROJECT_DIR/superset"

echo -e "${BLUE}Project directory: $PROJECT_DIR${NC}"

# Clone Superset repository if it doesn't exist
if [ ! -d "$SUPERSET_DIR" ]; then
    echo -e "${GREEN}Cloning Apache Superset repository...${NC}"
    git clone https://github.com/apache/superset.git "$SUPERSET_DIR" --depth 1 --branch 5.0.0
else
    echo -e "${YELLOW}Superset directory already exists, skipping clone${NC}"
fi

# Navigate to Superset directory
cd "$SUPERSET_DIR"

# Create custom docker-compose override
echo -e "${GREEN}Creating docker-compose override for DuckDB support...${NC}"
cat > docker-compose-duckdb.yml << 'EOF'
version: "3.8"

services:
  superset:
    volumes:
      # Mount the entire project directory to access DuckDB files
      - ../:/app/data
      # Mount custom requirements
      - ./docker/requirements-local.txt:/app/docker/requirements-local.txt
    environment:
      # Add any custom environment variables here
      SUPERSET_LOAD_EXAMPLES: "no"

  superset-init:
    volumes:
      - ../:/app/data
      - ./docker/requirements-local.txt:/app/docker/requirements-local.txt
    environment:
      SUPERSET_LOAD_EXAMPLES: "no"

  superset-worker:
    volumes:
      - ../:/app/data
      - ./docker/requirements-local.txt:/app/docker/requirements-local.txt

  superset-worker-beat:
    volumes:
      - ../:/app/data
      - ./docker/requirements-local.txt:/app/docker/requirements-local.txt
EOF

# Create custom requirements file for DuckDB
echo -e "${GREEN}Creating custom requirements file for DuckDB...${NC}"
mkdir -p docker
cat > docker/requirements-local.txt << 'EOF'
duckdb==1.4.2
duckdb-engine==0.17.0
EOF

# Create initialization script for databases
echo -e "${GREEN}Creating database initialization script...${NC}"
cat > docker/docker-init-duckdb.sh << 'EOF'
#!/bin/bash
set -e

echo "Installing DuckDB dependencies..."
pip install -r /app/docker/requirements-local.txt

echo "DuckDB support installed successfully!"
EOF

chmod +x docker/docker-init-duckdb.sh

# Create a custom superset_config.py for database pre-configuration
echo -e "${GREEN}Creating Superset configuration file...${NC}"
cat > docker/pythonpath_dev/superset_config.py << 'EOF'
import os
from flask_appbuilder.security.manager import AUTH_DB

# Superset specific config
ROW_LIMIT = 5000
SUPERSET_WEBSERVER_PORT = 8088

# Flask App Builder configuration
# Your App secret key
SECRET_KEY = os.environ.get('SECRET_KEY', 'thisISaSECRET_1234')

# The SQLAlchemy connection string to your database backend
SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL', 'postgresql+psycopg2://superset:superset@db:5432/superset')

# Flask-WTF flag for CSRF
WTF_CSRF_ENABLED = True
WTF_CSRF_EXEMPT_LIST = []
WTF_CSRF_TIME_LIMIT = None

# Set this API key to enable Mapbox visualizations
MAPBOX_API_KEY = os.environ.get('MAPBOX_API_KEY', '')

# Authentication type
AUTH_TYPE = AUTH_DB

# Allow embedding
FEATURE_FLAGS = {
    "EMBEDDED_SUPERSET": True,
    "ENABLE_TEMPLATE_PROCESSING": True,
}

# Optionally import superset_config_docker.py for Docker-specific overrides
try:
    from superset_config_docker import *  # noqa
except ImportError:
    pass
EOF

echo -e "${GREEN}✓ Setup complete!${NC}"
echo ""
echo -e "${BLUE}=== Next Steps ===${NC}"
echo -e "1. Start Superset:"
echo -e "   ${YELLOW}cd $SUPERSET_DIR${NC}"
echo -e "   ${YELLOW}docker compose -f docker-compose-image-tag.yml -f docker-compose-duckdb.yml up${NC}"
echo ""
echo -e "2. Wait for initialization (this may take a few minutes on first run)"
echo ""
echo -e "3. Access Superset at: ${GREEN}http://localhost:8088${NC}"
echo -e "   Default credentials: admin / admin"
echo ""
echo -e "4. Add DuckDB connections using the SQLAlchemy URIs from SUPERSET_SETUP.md"
echo ""
echo -e "For detailed instructions, see: ${YELLOW}$SUPERSET_DIR/SUPERSET_SETUP.md${NC}"
