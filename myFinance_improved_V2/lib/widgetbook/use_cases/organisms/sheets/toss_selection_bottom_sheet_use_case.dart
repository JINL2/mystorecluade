import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_selection_bottom_sheet.dart';

final tossSelectionBottomSheetComponent = WidgetbookComponent(
  name: 'TossSelectionBottomSheet',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            TossSelectionBottomSheet.show(
              context: context,
              title: context.knobs.string(
                label: 'Title',
                initialValue: 'Select Store',
              ),
              items: [
                const TossSelectionItem(
                  id: '1',
                  title: 'Store A',
                  subtitle: 'ST001',
                  icon: Icons.store,
                ),
                const TossSelectionItem(
                  id: '2',
                  title: 'Store B',
                  subtitle: 'ST002',
                  icon: Icons.store,
                ),
                const TossSelectionItem(
                  id: '3',
                  title: 'Store C',
                  subtitle: 'ST003',
                  icon: Icons.store,
                ),
              ],
              selectedId: '1',
              onItemSelected: (item) {
                // Handle selection
              },
            );
          },
          child: const Text('Show Selection Sheet'),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Search',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            TossSelectionBottomSheet.show(
              context: context,
              title: 'Select Account',
              showSearch: true,
              maxHeightFraction: 0.7,
              items: [
                const TossSelectionItem(
                  id: '1',
                  title: 'Cash Account',
                  subtitle: 'Asset',
                  icon: Icons.account_balance_wallet,
                ),
                const TossSelectionItem(
                  id: '2',
                  title: 'Bank Account',
                  subtitle: 'Asset',
                  icon: Icons.account_balance,
                ),
                const TossSelectionItem(
                  id: '3',
                  title: 'Sales Revenue',
                  subtitle: 'Income',
                  icon: Icons.trending_up,
                ),
                const TossSelectionItem(
                  id: '4',
                  title: 'Office Supplies',
                  subtitle: 'Expense',
                  icon: Icons.inventory,
                ),
              ],
              onItemSelected: (item) {},
            );
          },
          child: const Text('Show With Search'),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Avatar',
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () {
            TossSelectionBottomSheet.show(
              context: context,
              title: 'Select Employee',
              items: [
                const TossSelectionItem(
                  id: '1',
                  title: 'John Doe',
                  subtitle: 'Manager',
                  avatarUrl: 'https://i.pravatar.cc/150?img=1',
                ),
                const TossSelectionItem(
                  id: '2',
                  title: 'Jane Smith',
                  subtitle: 'Developer',
                  avatarUrl: 'https://i.pravatar.cc/150?img=2',
                ),
                const TossSelectionItem(
                  id: '3',
                  title: 'Bob Wilson',
                  subtitle: 'Designer',
                  avatarUrl: 'https://i.pravatar.cc/150?img=3',
                ),
              ],
              onItemSelected: (item) {},
            );
          },
          child: const Text('Show With Avatars'),
        ),
      ),
    ),
  ],
);
