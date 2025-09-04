#!/bin/bash

# Widget Dependency Analysis Script
# Analyzes widget inter-dependencies and import relationships

PROJECT_ROOT="/Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1"
WIDGETS_DIR="$PROJECT_ROOT/lib/presentation/widgets"
OUTPUT_FILE="$PROJECT_ROOT/widget_dependency_analysis.md"

echo "# Widget Dependency Analysis" > "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Function to find widgets that import other widgets
analyze_widget_dependencies() {
    local widget_file=$1
    local widget_name=$(basename "$widget_file" .dart)
    
    # Find all widget imports in this file
    local widget_imports=$(grep "import.*widgets/" "$widget_file" 2>/dev/null | grep -v "^//" | sed "s/.*widgets\///g" | sed "s/';.*//g")
    
    echo "$widget_name|$widget_imports"
}

# Analyze each widget's dependencies
echo "## Widget Import Dependencies" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "| Widget | Imports Other Widgets | Dependencies |" >> "$OUTPUT_FILE"
echo "|--------|----------------------|---------------|" >> "$OUTPUT_FILE"

for widget_file in $(find "$WIDGETS_DIR" -name "*.dart" -type f | sort); do
    result=$(analyze_widget_dependencies "$widget_file")
    IFS='|' read -r name imports <<< "$result"
    
    if [ ! -z "$imports" ]; then
        import_count=$(echo "$imports" | tr ' ' '\n' | wc -l | xargs)
        echo "| $name | Yes ($import_count) | $imports |" >> "$OUTPUT_FILE"
    else
        echo "| $name | No | - |" >> "$OUTPUT_FILE"
    fi
done

echo "" >> "$OUTPUT_FILE"

# Find widgets that are dependencies for multiple other widgets
echo "## High-Impact Widget Dependencies" >> "$OUTPUT_FILE"
echo "(Widgets that other widgets depend on)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Create temporary file to track which widgets are imported by others
temp_file=$(mktemp)

for widget_file in $(find "$WIDGETS_DIR" -name "*.dart" -type f); do
    widget_name=$(basename "$widget_file" .dart)
    
    # Count how many other widgets import this widget
    import_count=$(grep -r "import.*$widget_name.dart" "$WIDGETS_DIR" --include="*.dart" 2>/dev/null | grep -v "^$widget_file:" | wc -l)
    
    if [ $import_count -gt 0 ]; then
        # Find which widgets import this
        importing_widgets=$(grep -r "import.*$widget_name.dart" "$WIDGETS_DIR" --include="*.dart" 2>/dev/null | grep -v "^$widget_file:" | cut -d: -f1 | xargs -I {} basename {} .dart | sort -u | tr '\n' ', ' | sed 's/,$//')
        echo "$import_count|$widget_name|$importing_widgets" >> "$temp_file"
    fi
done

if [ -s "$temp_file" ]; then
    echo "| Widget | Imported By Count | Imported By |" >> "$OUTPUT_FILE"
    echo "|--------|------------------|-------------|" >> "$OUTPUT_FILE"
    sort -t'|' -k1 -rn "$temp_file" | while IFS='|' read -r count name importers; do
        echo "| $name | $count | $importers |" >> "$OUTPUT_FILE"
    done
else
    echo "No inter-widget dependencies found." >> "$OUTPUT_FILE"
fi

rm "$temp_file"

echo "" >> "$OUTPUT_FILE"

# Analyze circular dependencies
echo "## Potential Circular Dependencies" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

found_circular=false
for widget_file_a in $(find "$WIDGETS_DIR" -name "*.dart" -type f); do
    widget_a=$(basename "$widget_file_a" .dart)
    
    # Check if this widget imports any other widgets
    imports_of_a=$(grep "import.*widgets/" "$widget_file_a" 2>/dev/null | grep -v "^//" | sed "s/.*widgets\///g" | sed "s/\.dart.*//g")
    
    for import_b in $imports_of_a; do
        # Find the file for widget B
        widget_file_b=$(find "$WIDGETS_DIR" -name "$import_b.dart" -type f 2>/dev/null | head -1)
        
        if [ ! -z "$widget_file_b" ]; then
            # Check if widget B imports widget A
            if grep -q "import.*$widget_a.dart" "$widget_file_b" 2>/dev/null; then
                echo "- **Circular**: $widget_a ↔ $import_b" >> "$OUTPUT_FILE"
                found_circular=true
            fi
        fi
    done
done

if [ "$found_circular" = false ]; then
    echo "No circular dependencies detected." >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"
echo "## Dependency Depth Analysis" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Categorize widgets by dependency depth
echo "### Leaf Widgets (No dependencies on other widgets)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
for widget_file in $(find "$WIDGETS_DIR" -name "*.dart" -type f | sort); do
    widget_name=$(basename "$widget_file" .dart)
    has_widget_imports=$(grep "import.*widgets/" "$widget_file" 2>/dev/null | grep -v "^//" | wc -l)
    
    if [ $has_widget_imports -eq 0 ]; then
        echo "- $widget_name" >> "$OUTPUT_FILE"
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "### Hub Widgets (Both import and are imported)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
for widget_file in $(find "$WIDGETS_DIR" -name "*.dart" -type f | sort); do
    widget_name=$(basename "$widget_file" .dart)
    
    # Check if it imports other widgets
    has_widget_imports=$(grep "import.*widgets/" "$widget_file" 2>/dev/null | grep -v "^//" | wc -l)
    
    # Check if it's imported by other widgets
    is_imported=$(grep -r "import.*$widget_name.dart" "$WIDGETS_DIR" --include="*.dart" 2>/dev/null | grep -v "^$widget_file:" | wc -l)
    
    if [ $has_widget_imports -gt 0 ] && [ $is_imported -gt 0 ]; then
        echo "- $widget_name (imports: $has_widget_imports, imported by: $is_imported)" >> "$OUTPUT_FILE"
    fi
done

echo "" >> "$OUTPUT_FILE"
echo "Analysis complete! Report saved to: $OUTPUT_FILE"