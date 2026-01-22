import 'package:widgetbook/widgetbook.dart';

// Calendars
import 'calendars/toss_month_calendar_use_case.dart';
import 'calendars/toss_month_navigation_use_case.dart';
import 'calendars/toss_week_navigation_use_case.dart';

// Dialogs
import 'dialogs/toss_confirm_cancel_dialog_use_case.dart';
import 'dialogs/toss_info_dialog_use_case.dart';
import 'dialogs/toss_success_error_dialog_use_case.dart';

// Pickers
import 'pickers/toss_date_picker_use_case.dart';
import 'pickers/toss_time_picker_use_case.dart';

// Sheets
import 'sheets/toss_bottom_sheet_use_case.dart';

final organismsDirectory = WidgetbookCategory(
  name: 'Organisms (9)',
  children: [
    WidgetbookFolder(
      name: 'Calendars (3)',
      children: [
        tossMonthCalendarComponent,
        tossMonthNavigationComponent,
        tossWeekNavigationComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Dialogs (3)',
      children: [
        tossConfirmCancelDialogComponent,
        tossInfoDialogComponent,
        tossSuccessErrorDialogComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Pickers (2)',
      children: [
        tossDatePickerComponent,
        tossTimePickerComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Sheets (1) - 5 UseCases',
      children: [
        tossBottomSheetComponent, // 5 use cases
      ],
    ),
  ],
);
