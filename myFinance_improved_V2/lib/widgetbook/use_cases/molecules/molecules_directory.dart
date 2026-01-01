import 'package:widgetbook/widgetbook.dart';

// Buttons
import 'buttons/toss_fab_use_case.dart';

// Cards
import 'cards/toss_card_use_case.dart';
import 'cards/toss_expandable_card_use_case.dart';
import 'cards/toss_white_card_use_case.dart';
import 'cards/toss_selection_card_use_case.dart';

// Display
import 'display/avatar_stack_interact_use_case.dart';
import 'display/info_card_use_case.dart';
import 'display/icon_info_row_use_case.dart';

// Inputs
import 'inputs/toss_dropdown_use_case.dart';
import 'inputs/toss_quantity_input_use_case.dart';
import 'inputs/toss_quantity_stepper_use_case.dart';
import 'inputs/toss_enhanced_text_field_use_case.dart';
import 'inputs/category_chip_use_case.dart';
import 'inputs/keyboard_toolbar_use_case.dart';

// Keyboard
import 'keyboard/toss_keyboard_toolbar_use_case.dart';

// Menus
import 'menus/safe_popup_menu_use_case.dart';

// Navigation
import 'navigation/toss_app_bar_use_case.dart';
import 'navigation/toss_tab_bar_use_case.dart';

final moleculesDirectory = WidgetbookCategory(
  name: 'Molecules (21)',
  children: [
    WidgetbookFolder(
      name: 'Buttons (1)',
      children: [
        tossFabComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Cards (7)',
      children: [
        tossCardComponent,
        tossExpandableCardComponent,
        tossWhiteCardComponent,
        tossSelectionCardComponent,
        tossSummaryCardComponent,
        tossNoticeCardComponent,
        tossTransferArrowComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Display (3)',
      children: [
        avatarStackInteractComponent,
        infoCardComponent,
        iconInfoRowComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Inputs (6)',
      children: [
        tossDropdownComponent,
        tossQuantityInputComponent,
        tossQuantityStepperComponent,
        tossEnhancedTextFieldComponent,
        categoryChipComponent,
        keyboardToolbarComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Keyboard (1)',
      children: [
        tossKeyboardToolbarComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Menus (1)',
      children: [
        safePopupMenuComponent,
      ],
    ),
    WidgetbookFolder(
      name: 'Navigation (2)',
      children: [
        tossAppBarComponent,
        tossTabBarComponent,
      ],
    ),
  ],
);
