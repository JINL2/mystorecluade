#!/usr/bin/env python3
"""
Safe Import Migration Script for Atomic Design Pattern
This script safely replaces import paths without corrupting files.
"""

import os
import re
from pathlib import Path

PROJECT_DIR = "/Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V2"
LIB_DIR = os.path.join(PROJECT_DIR, "lib")

# Import mappings: old_path -> new_path
IMPORT_MAPPINGS = {
    # ATOMS - Buttons
    "shared/widgets/toss/toss_primary_button": "shared/widgets/atoms/buttons/toss_primary_button",
    "shared/widgets/toss/toss_secondary_button": "shared/widgets/atoms/buttons/toss_secondary_button",
    "shared/widgets/toss/toss_button": "shared/widgets/atoms/buttons/toss_button",
    "shared/widgets/common/toggle_button": "shared/widgets/atoms/buttons/toggle_button",
    "shared/widgets/toss/toggle_button": "shared/widgets/atoms/buttons/toggle_button",

    # ATOMS - Inputs
    "shared/widgets/toss/toss_text_field": "shared/widgets/atoms/inputs/toss_text_field",
    "shared/widgets/toss/toss_enhanced_text_field": "shared/widgets/atoms/inputs/toss_enhanced_text_field",
    "shared/widgets/toss/toss_search_field": "shared/widgets/atoms/inputs/toss_search_field",

    # ATOMS - Display
    "shared/widgets/toss/toss_badge": "shared/widgets/atoms/display/toss_badge",
    "shared/widgets/toss/toss_chip": "shared/widgets/atoms/display/toss_chip",
    "shared/widgets/toss/toss_card": "shared/widgets/atoms/display/toss_card",
    "shared/widgets/common/toss_card_safe": "shared/widgets/atoms/display/toss_card_safe",
    "shared/widgets/common/cached_product_image": "shared/widgets/atoms/display/cached_product_image",
    "shared/widgets/common/employee_profile_avatar": "shared/widgets/atoms/display/employee_profile_avatar",

    # ATOMS - Feedback
    "shared/widgets/toss/toss_refresh_indicator": "shared/widgets/atoms/feedback/toss_refresh_indicator",
    "shared/widgets/feedback/states/toss_empty_view": "shared/widgets/atoms/feedback/toss_empty_view",
    "shared/widgets/feedback/states/toss_error_view": "shared/widgets/atoms/feedback/toss_error_view",
    "shared/widgets/feedback/states/toss_loading_view": "shared/widgets/atoms/feedback/toss_loading_view",
    "shared/widgets/common/toss_empty_view": "shared/widgets/atoms/feedback/toss_empty_view",
    "shared/widgets/common/toss_error_view": "shared/widgets/atoms/feedback/toss_error_view",
    "shared/widgets/common/toss_loading_view": "shared/widgets/atoms/feedback/toss_loading_view",

    # ATOMS - Layout
    "shared/widgets/common/gray_divider_space": "shared/widgets/atoms/layout/gray_divider_space",
    "shared/widgets/common/toss_section_header": "shared/widgets/atoms/layout/toss_section_header",

    # MOLECULES - Inputs
    "shared/widgets/toss/toss_quantity_input": "shared/widgets/molecules/inputs/toss_quantity_input",
    "shared/widgets/toss/toss_quantity_stepper": "shared/widgets/molecules/inputs/toss_quantity_stepper",
    "shared/widgets/toss/category_chip": "shared/widgets/molecules/inputs/category_chip",
    "shared/widgets/toss/toss_dropdown": "shared/widgets/molecules/inputs/toss_dropdown",
    "shared/widgets/common/keyboard_toolbar_1": "shared/widgets/molecules/inputs/keyboard_toolbar_1",

    # MOLECULES - Cards
    "shared/widgets/toss/toss_expandable_card": "shared/widgets/molecules/cards/toss_expandable_card",
    "shared/widgets/common/toss_white_card": "shared/widgets/molecules/cards/toss_white_card",

    # MOLECULES - Navigation
    "shared/widgets/toss/toss_tab_bar_1": "shared/widgets/molecules/navigation/toss_tab_bar_1",
    "shared/widgets/navigation/toss_app_bar_1": "shared/widgets/molecules/navigation/toss_app_bar_1",
    "shared/widgets/common/toss_app_bar_1": "shared/widgets/molecules/navigation/toss_app_bar_1",

    # MOLECULES - Buttons
    "shared/widgets/common/toss_fab": "shared/widgets/molecules/buttons/toss_fab",
    "shared/widgets/navigation/toss_fab": "shared/widgets/molecules/buttons/toss_fab",
    "shared/widgets/common/toss_speed_dial": "shared/widgets/molecules/buttons/toss_speed_dial",

    # MOLECULES - Keyboard
    "shared/widgets/toss/keyboard/toss_keyboard_toolbar": "shared/widgets/molecules/keyboard/toss_keyboard_toolbar",
    "shared/widgets/toss/keyboard/modal_keyboard_patterns": "shared/widgets/molecules/keyboard/modal_keyboard_patterns",
    "shared/widgets/toss/keyboard/keyboard_utils": "shared/widgets/molecules/keyboard/keyboard_utils",
    "shared/widgets/toss/keyboard/toss_currency_exchange_modal": "shared/widgets/molecules/keyboard/toss_currency_exchange_modal",
    "shared/widgets/toss/keyboard/toss_textfield_keyboard_modal": "shared/widgets/molecules/keyboard/toss_textfield_keyboard_modal",
    "shared/widgets/toss/modal_keyboard_patterns": "shared/widgets/molecules/keyboard/modal_keyboard_patterns",
    "shared/widgets/keyboard/toss_keyboard_toolbar": "shared/widgets/molecules/keyboard/toss_keyboard_toolbar",
    "shared/widgets/keyboard/index": "shared/widgets/molecules/keyboard/index",

    # MOLECULES - Menus
    "shared/widgets/common/safe_popup_menu": "shared/widgets/molecules/menus/safe_popup_menu",

    # MOLECULES - Display
    "shared/widgets/common/avatar_stack_interact": "shared/widgets/molecules/display/avatar_stack_interact",

    # ORGANISMS - Sheets
    "shared/widgets/toss/toss_bottom_sheet": "shared/widgets/organisms/sheets/toss_bottom_sheet",
    "shared/widgets/toss/toss_selection_bottom_sheet": "shared/widgets/organisms/sheets/toss_selection_bottom_sheet",
    "shared/widgets/overlays/sheets/toss_bottom_sheet": "shared/widgets/organisms/sheets/toss_bottom_sheet",
    "shared/widgets/overlays/sheets/toss_selection_bottom_sheet": "shared/widgets/organisms/sheets/toss_selection_bottom_sheet",

    # ORGANISMS - Pickers
    "shared/widgets/toss/toss_time_picker": "shared/widgets/organisms/pickers/toss_time_picker",
    "shared/widgets/overlays/pickers/toss_time_picker": "shared/widgets/organisms/pickers/toss_time_picker",
    "shared/widgets/overlays/pickers/toss_date_picker": "shared/widgets/organisms/pickers/toss_date_picker",
    "shared/widgets/common/toss_date_picker": "shared/widgets/organisms/pickers/toss_date_picker",

    # ORGANISMS - Calendars
    "shared/widgets/toss/toss_month_calendar": "shared/widgets/organisms/calendars/toss_month_calendar",
    "shared/widgets/toss/toss_month_navigation": "shared/widgets/organisms/calendars/toss_month_navigation",
    "shared/widgets/toss/toss_week_navigation": "shared/widgets/organisms/calendars/toss_week_navigation",
    "shared/widgets/toss/month_dates_picker": "shared/widgets/organisms/calendars/month_dates_picker",
    "shared/widgets/toss/week_dates_picker": "shared/widgets/organisms/calendars/week_dates_picker",
    "shared/widgets/toss/calendar_time_range": "shared/widgets/organisms/calendars/calendar_time_range",
    "shared/widgets/calendar/toss_month_calendar": "shared/widgets/organisms/calendars/toss_month_calendar",
    "shared/widgets/calendar/index": "shared/widgets/organisms/calendars/index",

    # ORGANISMS - Dialogs
    "shared/widgets/common/toss_success_error_dialog": "shared/widgets/organisms/dialogs/toss_success_error_dialog",
    "shared/widgets/common/toss_info_dialog": "shared/widgets/organisms/dialogs/toss_info_dialog",
    "shared/widgets/common/toss_confirm_cancel_dialog": "shared/widgets/organisms/dialogs/toss_confirm_cancel_dialog",
    "shared/widgets/feedback/dialogs/toss_confirm_cancel_dialog": "shared/widgets/organisms/dialogs/toss_confirm_cancel_dialog",
    "shared/widgets/feedback/dialogs/toss_info_dialog": "shared/widgets/organisms/dialogs/toss_info_dialog",

    # ORGANISMS - Shift
    "shared/widgets/domain/shift/toss_today_shift_card": "shared/widgets/organisms/shift/toss_today_shift_card",
    "shared/widgets/domain/shift/toss_week_shift_card": "shared/widgets/organisms/shift/toss_week_shift_card",
    "shared/widgets/toss/toss_today_shift_card": "shared/widgets/organisms/shift/toss_today_shift_card",
    "shared/widgets/toss/toss_week_shift_card": "shared/widgets/organisms/shift/toss_week_shift_card",

    # ORGANISMS - Utilities
    "shared/widgets/common/exchange_rate_calculator": "shared/widgets/organisms/utilities/exchange_rate_calculator",

    # TEMPLATES
    "shared/widgets/common/toss_scaffold": "shared/widgets/templates/toss_scaffold",
    "shared/widgets/navigation/toss_scaffold": "shared/widgets/templates/toss_scaffold",

    # Legacy Index files
    "shared/widgets/common/index": "shared/widgets/_legacy/common/index",
    "shared/widgets/toss/index": "shared/widgets/_legacy/toss/index",
    "shared/widgets/navigation/index": "shared/widgets/_legacy/navigation/index",
    "shared/widgets/feedback/index": "shared/widgets/_legacy/feedback/index",
    "shared/widgets/feedback/dialogs/index": "shared/widgets/_legacy/feedback/dialogs/index",
    "shared/widgets/feedback/states/index": "shared/widgets/_legacy/feedback/states/index",
    "shared/widgets/feedback/indicators/index": "shared/widgets/_legacy/feedback/indicators/index",
    "shared/widgets/overlays/index": "shared/widgets/_legacy/overlays/index",
    "shared/widgets/overlays/sheets/index": "shared/widgets/_legacy/overlays/sheets/index",
    "shared/widgets/overlays/pickers/index": "shared/widgets/_legacy/overlays/pickers/index",
    "shared/widgets/overlays/menus/index": "shared/widgets/_legacy/overlays/menus/index",
    "shared/widgets/domain/index": "shared/widgets/_legacy/domain/index",
    "shared/widgets/domain/profile/index": "shared/widgets/_legacy/domain/profile/index",
    "shared/widgets/domain/finance/index": "shared/widgets/_legacy/domain/finance/index",
    "shared/widgets/domain/shift/index": "shared/widgets/_legacy/domain/shift/index",
}

def find_dart_files(directory):
    """Find all .dart files in directory recursively."""
    dart_files = []
    for root, dirs, files in os.walk(directory):
        # Skip _legacy folder
        if "_legacy" in root:
            continue
        for file in files:
            if file.endswith(".dart"):
                dart_files.append(os.path.join(root, file))
    return dart_files

def process_file(filepath):
    """Process a single dart file and replace imports."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return 0

    original_content = content
    changes = 0

    for old_path, new_path in IMPORT_MAPPINGS.items():
        # Match import statements with this path
        # Handle both package: and relative imports
        pattern = re.escape(old_path)

        if old_path in content:
            content = content.replace(old_path, new_path)
            changes += 1

    if content != original_content:
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            return changes
        except Exception as e:
            print(f"Error writing {filepath}: {e}")
            return 0

    return 0

def main():
    print("=== Safe Atomic Design Import Migration ===\n")

    # Process features folder
    features_dir = os.path.join(LIB_DIR, "features")
    dart_files = find_dart_files(features_dir)

    # Also process shared folder (but not _legacy)
    shared_dir = os.path.join(LIB_DIR, "shared")
    dart_files.extend(find_dart_files(shared_dir))

    # Also process app folder
    app_dir = os.path.join(LIB_DIR, "app")
    dart_files.extend(find_dart_files(app_dir))

    total_files = 0
    total_changes = 0

    for filepath in dart_files:
        changes = process_file(filepath)
        if changes > 0:
            total_files += 1
            total_changes += changes
            rel_path = os.path.relpath(filepath, PROJECT_DIR)
            print(f"  Updated: {rel_path} ({changes} changes)")

    print(f"\n=== Migration Complete ===")
    print(f"Files updated: {total_files}")
    print(f"Total import changes: {total_changes}")

if __name__ == "__main__":
    main()
