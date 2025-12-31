import 'package:widgetbook/widgetbook.dart';

// Dialogs
import 'dialogs/toss_confirm_cancel_dialog_use_case.dart';
import 'dialogs/toss_info_dialog_use_case.dart';
import 'dialogs/toss_success_error_dialog_use_case.dart';

// Sheets
import 'sheets/toss_bottom_sheet_use_case.dart';
import 'sheets/toss_selection_bottom_sheet_use_case.dart';

// Pickers
import 'pickers/toss_date_picker_use_case.dart';
import 'pickers/toss_time_picker_use_case.dart';

/// Organisms Directory - Complex UI Components
///
/// Organisms are complex components composed of atoms and molecules.
/// They represent distinct sections of an interface.
///
/// Categories:
/// - Dialogs: Confirm/Cancel, Info, Success/Error dialogs
/// - Sheets: Bottom sheets for selections and actions
/// - Pickers: Date and time pickers
final organismsDirectory = WidgetbookFolder(
  name: 'Organisms',
  children: [
    // Dialogs
    WidgetbookFolder(
      name: 'Dialogs',
      children: [
        tossConfirmCancelDialogComponent,
        tossInfoDialogComponent,
        tossDialogComponent,
      ],
    ),
    // Sheets
    WidgetbookFolder(
      name: 'Sheets',
      children: [
        tossBottomSheetComponent,
        tossSelectionBottomSheetComponent,
      ],
    ),
    // Pickers
    WidgetbookFolder(
      name: 'Pickers',
      children: [
        tossDatePickerComponent,
        tossTimePickerComponent,
      ],
    ),
  ],
);
