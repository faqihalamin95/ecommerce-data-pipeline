# ===============================
# Project Configuration
# ===============================

PYTHON := python3
PROJECT_ROOT := $(shell pwd)
export PYTHONPATH := $(PROJECT_ROOT)

.PHONY: init-db ingest staging data-quality-checks-staging foundation final-data-quality-checks marts run-all

# ===============================
# Core Pipeline Steps
# ===============================

init-db:
	@echo "Initializing database tables..."
	$(PYTHON) src/init_db.py

ingest:
	@echo "Running ingestion..."
	$(PYTHON) src/ingestion/ingest_pakistan_ecommerce.py

staging:
	@echo "Running staging data quality checks..."
	$(PYTHON) src/staging/stg_pakistan_ecommerce.py 

# First level data quality checks (staging)
data-quality-checks-staging:
	@echo "Running staging data quality tests..."
	$(PYTHON) src/qc/qc_staging.py

foundation:
	@echo "Building data foundation..."
	$(PYTHON) src/foundation/load_foundation.py

# Final Quality Gate (foundation/fact tables)
final-data-quality-checks:
	@echo "Running final fact data quality tests..."
	$(PYTHON) src/qc/qc_foundation.py

marts:
	@echo "Building data marts..."
	$(PYTHON) src/marts/load_marts.py

# ===============================
# Full Pipeline
# ===============================

run-all: init-db ingest staging data-quality-checks-staging foundation final-data-quality-checks marts
	@echo "========================================"
	@echo "PIPELINE COMPLETED — ALL TESTS PASSED"
	@echo "========================================"
