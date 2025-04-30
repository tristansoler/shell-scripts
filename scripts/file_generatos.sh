#!/bin/bash

# Target directory
target_dir="/c/Users/n740789/Documents/aih-dataplatform-python-dataflow-esg_sribusinessdata/data-quality"

# Ensure the directory exists
mkdir -p "$target_dir"

# List of database names
databases=(
    "funds_raw"
    "funds_staging"
    "funds_common"
    "funds_business"
)

# List of table names
tables=(
    "esg_map_str_ptf_bmk"
)

# Generate files
for db in "${databases[@]}"; do
    for tbl in "${tables[@]}"; do
        file_path="${target_dir}/${db}.${tbl}.gdq"
        touch "$file_path"
    done
done

echo "All files generated in $target_dir"
