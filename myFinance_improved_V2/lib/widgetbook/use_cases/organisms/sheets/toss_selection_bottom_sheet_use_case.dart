import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_selection_bottom_sheet.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final tossSelectionBottomSheetComponent = WidgetbookComponent(
  name: 'TossSelectionBottomSheet',
  useCases: [
    // Basic Selection
    WidgetbookUseCase(
      name: 'Basic Selection',
      builder: (context) => _SelectionDemo(
        buttonText: 'Show Basic Selection',
        title: 'Select Category',
        items: const [
          TossSelectionItem(id: '1', title: 'Food & Dining'),
          TossSelectionItem(id: '2', title: 'Transportation'),
          TossSelectionItem(id: '3', title: 'Shopping'),
          TossSelectionItem(id: '4', title: 'Entertainment'),
          TossSelectionItem(id: '5', title: 'Bills & Utilities'),
        ],
      ),
    ),

    // With Icons
    WidgetbookUseCase(
      name: 'With Icons',
      builder: (context) => _SelectionDemo(
        buttonText: 'Show With Icons',
        title: 'Select Payment Method',
        items: const [
          TossSelectionItem(
            id: '1',
            title: 'Credit Card',
            subtitle: 'Visa ending in 4242',
            icon: LucideIcons.creditCard,
          ),
          TossSelectionItem(
            id: '2',
            title: 'Bank Transfer',
            subtitle: 'Account ending in 1234',
            icon: LucideIcons.building,
          ),
          TossSelectionItem(
            id: '3',
            title: 'Cash',
            subtitle: 'Pay in store',
            icon: LucideIcons.banknote,
          ),
          TossSelectionItem(
            id: '4',
            title: 'Mobile Pay',
            subtitle: 'Apple Pay, Google Pay',
            icon: LucideIcons.smartphone,
          ),
        ],
      ),
    ),

    // With Search
    WidgetbookUseCase(
      name: 'With Search',
      builder: (context) => _SelectionDemo(
        buttonText: 'Show With Search',
        title: 'Select Store',
        showSearch: true,
        maxHeightFraction: 0.7,
        items: List.generate(
          20,
          (index) => TossSelectionItem(
            id: '${index + 1}',
            title: 'Store ${index + 1}',
            subtitle: 'Location ${String.fromCharCode(65 + (index % 26))}',
            icon: LucideIcons.store,
          ),
        ),
      ),
    ),

    // With Avatars
    WidgetbookUseCase(
      name: 'With Avatars',
      builder: (context) => _SelectionDemo(
        buttonText: 'Show With Avatars',
        title: 'Select Employee',
        items: const [
          TossSelectionItem(
            id: '1',
            title: 'John Doe',
            subtitle: 'Manager',
            avatarUrl: 'https://i.pravatar.cc/150?img=1',
          ),
          TossSelectionItem(
            id: '2',
            title: 'Jane Smith',
            subtitle: 'Cashier',
            avatarUrl: 'https://i.pravatar.cc/150?img=2',
          ),
          TossSelectionItem(
            id: '3',
            title: 'Bob Wilson',
            subtitle: 'Supervisor',
            avatarUrl: 'https://i.pravatar.cc/150?img=3',
          ),
          TossSelectionItem(
            id: '4',
            title: 'Alice Brown',
            subtitle: 'Staff',
            avatarUrl: 'https://i.pravatar.cc/150?img=4',
          ),
        ],
      ),
    ),

    // Customized Style
    WidgetbookUseCase(
      name: 'Customized Style',
      builder: (context) => _SelectionDemo(
        buttonText: 'Show Customized',
        title: 'Select Account',
        showIcon: false,
        showSelectedBackground: false,
        selectedFontWeight: FontWeight.w700,
        unselectedFontWeight: FontWeight.w500,
        checkIcon: LucideIcons.checkCircle,
        enableHapticFeedback: true,
        items: const [
          TossSelectionItem(id: '1', title: 'Savings Account'),
          TossSelectionItem(id: '2', title: 'Checking Account'),
          TossSelectionItem(id: '3', title: 'Business Account'),
        ],
      ),
    ),

    // Store Selector Helper
    WidgetbookUseCase(
      name: 'Store Selector (Helper)',
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final stores = [
                {'store_id': 1, 'store_name': 'Main Store', 'store_code': 'MS001'},
                {'store_id': 2, 'store_name': 'Branch A', 'store_code': 'BA001'},
                {'store_id': 3, 'store_name': 'Branch B', 'store_code': 'BB001'},
              ];

              final selected = await TossStoreSelector.show(
                context: context,
                stores: stores,
                title: 'Select Store',
              );

              if (selected != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: ${selected['store_name']}')),
                );
              }
            },
            child: const Text('Show Store Selector'),
          ),
        ),
      ),
    ),
  ],
);

/// Helper widget to manage selection state for demo
class _SelectionDemo extends StatefulWidget {
  final String buttonText;
  final String title;
  final List<TossSelectionItem> items;
  final bool showSearch;
  final double maxHeightFraction;
  final bool showIcon;
  final bool showSelectedBackground;
  final FontWeight selectedFontWeight;
  final FontWeight unselectedFontWeight;
  final IconData checkIcon;
  final bool enableHapticFeedback;

  const _SelectionDemo({
    required this.buttonText,
    required this.title,
    required this.items,
    this.showSearch = false,
    this.maxHeightFraction = 0.5,
    this.showIcon = true,
    this.showSelectedBackground = true,
    this.selectedFontWeight = FontWeight.w600,
    this.unselectedFontWeight = FontWeight.w400,
    this.checkIcon = LucideIcons.check,
    this.enableHapticFeedback = false,
  });

  @override
  State<_SelectionDemo> createState() => _SelectionDemoState();
}

class _SelectionDemoState extends State<_SelectionDemo> {
  String? _selectedId;
  String? _selectedTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedTitle != null) ...[
              Text(
                'Selected: $_selectedTitle',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
            ],
            ElevatedButton(
              onPressed: () async {
                await TossSelectionBottomSheet.show(
                  context: context,
                  title: widget.title,
                  items: widget.items,
                  selectedId: _selectedId,
                  showSearch: widget.showSearch,
                  maxHeightFraction: widget.maxHeightFraction,
                  showIcon: widget.showIcon,
                  showSelectedBackground: widget.showSelectedBackground,
                  selectedFontWeight: widget.selectedFontWeight,
                  unselectedFontWeight: widget.unselectedFontWeight,
                  checkIcon: widget.checkIcon,
                  enableHapticFeedback: widget.enableHapticFeedback,
                  onItemSelected: (item) {
                    setState(() {
                      _selectedId = item.id;
                      _selectedTitle = item.title;
                    });
                  },
                );
              },
              child: Text(widget.buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
