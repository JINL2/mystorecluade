/// Common Widgets - Shared UI components across features
///
/// MIGRATION NOTE (2025-12-31):
/// Widgets are being migrated to Atomic Design structure.
/// These re-exports maintain backward compatibility.
library;

// ═══════════════════════════════════════════════════════════════
// ATOMS (Re-exported from new location)
// ═══════════════════════════════════════════════════════════════

// Layout (moved to atoms/layout/)
export '../../atoms/layout/gray_divider_space.dart';
export '../../atoms/layout/toss_section_header.dart';

// Feedback (moved to atoms/feedback/)
export '../../atoms/feedback/toss_loading_view.dart';
export '../../atoms/feedback/toss_error_view.dart';
export '../../atoms/feedback/toss_empty_view.dart';

// Display (moved to atoms/display/)
export '../../atoms/display/cached_product_image.dart';
export '../../atoms/display/employee_profile_avatar.dart';

// ═══════════════════════════════════════════════════════════════
// MOLECULES (Re-exported from new location)
// ═══════════════════════════════════════════════════════════════

// Navigation (moved to molecules/navigation/)
export '../../molecules/navigation/toss_app_bar_1.dart';

// Buttons (moved to molecules/buttons/)
export '../../molecules/buttons/toss_fab.dart';

// Cards (moved to molecules/cards/)
export '../../molecules/cards/toss_white_card.dart';

// Menus (moved to molecules/menus/)
export '../../molecules/menus/safe_popup_menu.dart';

// Display (moved to molecules/display/)
export '../../molecules/display/avatar_stack_interact.dart';

// Inputs (moved to molecules/inputs/)
export '../../molecules/inputs/keyboard_toolbar_1.dart';

// ═══════════════════════════════════════════════════════════════
// ORGANISMS (Re-exported from new location)
// ═══════════════════════════════════════════════════════════════

// Dialogs (moved to organisms/dialogs/)
export '../../organisms/dialogs/toss_confirm_cancel_dialog.dart';
export '../../organisms/dialogs/toss_success_error_dialog.dart';
export '../../organisms/dialogs/toss_info_dialog.dart';

// Pickers (moved to organisms/pickers/)
export '../../organisms/pickers/toss_date_picker.dart';

// Utilities (moved to organisms/utilities/)
export '../../organisms/utilities/exchange_rate_calculator.dart';

// ═══════════════════════════════════════════════════════════════
// TEMPLATES (Re-exported from new location)
// ═══════════════════════════════════════════════════════════════

// Scaffold (moved to templates/)
export '../../templates/toss_scaffold.dart';
