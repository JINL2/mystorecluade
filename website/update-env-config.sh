#!/bin/bash

# Update all HTML files to include environment configuration scripts
# This script adds env-loader.js and env-config.js after Supabase CDN in all HTML files

echo "Adding environment configuration to all HTML files..."

# Find all HTML files in the website directory
find /Applications/XAMPP/xamppfiles/htdocs/mcparrange-main/myFinance_claude/website -name "*.html" -type f | while read -r file; do
    # Check if the file already has env-config.js
    if grep -q "env-config.js" "$file"; then
        echo "✓ Already updated: $file"
    else
        # Check if the file has Supabase CDN
        if grep -q "@supabase/supabase-js@2" "$file"; then
            echo "Updating: $file"
            
            # Calculate the relative path based on file location
            depth=$(echo "$file" | awk -F'/website/' '{print $2}' | tr -cd '/' | wc -c)
            relative_path=""
            for ((i=0; i<depth; i++)); do
                relative_path="../$relative_path"
            done
            
            # Add environment configuration after Supabase CDN
            sed -i.bak '/@supabase\/supabase-js@2/a\
    \
    <!-- Environment Configuration (for local development) -->\
    <script src="'${relative_path}'core/config/env-loader.js"></script>\
    <script src="'${relative_path}'core/config/env-config.js"></script>' "$file"
            
            # Remove backup file
            rm "${file}.bak"
            echo "✓ Updated: $file"
        else
            echo "⚠ No Supabase CDN found in: $file"
        fi
    fi
done

echo "Done! All HTML files have been updated."
