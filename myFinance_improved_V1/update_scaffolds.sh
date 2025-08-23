#!/bin/bash

# List of files that need to be updated
FILES=(
    "lib/presentation/pages/auth/choose_role_page.dart"
    "lib/presentation/pages/auth/create_business_page.dart"
    "lib/presentation/pages/auth/create_store_page.dart"
    "lib/presentation/pages/auth/forgot_password_page.dart"
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
    "lib/presentation/pages/journal_input/journal_input_page.dart"
    "lib/presentation/pages/my_page/my_page.dart"
    "lib/presentation/pages/my_page/my_page_enhanced.dart"
    "lib/presentation/pages/notifications/notifications_page.dart"
    "lib/presentation/pages/store_shift/store_shift_page.dart"
    "lib/presentation/pages/time_table_manage/time_table_manage_page.dart"
    "lib/presentation/pages/timetable/timetable_page.dart"
)

echo "Starting to update Scaffold to TossScaffold in ${#FILES[@]} files..."

for file in "${FILES[@]}"; do
    echo "Processing: $file"
    
    # Check if file exists
    if [ ! -f "$file" ]; then
        echo "  ⚠️  File not found: $file"
        continue
    fi
    
    # Check if TossScaffold import already exists
    if ! grep -q "import '../../widgets/common/toss_scaffold.dart';" "$file" 2>/dev/null; then
        # Add TossScaffold import after the first import statement
        # Using sed to insert the import after the first import line
        sed -i '' "1,/^import .*';$/s//&\nimport '..\/..\/widgets\/common\/toss_scaffold.dart';/" "$file"
        echo "  ✓ Added TossScaffold import"
    else
        echo "  - TossScaffold import already exists"
    fi
    
    # Replace Scaffold with TossScaffold
    if grep -q "Scaffold(" "$file" 2>/dev/null; then
        sed -i '' 's/Scaffold(/TossScaffold(/g' "$file"
        echo "  ✓ Replaced Scaffold with TossScaffold"
    else
        echo "  - No Scaffold found to replace"
    fi
    
    echo ""
done

echo "✅ Update complete!"