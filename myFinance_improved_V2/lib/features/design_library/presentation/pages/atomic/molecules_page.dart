import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
// Buttons
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toggle_button.dart';
import 'package:myfinance_improved/shared/widgets/molecules/buttons/toss_fab.dart';
// Cards
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_expandable_card.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_white_card.dart';
// Inputs
import 'package:myfinance_improved/shared/widgets/molecules/inputs/toss_dropdown.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/toss_quantity_input.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/toss_quantity_stepper.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/category_chip.dart';
import 'package:myfinance_improved/shared/widgets/molecules/inputs/toss_enhanced_text_field.dart';
// Keyboard
import 'package:myfinance_improved/shared/widgets/molecules/keyboard/toss_keyboard_toolbar.dart';
// Navigation
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/molecules/navigation/toss_tab_bar_1.dart';
// Display
import 'package:myfinance_improved/shared/widgets/molecules/display/avatar_stack_interact.dart';
// Menus
import 'package:myfinance_improved/shared/widgets/molecules/menus/safe_popup_menu.dart';

/// Molecules Page - Atoms를 조합한 중간 단위 컴포넌트
///
/// Buttons, Cards, Inputs, Navigation, Display, Menus 카테고리로 구성
class MoleculesPage extends StatefulWidget {
  const MoleculesPage({super.key});

  @override
  State<MoleculesPage> createState() => MoleculesPageState();
}

class MoleculesPageState extends State<MoleculesPage>
    with SingleTickerProviderStateMixin {
  // Interactive states
  String _toggleId = 'day';
  bool _isExpanded = false;
  String? _dropdownValue;
  int _quantity = 1;
  int _stepperQuantity = 0;
  int _tabIndex = 0;
  TabController? _tabController;
  String? _highlightedWidget;

  // Scroll controller for programmatic scrolling
  final ScrollController _scrollController = ScrollController();

  // Widget keys for scrolling
  final Map<String, GlobalKey> _widgetKeys = {};

  GlobalKey _getKeyForWidget(String name) {
    return _widgetKeys.putIfAbsent(name, () => GlobalKey());
  }

  /// Scroll to a specific widget by name. Returns true if successful.
  bool scrollToWidget(String widgetName) {
    // First try exact match
    var key = _widgetKeys[widgetName];

    // If not found, try to find by base name (for variants)
    if (key?.currentContext == null) {
      for (final entry in _widgetKeys.entries) {
        if (entry.key.split(' ').first == widgetName) {
          key = entry.value;
          break;
        }
      }
    }

    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
      setState(() => _highlightedWidget = widgetName);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _highlightedWidget = null);
      });
      return true;
    }
    return false;
  }

  // Category chips
  List<CategoryChipItem> _selectedCategories = [
    const CategoryChipItem(id: '1', label: 'Finance'),
    const CategoryChipItem(id: '2', label: 'Work'),
  ];

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  void _initTabController() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      if (!_tabController!.indexIsChanging) {
        setState(() => _tabIndex = _tabController!.index);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildSectionHeader('Buttons', Icons.toggle_on),
        _buildButtonsSection(),

        const SizedBox(height: TossSpacing.space6),
        _buildSectionHeader('Cards', Icons.credit_card),
        _buildCardsSection(),

        const SizedBox(height: TossSpacing.space6),
        _buildSectionHeader('Inputs', Icons.input),
        _buildInputsSection(),

        const SizedBox(height: TossSpacing.space6),
        _buildSectionHeader('Navigation', Icons.navigation),
        _buildNavigationSection(),

        const SizedBox(height: TossSpacing.space6),
        _buildSectionHeader('Display', Icons.visibility),
        _buildDisplaySection(),

        const SizedBox(height: TossSpacing.space6),
        _buildSectionHeader('Menus', Icons.menu),
        _buildMenusSection(),

        const SizedBox(height: TossSpacing.space6),
        _buildSectionHeader('Keyboard', Icons.keyboard),
        _buildKeyboardSection(),

        const SizedBox(height: TossSpacing.space8),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TossColors.successLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: TossColors.success, size: 20),
          ),
          const SizedBox(width: TossSpacing.space3),
          Text(
            title,
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsSection() {
    return _buildShowcaseCard(
      children: [
        _buildWidgetItem(
          'ToggleButtonGroup (Interactive)',
          'lib/shared/widgets/atoms/buttons/toggle_button.dart',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ToggleButtonGroup(
                items: const [
                  ToggleButtonItem(id: 'day', label: 'Day'),
                  ToggleButtonItem(id: 'week', label: 'Week'),
                  ToggleButtonItem(id: 'month', label: 'Month'),
                ],
                selectedId: _toggleId,
                onToggle: (id) => setState(() => _toggleId = id),
              ),
              const SizedBox(height: 12),
              Text(
                'Selected: ${_toggleId.toUpperCase()}',
                style:
                    TossTextStyles.caption.copyWith(color: TossColors.success),
              ),
            ],
          ),
        ),
        _buildWidgetItem(
          'TossFAB (Simple)',
          'lib/shared/widgets/molecules/buttons/toss_fab.dart',
          Row(
            children: [
              TossFAB(
                icon: Icons.add,
                onPressed: () => _showSnackBar('FAB pressed!'),
              ),
              const SizedBox(width: 16),
              Text('Simple FAB', style: TossTextStyles.caption),
            ],
          ),
        ),
        _buildWidgetItem(
          'TossFAB.expandable (Interactive)',
          'lib/shared/widgets/molecules/buttons/toss_fab.dart',
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: TossFAB.expandable(
                    actions: [
                      TossFABAction(
                        icon: Icons.photo,
                        label: 'Photo',
                        onPressed: () => _showSnackBar('Photo selected'),
                      ),
                      TossFABAction(
                        icon: Icons.edit,
                        label: 'Edit',
                        onPressed: () => _showSnackBar('Edit selected'),
                      ),
                      TossFABAction(
                        icon: Icons.delete,
                        label: 'Delete',
                        onPressed: () => _showSnackBar('Delete selected'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardsSection() {
    return _buildShowcaseCard(
      children: [
        _buildWidgetItem(
          'TossExpandableCard (Interactive)',
          'lib/shared/widgets/molecules/cards/toss_expandable_card.dart',
          TossExpandableCard(
            title: 'Expandable Section',
            isExpanded: _isExpanded,
            onToggle: () => setState(() => _isExpanded = !_isExpanded),
            content: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'This content is hidden until you tap the header. '
                'Great for FAQs, settings, or detailed information.',
                style: TossTextStyles.body,
              ),
            ),
          ),
        ),
        _buildWidgetItem(
          'TossWhiteCard',
          'lib/shared/widgets/molecules/cards/toss_white_card.dart',
          TossWhiteCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('White Card Title',
                      style: TossTextStyles.body
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('This is a simple white card with padding and shadow.',
                      style: TossTextStyles.caption),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputsSection() {
    return _buildShowcaseCard(
      children: [
        _buildWidgetItem(
          'TossDropdown (Interactive)',
          'lib/shared/widgets/molecules/inputs/toss_dropdown.dart',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TossDropdown<String>(
                label: 'Select Category',
                hint: 'Choose one',
                value: _dropdownValue,
                items: const [
                  TossDropdownItem(value: 'income', label: 'Income'),
                  TossDropdownItem(value: 'expense', label: 'Expense'),
                  TossDropdownItem(value: 'transfer', label: 'Transfer'),
                ],
                onChanged: (value) => setState(() => _dropdownValue = value),
              ),
              if (_dropdownValue != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Selected: $_dropdownValue',
                  style:
                      TossTextStyles.caption.copyWith(color: TossColors.success),
                ),
              ],
            ],
          ),
        ),
        _buildWidgetItem(
          'TossQuantityInput (Interactive)',
          'lib/shared/widgets/molecules/inputs/toss_quantity_input.dart',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TossQuantityInput(
                value: _quantity,
                minValue: 1,
                maxValue: 99,
                onChanged: (value) => setState(() => _quantity = value),
              ),
              const SizedBox(height: 12),
              Text(
                'Quantity: $_quantity',
                style:
                    TossTextStyles.caption.copyWith(color: TossColors.success),
              ),
            ],
          ),
        ),
        _buildWidgetItem(
          'TossQuantityStepper (with Stock Change)',
          'lib/shared/widgets/molecules/inputs/toss_quantity_stepper.dart',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TossQuantityStepper(
                initialValue: _stepperQuantity,
                minValue: 0,
                maxValue: 100,
                previousValue: 50,
                stockChangeMode: StockChangeMode.add,
                onChanged: (value) => setState(() => _stepperQuantity = value),
              ),
              const SizedBox(height: 8),
              Text(
                'Shows stock change: 50 → ${50 + _stepperQuantity}',
                style: TossTextStyles.caption.copyWith(color: TossColors.info),
              ),
            ],
          ),
        ),
        _buildWidgetItem(
          'CategoryChip (with Remove)',
          'lib/shared/widgets/molecules/inputs/category_chip.dart',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategoryChipGroup(
                items: _selectedCategories,
                onChipTap: (item) => _showSnackBar('Tapped: ${item.label}'),
                onChipRemove: (item) {
                  setState(() {
                    _selectedCategories = _selectedCategories
                        .where((c) => c.id != item.id)
                        .toList();
                  });
                  _showSnackBar('Removed: ${item.label}');
                },
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategories = [
                      const CategoryChipItem(id: '1', label: 'Finance'),
                      const CategoryChipItem(id: '2', label: 'Work'),
                      const CategoryChipItem(id: '3', label: 'Personal'),
                    ];
                  });
                },
                child: Text(
                  'Reset chips',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildWidgetItem(
          'TossEnhancedTextField',
          'lib/shared/widgets/molecules/inputs/toss_enhanced_text_field.dart',
          const TossEnhancedTextField(
            label: 'Enhanced Field',
            hintText: 'Tap to see keyboard toolbar',
            showKeyboardToolbar: true,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationSection() {
    return _buildShowcaseCard(
      children: [
        _buildWidgetItem(
          'TossAppBar1',
          'lib/shared/widgets/molecules/navigation/toss_app_bar_1.dart',
          Container(
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: TossColors.gray200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TossAppBar1(
                title: 'Sample App Bar',
                automaticallyImplyLeading: false,
                primaryActionText: 'Save',
                onPrimaryAction: () => _showSnackBar('Save pressed'),
              ),
            ),
          ),
        ),
        _buildWidgetItem(
          'TossTabBar1 (Interactive)',
          'lib/shared/widgets/molecules/navigation/toss_tab_bar_1.dart',
          _tabController != null
              ? Column(
                  children: [
                    TossTabBar1(
                      tabs: const ['Cash', 'Bank', 'Vault'],
                      controller: _tabController,
                    ),
                    Text(
                      'Selected: Tab ${_tabIndex + 1}',
                      style: TossTextStyles.caption
                          .copyWith(color: TossColors.success),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        _buildWidgetItem(
          'TossMinimalTabBar',
          'lib/shared/widgets/molecules/navigation/toss_tab_bar_1.dart',
          DefaultTabController(
            length: 3,
            child: Builder(
              builder: (context) {
                return TossMinimalTabBar(
                  tabs: const ['All', 'Income', 'Expense'],
                  controller: DefaultTabController.of(context),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisplaySection() {
    return _buildShowcaseCard(
      children: [
        _buildWidgetItem(
          'AvatarStackInteract (Interactive)',
          'lib/shared/widgets/molecules/display/avatar_stack_interact.dart',
          AvatarStackInteract(
            title: 'Team Members',
            countTextFormat: '{count} members',
            users: const [
              AvatarUser(id: '1', name: 'John Doe', subtitle: 'Manager'),
              AvatarUser(id: '2', name: 'Jane Smith', subtitle: 'Developer'),
              AvatarUser(id: '3', name: 'Bob Wilson', subtitle: 'Designer'),
              AvatarUser(id: '4', name: 'Alice Brown', subtitle: 'Analyst'),
              AvatarUser(id: '5', name: 'Charlie Davis', subtitle: 'Intern'),
            ],
            onUserTap: (user) => _showSnackBar('Selected: ${user.name}'),
          ),
        ),
      ],
    );
  }

  Widget _buildMenusSection() {
    return _buildShowcaseCard(
      children: [
        _buildWidgetItem(
          'SafePopupMenuButton',
          'lib/shared/widgets/molecules/menus/safe_popup_menu.dart',
          SafePopupMenuButton<String>(
            onSelected: (value) => _showSnackBar('Selected: $value'),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
              const PopupMenuItem(value: 'share', child: Text('Share')),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: TossColors.gray300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Tap for menu', style: TossTextStyles.body),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyboardSection() {
    return _buildShowcaseCard(
      children: [
        _buildWidgetItem(
          'TossKeyboardToolbar',
          'lib/shared/widgets/molecules/keyboard/toss_keyboard_toolbar.dart',
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: TossColors.gray200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TossKeyboardToolbar(
              onDone: () => _showSnackBar('Done pressed'),
              onPrevious: () => _showSnackBar('Previous pressed'),
              onNext: () => _showSnackBar('Next pressed'),
              showNavigation: true,
            ),
          ),
        ),
        _buildWidgetItem(
          'KeyboardToolbar1 (Overlay version)',
          'lib/shared/widgets/molecules/inputs/keyboard_toolbar_1.dart',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This toolbar uses Overlay to position above keyboard.',
                style: TossTextStyles.caption,
              ),
              const SizedBox(height: 8),
              Text(
                'Use with KeyboardToolbarController for multi-field navigation.',
                style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShowcaseCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildWidgetItem(String name, String path, Widget widget) {
    // Use full name as key to avoid duplicates
    final baseName = name.split(' ').first;
    final isHighlighted = _highlightedWidget == baseName || _highlightedWidget == name;

    return Container(
      key: _getKeyForWidget(name),
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: isHighlighted ? TossColors.successLight : null,
        border: Border(
          bottom: BorderSide(color: TossColors.gray100),
          left: isHighlighted
              ? BorderSide(color: TossColors.success, width: 3)
              : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isHighlighted ? TossColors.success : TossColors.gray900,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showPathDialog(name, path),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.code, size: 12, color: TossColors.gray500),
                      const SizedBox(width: 4),
                      Text(
                        'Code',
                        style: TossTextStyles.small
                            .copyWith(color: TossColors.gray500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          widget,
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showPathDialog(String name, String path) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name, style: TossTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('File Path:', style: TossTextStyles.caption),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                path,
                style: TossTextStyles.small.copyWith(
                  fontFamily: 'monospace',
                  color: TossColors.gray700,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
