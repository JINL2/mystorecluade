#!/usr/bin/env python3
import os
import re

files_to_fix = [
    "lib/presentation/pages/add_fix_asset/add_fix_asset_page.dart",
    "lib/presentation/pages/attendance/attendance_main_page_fixed.dart",
    "lib/presentation/pages/attendance/attendance_main_page.dart",
    "lib/presentation/pages/attendance/qr_scanner_page.dart",
    "lib/presentation/pages/auth/choose_role_page.dart",
    "lib/presentation/pages/auth/create_business_page.dart",
    "lib/presentation/pages/auth/create_store_page.dart",
    "lib/presentation/pages/auth/join_business_page.dart",
    "lib/presentation/pages/balance_sheet/balance_sheet_page.dart",
    "lib/presentation/pages/cash_ending/cash_ending_page.dart",
    "lib/presentation/pages/cash_location/account_detail_page.dart",
    "lib/presentation/pages/cash_location/account_settings_page.dart",
    "lib/presentation/pages/cash_location/add_account_page.dart",
    "lib/presentation/pages/cash_location/cash_location_page.dart",
    "lib/presentation/pages/cash_location/total_journal_page.dart",
    "lib/presentation/pages/component_test/component_test_page.dart",
    "lib/presentation/pages/debug/notification_debug_page.dart",
    "lib/presentation/pages/debug/supabase_connection_test_page.dart",
    "lib/presentation/pages/homepage/homepage_redesigned.dart",
    "lib/presentation/pages/my_page/my_page_enhanced.dart",
    "lib/presentation/pages/my_page/my_page.dart",
    "lib/presentation/pages/notifications/notifications_page.dart",
    "lib/presentation/pages/store_shift/store_shift_page.dart",
    "lib/presentation/pages/time_table_manage/time_table_manage_page.dart",
    "lib/presentation/pages/timetable/timetable_page.dart",
]

def fix_import(filepath):
    """Add TossScaffold import to file after the last import statement"""
    try:
        with open(filepath, 'r') as f:
            lines = f.readlines()
        
        # Find the last import line
        last_import_index = -1
        for i, line in enumerate(lines):
            if line.strip().startswith('import ') and line.strip().endswith(';'):
                last_import_index = i
        
        if last_import_index == -1:
            print(f"  ⚠️  No imports found in {filepath}")
            return False
        
        # Insert the TossScaffold import after the last import
        import_line = "import '../../widgets/common/toss_scaffold.dart';\n"
        lines.insert(last_import_index + 1, import_line)
        
        # Write back to file
        with open(filepath, 'w') as f:
            f.writelines(lines)
        
        print(f"  ✓ Fixed {filepath}")
        return True
    except Exception as e:
        print(f"  ❌ Error fixing {filepath}: {e}")
        return False

# Fix all files
print(f"Fixing TossScaffold imports in {len(files_to_fix)} files...")
fixed_count = 0
for filepath in files_to_fix:
    if os.path.exists(filepath):
        if fix_import(filepath):
            fixed_count += 1
    else:
        print(f"  ⚠️  File not found: {filepath}")

print(f"\n✅ Fixed {fixed_count}/{len(files_to_fix)} files")