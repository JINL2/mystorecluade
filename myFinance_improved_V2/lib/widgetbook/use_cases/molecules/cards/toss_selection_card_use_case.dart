import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_selection_card.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final tossSelectionCardComponent = WidgetbookComponent(
  name: 'TossSelectionCard',
  useCases: [
    // Basic Selection Card
    WidgetbookUseCase(
      name: 'Simple',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TossSelectionCard(
              title: context.knobs.string(
                label: 'Title',
                initialValue: 'Cash Location',
              ),
              icon: Icons.account_balance_wallet,
              isSelected: context.knobs.boolean(
                label: 'Is Selected',
                initialValue: false,
              ),
              onTap: () {},
            ),
            SizedBox(height: TossSpacing.space3),
            TossSelectionCard(
              title: 'Vault A',
              icon: Icons.lock,
              isSelected: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    ),

    // With Description
    WidgetbookUseCase(
      name: 'With Description',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TossSelectionCard(
              title: 'Income',
              description: 'Record incoming money',
              icon: Icons.arrow_downward,
              isSelected: false,
              onTap: () {},
            ),
            SizedBox(height: TossSpacing.space3),
            TossSelectionCard(
              title: 'Expense',
              description: 'Record outgoing money',
              icon: Icons.arrow_upward,
              isSelected: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    ),

    // With Subtitle
    WidgetbookUseCase(
      name: 'With Subtitle',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TossSelectionCard(
              title: 'ABC Company',
              subtitle: '3 stores',
              icon: Icons.business,
              isSelected: false,
              isHighlighted: true,
              onTap: () {},
            ),
            SizedBox(height: TossSpacing.space3),
            TossSelectionCard(
              title: 'XYZ Corp',
              subtitle: '1 store',
              icon: Icons.business,
              isSelected: true,
              isHighlighted: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    ),

    // Factory: Entry Type
    WidgetbookUseCase(
      name: 'Entry Type',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TossSelectionCard.entryType(
              label: 'Expense',
              description: 'Pay or refund expenses',
              icon: Icons.receipt_long_outlined,
              isSelected: true,
              onTap: () {},
            ),
            SizedBox(height: TossSpacing.space3),
            TossSelectionCard.entryType(
              label: 'Debt',
              description: 'Lend or borrow money',
              icon: Icons.handshake_outlined,
              isSelected: false,
              onTap: () {},
            ),
            SizedBox(height: TossSpacing.space3),
            TossSelectionCard.entryType(
              label: 'Transfer',
              description: 'Move cash between locations',
              icon: Icons.sync_alt,
              isSelected: false,
              isHighlighted: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    ),

    // Factory: Store
    WidgetbookUseCase(
      name: 'Store Selection',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TossSelectionCard.store(
              storeName: 'Main Branch',
              isSelected: true,
              onTap: () {},
            ),
            SizedBox(height: TossSpacing.space3),
            TossSelectionCard.store(
              storeName: 'Downtown Store',
              isSelected: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    ),

    // Factory: Company
    WidgetbookUseCase(
      name: 'Company Selection',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TossSelectionCard.company(
              companyName: 'ABC Holdings',
              storeCount: 5,
              isSelected: false,
              onTap: () {},
            ),
            SizedBox(height: TossSpacing.space3),
            TossSelectionCard.company(
              companyName: 'XYZ Corporation',
              storeCount: 1,
              isSelected: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    ),
  ],
);

final tossSummaryCardComponent = WidgetbookComponent(
  name: 'TossSummaryCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TossSummaryCard(
              icon: Icons.account_balance_wallet,
              label: 'Cash Location',
              value: 'Main Vault',
            ),
            SizedBox(height: TossSpacing.space3),
            TossSummaryCard(
              icon: Icons.store,
              label: 'Store',
              value: 'Downtown Branch',
              onEdit: () {},
            ),
          ],
        ),
      ),
    ),
  ],
);

final tossNoticeCardComponent = WidgetbookComponent(
  name: 'TossNoticeCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Variants',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TossNoticeCard.warning(
              message: 'This transfer will create a debt entry.',
            ),
            SizedBox(height: TossSpacing.space3),
            TossNoticeCard.info(
              message: 'You can edit this later in settings.',
            ),
            SizedBox(height: TossSpacing.space3),
            TossNoticeCard.success(
              message: 'Transaction completed successfully.',
            ),
            SizedBox(height: TossSpacing.space3),
            TossNoticeCard.error(
              message: 'Failed to process transaction.',
            ),
          ],
        ),
      ),
    ),
  ],
);

final tossTransferArrowComponent = WidgetbookComponent(
  name: 'TossTransferArrow',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        color: TossColors.white,
        child: const Column(
          children: [
            Text('From: Vault A'),
            TossTransferArrow(),
            Text('To: Vault B'),
          ],
        ),
      ),
    ),
  ],
);
