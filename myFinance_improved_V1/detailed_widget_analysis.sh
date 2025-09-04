#!/bin/bash

# Detailed Widget Usage Analysis Script
# This script provides comprehensive widget usage mapping

PROJECT_ROOT="/Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1"
WIDGETS_DIR="$PROJECT_ROOT/lib/presentation/widgets"
PAGES_DIR="$PROJECT_ROOT/lib/presentation/pages"
OUTPUT_FILE="$PROJECT_ROOT/detailed_widget_analysis.md"

echo "# Detailed Widget Usage Analysis" > "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Function to extract class names from widget files
get_widget_classes() {
    local widget_file=$1
    grep -E "^class [A-Z][a-zA-Z0-9_]+" "$widget_file" 2>/dev/null | sed 's/class \([A-Za-z0-9_]*\).*/\1/'
}

# Function to find pages using a specific widget
find_pages_using_widget() {
    local widget_class=$1
    local pages=""
    
    if [ ! -z "$widget_class" ]; then
        # Search in pages directory for widget usage
        pages=$(grep -r "$widget_class[^a-zA-Z0-9_]" "$PAGES_DIR" --include="*.dart" 2>/dev/null | cut -d: -f1 | sort -u | sed "s|$PROJECT_ROOT/lib/presentation/pages/||g")
    fi
    
    echo "$pages"
}

# Analyze widget usage frequency
echo "## Widget Usage Frequency Analysis" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Create a temporary file to store widget usage data
temp_file=$(mktemp)

# Process each widget and count its usage
for widget_file in $(find "$WIDGETS_DIR" -name "*.dart" -type f); do
    widget_name=$(basename "$widget_file" .dart)
    widget_path=$(echo "$widget_file" | sed "s|$PROJECT_ROOT/||")
    widget_classes=$(get_widget_classes "$widget_file")
    
    total_usage=0
    for class_name in $widget_classes; do
        if [ ! -z "$class_name" ]; then
            usage_count=$(grep -r "$class_name[^a-zA-Z0-9_]" "$PROJECT_ROOT/lib" --include="*.dart" 2>/dev/null | grep -v "^$widget_file:" | wc -l)
            total_usage=$((total_usage + usage_count))
        fi
    done
    
    echo "$total_usage|$widget_name|$widget_path|$widget_classes" >> "$temp_file"
done

# Sort by usage count and create frequency categories
echo "### High Usage Widgets (>20 uses)" >> "$OUTPUT_FILE"
echo "| Widget | Usage Count | Classes | Path |" >> "$OUTPUT_FILE"
echo "|--------|-------------|---------|------|" >> "$OUTPUT_FILE"
sort -t'|' -k1 -rn "$temp_file" | while IFS='|' read -r count name path classes; do
    if [ $count -gt 20 ]; then
        echo "| $name | $count | $classes | $path |" >> "$OUTPUT_FILE"
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "### Medium Usage Widgets (5-20 uses)" >> "$OUTPUT_FILE"
echo "| Widget | Usage Count | Classes | Path |" >> "$OUTPUT_FILE"
echo "|--------|-------------|---------|------|" >> "$OUTPUT_FILE"
sort -t'|' -k1 -rn "$temp_file" | while IFS='|' read -r count name path classes; do
    if [ $count -ge 5 ] && [ $count -le 20 ]; then
        echo "| $name | $count | $classes | $path |" >> "$OUTPUT_FILE"
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "### Low Usage Widgets (1-4 uses)" >> "$OUTPUT_FILE"
echo "| Widget | Usage Count | Classes | Path |" >> "$OUTPUT_FILE"
echo "|--------|-------------|---------|------|" >> "$OUTPUT_FILE"
sort -t'|' -k1 -rn "$temp_file" | while IFS='|' read -r count name path classes; do
    if [ $count -ge 1 ] && [ $count -lt 5 ]; then
        echo "| $name | $count | $classes | $path |" >> "$OUTPUT_FILE"
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "### Unused Widgets (0 uses)" >> "$OUTPUT_FILE"
echo "| Widget | Classes | Path |" >> "$OUTPUT_FILE"
echo "|--------|---------|------|" >> "$OUTPUT_FILE"
sort -t'|' -k1 -rn "$temp_file" | while IFS='|' read -r count name path classes; do
    if [ $count -eq 0 ]; then
        echo "| $name | $classes | $path |" >> "$OUTPUT_FILE"
    fi
done

# Clean up temp file
rm "$temp_file"

# Map widgets to pages
echo "" >> "$OUTPUT_FILE"
echo "## Widget to Page Mapping" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Find all pages
echo "### Pages Found in Project" >> "$OUTPUT_FILE"
find "$PAGES_DIR" -type d -maxdepth 1 | while read page_dir; do
    if [ "$page_dir" != "$PAGES_DIR" ]; then
        page_name=$(basename "$page_dir")
        echo "- $page_name" >> "$OUTPUT_FILE"
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "### High-Impact Widgets (Used in Multiple Pages)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Analyze which widgets are used in multiple pages
for widget_file in $(find "$WIDGETS_DIR" -name "*.dart" -type f); do
    widget_classes=$(get_widget_classes "$widget_file")
    widget_name=$(basename "$widget_file" .dart)
    
    all_pages=""
    for class_name in $widget_classes; do
        if [ ! -z "$class_name" ]; then
            pages=$(find_pages_using_widget "$class_name")
            if [ ! -z "$pages" ]; then
                all_pages="$all_pages$pages\n"
            fi
        fi
    done
    
    if [ ! -z "$all_pages" ]; then
        unique_pages=$(echo -e "$all_pages" | sort -u | grep -v "^$")
        page_count=$(echo "$unique_pages" | wc -l)
        
        if [ $page_count -ge 3 ]; then
            echo "#### $widget_name (Used in $page_count pages)" >> "$OUTPUT_FILE"
            echo "$unique_pages" | while read page; do
                echo "- $page" >> "$OUTPUT_FILE"
            done
            echo "" >> "$OUTPUT_FILE"
        fi
    fi
done

# Find similar widgets that could be consolidated
echo "## Consolidation Opportunities" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Duplicate TossBottomSheet widgets" >> "$OUTPUT_FILE"
echo "- common/toss_bottom_sheet.dart" >> "$OUTPUT_FILE"
echo "- toss/toss_bottom_sheet.dart" >> "$OUTPUT_FILE"
echo "**Recommendation**: Consolidate into single implementation" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Button Widgets" >> "$OUTPUT_FILE"
echo "- toss_primary_button.dart (68 uses)" >> "$OUTPUT_FILE"
echo "- toss_secondary_button.dart (29 uses)" >> "$OUTPUT_FILE"
echo "- toss_icon_button.dart (2 uses)" >> "$OUTPUT_FILE"
echo "- toss_toggle_button.dart (0 uses)" >> "$OUTPUT_FILE"
echo "- toss_floating_action_button.dart (0 uses)" >> "$OUTPUT_FILE"
echo "**Recommendation**: Create unified button system with variants" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Text Input Widgets" >> "$OUTPUT_FILE"
echo "- toss_text_field.dart (66 uses)" >> "$OUTPUT_FILE"
echo "- toss_enhanced_text_field.dart (10 uses)" >> "$OUTPUT_FILE"
echo "- toss_search_field.dart (17 uses)" >> "$OUTPUT_FILE"
echo "- toss_number_input.dart (1 use)" >> "$OUTPUT_FILE"
echo "**Recommendation**: Merge into configurable text field component" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Selector Widgets" >> "$OUTPUT_FILE"
echo "Found multiple selector implementations in specific/selectors/" >> "$OUTPUT_FILE"
echo "**Recommendation**: Review selector pattern for consistency" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "Analysis complete! Report saved to: $OUTPUT_FILE"