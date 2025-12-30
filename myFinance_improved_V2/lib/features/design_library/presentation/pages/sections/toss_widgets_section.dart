import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

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

/// Toss Widgets Section - Specialized Toss design system widgets
class TossWidgetsSection extends StatefulWidget {
  const TossWidgetsSection({super.key});

  @override
  State<TossWidgetsSection> createState() => _TossWidgetsSectionState();
}

class _TossWidgetsSectionState extends State<TossWidgetsSection>
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
    const CategoryChipItem(id: '4', label: 'Entertainment', icon: Icons.movie),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TossTabBar1
        _ComponentShowcase(
          name: 'TossTabBar1',
          description: 'Tab bar with Toss design system styling and underline indicator',
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

        // TossButton (Unified)
        _ComponentShowcase(
          name: 'TossButton',
          description: 'Unified button with 5 variants (primary, secondary, outlined, outlinedGray, textButton) and full customization',
          filename: 'toss_button.dart',
          child: Wrap(
            spacing: TossSpacing.space3,
            runSpacing: TossSpacing.space3,
            children: [
              _buildButtonVariant(
                TossButton.primary(text: 'Primary', onPressed: () {}),
                'primary',
              ),
              _buildButtonVariant(
                TossButton.secondary(text: 'Secondary', onPressed: () {}),
                'secondary',
              ),
              _buildButtonVariant(
                TossButton.outlined(text: 'Outlined', onPressed: () {}),
                'outlined',
              ),
              _buildButtonVariant(
                TossButton.outlinedGray(text: 'Outlined Gray', onPressed: () {}),
                'outlinedGray',
              ),
              _buildButtonVariant(
                TossButton.textButton(
                  text: 'Add currency',
                  leadingIcon: const Icon(Icons.add, size: 16),
                  onPressed: () {},
                ),
                'textButton',
              ),
              _buildButtonVariant(
                TossButton.primary(
                  text: 'With Icon',
                  leadingIcon: const Icon(Icons.add, size: 16),
                  onPressed: () {},
                ),
                'with icon',
              ),
              _buildButtonVariant(
                TossButton.primary(text: 'Loading', isLoading: true, onPressed: () {}),
                'loading',
              ),
              _buildButtonVariant(
                TossButton.primary(text: 'Disabled', isEnabled: false, onPressed: () {}),
                'disabled',
              ),
            ],
          ),
        ),

        // TossChip
        _ComponentShowcase(
          name: 'TossChip & TossChipGroup',
          description: 'Filter chips with selection states and count badges',
          filename: 'toss_chip.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeader('Single Chips'),
              const SizedBox(height: TossSpacing.space2),
              Wrap(
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
                children: [
                  TossChip(label: 'Active', isSelected: true, onTap: () {}),
                  TossChip(label: 'Inactive', isSelected: false, onTap: () {}),
                  TossChip(label: 'With Icon', icon: Icons.filter_list, onTap: () {}),
                  TossChip(label: 'Count', showCount: true, count: 5, onTap: () {}),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              _buildSubHeader('Chip Group'),
              const SizedBox(height: TossSpacing.space2),
              TossChipGroup(
                items: const [
                  TossChipItem(value: 'all', label: 'All', count: 42),
                  TossChipItem(value: 'pending', label: 'Pending', count: 12, icon: Icons.pending),
                  TossChipItem(value: 'completed', label: 'Completed', count: 30, icon: Icons.check_circle),
                ],
                selectedValue: _selectedChip,
                onChanged: (value) => setState(() => _selectedChip = value),
              ),
            ],
          ),
        ),

        // CategoryChip
        _ComponentShowcase(
          name: 'CategoryChip',
          description: 'Removable category/tag chips with close button',
          filename: 'category_chip.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeader('Single Chips'),
              const SizedBox(height: TossSpacing.space2),
              Wrap(
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
                children: [
                  CategoryChip(label: 'Basic Chip', onRemove: () {}),
                  CategoryChip(label: 'With Icon', icon: Icons.star, onRemove: () {}),
                  const CategoryChip(label: 'No Close'),
                  CategoryChip(
                    label: 'Custom Color',
                    backgroundColor: TossColors.primarySurface,
                    textColor: TossColors.primary,
                    borderColor: TossColors.primary,
                    onRemove: () {},
                  ),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              _buildSubHeader('Chip Group (Removable)'),
              const SizedBox(height: TossSpacing.space2),
              CategoryChipGroup(
                items: _categoryChips,
                onChipRemove: (chip) {
                  setState(() {
                    _categoryChips = _categoryChips.where((c) => c.id != chip.id).toList();
                  });
                },
                onChipTap: (chip) {},
              ),
            ],
          ),
        ),

        // TossBadge
        _ComponentShowcase(
          name: 'TossBadge & TossStatusBadge',
          description: 'Non-interactive badges for labels, statuses, and categories',
          filename: 'toss_badge.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeader('Basic Badges'),
              const SizedBox(height: TossSpacing.space2),
              Wrap(
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
                children: const [
                  TossBadge(label: 'Default'),
                  TossBadge(
                    label: 'Custom',
                    backgroundColor: TossColors.primarySurface,
                    textColor: TossColors.primary,
                  ),
                  TossBadge(label: 'With Icon', icon: Icons.star),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              _buildSubHeader('Status Badges'),
              const SizedBox(height: TossSpacing.space2),
              Wrap(
                spacing: TossSpacing.space2,
                runSpacing: TossSpacing.space2,
                children: const [
                  TossStatusBadge(label: 'Success', status: BadgeStatus.success, icon: Icons.check_circle),
                  TossStatusBadge(label: 'Warning', status: BadgeStatus.warning, icon: Icons.warning),
                  TossStatusBadge(label: 'Error', status: BadgeStatus.error, icon: Icons.error),
                  TossStatusBadge(label: 'Info', status: BadgeStatus.info, icon: Icons.info),
                  TossStatusBadge(label: 'Neutral', status: BadgeStatus.neutral),
                ],
              ),
            ],
          ),
        ),

        // TossTextField
        _ComponentShowcase(
          name: 'TossTextField',
          description: 'Text input field with label and validation support',
          filename: 'toss_text_field.dart',
          child: Column(
            children: [
              TossTextField(
                label: 'Username',
                hintText: 'Enter your username',
                controller: _textFieldController,
              ),
              const SizedBox(height: TossSpacing.space3),
              const TossTextField(
                label: 'Password',
                hintText: 'Enter password',
                obscureText: true,
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ],
          ),
        ),

        // TossQuantityInput
        _ComponentShowcase(
          name: 'TossQuantityInput',
          description: 'Quantity input with increment/decrement buttons, haptic feedback, and validation',
          filename: 'toss_quantity_input.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeader('Basic'),
              const SizedBox(height: TossSpacing.space2),
              TossQuantityInput(
                value: _quantity1,
                onChanged: (value) => setState(() => _quantity1 = value),
                minValue: 0,
                maxValue: 100,
              ),
              const SizedBox(height: TossSpacing.space3),
              _buildSubHeader('With Custom Colors'),
              const SizedBox(height: TossSpacing.space2),
              TossQuantityInput(
                value: _quantity2,
                onChanged: (value) => setState(() => _quantity2 = value),
                minValue: 1,
                maxValue: 50,
                buttonColor: TossColors.primary,
                buttonBackgroundColor: TossColors.primarySurface,
              ),
              const SizedBox(height: TossSpacing.space3),
              _buildSubHeader('Disabled Manual Input'),
              const SizedBox(height: TossSpacing.space2),
              TossQuantityInput(
                value: _quantity3,
                onChanged: (value) => setState(() => _quantity3 = value),
                minValue: 0,
                maxValue: 10,
                allowManualInput: false,
              ),
            ],
          ),
        ),

        // TossSearchField
        _ComponentShowcase(
          name: 'TossSearchField',
          description: 'Search field with debounce and clear functionality',
          filename: 'toss_search_field.dart',
          child: TossSearchField(
            hintText: 'Search...',
            controller: _searchController,
            prefixIcon: Icons.search,
            onChanged: (value) {},
          ),
        ),

        // TossDropdown
        _ComponentShowcase(
          name: 'TossDropdown',
          description: 'Dropdown with bottom sheet selection',
          filename: 'toss_dropdown.dart',
          child: TossDropdown<String>(
            label: 'Category',
            hint: 'Select a category',
            value: _selectedDropdown,
            items: const [
              TossDropdownItem(value: 'food', label: 'Food & Drinks', subtitle: 'Meals and beverages'),
              TossDropdownItem(value: 'transport', label: 'Transportation', subtitle: 'Travel expenses'),
              TossDropdownItem(value: 'shopping', label: 'Shopping', subtitle: 'Retail purchases'),
            ],
            onChanged: (value) => setState(() => _selectedDropdown = value),
          ),
        ),

        // TossTimePicker
        _ComponentShowcase(
          name: 'TossTimePicker',
          description: 'Wheel-style time picker with AM/PM support',
          filename: 'toss_time_picker.dart',
          child: TossTimePicker(
            time: _selectedTime,
            placeholder: 'Select time',
            onTimeChanged: (value) => setState(() => _selectedTime = value),
          ),
        ),

        // CalendarTimeRange
        _ComponentShowcase(
          name: 'CalendarTimeRange',
          description: 'Calendar-based date range picker with start/end selection',
          filename: 'calendar_time_range.dart',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Range: ${_selectedDateRange?.toShortString() ?? 'None'}',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              TossButton.primary(
                text: 'Select Date Range',
                onPressed: () {
                  CalendarTimeRange.show(
                    context: context,
                    initialRange: _selectedDateRange,
                    onRangeSelected: (range) => setState(() => _selectedDateRange = range),
                  );
                },
              ),
            ],
          ),
        ),

        // TossCard
        _ComponentShowcase(
          name: 'TossCard',
          description: 'Card with micro-interactions and tap animations',
          filename: 'toss_card.dart',
          child: TossCard(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tappable Card',
                  style: TossTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Tap this card to see the animation effect',
                  style: TossTextStyles.body.copyWith(color: TossColors.textSecondary),
                ),
              ],
            ),
          ),
        ),

        // TossCardSafe
        _ComponentShowcase(
          name: 'TossCardSafe',
          description: 'Memory-safe card variant without animations (ideal for lists)',
          filename: 'toss_card_safe.dart',
          child: TossCardSafe(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safe Card',
                  style: TossTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'No animations, perfect for database lists and heavy operations',
                  style: TossTextStyles.body.copyWith(color: TossColors.textSecondary),
                ),
              ],
            ),
          ),
        ),

        // TossRefreshIndicator
        _ComponentShowcase(
          name: 'TossRefreshIndicator',
          description: 'Pull-to-refresh wrapper with Toss styling',
          filename: 'toss_refresh_indicator.dart',
          child: SizedBox(
            height: 100,
            child: TossRefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView(
                children: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(TossSpacing.space4),
                      child: Text('Pull down to refresh'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // TossBottomSheet
        _ComponentShowcase(
          name: 'TossBottomSheet',
          description: 'Simple bottom sheet with action items',
          filename: 'toss_bottom_sheet.dart',
          child: ElevatedButton.icon(
            onPressed: () => _showBottomSheet(context),
            icon: const Icon(Icons.more_vert, size: 18),
            label: const Text('Show Bottom Sheet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
            ),
          ),
        ),

        // TossSelectionBottomSheet
        _ComponentShowcase(
          name: 'TossSelectionBottomSheet',
          description: 'Selection bottom sheet with search and item selection',
          filename: 'toss_selection_bottom_sheet.dart',
          child: ElevatedButton.icon(
            onPressed: () => _showSelectionSheet(context),
            icon: const Icon(Icons.list, size: 18),
            label: const Text('Show Selection Sheet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.success,
              foregroundColor: TossColors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonVariant(Widget button, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button,
        const SizedBox(height: TossSpacing.space1),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(color: TossColors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildSubHeader(String text) {
    return Text(
      text,
      style: TossTextStyles.caption.copyWith(
        color: TossColors.textTertiary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    TossBottomSheet.show(
      context: context,
      title: 'Select Action',
      content: const Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Text('Choose an option below'),
      ),
      actions: [
        TossActionItem(title: 'Option 1', onTap: () => Navigator.pop(context)),
        TossActionItem(title: 'Option 2', onTap: () => Navigator.pop(context)),
      ],
    );
  }

  void _showSelectionSheet(BuildContext context) {
    TossSelectionBottomSheet.show(
      context: context,
      title: 'Select Item',
      items: [
        const TossSelectionItem(id: '1', title: 'Item 1', subtitle: 'Description 1', icon: Icons.star),
        const TossSelectionItem(id: '2', title: 'Item 2', subtitle: 'Description 2', icon: Icons.favorite),
      ],
      onItemSelected: (item) => Navigator.pop(context),
    );
  }
}

/// Component showcase with visual example
class _ComponentShowcase extends StatelessWidget {
  const _ComponentShowcase({
    required this.name,
    required this.description,
    required this.filename,
    required this.child,
  });

  final String name;
  final String description;
  final String filename;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TossTextStyles.h4.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          description,
          style: TossTextStyles.body.copyWith(color: TossColors.textSecondary),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          filename,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textTertiary,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        child,
        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }
}
