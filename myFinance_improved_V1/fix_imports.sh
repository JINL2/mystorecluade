#!/bin/bash

# List of files that need import fixing
FILES=(
    "lib/presentation/pages/auth/choose_role_page.dart"
    "lib/presentation/pages/auth/create_business_page.dart"
    "lib/presentation/pages/auth/create_store_page.dart"
    "lib/presentation/pages/auth/join_business_page.dart"
    "lib/presentation/pages/add_fix_asset/add_fix_asset_page.dart"
    "lib/presentation/pages/attendance/attendance_main_page.dart"
    "lib/presentation/pages/attendance/attendance_main_page_fixed.dart"
    "lib/presentation/pages/attendance/qr_scanner_page.dart"
    "lib/presentation/pages/balance_sheet/balance_sheet_page.dart"
    "lib/presentation/pages/cash_ending/cash_ending_page.dart"
    "lib/presentation/pages/cash_location/account_detail_page.dart"
    "lib/presentation/pages/cash_location/account_settings_page.dart"
    "lib/presentation/pages/cash_location/add_account_page.dart"
    "lib/presentation/pages/cash_location/cash_location_page.dart"
    "lib/presentation/pages/cash_location/total_journal_page.dart"
    "lib/presentation/pages/component_test/component_test_page.dart"
    "lib/presentation/pages/debug/notification_debug_page.dart"
    "lib/presentation/pages/debug/supabase_connection_test_page.dart"
    "lib/presentation/pages/homepage/homepage_redesigned.dart"
    "lib/presentation/pages/my_page/my_page.dart"
    "lib/presentation/pages/my_page/my_page_enhanced.dart"
    "lib/presentation/pages/notifications/notifications_page.dart"
    "lib/presentation/pages/store_shift/store_shift_page.dart"
    "lib/presentation/pages/time_table_manage/time_table_manage_page.dart"
    "lib/presentation/pages/timetable/timetable_page.dart"
)

echo "Fixing TossScaffold imports in ${#FILES[@]} files..."

for file in "${FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "⚠️  File not found: $file"
        continue
    fi
    
    # Check if TossScaffold is used but import is missing
    if grep -q "TossScaffold(" "$file" 2>/dev/null; then
        if ! grep -q "import.*toss_scaffold.dart" "$file" 2>/dev/null; then
            echo "Fixing: $file"
            
            # Find the last import statement and add TossScaffold import after it
            # Using a more reliable method
            awk '/^import .*dart.*;$/ { imports = imports $0 "\n" }
                 /^import .*dart.*;$/ && !found { lastimport = NR }
                 !/^import/ && found == 0 && lastimport > 0 { 
                     print imports "import '\''../../widgets/common/toss_scaffold.dart'\'';"
                     found = 1
                 }
                 !/^import/ || found { print }
                 /^import/ && !found { print }' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
            
            echo "  ✓ Added TossScaffold import"
        else
            echo "  - Import already exists: $file"
        fi
    fi
done

echo "✅ Import fix complete!"