/// Organisms - Complex UI sections composed of molecules and atoms
///
/// Organisms are relatively complex UI components composed of groups of
/// molecules and/or atoms. They form distinct sections of an interface.
library;

// ═══════════════════════════════════════════════════════════════
// DIALOGS - Modal dialog components
// ═══════════════════════════════════════════════════════════════
export 'dialogs/toss_confirm_cancel_dialog.dart';
export 'dialogs/toss_info_dialog.dart';
export 'dialogs/toss_success_error_dialog.dart';

// ═══════════════════════════════════════════════════════════════
// SHEETS - Bottom sheet components
// ═══════════════════════════════════════════════════════════════
export 'sheets/toss_bottom_sheet.dart';
export 'sheets/toss_selection_bottom_sheet.dart';
export 'sheets/modal_bottom_sheet.dart';

// ═══════════════════════════════════════════════════════════════
// PICKERS - Date/time picker components
// ═══════════════════════════════════════════════════════════════
export 'pickers/toss_date_picker.dart';
export 'pickers/toss_time_picker.dart';

// ═══════════════════════════════════════════════════════════════
// CALENDARS - Calendar components
// ═══════════════════════════════════════════════════════════════
export 'calendars/toss_month_calendar.dart';
export 'calendars/toss_month_navigation.dart';
export 'calendars/toss_week_navigation.dart';
export 'calendars/month_dates_picker.dart';
export 'calendars/week_dates_picker.dart';
export 'calendars/calendar_time_range.dart';

// ═══════════════════════════════════════════════════════════════
// SKELETON - Full page skeleton loading templates
// ═══════════════════════════════════════════════════════════════
export 'skeleton/index.dart';

// NOTE: SHIFT widgets (TodayShiftCard, WeekShiftCard) should be imported directly from
// 'package:myfinance_improved/features/attendance/presentation/widgets/shift/index.dart'
// as they are feature-specific components, not shared organisms.
