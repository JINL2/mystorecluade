import 'package:widgetbook/widgetbook.dart';

import 'buttons/toss_fab_use_case.dart';
import 'cards/toss_expandable_card_use_case.dart';
import 'inputs/toss_dropdown_use_case.dart';
import 'inputs/toss_quantity_input_use_case.dart';
import 'navigation/toss_app_bar_use_case.dart';

/// Molecules Directory - Combined widgets
final moleculesDirectory = WidgetbookFolder(
  name: 'Molecules',
  children: [
    // Buttons
    WidgetbookFolder(
      name: 'Buttons',
      children: [
        tossFabComponent,
      ],
    ),
    // Cards
    WidgetbookFolder(
      name: 'Cards',
      children: [
        tossExpandableCardComponent,
      ],
    ),
    // Inputs
    WidgetbookFolder(
      name: 'Inputs',
      children: [
        tossDropdownComponent,
        tossQuantityInputComponent,
      ],
    ),
    // Navigation
    WidgetbookFolder(
      name: 'Navigation',
      children: [
        tossAppBarComponent,
      ],
    ),
  ],
);
