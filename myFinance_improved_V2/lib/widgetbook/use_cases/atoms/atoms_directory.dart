import 'package:widgetbook/widgetbook.dart';

// Buttons
import 'buttons/toss_button_use_case.dart';
import 'buttons/toggle_button_use_case.dart';

// Display
import 'display/toss_badge_use_case.dart';
import 'display/toss_card_use_case.dart';
import 'display/toss_chip_use_case.dart';
import 'display/cached_product_image_use_case.dart';
import 'display/employee_profile_avatar_use_case.dart';

// Feedback
import 'feedback/toss_loading_view_use_case.dart';
import 'feedback/toss_empty_view_use_case.dart';
import 'feedback/toss_error_view_use_case.dart';
import 'feedback/toss_refresh_indicator_use_case.dart';

// Inputs
import 'inputs/toss_text_field_use_case.dart';
import 'inputs/toss_search_field_use_case.dart';

// Layout
import 'layout/toss_section_header_use_case.dart';
import 'layout/gray_divider_space_use_case.dart';

final atomsDirectory = WidgetbookCategory(
  name: 'Atoms (15)',
  children: [
    WidgetbookFolder(
      name: 'Buttons (2)',
      children: [
        tossButtonComponent,
        toggleButtonComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Display (5)',
      children: [
        tossBadgeComponent,
        tossStatusBadgeComponent,
        tossCardComponent,
        tossChipComponent,
        cachedProductImageComponent,
        employeeProfileAvatarComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Feedback (4)',
      children: [
        tossLoadingViewComponent,
        tossEmptyViewComponent,
        tossErrorViewComponent,
        tossRefreshIndicatorComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Inputs (2)',
      children: [
        tossTextFieldComponent,
        tossSearchFieldComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Layout (2)',
      children: [
        tossSectionHeaderComponent,
        grayDividerSpaceComponent,
      ],
    ),
  ],
);
