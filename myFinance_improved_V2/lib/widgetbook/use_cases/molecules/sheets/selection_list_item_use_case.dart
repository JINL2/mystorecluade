import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/widgets/molecules/sheets/selection_list_item.dart';
import 'package:myfinance_improved/shared/models/selection_item.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final selectionListItemComponent = WidgetbookComponent(
  name: 'SelectionListItem',
  useCases: [
    WidgetbookUseCase(
      name: 'Standard',
      builder: (context) => Container(
        color: TossColors.white,
        child: SelectionListItem(
          item: SelectionItem(
            id: '1',
            title: context.knobs.string(
              label: 'Title',
              initialValue: 'Account Name',
            ),
            subtitle: context.knobs.stringOrNull(
              label: 'Subtitle',
              initialValue: 'Account details here',
            ),
            icon: LucideIcons.wallet,
          ),
          isSelected: context.knobs.boolean(
            label: 'Selected',
            initialValue: false,
          ),
          variant: context.knobs.list(
            label: 'Variant',
            options: SelectionItemVariant.values,
            initialOption: SelectionItemVariant.standard,
            labelBuilder: (v) => v.name,
          ),
          showDivider: context.knobs.boolean(
            label: 'Show Divider',
            initialValue: false,
          ),
          onTap: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Variants Comparison',
      builder: (context) => Container(
        color: TossColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Standard', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SelectionListItem(
              item: const SelectionItem(
                id: '1',
                title: 'Cash Account',
                subtitle: 'Main store cash',
                icon: LucideIcons.wallet,
              ),
              variant: SelectionItemVariant.standard,
              isSelected: true,
              onTap: () {},
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Minimal', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SelectionListItem(
              item: const SelectionItem(
                id: '2',
                title: 'Bank Account',
              ),
              variant: SelectionItemVariant.minimal,
              onTap: () {},
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Avatar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SelectionListItem(
              item: const SelectionItem(
                id: '3',
                title: 'John Doe',
                subtitle: 'Employee',
                avatarUrl: 'https://i.pravatar.cc/150?img=1',
              ),
              variant: SelectionItemVariant.avatar,
              onTap: () {},
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Compact', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SelectionListItem(
              item: const SelectionItem(
                id: '4',
                title: 'Quick Option',
                subtitle: 'Less padding',
                icon: LucideIcons.zap,
              ),
              variant: SelectionItemVariant.compact,
              onTap: () {},
            ),
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Selection List',
      builder: (context) => const _SelectionListDemo(),
    ),
  ],
);

class _SelectionListDemo extends StatefulWidget {
  const _SelectionListDemo();

  @override
  State<_SelectionListDemo> createState() => _SelectionListDemoState();
}

class _SelectionListDemoState extends State<_SelectionListDemo> {
  String? _selectedId;

  final _items = const [
    SelectionItem(id: '1', title: 'Cash', subtitle: 'Main cash register', icon: LucideIcons.banknote),
    SelectionItem(id: '2', title: 'Bank', subtitle: 'Business account', icon: LucideIcons.building),
    SelectionItem(id: '3', title: 'Vault', subtitle: 'Safe deposit', icon: LucideIcons.lock),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _items.map((item) => SelectionListItem(
          item: item,
          isSelected: _selectedId == item.id,
          showDivider: true,
          onTap: () => setState(() => _selectedId = item.id),
        )).toList(),
      ),
    );
  }
}
