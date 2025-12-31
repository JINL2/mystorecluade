import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_expandable_card.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final tossExpandableCardComponent = WidgetbookComponent(
  name: 'TossExpandableCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        final isExpanded = context.knobs.boolean(
          label: 'Expanded',
          initialValue: true,
        );

        return Padding(
          padding: const EdgeInsets.all(16),
          child: TossExpandableCard(
            title: context.knobs.string(
              label: 'Title',
              initialValue: 'Transaction Details',
            ),
            isExpanded: isExpanded,
            onToggle: () {},
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: 2024-01-15', style: TossTextStyles.body),
                const SizedBox(height: 8),
                Text('Amount: \$150.00', style: TossTextStyles.body),
                const SizedBox(height: 8),
                Text('Category: Food', style: TossTextStyles.body),
              ],
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Collapsed',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossExpandableCard(
          title: 'Payment Information',
          isExpanded: false,
          onToggle: () {},
          content: const Text('Hidden content'),
        ),
      ),
    ),
  ],
);
