#!/bin/bash

# Fix remaining imports that were missed

PROJECT_DIR="/Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V2"
LIB_DIR="$PROJECT_DIR/lib"

echo "=== Fixing Remaining Imports ==="

# Fix dialog imports
find "$LIB_DIR" -name "*.dart" -type f -exec sed -i '' \
    -e "s|shared/widgets/common/toss_info_dialog|shared/widgets/organisms/dialogs/toss_info_dialog|g" \
    -e "s|shared/widgets/common/toss_confirm_cancel_dialog|shared/widgets/organisms/dialogs/toss_confirm_cancel_dialog|g" \
    -e "s|shared/widgets/common/toss_date_picker|shared/widgets/organisms/pickers/toss_date_picker|g" \
    -e "s|shared/widgets/common/toss_speed_dial|shared/widgets/molecules/buttons/toss_speed_dial|g" \
    -e "s|shared/widgets/common/keyboard_toolbar_1|shared/widgets/molecules/inputs/keyboard_toolbar_1|g" \
    {} +

# Fix toss folder shift imports
find "$LIB_DIR" -name "*.dart" -type f -exec sed -i '' \
    -e "s|shared/widgets/toss/toss_today_shift_card|shared/widgets/organisms/shift/toss_today_shift_card|g" \
    -e "s|shared/widgets/toss/toss_week_shift_card|shared/widgets/organisms/shift/toss_week_shift_card|g" \
    -e "s|shared/widgets/toss/toggle_button|shared/widgets/atoms/buttons/toggle_button|g" \
    {} +

# Fix domain/profile imports
find "$LIB_DIR" -name "*.dart" -type f -exec sed -i '' \
    -e "s|shared/widgets/domain/profile/index|shared/widgets/_legacy/domain/profile/index|g" \
    -e "s|shared/widgets/domain/finance/index|shared/widgets/_legacy/domain/finance/index|g" \
    {} +

# Fix feedback imports
find "$LIB_DIR" -name "*.dart" -type f -exec sed -i '' \
    -e "s|shared/widgets/feedback/dialogs/index|shared/widgets/_legacy/feedback/dialogs/index|g" \
    -e "s|shared/widgets/feedback/states/index|shared/widgets/_legacy/feedback/states/index|g" \
    -e "s|shared/widgets/feedback/indicators/index|shared/widgets/_legacy/feedback/indicators/index|g" \
    {} +

# Fix overlays imports
find "$LIB_DIR" -name "*.dart" -type f -exec sed -i '' \
    -e "s|shared/widgets/overlays/sheets/index|shared/widgets/_legacy/overlays/sheets/index|g" \
    -e "s|shared/widgets/overlays/pickers/index|shared/widgets/_legacy/overlays/pickers/index|g" \
    -e "s|shared/widgets/overlays/menus/index|shared/widgets/_legacy/overlays/menus/index|g" \
    {} +

echo "Done fixing remaining imports!"
