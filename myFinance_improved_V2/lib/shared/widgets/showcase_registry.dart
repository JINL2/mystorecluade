/// Showcase Registry
///
/// ONE SINGLE FILE that lists all components for the Design System.
/// When you add a new component, just add it here!
///
/// Simple structure:
/// - Add your component demo to the appropriate category list
/// - The showcase pages will automatically display it
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/models/selection_item.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// ══════════════════════════════════════════════════════════════════════════════
// ATOMS IMPORTS
// ══════════════════════════════════════════════════════════════════════════════
import 'atoms/buttons/toss_button.dart';
import 'atoms/buttons/toss_icon_button.dart';
import 'atoms/buttons/toggle_button.dart';
import 'atoms/display/toss_badge.dart';
import 'atoms/display/toss_chip.dart';
import 'atoms/feedback/toss_loading_view.dart';
import 'atoms/feedback/toss_empty_view.dart';
import 'atoms/feedback/toss_error_view.dart';
import 'atoms/feedback/toss_skeleton.dart';
import 'atoms/inputs/toss_text_field.dart';
import 'atoms/inputs/toss_search_field.dart';
import 'atoms/layout/toss_section_header.dart';
import 'atoms/layout/gray_divider_space.dart';
import 'atoms/layout/sb_card_container.dart';
import 'atoms/sheets/drag_handle.dart';
import 'atoms/sheets/check_indicator.dart';
import 'atoms/sheets/avatar_circle.dart';
import 'atoms/sheets/icon_container.dart';

// ══════════════════════════════════════════════════════════════════════════════
// MOLECULES IMPORTS
// ══════════════════════════════════════════════════════════════════════════════
import 'molecules/buttons/toss_fab.dart';
import 'molecules/cards/toss_card.dart';
import 'molecules/cards/toss_expandable_card.dart';
import 'molecules/cards/info_card.dart';
import 'molecules/display/info_row.dart';
import 'molecules/display/icon_info_row.dart';
import 'molecules/display/avatar_stack_interact.dart';
import 'molecules/inputs/toss_dropdown.dart';
import 'molecules/inputs/toss_quantity_input.dart';
import 'molecules/inputs/toss_enhanced_text_field.dart';
import 'molecules/inputs/option_trigger.dart';
import 'molecules/navigation/toss_app_bar.dart';
import 'molecules/navigation/toss_tab_bar.dart';
import 'molecules/navigation/toss_section_bar.dart';
import 'molecules/sheets/sheet_header.dart';
import 'molecules/sheets/selection_list_item.dart';
import 'molecules/sheets/search_field.dart';
import 'molecules/sheets/bottom_sheet_wrapper.dart';

// ══════════════════════════════════════════════════════════════════════════════
// ORGANISMS IMPORTS
// ══════════════════════════════════════════════════════════════════════════════
import 'organisms/calendars/toss_month_navigation.dart';
import 'organisms/calendars/toss_week_navigation.dart';
import 'organisms/calendars/week_dates_picker.dart';
import 'organisms/calendars/month_dates_picker.dart';
import 'organisms/dialogs/toss_confirm_cancel_dialog.dart';
import 'organisms/dialogs/toss_info_dialog.dart';
import 'organisms/pickers/toss_date_picker.dart'; // TossSimpleWheelDatePicker
import 'organisms/pickers/toss_time_picker.dart'; // TossSimpleWheelTimePicker
import 'organisms/sheets/toss_bottom_sheet.dart';
import 'organisms/sheets/selection_bottom_sheet_common.dart';
import 'organisms/sheets/trigger_bottom_sheet_common.dart';

// ══════════════════════════════════════════════════════════════════════════════
// DEMO ITEM CLASS
// ══════════════════════════════════════════════════════════════════════════════

class DemoItem {
  final String name;
  final String description;
  final Widget Function() builder;
  final List<String> uses; // For molecules/organisms: which atoms they use

  const DemoItem({
    required this.name,
    required this.description,
    required this.builder,
    this.uses = const [],
  });
}

// ══════════════════════════════════════════════════════════════════════════════
// ATOMS REGISTRY
// ══════════════════════════════════════════════════════════════════════════════

Map<String, List<DemoItem>> getAtomsDemos() => {
  'Buttons': [
    DemoItem(
      name: 'TossButton',
      description: 'Unified button component with multiple variants',
      builder: () => const _TossButtonDemo(),
    ),
    DemoItem(
      name: 'TossIconButton',
      description: 'Icon-only button with multiple variants and sizes',
      builder: () => const _TossIconButtonDemo(),
    ),
    DemoItem(
      name: 'ToggleButtonGroup',
      description: 'Segmented toggle with compact/expanded layouts',
      builder: () => const _ToggleButtonDemo(),
    ),
  ],
  'Display': [
    DemoItem(
      name: 'TossBadge',
      description: 'Unified badge with .status(), .circle(), and .growth() factories',
      builder: () => const _TossBadgeDemo(),
    ),
    DemoItem(
      name: 'TossChip',
      description: 'Versatile chip for filters, selections, and removable tags. Supports onRemove for tag mode with × button.',
      builder: () => const _TossChipDemo(),
    ),
  ],
  'Feedback': [
    DemoItem(
      name: 'TossLoadingView',
      description: 'Loading indicator with optional message',
      builder: () => const SizedBox(
        height: 150,
        child: TossLoadingView(message: 'Loading data...'),
      ),
    ),
    DemoItem(
      name: 'TossEmptyView',
      description: 'Empty state with icon and message',
      builder: () => SizedBox(
        height: 200,
        child: TossEmptyView(
          icon: const Icon(Icons.inbox_outlined, size: 48, color: TossColors.gray400),
          title: 'No items found',
          description: 'Try adjusting your filters',
        ),
      ),
    ),
    DemoItem(
      name: 'TossErrorView',
      description: 'Error state with retry option',
      builder: () => SizedBox(
        height: 250,
        child: TossErrorView(
          error: Exception('Something went wrong'),
          title: 'Something went wrong',
          onRetry: () {},
        ),
      ),
    ),
    DemoItem(
      name: 'TossSkeleton',
      description: 'Skeleton loading placeholder',
      builder: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TossSkeleton(width: 200, height: 20),
          const SizedBox(height: TossSpacing.space2),
          const TossSkeleton(width: 150, height: 16),
          const SizedBox(height: TossSpacing.space3),
          Row(
            children: const [
              TossSkeleton(width: 48, height: 48, isCircle: true),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TossSkeleton(height: 16),
                    SizedBox(height: TossSpacing.space2),
                    TossSkeleton(width: 120, height: 14),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ],
  'Inputs': [
    DemoItem(
      name: 'TossTextField',
      description: 'Styled text field with label and hint',
      builder: () => const _TossTextFieldDemo(),
    ),
    DemoItem(
      name: 'TossTextField.filled',
      description: 'Filled text field with gray background (all variants)',
      builder: () => const _TossTextFieldFilledDemo(),
    ),
    DemoItem(
      name: 'TossSearchField',
      description: 'Search input with clear button',
      builder: () => const _TossSearchFieldDemo(),
    ),
  ],
  'Layout': [
    DemoItem(
      name: 'TossSectionHeader',
      description: 'Section header with optional trailing widget',
      builder: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TossSectionHeader(title: 'Recent Transactions'),
          const SizedBox(height: TossSpacing.space3),
          TossSectionHeader(
            title: 'With Action',
            trailing: TextButton(onPressed: () {}, child: const Text('See All')),
          ),
          const SizedBox(height: TossSpacing.space3),
          const TossSectionHeader(title: 'With Icon', icon: Icons.star),
        ],
      ),
    ),
    DemoItem(
      name: 'GrayDividerSpace',
      description: 'Gray divider for separating sections',
      builder: () => Container(
        color: TossColors.white,
        child: Column(
          children: [
            Container(padding: const EdgeInsets.all(TossSpacing.space4), child: const Text('Section 1')),
            const GrayDividerSpace(),
            Container(padding: const EdgeInsets.all(TossSpacing.space4), child: const Text('Section 2')),
          ],
        ),
      ),
    ),
    DemoItem(
      name: 'SBCardContainer',
      description: 'Basic card container with border and rounded corners',
      builder: () => Column(
        children: [
          const SBCardContainer(
            child: Text('Default card container'),
          ),
          const SizedBox(height: TossSpacing.space3),
          SBCardContainer(
            backgroundColor: TossColors.primarySurface,
            borderColor: TossColors.primary,
            child: const Text('Custom colors'),
          ),
          const SizedBox(height: TossSpacing.space3),
          const SBCardContainer(
            padding: EdgeInsets.all(TossSpacing.space6),
            borderRadius: TossBorderRadius.xl,
            child: Text('Custom padding & radius'),
          ),
        ],
      ),
    ),
  ],
  'Sheets': [
    DemoItem(
      name: 'DragHandle',
      description: 'Drag handle for bottom sheets',
      builder: () => Center(
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: const DragHandle(),
        ),
      ),
    ),
    DemoItem(
      name: 'CheckIndicator',
      description: 'Animated check indicator for selections',
      builder: () => const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CheckIndicator(isVisible: false),
          SizedBox(width: TossSpacing.space4),
          CheckIndicator(isVisible: true),
        ],
      ),
    ),
    DemoItem(
      name: 'AvatarCircle',
      description: 'Avatar circle with image or fallback icon',
      builder: () => const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AvatarCircle(),
          SizedBox(width: TossSpacing.space3),
          AvatarCircle(fallbackIcon: Icons.business),
          SizedBox(width: TossSpacing.space3),
          AvatarCircle(size: 48, isSelected: true),
        ],
      ),
    ),
    DemoItem(
      name: 'IconContainer',
      description: 'Styled container for icons',
      builder: () => const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconContainer(icon: Icons.account_balance_wallet),
          SizedBox(width: TossSpacing.space3),
          IconContainer(icon: Icons.credit_card, isSelected: true),
          SizedBox(width: TossSpacing.space3),
          IconContainer(icon: Icons.savings, size: 48),
        ],
      ),
    ),
  ],
};

// ══════════════════════════════════════════════════════════════════════════════
// MOLECULES REGISTRY
// ══════════════════════════════════════════════════════════════════════════════

Map<String, List<DemoItem>> getMoleculesDemos() => {
  'Buttons': [
    DemoItem(
      name: 'TossFAB',
      description: 'Floating action button with optional expandable actions',
      uses: ['TossButton'],
      builder: () => Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TossFAB(icon: Icons.add, onPressed: () {}),
            const SizedBox(width: TossSpacing.space4),
            TossFAB(icon: Icons.edit, onPressed: () {}, backgroundColor: TossColors.success),
          ],
        ),
      ),
    ),
  ],
  'Cards': [
    DemoItem(
      name: 'TossCard',
      description: 'Basic card with optional header and footer',
      uses: ['SBCardContainer'],
      builder: () => TossCard(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Card Title', style: TossTextStyles.titleMedium),
              const SizedBox(height: TossSpacing.space2),
              Text('This is the card content. Cards are used to group related information.', style: TossTextStyles.body),
            ],
          ),
        ),
      ),
    ),
    DemoItem(
      name: 'TossExpandableCard',
      description: 'Card with two variants: .simple() (header only) and .withSummary() (always-visible footer)',
      uses: ['TossCard', 'InfoRow'],
      builder: () => const _TossExpandableCardDemo(),
    ),
    DemoItem(
      name: 'InfoCard',
      description: 'Unified card with 3 modes: default (label+value), summary (icon+label+value+edit), alert (warning/info/success/error)',
      uses: ['TossCard'],
      builder: () => const _InfoCardDemo(),
    ),
  ],
  'Display': [
    DemoItem(
      name: 'InfoRow',
      description: 'Label-value row with .fixed() and .between() layouts, change tracking, and styling options',
      uses: ['TossTextStyles'],
      builder: () => const _InfoRowDemo(),
    ),
    DemoItem(
      name: 'IconInfoRow',
      description: 'Row with icon, label, and value',
      uses: ['InfoRow', 'IconContainer'],
      builder: () => Column(
        children: [
          IconInfoRow(icon: Icons.calendar_today, label: 'Date', value: 'Jan 15, 2026'),
          const SizedBox(height: TossSpacing.space2),
          IconInfoRow(icon: Icons.attach_money, label: 'Amount', value: '\$1,250.00'),
          const SizedBox(height: TossSpacing.space2),
          IconInfoRow(icon: Icons.category, label: 'Category', value: 'Shopping'),
        ],
      ),
    ),
    DemoItem(
      name: 'AvatarStackInteract',
      description: 'Overlapping avatar stack with interactive bottom sheet showing user list and optional action buttons',
      uses: ['CircleAvatar', 'TossBottomSheet'],
      builder: () => const _AvatarStackInteractDemo(),
    ),
  ],
  'Inputs': [
    DemoItem(
      name: 'TossDropdown',
      description: 'Dropdown selector with search',
      uses: ['TossTextField', 'TossBottomSheet'],
      builder: () => const _TossDropdownDemo(),
    ),
    DemoItem(
      name: 'TossQuantityInput',
      description: 'Quantity input with 2 variants: compact (inline) and stepper (dialogs with stock indicator)',
      uses: ['TossIconButton', 'TextField'],
      builder: () => const _TossQuantityInputDemo(),
    ),
    DemoItem(
      name: 'TossEnhancedTextField',
      description: 'Text field with keyboard toolbar',
      uses: ['TossTextField'],
      builder: () => const _TossEnhancedTextFieldDemo(),
    ),
    DemoItem(
      name: 'OptionTrigger',
      description: 'Reusable trigger button for option selection with label, display text, and chevron icon',
      uses: ['LucideIcons.chevronDown'],
      builder: () => const _OptionTriggerDemo(),
    ),
  ],
  'Navigation': [
    DemoItem(
      name: 'TossAppBar',
      description: 'App bar with back button and actions',
      uses: ['TossButton'],
      builder: () => Container(
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: TossAppBar(
          title: 'Page Title',
          actions: [IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})],
        ),
      ),
    ),
    DemoItem(
      name: 'TossTabBar',
      description: 'Tab bar for navigation between sections',
      uses: ['TossChip'],
      builder: () => Container(
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(color: TossColors.gray200),
        ),
        child: TossTabBar(tabs: const ['Overview', 'Transactions', 'Analytics'], onTabChanged: (index) {}),
      ),
    ),
    DemoItem(
      name: 'TossSectionBar',
      description: 'Segmented/pill-style section bar with sliding indicator',
      uses: ['TossTextStyles'],
      builder: () => const _TossSectionBarDemo(),
    ),
  ],
  'Sheets': [
    DemoItem(
      name: 'SheetHeader',
      description: 'Header for bottom sheets',
      uses: ['DragHandle', 'TossButton'],
      builder: () => Container(
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(color: TossColors.gray200),
        ),
        child: SheetHeader(title: 'Select Account', onClose: () {}),
      ),
    ),
    DemoItem(
      name: 'SheetSearchField',
      description: 'Search field for bottom sheets',
      uses: ['TossSearchField'],
      builder: () => const _SheetSearchFieldDemo(),
    ),
    DemoItem(
      name: 'SelectionListItem',
      description: 'Selectable list item for sheets with 4 variants',
      uses: ['IconContainer', 'AvatarCircle', 'CheckIndicator'],
      builder: () => const _SelectionListItemDemo(),
    ),
    DemoItem(
      name: 'BottomSheetWrapper',
      description: 'Minimal sheet wrapper with surface and scrim only (no handle/title)',
      uses: ['TossShadows.bottomSheet', 'TossAnimations'],
      builder: () => const _BottomSheetWrapperDemo(),
    ),
  ],
};

// ══════════════════════════════════════════════════════════════════════════════
// ORGANISMS REGISTRY
// ══════════════════════════════════════════════════════════════════════════════

Map<String, List<DemoItem>> getOrganismsDemos() => {
  'Calendars': [
    DemoItem(
      name: 'TossMonthNavigation',
      description: 'Month navigation header with arrows',
      uses: ['TossIconButton'],
      builder: () => const _TossMonthNavigationDemo(),
    ),
    DemoItem(
      name: 'TossWeekNavigation',
      description: 'Week navigation with day selection',
      uses: ['TossButton'],
      builder: () => const _TossWeekNavigationDemo(),
    ),
    DemoItem(
      name: 'WeekDatesPicker',
      description: 'Week view with date circles and status dots',
      uses: ['TossWeekNavigation'],
      builder: () => const _WeekDatesPickerDemo(),
    ),
    DemoItem(
      name: 'MonthDatesPicker',
      description: 'Month view with date circles and status dots',
      uses: ['TossMonthNavigation'],
      builder: () => const _MonthDatesPickerDemo(),
    ),
  ],
  'Dialogs': [
    DemoItem(
      name: 'TossConfirmCancelDialog',
      description: 'Dialog with confirm and cancel buttons',
      uses: ['TossButton', 'TossCard'],
      builder: () => const _TossConfirmCancelDialogDemo(),
    ),
    DemoItem(
      name: 'TossInfoDialog',
      description: 'Info dialog with single button',
      uses: ['TossButton', 'TossCard'],
      builder: () => const _TossInfoDialogDemo(),
    ),
  ],
  'Pickers': [
    DemoItem(
      name: 'TossDatePicker',
      description: 'Date picker with calendar',
      uses: ['MonthDatesPicker', 'TossBottomSheet'],
      builder: () => const _TossDatePickerDemo(),
    ),
    DemoItem(
      name: 'TossTimePicker',
      description: 'Time picker with wheel selector',
      uses: ['TossBottomSheet'],
      builder: () => const _TossTimePickerDemo(),
    ),
  ],
  'Sheets': [
    DemoItem(
      name: 'TossBottomSheet',
      description: 'Bottom sheet container',
      uses: ['SheetHeader', 'DragHandle'],
      builder: () => const _TossBottomSheetDemo(),
    ),
    DemoItem(
      name: 'SelectionBottomSheetCommon',
      description: 'Common selection sheet composing BottomSheetWrapper + SheetHeader + flexible content',
      uses: ['BottomSheetWrapper', 'SheetHeader', 'SheetSearchField'],
      builder: () => const _SelectionBottomSheetCommonDemo(),
    ),
    DemoItem(
      name: 'TriggerBottomSheetCommon',
      description: 'Complete selection organism: trigger field + bottom sheet + selection logic',
      uses: ['OptionTrigger', 'SelectionBottomSheetCommon', 'SelectionListItem'],
      builder: () => const _TriggerBottomSheetCommonDemo(),
    ),
  ],
};

// ══════════════════════════════════════════════════════════════════════════════
// STATEFUL DEMO WIDGETS (for components that need state)
// ══════════════════════════════════════════════════════════════════════════════

// ----- ATOMS -----

class _TossButtonDemo extends StatelessWidget {
  const _TossButtonDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buttonRow('.primary', TossButton.primary(text: 'Save', onPressed: () {})),
        _buttonRow('.secondary', TossButton.secondary(text: 'Cancel', onPressed: () {})),
        _buttonRow('.outlined', TossButton.outlined(text: 'Edit', onPressed: () {})),
        _buttonRow('.outlinedGray', TossButton.outlinedGray(text: 'More', onPressed: () {})),
        _buttonRow('.textButton', TossButton.textButton(text: 'Learn more', onPressed: () {})),
        _buttonRow('.destructive', TossButton.destructive(text: 'Delete', onPressed: () {})),
        const SizedBox(height: TossSpacing.space3),
        const Text('.pill() - Fully Rounded', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        _buttonRow('left icon', TossButton.pill(text: 'Approve', leadingIcon: const Icon(Icons.check), onPressed: () {})),
        _buttonRow('right icon', TossButton.pill(text: 'Next', trailingIcon: const Icon(Icons.arrow_forward), onPressed: () {})),
        _buttonRow('both icons', TossButton.pill(text: 'Continue', leadingIcon: const Icon(Icons.play_arrow), trailingIcon: const Icon(Icons.arrow_forward), onPressed: () {})),
        _buttonRow('custom color', TossButton.pill(text: 'Success', leadingIcon: const Icon(Icons.check_circle), backgroundColor: TossColors.success, onPressed: () {})),
        const SizedBox(height: TossSpacing.space3),
        const Text('States', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        _buttonRow('isLoading:', TossButton.primary(text: 'Loading...', isLoading: true, onPressed: () {})),
        _buttonRow('disabled:', TossButton.primary(text: 'Disabled', isEnabled: false, onPressed: () {})),
      ],
    );
  }
}

class _TossIconButtonDemo extends StatelessWidget {
  const _TossIconButtonDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Variants', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            _labeledWidget('.ghost', TossIconButton.ghost(icon: Icons.arrow_back, onPressed: () {})),
            const SizedBox(width: TossSpacing.space3),
            _labeledWidget('.filled', TossIconButton.filled(icon: Icons.add, onPressed: () {})),
            const SizedBox(width: TossSpacing.space3),
            _labeledWidget('.outlined', TossIconButton.outlined(icon: Icons.edit, onPressed: () {})),
            const SizedBox(width: TossSpacing.space3),
            _labeledWidget('.danger', TossIconButton.danger(icon: Icons.delete, onPressed: () {})),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        const Text('Sizes', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _labeledWidget('small', TossIconButton.filled(icon: Icons.add, size: TossIconButtonSize.small, onPressed: () {})),
            const SizedBox(width: TossSpacing.space3),
            _labeledWidget('medium', TossIconButton.filled(icon: Icons.add, size: TossIconButtonSize.medium, onPressed: () {})),
            const SizedBox(width: TossSpacing.space3),
            _labeledWidget('large', TossIconButton.filled(icon: Icons.add, size: TossIconButtonSize.large, onPressed: () {})),
          ],
        ),
      ],
    );
  }
}

class _TossBadgeDemo extends StatelessWidget {
  const _TossBadgeDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Default
        const Text('TossBadge() - Default', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: [
            const TossBadge(label: 'Default'),
            TossBadge(label: 'Custom', backgroundColor: TossColors.primarySurface, textColor: TossColors.primary),
            const TossBadge(label: 'With Icon', icon: Icons.star),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),

        // Status
        const Text('.status() - Semantic Status', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: [
            TossBadge.status(label: 'Success', status: BadgeStatus.success),
            TossBadge.status(label: 'Warning', status: BadgeStatus.warning),
            TossBadge.status(label: 'Error', status: BadgeStatus.error),
            TossBadge.status(label: 'Info', status: BadgeStatus.info),
            TossBadge.status(label: 'Neutral', status: BadgeStatus.neutral),
            TossBadge.status(label: 'Free', status: BadgeStatus.free),
            TossBadge.status(label: 'Basic', status: BadgeStatus.basic),
            TossBadge.status(label: 'Pro', status: BadgeStatus.pro),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),

        // Circle
        const Text('.circle() - Rankings/Avatars', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: [
            TossBadge.circle(text: '1', backgroundColor: TossColors.success),
            TossBadge.circle(text: '2', backgroundColor: TossColors.info),
            TossBadge.circle(text: '3', backgroundColor: TossColors.gray400),
            TossBadge.circle(text: '4'),
            TossBadge.circle(text: 'A'),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),

        // Growth
        const Text('.growth() - Analytics/Metrics', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: [
            TossBadge.growth(value: 12.5),
            TossBadge.growth(value: -3.2),
            TossBadge.growth(value: 0.0),
          ],
        ),
      ],
    );
  }
}

class _ToggleButtonDemo extends StatefulWidget {
  const _ToggleButtonDemo();
  @override
  State<_ToggleButtonDemo> createState() => _ToggleButtonDemoState();
}

class _ToggleButtonDemoState extends State<_ToggleButtonDemo> {
  String _selected = 'week';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Compact', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        ToggleButtonGroup(
          items: const [
            ToggleButtonItem(id: 'day', label: 'Day'),
            ToggleButtonItem(id: 'week', label: 'Week'),
            ToggleButtonItem(id: 'month', label: 'Month'),
          ],
          selectedId: _selected,
          onToggle: (id) => setState(() => _selected = id),
        ),
        const SizedBox(height: TossSpacing.space4),
        const Text('Expanded', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        ToggleButtonGroup(
          items: const [
            ToggleButtonItem(id: 'day', label: 'Day'),
            ToggleButtonItem(id: 'week', label: 'Week'),
            ToggleButtonItem(id: 'month', label: 'Month'),
          ],
          selectedId: _selected,
          onToggle: (id) => setState(() => _selected = id),
          layout: ToggleButtonLayout.expanded,
        ),
      ],
    );
  }
}

class _TossChipDemo extends StatefulWidget {
  const _TossChipDemo();
  @override
  State<_TossChipDemo> createState() => _TossChipDemoState();
}

class _TossChipDemoState extends State<_TossChipDemo> {
  String? _selected;
  List<String> _tags = ['VND • Vietnamese Dong', 'USD • US Dollar'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Filter Mode (selectable)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: [
            TossChip(label: 'All', isSelected: _selected == 'all', onTap: () => setState(() => _selected = 'all')),
            TossChip(label: 'Active', isSelected: _selected == 'active', onTap: () => setState(() => _selected = 'active')),
            TossChip(label: 'With Count', isSelected: _selected == 'count', onTap: () => setState(() => _selected = 'count'), showCount: true, count: 12),
            TossChip(label: 'With Icon', icon: Icons.filter_list, isSelected: _selected == 'icon', onTap: () => setState(() => _selected = 'icon')),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),
        const Text('Tag Mode (removable)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: _tags.map((tag) => TossChip(
            label: tag,
            onRemove: () => setState(() => _tags = _tags.where((t) => t != tag).toList()),
          )).toList(),
        ),
        if (_tags.isEmpty) ...[
          const SizedBox(height: TossSpacing.space2),
          TossChip(
            label: 'Add tag',
            icon: Icons.add,
            onTap: () => setState(() => _tags = ['VND • Vietnamese Dong', 'USD • US Dollar']),
          ),
        ],
      ],
    );
  }
}

class _TossTextFieldDemo extends StatefulWidget {
  const _TossTextFieldDemo();
  @override
  State<_TossTextFieldDemo> createState() => _TossTextFieldDemoState();
}

class _TossTextFieldDemoState extends State<_TossTextFieldDemo> {
  final _controller = TextEditingController();
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TossTextField(controller: _controller, label: 'Email', hintText: 'Enter your email'),
        const SizedBox(height: TossSpacing.space3),
        TossTextField(controller: TextEditingController(), label: 'Password', hintText: 'Enter password', obscureText: true),
        const SizedBox(height: TossSpacing.space3),
        TossTextField(controller: TextEditingController(text: 'Invalid'), label: 'With Error', hintText: 'Value', errorText: 'This field is required'),
      ],
    );
  }
}

class _TossTextFieldFilledDemo extends StatefulWidget {
  const _TossTextFieldFilledDemo();
  @override
  State<_TossTextFieldFilledDemo> createState() => _TossTextFieldFilledDemoState();
}

class _TossTextFieldFilledDemoState extends State<_TossTextFieldFilledDemo> {
  final _basicController = TextEditingController();
  final _labelController = TextEditingController();
  final _requiredController = TextEditingController();
  final _prefixSuffixController = TextEditingController();
  final _passwordController = TextEditingController();
  final _multilineController = TextEditingController();
  final _disabledController = TextEditingController(text: 'Disabled value');
  final _errorController = TextEditingController(text: 'Invalid input');
  final _inlineLabelController = TextEditingController();

  @override
  void dispose() {
    _basicController.dispose();
    _labelController.dispose();
    _requiredController.dispose();
    _prefixSuffixController.dispose();
    _passwordController.dispose();
    _multilineController.dispose();
    _disabledController.dispose();
    _errorController.dispose();
    _inlineLabelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic
        Text('Basic', style: TossTextStyles.label.copyWith(color: TossColors.gray600)),
        const SizedBox(height: TossSpacing.space2),
        TossTextField.filled(
          controller: _basicController,
          hintText: 'Enter text here',
        ),
        const SizedBox(height: TossSpacing.space4),

        // With Label
        Text('With Label', style: TossTextStyles.label.copyWith(color: TossColors.gray600)),
        const SizedBox(height: TossSpacing.space2),
        TossTextField.filled(
          controller: _labelController,
          label: 'Full Name',
          hintText: 'Enter your full name',
        ),
        const SizedBox(height: TossSpacing.space4),

        // Required Field
        Text('Required Field', style: TossTextStyles.label.copyWith(color: TossColors.gray600)),
        const SizedBox(height: TossSpacing.space2),
        TossTextField.filled(
          controller: _requiredController,
          label: 'Email Address',
          hintText: 'Enter your email',
          isRequired: true,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: TossSpacing.space4),

        // With Prefix & Suffix Icons
        Text('With Prefix & Suffix Icons', style: TossTextStyles.label.copyWith(color: TossColors.gray600)),
        const SizedBox(height: TossSpacing.space2),
        TossTextField.filled(
          controller: _prefixSuffixController,
          label: 'Search',
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search, color: TossColors.gray500),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: TossColors.gray500),
            onPressed: () => _prefixSuffixController.clear(),
          ),
        ),
        const SizedBox(height: TossSpacing.space4),

        // With Prefix & Suffix Text
        Text('With Prefix & Suffix Text', style: TossTextStyles.label.copyWith(color: TossColors.gray600)),
        const SizedBox(height: TossSpacing.space2),
        TossTextField.filled(
          controller: TextEditingController(),
          label: 'Amount',
          hintText: '0.00',
          prefixText: 'USD ',
          suffixText: ' /month',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: TossSpacing.space4),

        // Password Field
        Text('Password (obscured)', style: TossTextStyles.label.copyWith(color: TossColors.gray600)),
        const SizedBox(height: TossSpacing.space2),
        TossTextField.filled(
          controller: _passwordController,
          label: 'Password',
          hintText: 'Enter password',
          obscureText: true,
          suffixIcon: const Icon(Icons.visibility_off, color: TossColors.gray500),
        ),
        const SizedBox(height: TossSpacing.space4),

        // Multiline
        Text('Multiline', style: TossTextStyles.label.copyWith(color: TossColors.gray600)),
        const SizedBox(height: TossSpacing.space2),
        TossTextField.filled(
          controller: _multilineController,
          label: 'Description',
          hintText: 'Enter a detailed description...',
          maxLines: 4,
        ),
        const SizedBox(height: TossSpacing.space4),

        // With Inline Label (floating)
        Text('With Inline Label (floating)', style: TossTextStyles.label.copyWith(color: TossColors.gray600)),
        const SizedBox(height: TossSpacing.space2),
        TossTextField.filled(
          controller: _inlineLabelController,
          hintText: 'Enter phone number',
          inlineLabel: 'Phone Number',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: TossSpacing.space4),

        // Disabled State
        Text('Disabled State', style: TossTextStyles.label.copyWith(color: TossColors.gray600)),
        const SizedBox(height: TossSpacing.space2),
        TossTextField.filled(
          controller: _disabledController,
          label: 'Read Only',
          hintText: 'Cannot edit',
          enabled: false,
        ),
        const SizedBox(height: TossSpacing.space4),

        // Error State
        Text('Error State', style: TossTextStyles.label.copyWith(color: TossColors.gray600)),
        const SizedBox(height: TossSpacing.space2),
        TossTextField.filled(
          controller: _errorController,
          label: 'Username',
          hintText: 'Enter username',
          errorText: 'This username is already taken',
        ),
      ],
    );
  }
}

class _TossSearchFieldDemo extends StatefulWidget {
  const _TossSearchFieldDemo();
  @override
  State<_TossSearchFieldDemo> createState() => _TossSearchFieldDemoState();
}

class _TossSearchFieldDemoState extends State<_TossSearchFieldDemo> {
  final _controller = TextEditingController();
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return TossSearchField(controller: _controller, hintText: 'Search...', onChanged: (v) {});
  }
}

class _InfoRowDemo extends StatelessWidget {
  const _InfoRowDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== .fixed() Layout =====
        const Text('.fixed() - Fixed Label Width', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            children: [
              InfoRow.fixed(label: 'Name', value: 'John Doe'),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.fixed(label: 'Email', value: 'john@example.com'),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.fixed(label: 'Status', value: 'Active', labelWidth: 100),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.fixed(label: 'Custom', value: 'With trailing', trailing: Icon(Icons.chevron_right, size: 16, color: TossColors.gray400)),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),

        // ===== .between() Layout =====
        const Text('.between() - SpaceBetween Layout', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            children: [
              InfoRow.between(label: 'Subtotal', value: '₫1,000,000'),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.between(label: 'Tax (10%)', value: '₫100,000'),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.between(label: 'Discount', value: '-₫50,000', valueColor: TossColors.error),
              const Divider(height: TossSpacing.space4),
              InfoRow.between(label: 'Total', value: '₫1,050,000', isTotal: true),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),

        // ===== Change Tracking (originalValue) =====
        const Text('Change Tracking (originalValue)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Shows original value with strikethrough',
          style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            children: [
              InfoRow.between(
                label: 'Base Pay',
                value: '₫500,000',
                originalValue: '₫450,000',
              ),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.between(
                label: 'Overtime',
                value: '₫120,000',
                originalValue: '₫80,000',
              ),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.between(
                label: 'Bonus',
                value: '₫200,000',
                originalValue: '₫150,000',
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),

        // ===== Value Color =====
        const Text('Value Colors', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            children: [
              InfoRow.between(label: 'Income', value: '+₫5,000,000', valueColor: TossColors.profit),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.between(label: 'Expense', value: '-₫2,500,000', valueColor: TossColors.loss),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.between(label: 'Pending', value: '₫1,200,000', valueColor: TossColors.warning),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.between(label: 'Completed', value: 'Done', valueColor: TossColors.success),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),

        // ===== Empty State =====
        const Text('Empty State (showEmptyStyle)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            children: [
              InfoRow.fixed(label: 'Phone', value: '', showEmptyStyle: true),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.fixed(label: 'Address', value: '-', showEmptyStyle: true),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.fixed(label: 'Notes', value: 'N/A', showEmptyStyle: true),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),

        // ===== isTotal =====
        const Text('Total/Emphasis Row (isTotal)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            children: [
              InfoRow.between(label: 'Item 1', value: '₫100,000'),
              const SizedBox(height: TossSpacing.space2),
              InfoRow.between(label: 'Item 2', value: '₫200,000'),
              const Divider(height: TossSpacing.space4),
              InfoRow.between(label: 'Grand Total', value: '₫300,000', isTotal: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvatarStackInteractDemo extends StatelessWidget {
  const _AvatarStackInteractDemo();

  @override
  Widget build(BuildContext context) {
    final users = [
      const AvatarUser(id: '1', name: 'John Smith', subtitle: 'Manager', avatarUrl: 'https://i.pravatar.cc/150?img=1'),
      const AvatarUser(id: '2', name: 'Jane Doe', subtitle: 'Supervisor', avatarUrl: 'https://i.pravatar.cc/150?img=5'),
      const AvatarUser(id: '3', name: 'Mike Johnson', subtitle: 'Staff', avatarUrl: 'https://i.pravatar.cc/150?img=8'),
      const AvatarUser(id: '4', name: 'Sarah Williams', subtitle: 'Staff', avatarUrl: 'https://i.pravatar.cc/150?img=9'),
      const AvatarUser(id: '5', name: 'Tom Brown', subtitle: 'Intern'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic - tap to see list
        const Text('Tap to View Users List', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: AvatarStackInteract(
            users: users,
            title: 'Applied Users',
            countTextFormat: '{count} applied',
          ),
        ),
        const SizedBox(height: TossSpacing.space4),

        // Different count formats
        const Text('Custom Count Formats', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarStackInteract(
                users: users.take(3).toList(),
                title: 'Team Members',
                countTextFormat: '{count} members',
              ),
              const SizedBox(height: TossSpacing.space3),
              AvatarStackInteract(
                users: users,
                title: 'Participants',
                countTextFormat: '{count} joined',
              ),
              const SizedBox(height: TossSpacing.space3),
              AvatarStackInteract(
                users: users.take(2).toList(),
                title: 'Assignees',
                countTextFormat: '{count} assigned',
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),

        // Different sizes
        const Text('Avatar Sizes', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 70, child: Text('Small:', style: TextStyle(fontSize: 12))),
                  AvatarStackInteract(
                    users: users.take(3).toList(),
                    title: 'Team',
                    avatarSize: 20,
                    overlapOffset: 14,
                    showCount: false,
                  ),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              Row(
                children: [
                  const SizedBox(width: 70, child: Text('Default:', style: TextStyle(fontSize: 12))),
                  AvatarStackInteract(
                    users: users.take(3).toList(),
                    title: 'Team',
                    showCount: false,
                  ),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              Row(
                children: [
                  const SizedBox(width: 70, child: Text('Large:', style: TextStyle(fontSize: 12))),
                  AvatarStackInteract(
                    users: users.take(3).toList(),
                    title: 'Team',
                    avatarSize: 32,
                    overlapOffset: 24,
                    showCount: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ----- MOLECULES -----

class _TossExpandableCardDemo extends StatefulWidget {
  const _TossExpandableCardDemo();
  @override
  State<_TossExpandableCardDemo> createState() => _TossExpandableCardDemoState();
}

class _TossExpandableCardDemoState extends State<_TossExpandableCardDemo> {
  bool _simpleExpanded = false;
  bool _summaryExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // .simple() variant
        const Text('.simple() - Header only when collapsed', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        TossExpandableCard.simple(
          title: 'Transaction Details',
          isExpanded: _simpleExpanded,
          onToggle: () => setState(() => _simpleExpanded = !_simpleExpanded),
          content: Column(
            children: [
              _infoRow('Date', 'Jan 15, 2026'),
              _infoRow('Amount', '\$250.00'),
              _infoRow('Category', 'Shopping'),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),

        // .withSummary() variant
        const Text('.withSummary() - Always-visible footer', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        TossExpandableCard.withSummary(
          headerWidget: Row(
            children: [
              Text('VND', style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(width: TossSpacing.space2),
              Text('Vietnamese Dong', style: TossTextStyles.caption.copyWith(color: TossColors.gray600)),
            ],
          ),
          isExpanded: _summaryExpanded,
          onToggle: () => setState(() => _summaryExpanded = !_summaryExpanded),
          content: Column(
            children: [
              _infoRow('500,000₫', '× 2'),
              _infoRow('200,000₫', '× 5'),
              _infoRow('100,000₫', '× 10'),
            ],
          ),
          summary: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: TossTextStyles.caption.copyWith(color: TossColors.gray600)),
              Text('2,000,000₫', style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TossTextStyles.caption.copyWith(color: TossColors.gray600)),
        Text(value, style: TossTextStyles.bodyMedium),
      ],
    ),
  );
}

class _InfoCardDemo extends StatelessWidget {
  const _InfoCardDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== DEFAULT MODE =====
        const Text('Default (label + value)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        InfoCard(label: 'PI Number', value: 'PI-2024-001'),
        const SizedBox(height: TossSpacing.space2),
        InfoCard(label: 'Amount', value: '5,000,000 VND', backgroundColor: TossColors.primarySurface),

        const SizedBox(height: TossSpacing.space4),

        // ===== HIGHLIGHT FACTORIES =====
        const Text('Highlight Factories', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        InfoCard.highlight(label: 'Highlighted', value: 'Primary surface background'),
        const SizedBox(height: TossSpacing.space2),
        InfoCard.success(label: 'Success', value: 'Green background'),
        const SizedBox(height: TossSpacing.space2),
        InfoCard.error(label: 'Error', value: 'Red background'),

        const SizedBox(height: TossSpacing.space4),

        // ===== SUMMARY MODE =====
        const Text('.summary() - Icon + Label + Value + Edit', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        InfoCard.summary(
          icon: Icons.store,
          label: 'Store',
          value: 'Main Branch',
          onEdit: () {},
        ),
        const SizedBox(height: TossSpacing.space2),
        InfoCard.summary(
          icon: Icons.account_balance_wallet,
          label: 'Cash Location',
          value: 'Register 1',
        ),

        const SizedBox(height: TossSpacing.space4),

        // ===== ALERT MODE =====
        const Text('.alert*() - Warning/Info/Success/Error', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        InfoCard.alertWarning(message: 'This action will create a debt entry'),
        const SizedBox(height: TossSpacing.space2),
        InfoCard.alertInfo(message: 'Tip: You can swipe left to delete'),
        const SizedBox(height: TossSpacing.space2),
        InfoCard.alertSuccess(message: 'Transaction completed successfully'),
        const SizedBox(height: TossSpacing.space2),
        InfoCard.alertError(message: 'Failed to save. Please try again.'),
      ],
    );
  }
}

class _TossDropdownDemo extends StatefulWidget {
  const _TossDropdownDemo();
  @override
  State<_TossDropdownDemo> createState() => _TossDropdownDemoState();
}

class _TossDropdownDemoState extends State<_TossDropdownDemo> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return TossDropdown<String>(
      label: 'Select Account',
      hint: 'Choose an account',
      value: _selected,
      items: [
        TossDropdownItem(value: 'checking', label: 'Checking Account', subtitle: 'Main'),
        TossDropdownItem(value: 'savings', label: 'Savings Account', subtitle: 'Emergency'),
        TossDropdownItem(value: 'business', label: 'Business Account', subtitle: 'Company'),
      ],
      onChanged: (v) => setState(() => _selected = v),
    );
  }
}

class _TossQuantityInputDemo extends StatefulWidget {
  const _TossQuantityInputDemo();
  @override
  State<_TossQuantityInputDemo> createState() => _TossQuantityInputDemoState();
}

class _TossQuantityInputDemoState extends State<_TossQuantityInputDemo> {
  int _compactQty = 1;
  int _stepperQty = 0;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Compact variant
      const Text('Compact (default)', style: TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: TossSpacing.space2),
      Center(
        child: TossQuantityInput(
          value: _compactQty,
          onChanged: (v) => setState(() => _compactQty = v),
          minValue: 0,
          maxValue: 100,
        ),
      ),
      const SizedBox(height: TossSpacing.space4),

      // Stepper variant
      const Text('.stepper() - For dialogs', style: TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: TossSpacing.space2),
      Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(color: TossColors.gray200),
        ),
        child: TossQuantityInput.stepper(
          value: _stepperQty,
          onChanged: (v) => setState(() => _stepperQty = v),
          previousValue: 10,
          stockChangeMode: StockChangeMode.add,
        ),
      ),
      const SizedBox(height: TossSpacing.space2),
      Text(
        'Stock indicator shows: 10 → ${10 + _stepperQty}',
        style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
      ),
    ],
  );
}

class _TossEnhancedTextFieldDemo extends StatefulWidget {
  const _TossEnhancedTextFieldDemo();
  @override
  State<_TossEnhancedTextFieldDemo> createState() => _TossEnhancedTextFieldDemoState();
}

class _TossEnhancedTextFieldDemoState extends State<_TossEnhancedTextFieldDemo> {
  final _controller = TextEditingController();
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => TossEnhancedTextField(controller: _controller, label: 'Amount', hintText: 'Enter amount', keyboardType: TextInputType.number);
}

class _OptionTriggerDemo extends StatefulWidget {
  const _OptionTriggerDemo();
  @override
  State<_OptionTriggerDemo> createState() => _OptionTriggerDemoState();
}

class _OptionTriggerDemoState extends State<_OptionTriggerDemo> {
  String? _selectedLocation;
  final _locations = ['cashtestnewrpc', 'cash test', 'Main Register', 'Back Office'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Default State', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        OptionTrigger(
          label: 'Cash Location',
          displayText: _selectedLocation ?? 'Select Cash Location',
          hasSelection: _selectedLocation != null,
          onTap: () => _showLocationPicker(context),
        ),
        const SizedBox(height: TossSpacing.space4),
        const Text('Required Field', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        OptionTrigger(
          label: 'Store',
          displayText: 'Select Store',
          isRequired: true,
          onTap: () {},
        ),
        const SizedBox(height: TossSpacing.space4),
        const Text('With Error', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        OptionTrigger(
          label: 'Category',
          displayText: 'Select Category',
          hasError: true,
          errorText: 'This field is required',
          onTap: () {},
        ),
        const SizedBox(height: TossSpacing.space4),
        const Text('Loading State', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        OptionTrigger(
          label: 'Account',
          displayText: 'Loading...',
          isLoading: true,
          onTap: () {},
        ),
        const SizedBox(height: TossSpacing.space4),
        const Text('Disabled State', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        OptionTrigger(
          label: 'Currency',
          displayText: 'VND - Vietnamese Dong',
          hasSelection: true,
          isDisabled: true,
          onTap: () {},
        ),
      ],
    );
  }

  void _showLocationPicker(BuildContext context) {
    SelectionBottomSheetCommon.show<void>(
      context: context,
      title: 'Cash Location',
      maxHeightRatio: 0.5,
      children: _locations.map((loc) => ListTile(
        title: Text(loc),
        trailing: _selectedLocation == loc
            ? Icon(Icons.check, color: TossColors.primary)
            : null,
        onTap: () {
          setState(() => _selectedLocation = loc);
          Navigator.pop(context);
        },
      )).toList(),
    );
  }
}

class _SheetSearchFieldDemo extends StatefulWidget {
  const _SheetSearchFieldDemo();
  @override
  State<_SheetSearchFieldDemo> createState() => _SheetSearchFieldDemoState();
}

class _SheetSearchFieldDemoState extends State<_SheetSearchFieldDemo> {
  final _controller = TextEditingController();
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(TossSpacing.space3),
    decoration: BoxDecoration(
      color: TossColors.white,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      border: Border.all(color: TossColors.gray200),
    ),
    child: SheetSearchField(controller: _controller, hintText: 'Search accounts...'),
  );
}

class _SelectionListItemDemo extends StatefulWidget {
  const _SelectionListItemDemo();
  @override
  State<_SelectionListItemDemo> createState() => _SelectionListItemDemoState();
}

class _SelectionListItemDemoState extends State<_SelectionListItemDemo> {
  String? _selectedStandard;
  String? _selectedMinimal;
  String? _selectedAvatar;
  String? _selectedCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== STANDARD VARIANT =====
        const Text('Standard (icon + title + subtitle)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            children: [
              SelectionListItem(
                item: SelectionItem(id: 'wallet', title: 'Cash Wallet', subtitle: '₩1,250,000', icon: Icons.account_balance_wallet),
                variant: SelectionItemVariant.standard,
                isSelected: _selectedStandard == 'wallet',
                onTap: () => setState(() => _selectedStandard = 'wallet'),
              ),
              SelectionListItem(
                item: SelectionItem(id: 'bank', title: 'Bank Account', subtitle: '₩15,000,000', icon: Icons.account_balance),
                variant: SelectionItemVariant.standard,
                isSelected: _selectedStandard == 'bank',
                onTap: () => setState(() => _selectedStandard = 'bank'),
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // ===== MINIMAL VARIANT =====
        const Text('Minimal (title only, no icon)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            children: [
              SelectionListItem(
                item: const SelectionItem(id: 'gangnam', title: 'Gangnam Branch'),
                variant: SelectionItemVariant.minimal,
                isSelected: _selectedMinimal == 'gangnam',
                onTap: () => setState(() => _selectedMinimal = 'gangnam'),
              ),
              SelectionListItem(
                item: const SelectionItem(id: 'itaewon', title: 'Itaewon Store'),
                variant: SelectionItemVariant.minimal,
                isSelected: _selectedMinimal == 'itaewon',
                onTap: () => setState(() => _selectedMinimal = 'itaewon'),
              ),
              SelectionListItem(
                item: const SelectionItem(id: 'hongdae', title: 'Hongdae Branch'),
                variant: SelectionItemVariant.minimal,
                isSelected: _selectedMinimal == 'hongdae',
                onTap: () => setState(() => _selectedMinimal = 'hongdae'),
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // ===== AVATAR VARIANT =====
        const Text('Avatar (image + title + subtitle)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            children: [
              SelectionListItem(
                item: const SelectionItem(
                  id: 'john',
                  title: 'John Smith',
                  subtitle: 'Manager',
                  avatarUrl: 'https://i.pravatar.cc/150?img=1',
                ),
                variant: SelectionItemVariant.avatar,
                isSelected: _selectedAvatar == 'john',
                onTap: () => setState(() => _selectedAvatar = 'john'),
              ),
              SelectionListItem(
                item: const SelectionItem(
                  id: 'jane',
                  title: 'Jane Doe',
                  subtitle: 'Supervisor',
                  avatarUrl: 'https://i.pravatar.cc/150?img=5',
                ),
                variant: SelectionItemVariant.avatar,
                isSelected: _selectedAvatar == 'jane',
                onTap: () => setState(() => _selectedAvatar = 'jane'),
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // ===== COMPACT VARIANT =====
        const Text('Compact (smaller padding)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            children: [
              SelectionListItem(
                item: SelectionItem(id: 'daily', title: 'Daily', subtitle: 'Every day', icon: Icons.today),
                variant: SelectionItemVariant.compact,
                isSelected: _selectedCompact == 'daily',
                onTap: () => setState(() => _selectedCompact = 'daily'),
              ),
              SelectionListItem(
                item: SelectionItem(id: 'weekly', title: 'Weekly', subtitle: 'Every week', icon: Icons.date_range),
                variant: SelectionItemVariant.compact,
                isSelected: _selectedCompact == 'weekly',
                onTap: () => setState(() => _selectedCompact = 'weekly'),
              ),
              SelectionListItem(
                item: SelectionItem(id: 'monthly', title: 'Monthly', subtitle: 'Every month', icon: Icons.calendar_month),
                variant: SelectionItemVariant.compact,
                isSelected: _selectedCompact == 'monthly',
                onTap: () => setState(() => _selectedCompact = 'monthly'),
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        // ===== STATES =====
        const Text('States (selected highlight, divider)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Column(
            children: [
              SelectionListItem(
                item: SelectionItem(id: 'selected', title: 'Selected Item', subtitle: 'Has blue background', icon: Icons.check_circle),
                variant: SelectionItemVariant.standard,
                isSelected: true,
                showDivider: true,
                onTap: () {},
              ),
              SelectionListItem(
                item: SelectionItem(id: 'unselected', title: 'Unselected Item', subtitle: 'Normal background', icon: Icons.radio_button_unchecked),
                variant: SelectionItemVariant.standard,
                isSelected: false,
                showDivider: true,
                onTap: () {},
              ),
              SelectionListItem(
                item: SelectionItem(id: 'trailing', title: 'With Trailing Widget', subtitle: 'Custom trailing', icon: Icons.star, trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: TossColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('NEW', style: TextStyle(fontSize: 10, color: TossColors.warning, fontWeight: FontWeight.w600)),
                )),
                variant: SelectionItemVariant.standard,
                isSelected: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomSheetWrapperDemo extends StatelessWidget {
  const _BottomSheetWrapperDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pure Surface Wrapper', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'A minimal wrapper providing only the surface (content area) and scrim (background overlay). No handle, no title - full control over content.',
          style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
        ),
        const SizedBox(height: TossSpacing.space4),
        Row(
          children: [
            Expanded(
              child: TossButton.primary(
                text: 'Show Empty Sheet',
                onPressed: () => _showEmptySheet(context),
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: TossButton.outlined(
                text: 'Show Custom Content',
                onPressed: () => _showCustomContentSheet(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space4),
        // Preview of the surface styling
        const Text('Surface Preview:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          height: 120,
          decoration: const BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(TossBorderRadius.xl),
              topRight: Radius.circular(TossBorderRadius.xl),
            ),
            boxShadow: TossShadows.bottomSheet,
          ),
          child: Center(
            child: Text(
              'Surface with rounded top corners\n(TossBorderRadius.xl = 16px)',
              textAlign: TextAlign.center,
              style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
            ),
          ),
        ),
      ],
    );
  }

  void _showEmptySheet(BuildContext context) {
    BottomSheetWrapper.show(
      context: context,
      child: const SizedBox(
        height: 200,
        child: Center(
          child: Text('Empty sheet - you control the content'),
        ),
      ),
    );
  }

  void _showCustomContentSheet(BuildContext context) {
    BottomSheetWrapper.show(
      context: context,
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Custom drag handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Custom title
          Text('Custom Content', style: TossTextStyles.h4),
          const SizedBox(height: TossSpacing.space4),
          // Custom content
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: TossColors.success, size: 20),
                    const SizedBox(width: TossSpacing.space2),
                    const Text('Keyboard-aware animation'),
                  ],
                ),
                const SizedBox(height: TossSpacing.space2),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: TossColors.success, size: 20),
                    const SizedBox(width: TossSpacing.space2),
                    const Text('Safe area padding'),
                  ],
                ),
                const SizedBox(height: TossSpacing.space2),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: TossColors.success, size: 20),
                    const SizedBox(width: TossSpacing.space2),
                    const Text('Drag to dismiss'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          TossButton.primary(
            text: 'Close',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _TossSectionBarDemo extends StatefulWidget {
  const _TossSectionBarDemo();
  @override
  State<_TossSectionBarDemo> createState() => _TossSectionBarDemoState();
}

class _TossSectionBarDemoState extends State<_TossSectionBarDemo> {
  int _selectedIndex = 0;
  int _pillIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Common Style (default)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: TossSectionBar(
            tabs: const ['P&L', 'B/S', 'Trend'],
            initialIndex: _selectedIndex,
            onTabChanged: (index) => setState(() => _selectedIndex = index),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Selected: ${['P&L', 'B/S', 'Trend'][_selectedIndex]}',
          style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
        ),
        const SizedBox(height: TossSpacing.space4),
        const Text('Compact Style (TossSectionBar.compact)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            TossSectionBar.compact(
              tabs: const ['Store', 'Company'],
              initialIndex: _pillIndex,
              onTabChanged: (index) => setState(() => _pillIndex = index),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Selected: ${['Store', 'Company'][_pillIndex]}',
          style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
        ),
      ],
    );
  }
}

// ----- ORGANISMS -----

class _TossMonthNavigationDemo extends StatefulWidget {
  const _TossMonthNavigationDemo();
  @override
  State<_TossMonthNavigationDemo> createState() => _TossMonthNavigationDemoState();
}

class _TossMonthNavigationDemoState extends State<_TossMonthNavigationDemo> {
  DateTime _date = DateTime.now();

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) => TossMonthNavigation(
    currentMonth: _getMonthName(_date.month),
    year: _date.year,
    onPrevMonth: () => setState(() => _date = DateTime(_date.year, _date.month - 1)),
    onCurrentMonth: () => setState(() => _date = DateTime.now()),
    onNextMonth: () => setState(() => _date = DateTime(_date.year, _date.month + 1)),
  );
}

class _TossWeekNavigationDemo extends StatefulWidget {
  const _TossWeekNavigationDemo();
  @override
  State<_TossWeekNavigationDemo> createState() => _TossWeekNavigationDemoState();
}

class _TossWeekNavigationDemoState extends State<_TossWeekNavigationDemo> {
  DateTime _selected = DateTime.now();

  String _getDateRange(DateTime date) {
    final start = date.subtract(Duration(days: date.weekday - 1));
    final end = start.add(const Duration(days: 6));
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${start.day} - ${end.day} ${months[end.month - 1]}';
  }

  @override
  Widget build(BuildContext context) => TossWeekNavigation(
    weekLabel: 'This week',
    dateRange: _getDateRange(_selected),
    onPrevWeek: () => setState(() => _selected = _selected.subtract(const Duration(days: 7))),
    onCurrentWeek: () => setState(() => _selected = DateTime.now()),
    onNextWeek: () => setState(() => _selected = _selected.add(const Duration(days: 7))),
  );
}

class _WeekDatesPickerDemo extends StatefulWidget {
  const _WeekDatesPickerDemo();
  @override
  State<_WeekDatesPickerDemo> createState() => _WeekDatesPickerDemoState();
}

class _WeekDatesPickerDemoState extends State<_WeekDatesPickerDemo> {
  DateTime _selected = DateTime.now();

  DateTime get _weekStart {
    final now = _selected;
    return now.subtract(Duration(days: now.weekday - 1)); // Monday
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      // Problem status mode demo
      Text('Problem Status Mode:', style: TossTextStyles.label),
      const SizedBox(height: TossSpacing.space2),
      WeekDatesPicker(
        selectedDate: _selected,
        weekStartDate: _weekStart,
        problemStatusMap: {
          '${_weekStart.year}-${_weekStart.month.toString().padLeft(2, '0')}-${_weekStart.day.toString().padLeft(2, '0')}': ProblemStatus.unsolvedProblem,
          '${_weekStart.add(const Duration(days: 1)).year}-${_weekStart.add(const Duration(days: 1)).month.toString().padLeft(2, '0')}-${_weekStart.add(const Duration(days: 1)).day.toString().padLeft(2, '0')}': ProblemStatus.unsolvedReport,
          '${_weekStart.add(const Duration(days: 2)).year}-${_weekStart.add(const Duration(days: 2)).month.toString().padLeft(2, '0')}-${_weekStart.add(const Duration(days: 2)).day.toString().padLeft(2, '0')}': ProblemStatus.solved,
          '${_weekStart.add(const Duration(days: 3)).year}-${_weekStart.add(const Duration(days: 3)).month.toString().padLeft(2, '0')}-${_weekStart.add(const Duration(days: 3)).day.toString().padLeft(2, '0')}': ProblemStatus.hasShift,
        },
        onDateSelected: (d) => setState(() => _selected = d),
      ),
      const SizedBox(height: TossSpacing.space4),
      // Schedule mode demo
      Text('Schedule Mode:', style: TossTextStyles.label),
      const SizedBox(height: TossSpacing.space2),
      WeekDatesPicker(
        selectedDate: _selected,
        weekStartDate: _weekStart,
        shiftAvailabilityMap: {
          DateTime(_weekStart.year, _weekStart.month, _weekStart.day): ShiftAvailabilityStatus.empty,
          DateTime(_weekStart.add(const Duration(days: 1)).year, _weekStart.add(const Duration(days: 1)).month, _weekStart.add(const Duration(days: 1)).day): ShiftAvailabilityStatus.understaffed,
          DateTime(_weekStart.add(const Duration(days: 2)).year, _weekStart.add(const Duration(days: 2)).month, _weekStart.add(const Duration(days: 2)).day): ShiftAvailabilityStatus.full,
        },
        onDateSelected: (d) => setState(() => _selected = d),
      ),
    ],
  );
}

class _MonthDatesPickerDemo extends StatefulWidget {
  const _MonthDatesPickerDemo();
  @override
  State<_MonthDatesPickerDemo> createState() => _MonthDatesPickerDemoState();
}

class _MonthDatesPickerDemoState extends State<_MonthDatesPickerDemo> {
  DateTime _selected = DateTime.now();
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(_selected.year, _selected.month, 1);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 400,
    child: MonthDatesPicker(
      currentMonth: _currentMonth,
      selectedDate: _selected,
      problemStatusByDate: {
        _formatDate(DateTime(_currentMonth.year, _currentMonth.month, 5)): ProblemStatus.unsolvedProblem,
        _formatDate(DateTime(_currentMonth.year, _currentMonth.month, 10)): ProblemStatus.unsolvedReport,
        _formatDate(DateTime(_currentMonth.year, _currentMonth.month, 15)): ProblemStatus.solved,
        _formatDate(DateTime(_currentMonth.year, _currentMonth.month, 20)): ProblemStatus.hasShift,
      },
      onDateSelected: (d) => setState(() => _selected = d),
    ),
  );
}

class _TossConfirmCancelDialogDemo extends StatelessWidget {
  const _TossConfirmCancelDialogDemo();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      TossButton.primary(
        text: 'Show Confirm Dialog',
        onPressed: () => TossConfirmCancelDialog.show(
          context: context,
          title: 'Confirm Action',
          message: 'Are you sure you want to proceed?',
        ),
      ),
      const SizedBox(height: TossSpacing.space2),
      TossButton.destructive(
        text: 'Show Delete Dialog',
        onPressed: () => TossConfirmCancelDialog.showDelete(
          context: context,
          title: 'Delete Item',
          message: 'This action cannot be undone.',
        ),
      ),
    ],
  );
}

class _TossInfoDialogDemo extends StatelessWidget {
  const _TossInfoDialogDemo();
  @override
  Widget build(BuildContext context) => TossButton.primary(
    text: 'Show Info Dialog',
    onPressed: () => TossInfoDialog.show(
      context: context,
      title: 'What is this?',
      bulletPoints: [
        'This is an informational dialog.',
        'It can display multiple bullet points.',
        'Great for help content or explanations.',
      ],
    ),
  );
}

class _TossDatePickerDemo extends StatefulWidget {
  const _TossDatePickerDemo();
  @override
  State<_TossDatePickerDemo> createState() => _TossDatePickerDemoState();
}

class _TossDatePickerDemoState extends State<_TossDatePickerDemo> {
  DateTime? _selected;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text('Selected: ${_selected?.toString().split(' ')[0] ?? 'None'}'),
      const SizedBox(height: TossSpacing.space2),
      TossButton.primary(
        text: 'Pick Date',
        onPressed: () async {
          showDialog<void>(
            context: context,
            builder: (ctx) => TossSimpleWheelDatePicker(
              initialDate: _selected,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              onDateSelected: (date) {
                setState(() => _selected = date);
                Navigator.pop(ctx);
              },
            ),
          );
        },
      ),
    ],
  );
}

class _TossTimePickerDemo extends StatefulWidget {
  const _TossTimePickerDemo();
  @override
  State<_TossTimePickerDemo> createState() => _TossTimePickerDemoState();
}

class _TossTimePickerDemoState extends State<_TossTimePickerDemo> {
  TimeOfDay? _selected;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text('Selected: ${_selected?.format(context) ?? 'None'}'),
      const SizedBox(height: TossSpacing.space2),
      TossButton.primary(
        text: 'Pick Time',
        onPressed: () async {
          showDialog<void>(
            context: context,
            builder: (ctx) => TossSimpleWheelTimePicker(
              initialTime: _selected,
              onTimeSelected: (time) {
                setState(() => _selected = time);
                Navigator.pop(ctx);
              },
            ),
          );
        },
      ),
    ],
  );
}

class _TossBottomSheetDemo extends StatelessWidget {
  const _TossBottomSheetDemo();
  @override
  Widget build(BuildContext context) => TossButton.primary(
    text: 'Show Bottom Sheet',
    onPressed: () => TossBottomSheet.show<void>(
      context: context,
      title: 'Bottom Sheet',
      content: const Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Text('This is the bottom sheet content.'),
      ),
    ),
  );
}

class _SelectionBottomSheetCommonDemo extends StatefulWidget {
  const _SelectionBottomSheetCommonDemo();
  @override
  State<_SelectionBottomSheetCommonDemo> createState() => _SelectionBottomSheetCommonDemoState();
}

class _SelectionBottomSheetCommonDemoState extends State<_SelectionBottomSheetCommonDemo> {
  String? _selectedLocation;
  final _locations = [
    {'id': '1', 'name': 'cashtestnewrpc', 'code': 'CASH-001'},
    {'id': '2', 'name': 'cash test', 'code': 'CASH-002'},
    {'id': '3', 'name': 'Main Register', 'code': 'MAIN-001'},
    {'id': '4', 'name': 'Back Office', 'code': 'BACK-001'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Composes: BottomSheetWrapper + SheetHeader + flexible content slot',
          style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
        ),
        const SizedBox(height: TossSpacing.space4),
        Row(
          children: [
            Expanded(
              child: TossButton.primary(
                text: 'Simple List',
                onPressed: () => _showSimpleList(context),
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: TossButton.outlined(
                text: 'With Search',
                onPressed: () => _showWithSearch(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        if (_selectedLocation != null)
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.primarySurface,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: TossColors.primary, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Text('Selected: $_selectedLocation', style: TossTextStyles.body),
              ],
            ),
          ),
      ],
    );
  }

  void _showSimpleList(BuildContext context) {
    SelectionBottomSheetCommon.show(
      context: context,
      title: 'Cash Location',
      children: _locations.map((loc) => ListTile(
        title: Text(loc['name']!),
        subtitle: Text(loc['code']!),
        trailing: _selectedLocation == loc['name']
            ? Icon(Icons.check, color: TossColors.primary)
            : null,
        onTap: () {
          setState(() => _selectedLocation = loc['name']);
          Navigator.pop(context);
        },
      )).toList(),
    );
  }

  void _showWithSearch(BuildContext context) {
    SelectionBottomSheetCommon.show(
      context: context,
      title: 'Select Location',
      showSearch: true,
      searchHint: 'Search locations...',
      itemCount: _locations.length,
      itemBuilder: (context, index) {
        final loc = _locations[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(Icons.location_on, color: TossColors.gray600, size: 20),
          ),
          title: Text(loc['name']!),
          subtitle: Text(loc['code']!),
          trailing: _selectedLocation == loc['name']
              ? Icon(Icons.check, color: TossColors.primary)
              : null,
          onTap: () {
            setState(() => _selectedLocation = loc['name']);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

// ----- TriggerBottomSheetCommon Demo -----

class _TriggerBottomSheetCommonDemo extends StatefulWidget {
  const _TriggerBottomSheetCommonDemo();
  @override
  State<_TriggerBottomSheetCommonDemo> createState() => _TriggerBottomSheetCommonDemoState();
}

class _TriggerBottomSheetCommonDemoState extends State<_TriggerBottomSheetCommonDemo> {
  String? _selectedStoreId;
  String? _selectedAccountId;

  final _stores = [
    SelectionItem(id: '1', title: 'Gangnam Branch', subtitle: 'Seoul'),
    SelectionItem(id: '2', title: 'Headquarters', subtitle: 'Main Office'),
    SelectionItem(id: '3', title: 'Itaewon Store', subtitle: 'Seoul'),
    SelectionItem(id: '4', title: 'Busan Branch', subtitle: 'Busan'),
  ];

  final _accounts = [
    {'id': 'acc1', 'name': 'Cash Register', 'balance': '₩1,250,000'},
    {'id': 'acc2', 'name': 'Petty Cash', 'balance': '₩350,000'},
    {'id': 'acc3', 'name': 'Bank Account', 'balance': '₩15,000,000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Composes: OptionTrigger + SelectionBottomSheetCommon + SelectionListItem',
          style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
        ),
        const SizedBox(height: TossSpacing.space4),

        // Simple mode with items list
        const Text('Simple Mode (items list)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(height: TossSpacing.space2),
        TriggerBottomSheetCommon<String>(
          label: 'Store',
          value: _selectedStoreId,
          hint: 'Select a store',
          items: _stores,
          onChanged: (value) => setState(() => _selectedStoreId = value),
        ),

        const SizedBox(height: TossSpacing.space4),

        // Builder mode for custom items
        const Text('Builder Mode (custom items)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(height: TossSpacing.space2),
        TriggerBottomSheetCommon<String>(
          label: 'Account',
          value: _selectedAccountId,
          displayText: _selectedAccountId != null
              ? _accounts.firstWhere((a) => a['id'] == _selectedAccountId)['name']
              : null,
          hint: 'Select an account',
          itemCount: _accounts.length,
          itemBuilder: (context, index, isSelected, onSelect) {
            final account = _accounts[index];
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? TossColors.primarySurface : TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: isSelected ? TossColors.primary : TossColors.gray600,
                  size: 20,
                ),
              ),
              title: Text(
                account['name']!,
                style: TextStyle(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400),
              ),
              subtitle: Text(account['balance']!),
              trailing: isSelected
                  ? Icon(Icons.check, color: TossColors.primary)
                  : null,
              onTap: () => onSelect(account['id']!),
            );
          },
          isItemSelected: (index) => _accounts[index]['id'] == _selectedAccountId,
          onChanged: (value) => setState(() => _selectedAccountId = value),
        ),

        const SizedBox(height: TossSpacing.space4),

        // With required & error states
        const Text('States (required, error, disabled)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(height: TossSpacing.space2),
        Row(
          children: [
            Expanded(
              child: TriggerBottomSheetCommon<String>(
                label: 'Required',
                value: null,
                isRequired: true,
                items: _stores,
                onChanged: (_) {},
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: TriggerBottomSheetCommon<String>(
                label: 'Disabled',
                value: '1',
                isDisabled: true,
                items: _stores,
                onChanged: null,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        TriggerBottomSheetCommon<String>(
          label: 'With Error',
          value: null,
          hasError: true,
          errorText: 'Please select a store',
          items: _stores,
          onChanged: (_) {},
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ══════════════════════════════════════════════════════════════════════════════

Widget _buttonRow(String label, Widget button) => Padding(
  padding: const EdgeInsets.only(bottom: TossSpacing.space2),
  child: Row(
    children: [
      SizedBox(width: 100, child: Text(label, style: TossTextStyles.caption.copyWith(color: TossColors.gray600, fontFamily: 'monospace'))),
      const SizedBox(width: TossSpacing.space2),
      Flexible(child: button),
    ],
  ),
);

Widget _labeledWidget(String label, Widget widget) => Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    widget,
    const SizedBox(height: TossSpacing.space1),
    Text(label, style: TossTextStyles.caption.copyWith(color: TossColors.gray600, fontSize: 10, fontFamily: 'monospace')),
  ],
);
