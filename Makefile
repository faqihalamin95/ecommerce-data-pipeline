# ===============================
# Project Configuration
# ===============================

PYTHON := python3
PROJECT_ROOT := $(shell pwd)
export PYTHONPATH := $(PROJECT_ROOT)

.PHONY: init-db ingest staging marts test run-all

# ===============================
# Core Pipeline Steps
# ===============================

init-db:
	@echo "Initializing database tables..."
	$(PYTHON) init_db.py

ingest:
	@echo "Running ingestion..."
	$(PYTHON) src/ingestion/ingest_pakistan_ecommerce.py

staging:
	@echo "Running staging data quality checks..."
	$(PYTHON) src/staging/load_staging.py

marts:
	@echo "Building data marts..."
	$(PYTHON) src/marts/load_marts.py

# ===============================
# Final Quality Gate
# ===============================

test:
	@echo "Running final fact data quality tests..."
	psql -U postgres -d ecommerce_dwh -f tests/fact_sales_quality.sql

# ===============================
# Full Pipeline
# ===============================

run-all: ingest staging marts test
	@echo "========================================"
	@echo "PIPELINE COMPLETED — ALL TESTS PASSED"
	@echo "========================================"
