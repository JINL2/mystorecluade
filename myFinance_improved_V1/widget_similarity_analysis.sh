#!/bin/bash

# Widget Similarity and Consolidation Analysis Script
# Analyzes widgets for functional similarities and consolidation opportunities

PROJECT_ROOT="/Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1"
WIDGETS_DIR="$PROJECT_ROOT/lib/presentation/widgets"
OUTPUT_FILE="$PROJECT_ROOT/WIDGET_CONSOLIDATION_ANALYSIS.md"

echo "# Widget Consolidation & Removal Analysis" > "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Function to extract widget properties
analyze_widget_properties() {
    local widget_file=$1
    local widget_name=$(basename "$widget_file" .dart)
    
    # Count common widget patterns
    has_onPressed=$(grep -c "onPressed" "$widget_file" 2>/dev/null || echo 0)
    has_controller=$(grep -c "controller" "$widget_file" 2>/dev/null || echo 0)
    has_isLoading=$(grep -c "isLoading" "$widget_file" 2>/dev/null || echo 0)
    has_validator=$(grep -c "validator" "$widget_file" 2>/dev/null || echo 0)
    has_hintText=$(grep -c "hintText" "$widget_file" 2>/dev/null || echo 0)
    has_icon=$(grep -c "icon" "$widget_file" 2>/dev/null || echo 0)
    has_text=$(grep -c "final String.*text" "$widget_file" 2>/dev/null || echo 0)
    has_label=$(grep -c "final String.*label" "$widget_file" 2>/dev/null || echo 0)
    
    # Determine widget type based on patterns
    widget_type="unknown"
    if [ $has_onPressed -gt 0 ] && [ $has_text -gt 0 ]; then
        widget_type="button"
    elif [ $has_controller -gt 0 ] || [ $has_validator -gt 0 ] || [ $has_hintText -gt 0 ]; then
        widget_type="input"
    elif [ $has_isLoading -gt 0 ]; then
        widget_type="loading"
    elif grep -q "showModalBottomSheet\|BottomSheet" "$widget_file" 2>/dev/null; then
        widget_type="bottomsheet"
    elif grep -q "selector\|Selector" "$widget_file" 2>/dev/null; then
        widget_type="selector"
    elif grep -q "card\|Card" "$widget_file" 2>/dev/null; then
        widget_type="card"
    elif grep -q "empty\|Empty" "$widget_file" 2>/dev/null; then
        widget_type="empty_state"
    elif grep -q "error\|Error" "$widget_file" 2>/dev/null; then
        widget_type="error"
    elif grep -q "dialog\|Dialog" "$widget_file" 2>/dev/null; then
        widget_type="dialog"
    elif grep -q "badge\|Badge" "$widget_file" 2>/dev/null; then
        widget_type="badge"
    elif grep -q "notification\|Notification" "$widget_file" 2>/dev/null; then
        widget_type="notification"
    fi
    
    echo "$widget_name|$widget_type"
}

# Analyze all widgets and group by type
echo "## Widget Functionality Groups" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Create temporary file for grouping
temp_file=$(mktemp)

for widget_file in $(find "$WIDGETS_DIR" -name "*.dart" -type f); do
    result=$(analyze_widget_properties "$widget_file")
    echo "$result" >> "$temp_file"
done

# Group widgets by type
for widget_type in button input loading bottomsheet selector card empty_state error dialog badge notification unknown; do
    widgets_of_type=$(grep "|$widget_type$" "$temp_file" | cut -d'|' -f1 | sort)
    widget_count=$(echo "$widgets_of_type" | grep -v "^$" | wc -l)
    
    if [ $widget_count -gt 0 ]; then
        echo "### ${widget_type^} Widgets ($widget_count)" >> "$OUTPUT_FILE"
        echo "$widgets_of_type" | while read widget; do
            if [ ! -z "$widget" ]; then
                # Get usage count from previous analysis
                usage_count=$(grep "^| $widget " "$PROJECT_ROOT/widget_usage_report.md" 2>/dev/null | awk -F'|' '{print $5}' | xargs)
                if [ -z "$usage_count" ]; then
                    usage_count="0"
                fi
                echo "- $widget (Usage: $usage_count)" >> "$OUTPUT_FILE"
            fi
        done
        echo "" >> "$OUTPUT_FILE"
    fi
done

rm "$temp_file"

# Analyze specific consolidation opportunities
echo "## Consolidation Opportunities" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### 1. Button Consolidation" >> "$OUTPUT_FILE"
echo "**Similar Widgets:**" >> "$OUTPUT_FILE"
echo "- TossPrimaryButton (68 uses)" >> "$OUTPUT_FILE"
echo "- TossSecondaryButton (29 uses)" >> "$OUTPUT_FILE"
echo "- TossIconButton (2 uses)" >> "$OUTPUT_FILE"
echo "- TossToggleButton (3 uses)" >> "$OUTPUT_FILE"
echo "- TossFloatingActionButton (0 uses) - REMOVE" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Analysis:** All button widgets share similar APIs (text, onPressed, isLoading, isEnabled)" >> "$OUTPUT_FILE"
echo "**Recommendation:** Create unified TossButton with variant prop" >> "$OUTPUT_FILE"
echo "**Impact:** 102 total uses to migrate" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### 2. Text Input Consolidation" >> "$OUTPUT_FILE"
echo "**Similar Widgets:**" >> "$OUTPUT_FILE"
echo "- TossTextField (66 uses)" >> "$OUTPUT_FILE"
echo "- TossEnhancedTextField (11 uses) - adds keyboard toolbar" >> "$OUTPUT_FILE"
echo "- TossSearchField (17 uses) - adds debouncing & clear button" >> "$OUTPUT_FILE"
echo "- TossNumberInput (1 use) - number-specific input" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Analysis:** All are text inputs with overlapping features" >> "$OUTPUT_FILE"
echo "**Recommendation:** Merge into TossTextField with type parameter" >> "$OUTPUT_FILE"
echo "**Impact:** 95 total uses to migrate" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### 3. Bottom Sheet Duplication" >> "$OUTPUT_FILE"
echo "**Duplicate Implementations:**" >> "$OUTPUT_FILE"
echo "- common/toss_bottom_sheet.dart (25 uses) - static helper" >> "$OUTPUT_FILE"
echo "- toss/toss_bottom_sheet.dart (27 uses) - widget" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Analysis:** One is helper class, one is widget - can be combined" >> "$OUTPUT_FILE"
echo "**Recommendation:** Single file with both static methods and widget class" >> "$OUTPUT_FILE"
echo "**Impact:** 52 total uses to update imports" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### 4. Empty/Error State Consolidation" >> "$OUTPUT_FILE"
echo "**Similar Widgets:**" >> "$OUTPUT_FILE"
echo "- TossEmptyView (13 uses)" >> "$OUTPUT_FILE"
echo "- TossEmptyStateCard (7 uses)" >> "$OUTPUT_FILE"
echo "- TossErrorView (5 uses)" >> "$OUTPUT_FILE"
echo "- TossErrorDialog (7 uses)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Analysis:** All show state messages with icons" >> "$OUTPUT_FILE"
echo "**Recommendation:** Create TossStateView with type parameter" >> "$OUTPUT_FILE"
echo "**Impact:** 32 total uses to migrate" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### 5. Selector Widget Standardization" >> "$OUTPUT_FILE"
echo "**Similar Widgets:**" >> "$OUTPUT_FILE"
echo "- AutonomousAccountSelector (0 uses) - REMOVE" >> "$OUTPUT_FILE"
echo "- AutonomousCashLocationSelector (11 uses)" >> "$OUTPUT_FILE"
echo "- AutonomousCounterpartySelector (7 uses)" >> "$OUTPUT_FILE"
echo "- EnhancedAccountSelector (4 uses)" >> "$OUTPUT_FILE"
echo "- EnhancedMultiAccountSelector (1 use)" >> "$OUTPUT_FILE"
echo "- TossBaseSelector (10 uses)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Analysis:** All follow similar selector patterns" >> "$OUTPUT_FILE"
echo "**Recommendation:** Create generic TossSelector<T> with type configuration" >> "$OUTPUT_FILE"
echo "**Impact:** 33 total uses to migrate" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Never used widgets
echo "## Never Used Widgets (0 Uses) - SAFE TO REMOVE" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "| Widget | Category | Action |" >> "$OUTPUT_FILE"
echo "|--------|----------|--------|" >> "$OUTPUT_FILE"
echo "| AppIcon | common | DELETE |" >> "$OUTPUT_FILE"
echo "| CompanyStoreBottomDrawer | common | DELETE |" >> "$OUTPUT_FILE"
echo "| TossBottomDrawer | common | DELETE |" >> "$OUTPUT_FILE"
echo "| TossFloatingActionButton | common | DELETE |" >> "$OUTPUT_FILE"
echo "| TossLocationBar | common | DELETE |" >> "$OUTPUT_FILE"
echo "| TossNotificationIcon | common | DELETE |" >> "$OUTPUT_FILE"
echo "| TossProfileAvatar | common | DELETE |" >> "$OUTPUT_FILE"
echo "| TossSortDropdown | common | DELETE |" >> "$OUTPUT_FILE"
echo "| TossTypeSelector | common | DELETE |" >> "$OUTPUT_FILE"
echo "| MyFinanceAuthHeader | auth | DELETE |" >> "$OUTPUT_FILE"
echo "| AutonomousAccountSelector | selectors | DELETE |" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Low use widgets that can be replaced
echo "## Low Use Widgets (1-4 Uses) - REPLACEMENT CANDIDATES" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "| Widget | Uses | Replace With | Reason |" >> "$OUTPUT_FILE"
echo "|--------|------|--------------|--------|" >> "$OUTPUT_FILE"
echo "| TossNumberInput | 1 | TossTextField | Merge as input type |" >> "$OUTPUT_FILE"
echo "| TossCurrencyChip | 1 | TossChip | Same functionality |" >> "$OUTPUT_FILE"
echo "| TossCheckbox | 1 | Flutter Checkbox | Low customization |" >> "$OUTPUT_FILE"
echo "| TossSimpleWheelDatePicker | 1 | Platform picker | Low usage |" >> "$OUTPUT_FILE"
echo "| SmartToastNotification | 1 | SnackBar | Standard pattern |" >> "$OUTPUT_FILE"
echo "| EnhancedMultiAccountSelector | 1 | TossSelector | Standardize |" >> "$OUTPUT_FILE"
echo "| TossToggleButton | 3 | TossButton | Merge as variant |" >> "$OUTPUT_FILE"
echo "| TossIconButton | 2 | TossButton | Merge as variant |" >> "$OUTPUT_FILE"
echo "| TossModal | 2 | Dialog | Standard widget |" >> "$OUTPUT_FILE"
echo "| TossEnhancedModal | 2 | Dialog | Standard widget |" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Summary and action plan
echo "## Summary Statistics" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "- **Total Widgets:** 57" >> "$OUTPUT_FILE"
echo "- **Removable (0 uses):** 11 widgets" >> "$OUTPUT_FILE"
echo "- **Replaceable (1-4 uses):** 10 widgets" >> "$OUTPUT_FILE"
echo "- **Consolidatable Groups:** 5 major groups" >> "$OUTPUT_FILE"
echo "- **Potential Reduction:** 57 → ~25-30 widgets (50% reduction)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "## Prioritized Action Plan" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "### Phase 1: Quick Wins (1 day)" >> "$OUTPUT_FILE"
echo "1. **Delete 11 unused widgets** - Zero risk" >> "$OUTPUT_FILE"
echo "2. **Fix TossBottomSheet duplication** - High impact (52 uses)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Phase 2: Low-Risk Replacements (2-3 days)" >> "$OUTPUT_FILE"
echo "1. Replace TossNumberInput → TossTextField (1 use)" >> "$OUTPUT_FILE"
echo "2. Replace TossCurrencyChip → TossChip (1 use)" >> "$OUTPUT_FILE"
echo "3. Replace TossCheckbox → Flutter Checkbox (1 use)" >> "$OUTPUT_FILE"
echo "4. Replace SmartToastNotification → SnackBar (1 use)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Phase 3: Button System Unification (3-4 days)" >> "$OUTPUT_FILE"
echo "1. Create unified TossButton component" >> "$OUTPUT_FILE"
echo "2. Migrate TossPrimaryButton (68 uses)" >> "$OUTPUT_FILE"
echo "3. Migrate TossSecondaryButton (29 uses)" >> "$OUTPUT_FILE"
echo "4. Migrate TossIconButton (2 uses)" >> "$OUTPUT_FILE"
echo "5. Migrate TossToggleButton (3 uses)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Phase 4: Text Field Unification (3-4 days)" >> "$OUTPUT_FILE"
echo "1. Enhance TossTextField with all features" >> "$OUTPUT_FILE"
echo "2. Migrate TossEnhancedTextField (11 uses)" >> "$OUTPUT_FILE"
echo "3. Migrate TossSearchField (17 uses)" >> "$OUTPUT_FILE"
echo "4. Migrate TossNumberInput (1 use)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Phase 5: State View Consolidation (2-3 days)" >> "$OUTPUT_FILE"
echo "1. Create unified TossStateView" >> "$OUTPUT_FILE"
echo "2. Migrate empty/error views (32 uses)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Phase 6: Selector Standardization (4-5 days)" >> "$OUTPUT_FILE"
echo "1. Create generic TossSelector<T>" >> "$OUTPUT_FILE"
echo "2. Migrate all selector variants (33 uses)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "Analysis complete! Report saved to: $OUTPUT_FILE"