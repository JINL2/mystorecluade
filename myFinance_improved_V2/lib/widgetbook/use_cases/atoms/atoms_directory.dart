import 'package:widgetbook/widgetbook.dart';

import 'buttons/toss_button_use_case.dart';
import 'buttons/toggle_button_use_case.dart';
import 'display/toss_card_use_case.dart';
import 'display/toss_chip_use_case.dart';
import 'display/toss_badge_use_case.dart';
import 'feedback/toss_error_view_use_case.dart';
import 'feedback/toss_empty_view_use_case.dart';
import 'feedback/toss_loading_view_use_case.dart';
import 'inputs/toss_text_field_use_case.dart';
import 'inputs/toss_search_field_use_case.dart';
import 'layout/toss_section_header_use_case.dart';

/// Atoms Directory - Basic building blocks
final atomsDirectory = WidgetbookFolder(
  name: 'Atoms',
  children: [
    // Buttons
    WidgetbookFolder(
      name: 'Buttons',
      children: [
        tossButtonComponent,
        toggleButtonComponent,
      ],
    ),
    // Display
    WidgetbookFolder(
      name: 'Display',
      children: [
        tossCardComponent,
        tossChipComponent,
        tossBadgeComponent,
      ],
    ),
    // Feedback
    WidgetbookFolder(
      name: 'Feedback',
      children: [
        tossErrorViewComponent,
        tossEmptyViewComponent,
        tossLoadingViewComponent,
      ],
    ),
    // Inputs
    WidgetbookFolder(
      name: 'Inputs',
      children: [
        tossTextFieldComponent,
        tossSearchFieldComponent,
      ],
    ),
    // Layout
    WidgetbookFolder(
      name: 'Layout',
      children: [
        tossSectionHeaderComponent,
      ],
    ),
  ],
);
