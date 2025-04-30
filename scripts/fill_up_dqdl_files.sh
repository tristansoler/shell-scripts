#!/bin/bash

# Hardcoded file name ending (no extension)
file_name_ending="esg_map_brs_crossreference"

# Hardcoded multi-line input string
input_text="# Check primary key
IsPrimaryKey \"issuer_id\"
# Check completeness
IsComplete \"issuer_id\"
# Check uniqueness
IsUnique \"issuer_id\" \"permid\""

# Target directory
target_dir="/c/Users/n740789/Documents/aih-dataplatform-python-dataflow-esg_sribusinessdata/data-quality"

# Loop through the matching files and write the input string to each
for file in "$target_dir"/*."$file_name_ending".gdq; do
    if [ -f "$file" ]; then
        echo "Writing to $file"
        printf "%s\n" "$input_text" > "$file"
    fi
done
