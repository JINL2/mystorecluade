import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// Toss widgets
import 'package:myfinance_improved/shared/widgets/toss/toss_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_text_field.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_search_field.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_quantity_input.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_chip.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_card.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_card_safe.dart';
import 'package:myfinance_improved/shared/widgets/toss/category_chip.dart';

import '../component_showcase.dart';

/// Core Widgets Page - Buttons, Inputs, Display, Containers
class CoreWidgetsPage extends StatefulWidget {
  const CoreWidgetsPage({super.key});

  @override
  State<CoreWidgetsPage> createState() => _CoreWidgetsPageState();
}

class _CoreWidgetsPageState extends State<CoreWidgetsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedChip;
  String? _selectedDropdown;
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<CategoryChipItem> _categoryChips = [
    const CategoryChipItem(id: '1', label: 'Food & Drinks', icon: Icons.restaurant),
    const CategoryChipItem(id: '2', label: 'Transportation', icon: Icons.directions_car),
    const CategoryChipItem(id: '3', label: 'Shopping', icon: Icons.shopping_bag),
  ];

  int _quantity1 = 5;
  int _quantity2 = 10;

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
        // Section: Buttons
        _buildSectionHeader('Buttons', Icons.smart_button),

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

        // Section: Inputs
        _buildSectionHeader('Inputs', Icons.input),

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

        // Section: Display
        _buildSectionHeader('Display', Icons.view_agenda),

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

        // Section: Containers
        _buildSectionHeader('Containers', Icons.dashboard),

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

        const SizedBox(height: TossSpacing.space8),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: TossSpacing.space4, bottom: TossSpacing.space2),
      child: Row(
        children: [
          Icon(icon, size: 20, color: TossColors.primary),
          const SizedBox(width: TossSpacing.space2),
          Text(
            title,
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
        ],
      ),
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
