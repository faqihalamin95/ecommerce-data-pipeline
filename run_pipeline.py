import subprocess
import sys
import os

def run_script(path, description):
    print(f"\n--- [RUNNING] {description} ({path}) ---")
    
    env = os.environ.copy()
    env["PYTHONPATH"] = os.getcwd() 

    try:
        subprocess.run([sys.executable, path], check=True, env=env)
        print(f"--- [SUCCESS] {description} Completed ---")
    except subprocess.CalledProcessError:
        print(f"--- [ERROR] {description} Failed! Pipeline stopped. ---")
        sys.exit(1)

if __name__ == "__main__":
    print("STAGING & MARTS PIPELINE ORCHESTRATOR")
    print("="*40)
    
    run_script("src/ingestion/ingest_pakistan_ecommerce.py", "Ingestion")
    run_script("src/staging/load_staging.py", "Staging")
    run_script("src/marts/load_marts.py", "Marts (Fact & Dimensions)")
    
    print("\n" + "="*40)
    print("ALL STEPS COMPLETED SUCCESSFULLY!")