#!/bin/bash

# Directory containing all repos
REPOS_DIR="/c/Users/n740789/Documents"
PYTHON_PATH="/c/Program Files/Python313/python.exe"
LOG_FILE="$REPOS_DIR/venv_update_errors.log"

# Explicit list of valid repos
REPOS=(
    "aih-dataplatform-python-dataflow-brs_crossreference"
    "aih-dataplatform-python-data_framework"
    "aih-dataplatform-python-dataflow-esg_clarity"
    "aih-dataplatform-python-dataflow-esg_sribusinessdata"
    "benchmark_srating_impact_analysis"
    "clarity_data_quality_controls"
    "esg_database"
    "esg_srating_strategies"
    "other_projects"
    "sfdr_report_generator"
    "stewardship_projects"
    "udemy-pyspark"
    "udemy-pyspark-portilla"
)

# Ensure Python exists
if [[ ! -f "$PYTHON_PATH" ]]; then
    echo "Python interpreter not found at $PYTHON_PATH. Exiting."
    exit 1
fi

# Start logging (without clearing previous logs)
echo "Logging errors to $LOG_FILE"
echo "--- Script run at $(date) ---" >> "$LOG_FILE"

# Loop through listed repos only
for repo_name in "${REPOS[@]}"; do
    repo="$REPOS_DIR/$repo_name"
    
    # Ensure it's a directory and contains a .venv
    if [[ -d "$repo" && -d "$repo/.venv" ]]; then
        echo "Processing $repo_name"
        
        cd "$repo" || { echo "Failed to enter directory $repo"; continue; }
        
        # Activate old venv and save dependencies if requirements.txt doesn't exist
        if [[ ! -f requirements.txt ]]; then
            if [[ -f .venv/Scripts/activate ]]; then
                source .venv/Scripts/activate
                pip freeze > requirements.txt
                deactivate
                echo "Created requirements.txt"
            else
                echo "Activation script missing for $repo_name, logging and skipping."
                echo "[ERROR] $repo_name: Missing activation script in old venv." >> "$LOG_FILE"
                continue
            fi
        else
            echo "requirements.txt already exists"
        fi
        
        # Delete old virtual environment
        rm -rf .venv
        echo ".venv deleted"
        
        # Create new virtual environment with Python 3.13
        "$PYTHON_PATH" -m venv .venv || { echo "Failed to create venv for $repo_name, logging and skipping."; echo "[ERROR] $repo_name: Failed to create venv." >> "$LOG_FILE"; continue; }
        source .venv/Scripts/activate
        
        # Install each dependency individually and log errors clearly
        echo "Installing dependencies for $repo_name"
        while IFS= read -r package; do
            if [[ -n "$package" ]]; then
                pip install --upgrade "$package" 2>> "$LOG_FILE" || echo "[ERROR] $repo_name: failed to install: $package" >> "$LOG_FILE"
            fi
        done < requirements.txt
        
        deactivate
        echo "Finished $repo_name"
        echo "-------------------------------"
    fi
    
done

echo "All listed repositories processed! Check $LOG_FILE for any errors."
