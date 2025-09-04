#!/bin/bash

# Deep Widget Implementation Analysis Script
# Analyzes actual widget usage patterns and replacement impact

PROJECT_ROOT="/Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1"
OUTPUT_FILE="$PROJECT_ROOT/WIDGET_IMPLEMENTATION_PLAN.md"

echo "# Widget Implementation & Migration Plan" > "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Function to analyze widget usage in detail
analyze_widget_usage() {
    local widget_name=$1
    local widget_file=$2
    
    echo "### $widget_name" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    # Find all files using this widget
    local usage_files=$(grep -l "$widget_name" "$PROJECT_ROOT/lib" -r --include="*.dart" 2>/dev/null | grep -v "$widget_file")
    local usage_count=$(echo "$usage_files" | grep -v "^$" | wc -l)
    
    echo "**Files using this widget: $usage_count**" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    if [ $usage_count -gt 0 ]; then
        echo "| File | Usage Context |" >> "$OUTPUT_FILE"
        echo "|------|---------------|" >> "$OUTPUT_FILE"
        
        for file in $usage_files; do
            if [ ! -z "$file" ]; then
                local page_name=$(echo "$file" | sed "s|$PROJECT_ROOT/lib/presentation/pages/||" | sed "s|/| > |g")
                local usage_line=$(grep -n "$widget_name" "$file" 2>/dev/null | head -1 | cut -d: -f1)
                echo "| $page_name | Line $usage_line |" >> "$OUTPUT_FILE"
            fi
        done
    fi
    echo "" >> "$OUTPUT_FILE"
}

# Analyze never-used widgets (0 uses)
echo "## 1. NEVER-USED WIDGETS (Safe to Delete)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "These widgets have 0 uses and can be deleted immediately:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "| Widget | File | Action | Risk |" >> "$OUTPUT_FILE"
echo "|--------|------|--------|------|" >> "$OUTPUT_FILE"
echo "| AppIcon | common/app_icon.dart | DELETE | None |" >> "$OUTPUT_FILE"
echo "| CompanyStoreBottomDrawer | common/company_store_bottom_drawer.dart | DELETE | None |" >> "$OUTPUT_FILE"
echo "| TossBottomDrawer | common/toss_bottom_drawer.dart | DELETE | None |" >> "$OUTPUT_FILE"
echo "| TossFloatingActionButton | common/toss_floating_action_button.dart | DELETE | None |" >> "$OUTPUT_FILE"
echo "| TossLocationBar | common/toss_location_bar.dart | DELETE | None |" >> "$OUTPUT_FILE"
echo "| TossNotificationIcon | common/toss_notification_icon.dart | DELETE | None |" >> "$OUTPUT_FILE"
echo "| TossProfileAvatar | common/toss_profile_avatar.dart | DELETE | None |" >> "$OUTPUT_FILE"
echo "| TossSortDropdown | common/toss_sort_dropdown.dart | DELETE | None |" >> "$OUTPUT_FILE"
echo "| TossTypeSelector | common/toss_type_selector.dart | DELETE | None |" >> "$OUTPUT_FILE"
echo "| MyFinanceAuthHeader | auth/myfinance_auth_header.dart | DELETE | None |" >> "$OUTPUT_FILE"
echo "| AutonomousAccountSelector | selectors/autonomous_account_selector.dart | DELETE | None |" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "**Deletion Command:**" >> "$OUTPUT_FILE"
echo '```bash' >> "$OUTPUT_FILE"
echo "cd $PROJECT_ROOT" >> "$OUTPUT_FILE"
echo "rm lib/presentation/widgets/common/{app_icon,company_store_bottom_drawer,toss_bottom_drawer,toss_floating_action_button,toss_location_bar,toss_notification_icon,toss_profile_avatar,toss_sort_dropdown,toss_type_selector}.dart" >> "$OUTPUT_FILE"
echo "rm lib/presentation/widgets/auth/myfinance_auth_header.dart" >> "$OUTPUT_FILE"
echo "rm lib/presentation/widgets/specific/selectors/autonomous_account_selector.dart" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Analyze low-use widgets with replacement details
echo "## 2. LOW-USE WIDGETS (1-4 uses) - Replacement Details" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# TossNumberInput -> TossTextField
echo "### TossNumberInput → TossTextField" >> "$OUTPUT_FILE"
echo "**Current Usage: 1 location**" >> "$OUTPUT_FILE"
echo "- store_shift/store_shift_page.dart" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Migration Example:**" >> "$OUTPUT_FILE"
echo '```dart' >> "$OUTPUT_FILE"
echo "// Before:" >> "$OUTPUT_FILE"
echo "TossNumberInput(" >> "$OUTPUT_FILE"
echo "  controller: controller," >> "$OUTPUT_FILE"
echo "  hintText: '0'," >> "$OUTPUT_FILE"
echo "  suffix: 'USD'," >> "$OUTPUT_FILE"
echo ")" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "// After:" >> "$OUTPUT_FILE"
echo "TossTextField(" >> "$OUTPUT_FILE"
echo "  controller: controller," >> "$OUTPUT_FILE"
echo "  hintText: '0'," >> "$OUTPUT_FILE"
echo "  keyboardType: TextInputType.number," >> "$OUTPUT_FILE"
echo "  suffixIcon: Text('USD')," >> "$OUTPUT_FILE"
echo ")" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# TossCurrencyChip -> TossChip
echo "### TossCurrencyChip → TossChip" >> "$OUTPUT_FILE"
echo "**Current Usage: 1 location**" >> "$OUTPUT_FILE"
echo "- cash_ending/cash_ending_page.dart" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Migration Example:**" >> "$OUTPUT_FILE"
echo '```dart' >> "$OUTPUT_FILE"
echo "// Before:" >> "$OUTPUT_FILE"
echo "TossCurrencyChip(" >> "$OUTPUT_FILE"
echo "  currencyId: currencyId," >> "$OUTPUT_FILE"
echo "  symbol: symbol," >> "$OUTPUT_FILE"
echo "  name: name," >> "$OUTPUT_FILE"
echo "  isSelected: isSelected," >> "$OUTPUT_FILE"
echo "  onTap: onTap," >> "$OUTPUT_FILE"
echo ")" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "// After:" >> "$OUTPUT_FILE"
echo "TossChip(" >> "$OUTPUT_FILE"
echo "  label: '\$symbol - \$name'," >> "$OUTPUT_FILE"
echo "  isSelected: isSelected," >> "$OUTPUT_FILE"
echo "  onTap: onTap," >> "$OUTPUT_FILE"
echo ")" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# TossCheckbox -> Checkbox
echo "### TossCheckbox → Flutter Checkbox" >> "$OUTPUT_FILE"
echo "**Current Usage: 1 location (self-referential)**" >> "$OUTPUT_FILE"
echo "- Only used in TossCheckboxListTile example code" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Action: DELETE** (no real usage)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# TossIconButton -> IconButton or TossButton
echo "### TossIconButton → IconButton" >> "$OUTPUT_FILE"
echo "**Current Usage: 2 locations**" >> "$OUTPUT_FILE"
echo "- transactions/widgets/transaction_detail_sheet.dart (2 uses)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Migration Example:**" >> "$OUTPUT_FILE"
echo '```dart' >> "$OUTPUT_FILE"
echo "// Before:" >> "$OUTPUT_FILE"
echo "TossIconButton(" >> "$OUTPUT_FILE"
echo "  icon: Icons.copy," >> "$OUTPUT_FILE"
echo "  iconSize: 20," >> "$OUTPUT_FILE"
echo "  tooltip: 'Copy'," >> "$OUTPUT_FILE"
echo "  onPressed: () {}," >> "$OUTPUT_FILE"
echo ")" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "// After:" >> "$OUTPUT_FILE"
echo "IconButton(" >> "$OUTPUT_FILE"
echo "  icon: Icon(Icons.copy, size: 20)," >> "$OUTPUT_FILE"
echo "  tooltip: 'Copy'," >> "$OUTPUT_FILE"
echo "  onPressed: () {}," >> "$OUTPUT_FILE"
echo ")" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# SmartToastNotification -> SnackBar
echo "### SmartToastNotification → SnackBar" >> "$OUTPUT_FILE"
echo "**Current Usage: 1 location**" >> "$OUTPUT_FILE"
echo "- core/notifications/services/notification_display_manager.dart" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Migration Example:**" >> "$OUTPUT_FILE"
echo '```dart' >> "$OUTPUT_FILE"
echo "// Before:" >> "$OUTPUT_FILE"
echo "SmartToastNotification.show(" >> "$OUTPUT_FILE"
echo "  context," >> "$OUTPUT_FILE"
echo "  title: 'Title'," >> "$OUTPUT_FILE"
echo "  body: 'Message'," >> "$OUTPUT_FILE"
echo ")" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "// After:" >> "$OUTPUT_FILE"
echo "ScaffoldMessenger.of(context).showSnackBar(" >> "$OUTPUT_FILE"
echo "  SnackBar(" >> "$OUTPUT_FILE"
echo "    content: Column(" >> "$OUTPUT_FILE"
echo "      children: [" >> "$OUTPUT_FILE"
echo "        Text('Title', style: TextStyle(fontWeight: FontWeight.bold))," >> "$OUTPUT_FILE"
echo "        Text('Message')," >> "$OUTPUT_FILE"
echo "      ]," >> "$OUTPUT_FILE"
echo "    )," >> "$OUTPUT_FILE"
echo "  )," >> "$OUTPUT_FILE"
echo ")" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Button consolidation analysis
echo "## 3. BUTTON CONSOLIDATION IMPACT" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "### TossPrimaryButton & TossSecondaryButton Analysis" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Count actual usage patterns
primary_count=$(grep -r "TossPrimaryButton(" "$PROJECT_ROOT/lib" --include="*.dart" 2>/dev/null | wc -l)
secondary_count=$(grep -r "TossSecondaryButton(" "$PROJECT_ROOT/lib" --include="*.dart" 2>/dev/null | wc -l)

echo "- **TossPrimaryButton**: $primary_count uses" >> "$OUTPUT_FILE"
echo "- **TossSecondaryButton**: $secondary_count uses" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "**Key Differences:**" >> "$OUTPUT_FILE"
echo "- Both have identical APIs (text, onPressed, isLoading, isEnabled, leadingIcon)" >> "$OUTPUT_FILE"
echo "- Only difference is styling (primary vs secondary)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "**Migration Strategy:**" >> "$OUTPUT_FILE"
echo '```dart' >> "$OUTPUT_FILE"
echo "// New unified TossButton" >> "$OUTPUT_FILE"
echo "class TossButton extends StatefulWidget {" >> "$OUTPUT_FILE"
echo "  final ButtonVariant variant; // primary, secondary, icon, text" >> "$OUTPUT_FILE"
echo "  final String? text;" >> "$OUTPUT_FILE"
echo "  final IconData? icon;" >> "$OUTPUT_FILE"
echo "  final VoidCallback? onPressed;" >> "$OUTPUT_FILE"
echo "  final bool isLoading;" >> "$OUTPUT_FILE"
echo "  // ... all existing props" >> "$OUTPUT_FILE"
echo "}" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "// Migration:" >> "$OUTPUT_FILE"
echo "TossPrimaryButton(text: 'Save', ...) → TossButton.primary(text: 'Save', ...)" >> "$OUTPUT_FILE"
echo "TossSecondaryButton(text: 'Cancel', ...) → TossButton.secondary(text: 'Cancel', ...)" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Bottom sheet duplication
echo "## 4. BOTTOM SHEET DUPLICATION FIX" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Two implementations:**" >> "$OUTPUT_FILE"
echo "1. common/toss_bottom_sheet.dart - Static helper class" >> "$OUTPUT_FILE"
echo "2. toss/toss_bottom_sheet.dart - Widget class" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Solution:** Merge into single file with both functionalities" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "**Migration:** Update imports only (no API changes)" >> "$OUTPUT_FILE"
echo '```bash' >> "$OUTPUT_FILE"
echo "# Find and replace imports" >> "$OUTPUT_FILE"
echo "find lib -name '*.dart' -exec sed -i 's|widgets/common/toss_bottom_sheet|widgets/toss/toss_bottom_sheet|g' {} +" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Text field consolidation
echo "## 5. TEXT FIELD CONSOLIDATION ANALYSIS" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "### Feature Comparison" >> "$OUTPUT_FILE"
echo "| Widget | Uses | Unique Features |" >> "$OUTPUT_FILE"
echo "|--------|------|-----------------|" >> "$OUTPUT_FILE"
echo "| TossTextField | 66 | Base implementation |" >> "$OUTPUT_FILE"
echo "| TossEnhancedTextField | 11 | + keyboard toolbar, done/next buttons |" >> "$OUTPUT_FILE"
echo "| TossSearchField | 17 | + debouncing, clear button, search icon |" >> "$OUTPUT_FILE"
echo "| TossNumberInput | 1 | + number keyboard, minimal style |" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "**Consolidation Strategy:**" >> "$OUTPUT_FILE"
echo '```dart' >> "$OUTPUT_FILE"
echo "TossTextField(" >> "$OUTPUT_FILE"
echo "  // Existing props" >> "$OUTPUT_FILE"
echo "  controller: controller," >> "$OUTPUT_FILE"
echo "  hintText: 'Enter text'," >> "$OUTPUT_FILE"
echo "  " >> "$OUTPUT_FILE"
echo "  // New optional props for variants" >> "$OUTPUT_FILE"
echo "  variant: TextFieldVariant.search, // standard (default), search, enhanced" >> "$OUTPUT_FILE"
echo "  showKeyboardToolbar: true, // from enhanced" >> "$OUTPUT_FILE"
echo "  debounceDelay: Duration(milliseconds: 300), // from search" >> "$OUTPUT_FILE"
echo "  showClearButton: true, // from search" >> "$OUTPUT_FILE"
echo ")" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Summary
echo "## Implementation Timeline" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "### Day 1: Quick Wins (2-3 hours)" >> "$OUTPUT_FILE"
echo "- [ ] Delete 11 unused widgets" >> "$OUTPUT_FILE"
echo "- [ ] Fix TossCheckbox (delete - no real usage)" >> "$OUTPUT_FILE"
echo "- [ ] Replace TossNumberInput (1 file)" >> "$OUTPUT_FILE"
echo "- [ ] Replace TossCurrencyChip (1 file)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Day 2: Simple Replacements (3-4 hours)" >> "$OUTPUT_FILE"
echo "- [ ] Replace TossIconButton with IconButton (1 file, 2 locations)" >> "$OUTPUT_FILE"
echo "- [ ] Replace SmartToastNotification with SnackBar (1 file)" >> "$OUTPUT_FILE"
echo "- [ ] Fix TossBottomSheet duplication (52 imports to update)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Week 1: Button Consolidation (2-3 days)" >> "$OUTPUT_FILE"
echo "- [ ] Create unified TossButton widget" >> "$OUTPUT_FILE"
echo "- [ ] Migrate TossPrimaryButton (68 uses)" >> "$OUTPUT_FILE"
echo "- [ ] Migrate TossSecondaryButton (29 uses)" >> "$OUTPUT_FILE"
echo "- [ ] Test all button interactions" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Week 2: Text Field Consolidation (2-3 days)" >> "$OUTPUT_FILE"
echo "- [ ] Enhance TossTextField with all features" >> "$OUTPUT_FILE"
echo "- [ ] Migrate TossEnhancedTextField (11 uses)" >> "$OUTPUT_FILE"
echo "- [ ] Migrate TossSearchField (17 uses)" >> "$OUTPUT_FILE"
echo "- [ ] Test all form inputs" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "## Risk Assessment" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "| Change | Risk | Mitigation |" >> "$OUTPUT_FILE"
echo "|--------|------|------------|" >> "$OUTPUT_FILE"
echo "| Delete unused widgets | None | No usage found |" >> "$OUTPUT_FILE"
echo "| Replace low-use widgets | Low | Only 1-2 files affected each |" >> "$OUTPUT_FILE"
echo "| Button consolidation | Medium | Identical APIs, only styling differs |" >> "$OUTPUT_FILE"
echo "| Text field consolidation | Medium | Feature additions, backward compatible |" >> "$OUTPUT_FILE"
echo "| Bottom sheet fix | Low | Import changes only |" >> "$OUTPUT_FILE"

echo "" >> "$OUTPUT_FILE"
echo "Analysis complete! Report saved to: $OUTPUT_FILE"