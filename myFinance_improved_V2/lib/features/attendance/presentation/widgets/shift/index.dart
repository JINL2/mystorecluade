/// Shift Widgets - Attendance feature specific shift cards
///
/// These widgets contain domain-specific logic (ShiftStatus, ShiftProblemInfo)
/// and are used exclusively within the attendance feature.
///
/// ## Architecture
/// ```
/// domain/entities/
/// ├── shift_status.dart         # ShiftStatus enum
/// ├── shift_card_status.dart    # ShiftCardStatus enum
/// └── shift_problem_info.dart   # ShiftProblemInfo class
///
/// presentation/widgets/shift/
/// ├── index.dart                # This file (barrel export)
/// ├── today_shift_card.dart     # TossTodayShiftCard widget
/// └── week_shift_card.dart      # TossWeekShiftCard widget
/// ```
library;

// Domain entities (re-exported from widgets for convenience)
export '../../../domain/entities/shift_card_status.dart';
export '../../../domain/entities/shift_problem_info.dart';
export '../../../domain/entities/shift_status.dart';

// Presentation widgets
export 'today_shift_card.dart';
export 'week_shift_card.dart';
