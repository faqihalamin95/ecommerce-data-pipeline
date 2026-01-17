ingest:
	python src/ingestion/ingest_pakistan_ecommerce.py

staging:
	python src/staging/load_staging.py

marts:
	python src/marts/load_marts.py

run-all: ingest staging marts
	@echo "Pipeline finished successfully."