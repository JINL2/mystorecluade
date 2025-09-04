#!/bin/bash

# Widget Usage Analysis Script
# This script analyzes the usage of widgets across the Flutter project

PROJECT_ROOT="/Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1"
WIDGETS_DIR="$PROJECT_ROOT/lib/presentation/widgets"
OUTPUT_FILE="$PROJECT_ROOT/widget_usage_report.md"

echo "# Widget Usage Analysis Report" > "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Function to count widget usage
count_widget_usage() {
    local widget_file=$1
    local widget_name=$(basename "$widget_file" .dart)
    local widget_class=""
    
    # Extract the main class name from the file
    if [ -f "$widget_file" ]; then
        # Try to find class definitions
        widget_class=$(grep -E "^class [A-Z][a-zA-Z0-9_]+" "$widget_file" | head -1 | sed 's/class \([A-Za-z0-9_]*\).*/\1/')
    fi
    
    # Count imports
    import_count=$(grep -r "import.*$(basename "$widget_file")" "$PROJECT_ROOT/lib" --include="*.dart" 2>/dev/null | wc -l)
    
    # Count class usage if we found a class name
    usage_count=0
    if [ ! -z "$widget_class" ]; then
        usage_count=$(grep -r "$widget_class[^a-zA-Z0-9_]" "$PROJECT_ROOT/lib" --include="*.dart" 2>/dev/null | grep -v "^$widget_file:" | wc -l)
    fi
    
    # Find files that use this widget
    using_files=""
    if [ ! -z "$widget_class" ]; then
        using_files=$(grep -l "$widget_class[^a-zA-Z0-9_]" "$PROJECT_ROOT/lib"/**/*.dart 2>/dev/null | grep -v "$widget_file" | sed "s|$PROJECT_ROOT/lib/||g")
    fi
    
    echo "$widget_name|$widget_class|$import_count|$usage_count|$using_files"
}

# Create sections for each widget category
echo "## Widget Categories" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Process each category
for category_dir in "$WIDGETS_DIR"/*; do
    if [ -d "$category_dir" ]; then
        category_name=$(basename "$category_dir")
        echo "### $category_name" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        echo "| Widget File | Class Name | Import Count | Usage Count | Used In |" >> "$OUTPUT_FILE"
        echo "|-------------|------------|--------------|-------------|---------|" >> "$OUTPUT_FILE"
        
        # Process each widget in the category
        for widget_file in "$category_dir"/*.dart; do
            if [ -f "$widget_file" ]; then
                result=$(count_widget_usage "$widget_file")
                IFS='|' read -r name class imports usage files <<< "$result"
                
                # Truncate file list if too long
                if [ ${#files} -gt 50 ]; then
                    file_count=$(echo "$files" | tr ' ' '\n' | wc -l)
                    files="Multiple files ($file_count total)"
                fi
                
                echo "| $name | $class | $imports | $usage | $files |" >> "$OUTPUT_FILE"
            fi
        done
        echo "" >> "$OUTPUT_FILE"
    fi
done

# Summary statistics
echo "## Summary Statistics" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Count total widgets
total_widgets=$(find "$WIDGETS_DIR" -name "*.dart" -type f | wc -l)
echo "- Total widgets: $total_widgets" >> "$OUTPUT_FILE"

# Find unused widgets
echo "" >> "$OUTPUT_FILE"
echo "## Potentially Unused Widgets" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

for widget_file in $(find "$WIDGETS_DIR" -name "*.dart" -type f); do
    widget_name=$(basename "$widget_file" .dart)
    import_count=$(grep -r "import.*$widget_name.dart" "$PROJECT_ROOT/lib" --include="*.dart" 2>/dev/null | wc -l)
    
    if [ $import_count -eq 0 ]; then
        echo "- $widget_name ($(echo "$widget_file" | sed "s|$PROJECT_ROOT/||"))" >> "$OUTPUT_FILE"
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "Analysis complete! Report saved to: $OUTPUT_FILE"