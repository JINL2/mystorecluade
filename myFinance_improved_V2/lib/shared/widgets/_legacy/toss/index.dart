/// Toss Widgets Index
///
/// MIGRATION NOTE (2025-12-31):
/// Widgets are being migrated to Atomic Design structure.
/// These re-exports maintain backward compatibility.
/// New structure:
/// - atoms/     : buttons, inputs, display, feedback, layout
/// - molecules/ : dropdowns, cards, navigation, menus
/// - organisms/ : dialogs, sheets, pickers, selectors
/// - templates/ : scaffolds
library;

// ═══════════════════════════════════════════════════════════════
// ATOMS (Re-exported from new location)
// Buttons (moved to atoms/buttons/)
export '../../atoms/buttons/toss_button.dart';
export '../../atoms/buttons/toggle_button.dart';
// Inputs (moved to atoms/inputs/)
export '../../atoms/inputs/toss_text_field.dart';
export '../../atoms/inputs/toss_enhanced_text_field.dart';
export '../../atoms/inputs/toss_search_field.dart';
// Display (moved to atoms/display/)
export '../../atoms/display/toss_badge.dart';
export '../../atoms/display/toss_chip.dart';
export '../../atoms/display/toss_card.dart';
export '../../atoms/display/toss_card_safe.dart';
// Feedback (moved to atoms/feedback/)
export '../../atoms/feedback/toss_refresh_indicator.dart';
// MOLECULES (Re-exported from new location)
// Inputs (moved to molecules/inputs/)
export '../../molecules/inputs/toss_quantity_input.dart';
export '../../molecules/inputs/toss_quantity_stepper.dart';
export '../../molecules/inputs/category_chip.dart';
export '../../molecules/inputs/toss_dropdown.dart';
// Cards (moved to molecules/cards/)
export '../../molecules/cards/toss_expandable_card.dart';
// Navigation (moved to molecules/navigation/)
export '../../molecules/navigation/toss_tab_bar_1.dart';
// ORGANISMS (Re-exported from new location)
// Sheets (moved to organisms/sheets/)
export '../../organisms/sheets/toss_bottom_sheet.dart';
export '../../organisms/sheets/toss_selection_bottom_sheet.dart';
// Pickers (moved to organisms/pickers/)
export '../../organisms/pickers/toss_time_picker.dart';
// Calendars (moved to organisms/calendars/)
export '../../organisms/calendars/toss_month_calendar.dart';
export '../../organisms/calendars/toss_month_navigation.dart';
export '../../organisms/calendars/toss_week_navigation.dart';
export '../../organisms/calendars/month_dates_picker.dart';
export '../../organisms/calendars/week_dates_picker.dart';
export '../../organisms/calendars/calendar_time_range.dart';
// Shift (moved to organisms/shift/)
export '../../organisms/shift/toss_today_shift_card.dart';
export '../../organisms/shift/toss_week_shift_card.dart';
// KEYBOARD (Re-exported from new location)
// Keyboard (moved to molecules/keyboard/)
export '../../molecules/keyboard/toss_keyboard_toolbar.dart';
export '../../molecules/keyboard/modal_keyboard_patterns.dart';
export '../../molecules/keyboard/keyboard_utils.dart';
export '../../molecules/keyboard/toss_currency_exchange_modal.dart';
export '../../molecules/keyboard/toss_textfield_keyboard_modal.dart';
