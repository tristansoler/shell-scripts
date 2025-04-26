#!/bin/bash

# Path to the output file
OUTPUT_FILE="$HOME/Documents/docs_man/dataplatform_framework/dataplatform_framework_doc.md"

# Start fresh (overwrite) the file with your title
echo "# DataplatFormFramework" > "$OUTPUT_FILE"

# Go into your repo
cd /c/Users/n740789/Documents/aih-dataplatform-python-data_framework || exit

# Find all Python files, sorted alphabetically
find . -type f -name "*.py" | sort | while read -r file; do
    echo -e "\n\n---\n## File: $file\n" >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
done
