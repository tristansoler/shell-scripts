#!/bin/bash

# Navigate to the parent repository
cd /c/Users/n740789/Documents/df-repos || { echo "Directory not found!"; exit 1; }

# Step 1: Remove incorrectly added nested repositories from git index
echo "Starting removal of incorrectly added nested repositories..."
git rm --cached brs_crossreference
git rm --cached data_framework
git rm --cached dataflow-esg_clarity
git rm --cached dataflow-esg_sribusinessdata

git commit -m "Remove incorrectly added nested repositories"
echo "Completed removal and commit."

# Step 2: Verify and store remote configuration for each submodule
declare -A repo_urls

for repo in brs_crossreference data_framework dataflow-esg_clarity dataflow-esg_sribusinessdata
do
    echo "Checking remote for repository: $repo"
    cd "$repo" || { echo "Failed to enter directory $repo"; exit 1; }
    
    remote_url=$(git remote get-url origin 2>/dev/null)
    
    if [ -z "$remote_url" ]; then
        echo "ERROR: Remote 'origin' not set for $repo. Exiting."
        exit 1
    else
        echo "Found remote URL for $repo: $remote_url"
        repo_urls[$repo]=$remote_url
    fi
    
    cd ..
done
echo "All repository URLs successfully verified and stored."

# Step 3: Add repositories as git submodules using stored URLs
echo "Starting to add repositories as submodules..."
for repo in "${!repo_urls[@]}"
do
    echo "Adding submodule for repository: $repo"
    git submodule add "${repo_urls[$repo]}" "$repo"
done
echo "All repositories added as submodules."

git commit -m "Properly added repositories as git submodules"
git push origin main
echo "Submodules committed and pushed successfully."