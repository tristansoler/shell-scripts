#!/bin/bash

# Path to the output file
OUTPUT_FILE="$HOME/Documents/docs_man/dataplatform_framework/20250428_dataframework_doc_ultra.md"

# Start fresh (overwrite) the file with your title
echo "# DataplatFormFramework" > "$OUTPUT_FILE"

# Go into your repo
cd "/c/Users/n740789/Documents/aih-dataplatform-python-data_framework" || exit

# Find all Python files, sorted alphabetically
find . -type f -name "*.py" | sort | while read -r file; do
    echo -e "\n\n---\n## File: $file\n\`\`\`python" >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
    echo -e "\n\`\`\`" >> "$OUTPUT_FILE"
done

echo "Markdown file generated at $OUTPUT_FILE"
echo "Cleaning up empty __init__.py files..."

# Delete blocks exactly matching that structure to get rid of empty __init__.py files
sed -i '/\/__init__\.py/,/---/d' "$OUTPUT_FILE"