#!/bin/bash

# Atomic Design Import Migration Script
# This script converts all legacy widget imports to Atomic Design structure

PROJECT_DIR="/Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V2"
LIB_DIR="$PROJECT_DIR/lib"

echo "=== Atomic Design Import Migration ==="
echo ""

# Counter for changes
TOTAL_CHANGES=0

# Function to replace imports in all dart files
replace_import() {
    local old_pattern="$1"
    local new_pattern="$2"
    local description="$3"

    # Count matches before replacement
    local count=$(grep -r "$old_pattern" "$LIB_DIR" --include="*.dart" 2>/dev/null | wc -l | tr -d ' ')

    if [ "$count" -gt 0 ]; then
        echo "[$description] $count occurrences"

        # Perform replacement
        find "$LIB_DIR" -name "*.dart" -type f -exec sed -i '' "s|$old_pattern|$new_pattern|g" {} +

        TOTAL_CHANGES=$((TOTAL_CHANGES + count))
    fi
}

echo "=== ATOMS - Buttons ==="
replace_import "shared/widgets/toss/toss_primary_button" "shared/widgets/atoms/buttons/toss_primary_button" "TossPrimaryButton"
replace_import "shared/widgets/toss/toss_secondary_button" "shared/widgets/atoms/buttons/toss_secondary_button" "TossSecondaryButton"
replace_import "shared/widgets/toss/toss_button" "shared/widgets/atoms/buttons/toss_button" "TossButton"
replace_import "shared/widgets/common/toggle_button" "shared/widgets/atoms/buttons/toggle_button" "ToggleButton"

echo ""
echo "=== ATOMS - Inputs ==="
replace_import "shared/widgets/toss/toss_text_field" "shared/widgets/atoms/inputs/toss_text_field" "TossTextField"
replace_import "shared/widgets/toss/toss_enhanced_text_field" "shared/widgets/atoms/inputs/toss_enhanced_text_field" "TossEnhancedTextField"
replace_import "shared/widgets/toss/toss_search_field" "shared/widgets/atoms/inputs/toss_search_field" "TossSearchField"

echo ""
echo "=== ATOMS - Display ==="
replace_import "shared/widgets/toss/toss_badge" "shared/widgets/atoms/display/toss_badge" "TossBadge"
replace_import "shared/widgets/toss/toss_chip" "shared/widgets/atoms/display/toss_chip" "TossChip"
replace_import "shared/widgets/toss/toss_card" "shared/widgets/atoms/display/toss_card" "TossCard"
replace_import "shared/widgets/common/toss_card_safe" "shared/widgets/atoms/display/toss_card_safe" "TossCardSafe"
replace_import "shared/widgets/common/cached_product_image" "shared/widgets/atoms/display/cached_product_image" "CachedProductImage"
replace_import "shared/widgets/common/employee_profile_avatar" "shared/widgets/atoms/display/employee_profile_avatar" "EmployeeProfileAvatar"

echo ""
echo "=== ATOMS - Feedback ==="
replace_import "shared/widgets/toss/toss_refresh_indicator" "shared/widgets/atoms/feedback/toss_refresh_indicator" "TossRefreshIndicator"
replace_import "shared/widgets/feedback/states/toss_empty_view" "shared/widgets/atoms/feedback/toss_empty_view" "TossEmptyView"
replace_import "shared/widgets/feedback/states/toss_error_view" "shared/widgets/atoms/feedback/toss_error_view" "TossErrorView"
replace_import "shared/widgets/feedback/states/toss_loading_view" "shared/widgets/atoms/feedback/toss_loading_view" "TossLoadingView"
replace_import "shared/widgets/common/toss_empty_view" "shared/widgets/atoms/feedback/toss_empty_view" "TossEmptyView (common)"
replace_import "shared/widgets/common/toss_error_view" "shared/widgets/atoms/feedback/toss_error_view" "TossErrorView (common)"
replace_import "shared/widgets/common/toss_loading_view" "shared/widgets/atoms/feedback/toss_loading_view" "TossLoadingView (common)"

echo ""
echo "=== ATOMS - Layout ==="
replace_import "shared/widgets/common/gray_divider_space" "shared/widgets/atoms/layout/gray_divider_space" "GrayDividerSpace"
replace_import "shared/widgets/common/toss_section_header" "shared/widgets/atoms/layout/toss_section_header" "TossSectionHeader"

echo ""
echo "=== MOLECULES - Inputs ==="
replace_import "shared/widgets/toss/toss_quantity_input" "shared/widgets/molecules/inputs/toss_quantity_input" "TossQuantityInput"
replace_import "shared/widgets/toss/toss_quantity_stepper" "shared/widgets/molecules/inputs/toss_quantity_stepper" "TossQuantityStepper"
replace_import "shared/widgets/toss/category_chip" "shared/widgets/molecules/inputs/category_chip" "CategoryChip"
replace_import "shared/widgets/toss/toss_dropdown" "shared/widgets/molecules/inputs/toss_dropdown" "TossDropdown"

echo ""
echo "=== MOLECULES - Cards ==="
replace_import "shared/widgets/toss/toss_expandable_card" "shared/widgets/molecules/cards/toss_expandable_card" "TossExpandableCard"
replace_import "shared/widgets/common/toss_white_card" "shared/widgets/molecules/cards/toss_white_card" "TossWhiteCard"

echo ""
echo "=== MOLECULES - Navigation ==="
replace_import "shared/widgets/toss/toss_tab_bar_1" "shared/widgets/molecules/navigation/toss_tab_bar_1" "TossTabBar"
replace_import "shared/widgets/navigation/toss_app_bar_1" "shared/widgets/molecules/navigation/toss_app_bar_1" "TossAppBar"
replace_import "shared/widgets/common/toss_app_bar_1" "shared/widgets/molecules/navigation/toss_app_bar_1" "TossAppBar (common)"

echo ""
echo "=== MOLECULES - Buttons ==="
replace_import "shared/widgets/common/toss_fab" "shared/widgets/molecules/buttons/toss_fab" "TossFab"
replace_import "shared/widgets/navigation/toss_fab" "shared/widgets/molecules/buttons/toss_fab" "TossFab (nav)"

echo ""
echo "=== MOLECULES - Keyboard ==="
replace_import "shared/widgets/toss/keyboard/toss_keyboard_toolbar" "shared/widgets/molecules/keyboard/toss_keyboard_toolbar" "TossKeyboardToolbar"
replace_import "shared/widgets/toss/keyboard/modal_keyboard_patterns" "shared/widgets/molecules/keyboard/modal_keyboard_patterns" "ModalKeyboardPatterns"
replace_import "shared/widgets/toss/keyboard/keyboard_utils" "shared/widgets/molecules/keyboard/keyboard_utils" "KeyboardUtils"
replace_import "shared/widgets/toss/keyboard/toss_currency_exchange_modal" "shared/widgets/molecules/keyboard/toss_currency_exchange_modal" "TossCurrencyExchangeModal"
replace_import "shared/widgets/toss/keyboard/toss_textfield_keyboard_modal" "shared/widgets/molecules/keyboard/toss_textfield_keyboard_modal" "TossTextFieldKeyboardModal"
replace_import "shared/widgets/toss/modal_keyboard_patterns" "shared/widgets/molecules/keyboard/modal_keyboard_patterns" "ModalKeyboardPatterns (toss)"
replace_import "shared/widgets/keyboard/toss_keyboard_toolbar" "shared/widgets/molecules/keyboard/toss_keyboard_toolbar" "TossKeyboardToolbar (keyboard)"
replace_import "shared/widgets/keyboard/index" "shared/widgets/molecules/keyboard/index" "Keyboard Index"

echo ""
echo "=== MOLECULES - Menus ==="
replace_import "shared/widgets/common/safe_popup_menu" "shared/widgets/molecules/menus/safe_popup_menu" "SafePopupMenu"

echo ""
echo "=== MOLECULES - Display ==="
replace_import "shared/widgets/common/avatar_stack_interact" "shared/widgets/molecules/display/avatar_stack_interact" "AvatarStackInteract"

echo ""
echo "=== ORGANISMS - Sheets ==="
replace_import "shared/widgets/toss/toss_bottom_sheet" "shared/widgets/organisms/sheets/toss_bottom_sheet" "TossBottomSheet"
replace_import "shared/widgets/toss/toss_selection_bottom_sheet" "shared/widgets/organisms/sheets/toss_selection_bottom_sheet" "TossSelectionBottomSheet"
replace_import "shared/widgets/overlays/sheets/toss_bottom_sheet" "shared/widgets/organisms/sheets/toss_bottom_sheet" "TossBottomSheet (overlays)"
replace_import "shared/widgets/overlays/sheets/toss_selection_bottom_sheet" "shared/widgets/organisms/sheets/toss_selection_bottom_sheet" "TossSelectionBottomSheet (overlays)"

echo ""
echo "=== ORGANISMS - Pickers ==="
replace_import "shared/widgets/toss/toss_time_picker" "shared/widgets/organisms/pickers/toss_time_picker" "TossTimePicker"
replace_import "shared/widgets/overlays/pickers/toss_time_picker" "shared/widgets/organisms/pickers/toss_time_picker" "TossTimePicker (overlays)"
replace_import "shared/widgets/overlays/pickers/toss_date_picker" "shared/widgets/organisms/pickers/toss_date_picker" "TossDatePicker"

echo ""
echo "=== ORGANISMS - Calendars ==="
replace_import "shared/widgets/toss/toss_month_calendar" "shared/widgets/organisms/calendars/toss_month_calendar" "TossMonthCalendar"
replace_import "shared/widgets/toss/toss_month_navigation" "shared/widgets/organisms/calendars/toss_month_navigation" "TossMonthNavigation"
replace_import "shared/widgets/toss/toss_week_navigation" "shared/widgets/organisms/calendars/toss_week_navigation" "TossWeekNavigation"
replace_import "shared/widgets/toss/month_dates_picker" "shared/widgets/organisms/calendars/month_dates_picker" "MonthDatesPicker"
replace_import "shared/widgets/toss/week_dates_picker" "shared/widgets/organisms/calendars/week_dates_picker" "WeekDatesPicker"
replace_import "shared/widgets/toss/calendar_time_range" "shared/widgets/organisms/calendars/calendar_time_range" "CalendarTimeRange"
replace_import "shared/widgets/calendar/toss_month_calendar" "shared/widgets/organisms/calendars/toss_month_calendar" "TossMonthCalendar (calendar)"
replace_import "shared/widgets/calendar/index" "shared/widgets/organisms/calendars/index" "Calendar Index"

echo ""
echo "=== ORGANISMS - Dialogs ==="
replace_import "shared/widgets/common/toss_success_error_dialog" "shared/widgets/organisms/dialogs/toss_success_error_dialog" "TossSuccessErrorDialog"
replace_import "shared/widgets/feedback/dialogs/toss_confirm_cancel_dialog" "shared/widgets/organisms/dialogs/toss_confirm_cancel_dialog" "TossConfirmCancelDialog"
replace_import "shared/widgets/feedback/dialogs/toss_info_dialog" "shared/widgets/organisms/dialogs/toss_info_dialog" "TossInfoDialog"

echo ""
echo "=== ORGANISMS - Shift ==="
replace_import "shared/widgets/domain/shift/toss_today_shift_card" "shared/widgets/organisms/shift/toss_today_shift_card" "TossTodayShiftCard"
replace_import "shared/widgets/domain/shift/toss_week_shift_card" "shared/widgets/organisms/shift/toss_week_shift_card" "TossWeekShiftCard"

echo ""
echo "=== ORGANISMS - Utilities ==="
replace_import "shared/widgets/common/exchange_rate_calculator" "shared/widgets/organisms/utilities/exchange_rate_calculator" "ExchangeRateCalculator"

echo ""
echo "=== TEMPLATES ==="
replace_import "shared/widgets/common/toss_scaffold" "shared/widgets/templates/toss_scaffold" "TossScaffold"
replace_import "shared/widgets/navigation/toss_scaffold" "shared/widgets/templates/toss_scaffold" "TossScaffold (nav)"

echo ""
echo "=== Index files ==="
replace_import "shared/widgets/common/index" "shared/widgets/_legacy/common/index" "Common Index"
replace_import "shared/widgets/toss/index" "shared/widgets/_legacy/toss/index" "Toss Index"
replace_import "shared/widgets/navigation/index" "shared/widgets/_legacy/navigation/index" "Navigation Index"
replace_import "shared/widgets/feedback/index" "shared/widgets/_legacy/feedback/index" "Feedback Index"
replace_import "shared/widgets/overlays/index" "shared/widgets/_legacy/overlays/index" "Overlays Index"
replace_import "shared/widgets/domain/index" "shared/widgets/_legacy/domain/index" "Domain Index"

echo ""
echo "=== Migration Complete ==="
echo "Total imports updated: $TOTAL_CHANGES"
echo ""
