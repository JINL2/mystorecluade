import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

// Core: Buttons
import 'package:myfinance_improved/shared/widgets/core/buttons/index.dart';

// Core: Inputs
import 'package:myfinance_improved/shared/widgets/core/inputs/index.dart';

// Core: Display
import 'package:myfinance_improved/shared/widgets/core/display/index.dart';

// Core: Containers
import 'package:myfinance_improved/shared/widgets/core/containers/index.dart';

// Feedback: Indicators
import 'package:myfinance_improved/shared/widgets/feedback/indicators/index.dart';

// Overlays: Sheets
import 'package:myfinance_improved/shared/widgets/overlays/sheets/index.dart';

// Overlays: Pickers
import 'package:myfinance_improved/shared/widgets/overlays/pickers/index.dart';

// Navigation
import 'package:myfinance_improved/shared/widgets/navigation/index.dart';

// Calendar
import 'package:myfinance_improved/shared/widgets/calendar/index.dart';

import '../component_showcase.dart';

/// Toss Widgets Page - widgets/toss folder
class TossWidgetsPage extends StatefulWidget {
  const TossWidgetsPage({super.key});

  @override
  State<TossWidgetsPage> createState() => _TossWidgetsPageState();
}

class _TossWidgetsPageState extends State<TossWidgetsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedChip;
  String? _selectedDropdown;
  TimeOfDay? _selectedTime;
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<CategoryChipItem> _categoryChips = [
    const CategoryChipItem(id: '1', label: 'Food & Drinks', icon: Icons.restaurant),
    const CategoryChipItem(id: '2', label: 'Transportation', icon: Icons.directions_car),
    const CategoryChipItem(id: '3', label: 'Shopping', icon: Icons.shopping_bag),
  ];

  int _quantity1 = 5;
  int _quantity2 = 10;
  int _quantity3 = 0;
  DateRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textFieldController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      children: [
        // TossTabBar1
        ComponentShowcase(
          name: 'TossTabBar1',
          filename: 'toss_tab_bar_1.dart',
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: TossTabBar1(
              tabs: const ['Cash', 'Bank', 'Vault'],
              controller: _tabController,
              onTabChanged: (index) {},
            ),
          ),
        ),

        // TossButton
        ComponentShowcase(
          name: 'TossButton',
          filename: 'toss_button.dart',
          child: Wrap(
            spacing: TossSpacing.space3,
            runSpacing: TossSpacing.space3,
            children: [
              _buildButtonVariant('Primary', TossButton.primary(text: 'Primary', onPressed: () {})),
              _buildButtonVariant('Secondary', TossButton.secondary(text: 'Secondary', onPressed: () {})),
              _buildButtonVariant('Outlined', TossButton.outlined(text: 'Outlined', onPressed: () {})),
              _buildButtonVariant('OutlinedGray', TossButton.outlinedGray(text: 'Gray', onPressed: () {})),
              _buildButtonVariant('TextButton', TossButton.textButton(text: 'Text', onPressed: () {})),
              _buildButtonVariant('Loading', TossButton.primary(text: 'Loading', isLoading: true, onPressed: () {})),
              _buildButtonVariant('Disabled', TossButton.primary(text: 'Disabled', isEnabled: false, onPressed: () {})),
            ],
          ),
        ),

        // TossChip
        ComponentShowcase(
          name: 'TossChip & TossChipGroup',
          filename: 'toss_chip.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: TossSpacing.space2,
                children: [
                  TossChip(label: 'Active', isSelected: true, onTap: () {}),
                  TossChip(label: 'Inactive', isSelected: false, onTap: () {}),
                  TossChip(label: 'With Icon', icon: Icons.filter_list, onTap: () {}),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              TossChipGroup(
                items: const [
                  TossChipItem(value: 'all', label: 'All', count: 42),
                  TossChipItem(value: 'pending', label: 'Pending', count: 12),
                  TossChipItem(value: 'completed', label: 'Completed', count: 30),
                ],
                selectedValue: _selectedChip,
                onChanged: (v) => setState(() => _selectedChip = v),
              ),
            ],
          ),
        ),

        // CategoryChip
        ComponentShowcase(
          name: 'CategoryChip',
          filename: 'category_chip.dart',
          child: CategoryChipGroup(
            items: _categoryChips,
            onChipRemove: (chip) {
              setState(() {
                _categoryChips = _categoryChips.where((c) => c.id != chip.id).toList();
              });
            },
          ),
        ),

        // TossBadge
        ComponentShowcase(
          name: 'TossBadge & TossStatusBadge',
          filename: 'toss_badge.dart',
          child: Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: const [
              TossBadge(label: 'Default'),
              TossStatusBadge(label: 'Success', status: BadgeStatus.success, icon: Icons.check_circle),
              TossStatusBadge(label: 'Warning', status: BadgeStatus.warning, icon: Icons.warning),
              TossStatusBadge(label: 'Error', status: BadgeStatus.error, icon: Icons.error),
              TossStatusBadge(label: 'Info', status: BadgeStatus.info, icon: Icons.info),
            ],
          ),
        ),

        // TossTextField
        ComponentShowcase(
          name: 'TossTextField',
          filename: 'toss_text_field.dart',
          child: TossTextField(
            label: 'Username',
            hintText: 'Enter your username',
            controller: _textFieldController,
          ),
        ),

        // TossQuantityInput
        ComponentShowcase(
          name: 'TossQuantityInput',
          filename: 'toss_quantity_input.dart',
          child: Column(
            children: [
              TossQuantityInput(
                value: _quantity1,
                onChanged: (v) => setState(() => _quantity1 = v),
                minValue: 0,
                maxValue: 100,
              ),
              const SizedBox(height: TossSpacing.space3),
              TossQuantityInput(
                value: _quantity2,
                onChanged: (v) => setState(() => _quantity2 = v),
                buttonColor: TossColors.primary,
                buttonBackgroundColor: TossColors.primarySurface,
              ),
            ],
          ),
        ),

        // TossSearchField
        ComponentShowcase(
          name: 'TossSearchField',
          filename: 'toss_search_field.dart',
          child: TossSearchField(
            hintText: 'Search...',
            controller: _searchController,
            prefixIcon: Icons.search,
            onChanged: (value) {},
          ),
        ),

        // TossDropdown
        ComponentShowcase(
          name: 'TossDropdown',
          filename: 'toss_dropdown.dart',
          child: TossDropdown<String>(
            label: 'Category',
            hint: 'Select a category',
            value: _selectedDropdown,
            items: const [
              TossDropdownItem(value: 'food', label: 'Food & Drinks'),
              TossDropdownItem(value: 'transport', label: 'Transportation'),
              TossDropdownItem(value: 'shopping', label: 'Shopping'),
            ],
            onChanged: (v) => setState(() => _selectedDropdown = v),
          ),
        ),

        // TossTimePicker
        ComponentShowcase(
          name: 'TossTimePicker',
          filename: 'toss_time_picker.dart',
          child: TossTimePicker(
            time: _selectedTime,
            placeholder: 'Select time',
            onTimeChanged: (v) => setState(() => _selectedTime = v),
          ),
        ),

        // CalendarTimeRange
        ComponentShowcase(
          name: 'CalendarTimeRange',
          filename: 'calendar_time_range.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected: ${_selectedDateRange?.toShortString() ?? 'None'}',
                style: TossTextStyles.body.copyWith(color: TossColors.textSecondary),
              ),
              const SizedBox(height: TossSpacing.space2),
              TossPrimaryButton(
                text: 'Select Date Range',
                onPressed: () {
                  CalendarTimeRange.show(
                    context: context,
                    initialRange: _selectedDateRange,
                    onRangeSelected: (r) => setState(() => _selectedDateRange = r),
                  );
                },
              ),
            ],
          ),
        ),

        // TossCard
        ComponentShowcase(
          name: 'TossCard',
          filename: 'toss_card.dart',
          child: TossCard(
            onTap: () {},
            child: Text('Tappable Card with animation', style: TossTextStyles.body),
          ),
        ),

        // TossCardSafe
        ComponentShowcase(
          name: 'TossCardSafe',
          filename: 'toss_card_safe.dart',
          child: TossCardSafe(
            onTap: () {},
            child: Text('Memory-safe card for lists', style: TossTextStyles.body),
          ),
        ),

        // TossRefreshIndicator
        ComponentShowcase(
          name: 'TossRefreshIndicator',
          filename: 'toss_refresh_indicator.dart',
          child: SizedBox(
            height: 80,
            child: TossRefreshIndicator(
              onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
              child: ListView(children: const [Center(child: Padding(padding: EdgeInsets.all(16), child: Text('Pull down to refresh')))]),
            ),
          ),
        ),

        // TossBottomSheet
        ComponentShowcase(
          name: 'TossBottomSheet',
          filename: 'toss_bottom_sheet.dart',
          child: TossPrimaryButton(
            text: 'Show Bottom Sheet',
            onPressed: () {
              TossBottomSheet.show(
                context: context,
                title: 'Select Action',
                content: const Padding(padding: EdgeInsets.all(16), child: Text('Choose an option')),
                actions: [
                  TossActionItem(title: 'Option 1', onTap: () => Navigator.pop(context)),
                  TossActionItem(title: 'Option 2', onTap: () => Navigator.pop(context)),
                ],
              );
            },
          ),
        ),

        // TossSelectionBottomSheet
        ComponentShowcase(
          name: 'TossSelectionBottomSheet',
          filename: 'toss_selection_bottom_sheet.dart',
          child: TossSecondaryButton(
            text: 'Show Selection Sheet',
            onPressed: () {
              TossSelectionBottomSheet.show(
                context: context,
                title: 'Select Item',
                items: [
                  const TossSelectionItem(id: '1', title: 'Item 1', icon: Icons.star),
                  const TossSelectionItem(id: '2', title: 'Item 2', icon: Icons.favorite),
                ],
                onItemSelected: (item) => Navigator.pop(context),
              );
            },
          ),
        ),

        const SizedBox(height: TossSpacing.space8),
      ],
    );
  }

  Widget _buildButtonVariant(String label, Widget button) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button,
        const SizedBox(height: 4),
        Text(label, style: TossTextStyles.caption.copyWith(color: TossColors.textTertiary)),
      ],
    );
  }
}
