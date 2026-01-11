/// Molecules Showcase
///
/// Displays all molecule components from shared/widgets/molecules folder.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/models/selection_item.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/molecules/buttons/toss_fab.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_expandable_card.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_white_card.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_selection_card.dart';
import 'package:myfinance_improved/shared/widgets/molecules/display/icon_info_row.dart';
import 'package:myfinance_improved/shared/widgets/molecules/display/info_card.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/toss_dropdown.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/toss_quantity_input.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/toss_quantity_stepper.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/toss_enhanced_text_field.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/category_chip.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_app_bar.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_tab_bar.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/sheet_header.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/selection_list_item.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/search_field.dart';

class MoleculesShowcase extends StatefulWidget {
  const MoleculesShowcase({super.key});

  @override
  State<MoleculesShowcase> createState() => _MoleculesShowcaseState();
}

class _MoleculesShowcaseState extends State<MoleculesShowcase>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'Buttons',
    'Cards',
    'Display',
    'Inputs',
    'Navigation',
    'Sheets',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: TossColors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: TossColors.primary,
            unselectedLabelColor: TossColors.gray600,
            indicatorColor: TossColors.primary,
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _ButtonsTab(),
              _CardsTab(),
              _DisplayTab(),
              _InputsTab(),
              _NavigationTab(),
              _SheetsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== Buttons Tab ====================
class _ButtonsTab extends StatelessWidget {
  const _ButtonsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'TossFAB',
          'Floating action button with optional expandable actions',
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TossFAB(
                  icon: Icons.add,
                  onPressed: () {},
                ),
                const SizedBox(width: TossSpacing.space4),
                TossFAB(
                  icon: Icons.edit,
                  onPressed: () {},
                  backgroundColor: TossColors.success,
                ),
              ],
            ),
          ),
          atomsUsed: ['TossButton'],
        ),
      ],
    );
  }
}

// ==================== Cards Tab ====================
class _CardsTab extends StatefulWidget {
  const _CardsTab();

  @override
  State<_CardsTab> createState() => _CardsTabState();
}

class _CardsTabState extends State<_CardsTab> {
  bool _isExpanded = false;
  int _selectedCard = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'TossCard',
          'Basic card with optional header and footer',
          TossCard(
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Card Title', style: TossTextStyles.titleMedium),
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    'This is the card content. Cards are used to group related information.',
                    style: TossTextStyles.body,
                  ),
                ],
              ),
            ),
          ),
          atomsUsed: ['TossShadows', 'TossBorderRadius'],
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossWhiteCard',
          'Simple white card with shadow',
          TossWhiteCard(
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: TossColors.primarySurface,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: const Icon(Icons.account_balance, color: TossColors.primary),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bank Account', style: TossTextStyles.bodyMedium),
                        Text(
                          'Main checking account',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$12,500',
                    style: TossTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          atomsUsed: ['TossShadows', 'TossBorderRadius'],
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossExpandableCard',
          'Card that can expand to show more content',
          TossExpandableCard(
            title: 'Transaction Details',
            isExpanded: _isExpanded,
            onToggle: () => setState(() => _isExpanded = !_isExpanded),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow('Date', 'Jan 15, 2026'),
                _infoRow('Amount', '\$250.00'),
                _infoRow('Category', 'Shopping'),
                _infoRow('Status', 'Completed'),
              ],
            ),
          ),
          atomsUsed: ['TossCard', 'InfoRow'],
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossSelectionCard',
          'Card for selection in a list',
          Column(
            children: [
              TossSelectionCard(
                title: 'Option A',
                subtitle: 'First option description',
                icon: Icons.looks_one,
                isSelected: _selectedCard == 0,
                onTap: () => setState(() => _selectedCard = 0),
              ),
              const SizedBox(height: TossSpacing.space2),
              TossSelectionCard(
                title: 'Option B',
                subtitle: 'Second option description',
                icon: Icons.looks_two,
                isSelected: _selectedCard == 1,
                onTap: () => setState(() => _selectedCard = 1),
              ),
              const SizedBox(height: TossSpacing.space2),
              TossSelectionCard(
                title: 'Option C',
                subtitle: 'Third option description',
                icon: Icons.looks_3,
                isSelected: _selectedCard == 2,
                onTap: () => setState(() => _selectedCard = 2),
              ),
            ],
          ),
          atomsUsed: ['IconContainer', 'CheckIndicator'],
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
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
}

// ==================== Display Tab ====================
class _DisplayTab extends StatelessWidget {
  const _DisplayTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'IconInfoRow',
          'Row with icon, label, and value',
          Column(
            children: [
              IconInfoRow(
                icon: Icons.calendar_today,
                label: 'Date',
                value: 'Jan 15, 2026',
              ),
              const SizedBox(height: TossSpacing.space2),
              IconInfoRow(
                icon: Icons.attach_money,
                label: 'Amount',
                value: '\$1,250.00',
              ),
              const SizedBox(height: TossSpacing.space2),
              IconInfoRow(
                icon: Icons.category,
                label: 'Category',
                value: 'Shopping',
              ),
            ],
          ),
          atomsUsed: ['InfoRow', 'IconContainer'],
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'InfoCard',
          'Card with label and value',
          Column(
            children: [
              InfoCard(
                label: 'PI Number',
                value: 'PI-2024-001',
              ),
              const SizedBox(height: TossSpacing.space3),
              InfoCard(
                label: 'Amount',
                value: '5,000,000 VND',
                backgroundColor: TossColors.primarySurface,
              ),
            ],
          ),
          atomsUsed: ['TossCard'],
        ),
      ],
    );
  }
}

// ==================== Inputs Tab ====================
class _InputsTab extends StatefulWidget {
  const _InputsTab();

  @override
  State<_InputsTab> createState() => _InputsTabState();
}

class _InputsTabState extends State<_InputsTab> {
  String? _selectedDropdown;
  int _quantity = 1;
  final _enhancedController = TextEditingController();

  @override
  void dispose() {
    _enhancedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'TossDropdown',
          'Dropdown selector with search',
          TossDropdown<String>(
            label: 'Select Account',
            hint: 'Choose an account',
            value: _selectedDropdown,
            items: [
              TossDropdownItem(value: 'checking', label: 'Checking Account', subtitle: 'Main'),
              TossDropdownItem(value: 'savings', label: 'Savings Account', subtitle: 'Emergency'),
              TossDropdownItem(value: 'business', label: 'Business Account', subtitle: 'Company'),
            ],
            onChanged: (value) => setState(() => _selectedDropdown = value),
          ),
          atomsUsed: ['TossTextField', 'TossBottomSheet'],
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossQuantityInput',
          'Input for numeric quantities',
          Center(
            child: TossQuantityInput(
              value: _quantity,
              onChanged: (value) => setState(() => _quantity = value),
              minValue: 0,
              maxValue: 100,
            ),
          ),
          atomsUsed: ['TossTextField', 'TossButton'],
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossQuantityStepper',
          'Stepper for quantity selection',
          Center(
            child: TossQuantityStepper(
              initialValue: _quantity,
              onChanged: (value) => setState(() => _quantity = value),
              minValue: 0,
              maxValue: 10,
            ),
          ),
          atomsUsed: ['TossButton'],
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossEnhancedTextField',
          'Text field with keyboard toolbar',
          TossEnhancedTextField(
            controller: _enhancedController,
            label: 'Amount',
            hintText: 'Enter amount',
            keyboardType: TextInputType.number,
          ),
          atomsUsed: ['TossTextField'],
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'CategoryChip',
          'Chip for category/tag with optional remove button',
          Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: [
              CategoryChip(
                label: 'Food',
                icon: Icons.restaurant,
                onTap: () {},
              ),
              CategoryChip(
                label: 'Transport',
                icon: Icons.directions_car,
                onTap: () {},
              ),
              CategoryChip(
                label: 'Shopping',
                icon: Icons.shopping_bag,
                onRemove: () {},
              ),
              CategoryChip(
                label: 'Entertainment',
                icon: Icons.movie,
                backgroundColor: TossColors.primarySurface,
                borderColor: TossColors.primary,
                textColor: TossColors.primary,
              ),
            ],
          ),
          atomsUsed: ['TossChip'],
        ),
      ],
    );
  }
}

// ==================== Navigation Tab ====================
class _NavigationTab extends StatefulWidget {
  const _NavigationTab();

  @override
  State<_NavigationTab> createState() => _NavigationTabState();
}

class _NavigationTabState extends State<_NavigationTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'TossAppBar',
          'App bar with back button and actions',
          Container(
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: TossAppBar(
              title: 'Page Title',
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          atomsUsed: ['TossButton'],
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossTabBar',
          'Tab bar for navigation between sections',
          Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: TossTabBar(
              tabs: const ['Overview', 'Transactions', 'Analytics'],
              onTabChanged: (index) {},
            ),
          ),
          atomsUsed: ['TossChip'],
        ),
      ],
    );
  }
}

// ==================== Sheets Tab ====================
class _SheetsTab extends StatefulWidget {
  const _SheetsTab();

  @override
  State<_SheetsTab> createState() => _SheetsTabState();
}

class _SheetsTabState extends State<_SheetsTab> {
  String? _selectedItem;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'SheetHeader',
          'Header for bottom sheets',
          Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.gray200),
            ),
            child: SheetHeader(
              title: 'Select Account',
              onClose: () {},
            ),
          ),
          atomsUsed: ['DragHandle', 'TossButton'],
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'SheetSearchField',
          'Search field for bottom sheets',
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.gray200),
            ),
            child: SheetSearchField(
              controller: _searchController,
              hintText: 'Search accounts...',
            ),
          ),
          atomsUsed: ['TossSearchField'],
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'SelectionListItem',
          'Selectable list item for sheets',
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
                    id: 'checking',
                    title: 'Checking Account',
                    subtitle: 'Main - \$5,250.00',
                  ),
                  isSelected: _selectedItem == 'checking',
                  onTap: () => setState(() => _selectedItem = 'checking'),
                ),
                const Divider(height: 1),
                SelectionListItem(
                  item: const SelectionItem(
                    id: 'savings',
                    title: 'Savings Account',
                    subtitle: 'Emergency - \$12,000.00',
                  ),
                  isSelected: _selectedItem == 'savings',
                  onTap: () => setState(() => _selectedItem = 'savings'),
                ),
                const Divider(height: 1),
                SelectionListItem(
                  item: const SelectionItem(
                    id: 'business',
                    title: 'Business Account',
                    subtitle: 'Company - \$45,000.00',
                  ),
                  isSelected: _selectedItem == 'business',
                  onTap: () => setState(() => _selectedItem = 'business'),
                ),
              ],
            ),
          ),
          atomsUsed: ['AvatarCircle', 'CheckIndicator'],
        ),
      ],
    );
  }
}

// ==================== Helper ====================
Widget _buildComponentCard(
  String title,
  String description,
  Widget child, {
  List<String>? atomsUsed,
}) {
  return Container(
    decoration: BoxDecoration(
      color: TossColors.white,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      border: Border.all(color: TossColors.gray200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TossTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                description,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              if (atomsUsed != null && atomsUsed.isNotEmpty) ...[
                const SizedBox(height: TossSpacing.space2),
                Wrap(
                  spacing: TossSpacing.space1,
                  runSpacing: TossSpacing.space1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, size: 12, color: TossColors.primary),
                    Text(
                      'Uses: ',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ...atomsUsed.map((atom) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.primarySurface,
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Text(
                        atom,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.primary,
                          fontSize: 10,
                        ),
                      ),
                    )),
                  ],
                ),
              ],
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: child,
        ),
      ],
    ),
  );
}
