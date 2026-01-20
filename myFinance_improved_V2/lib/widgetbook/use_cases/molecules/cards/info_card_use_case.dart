import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/info_card.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final infoCardComponent = WidgetbookComponent(
  name: 'InfoCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: InfoCard(
          label: context.knobs.string(
            label: 'Label',
            initialValue: 'PI Number',
          ),
          value: context.knobs.string(
            label: 'Value',
            initialValue: 'PI-2024-001',
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Highlight (Primary)',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: InfoCard.highlight(
          label: context.knobs.string(
            label: 'Label',
            initialValue: 'Total Amount',
          ),
          value: context.knobs.string(
            label: 'Value',
            initialValue: '5,000,000',
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Success',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: InfoCard.success(
          label: context.knobs.string(
            label: 'Label',
            initialValue: 'Status',
          ),
          value: context.knobs.string(
            label: 'Value',
            initialValue: 'Completed',
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Error',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: InfoCard.error(
          label: context.knobs.string(
            label: 'Label',
            initialValue: 'Payment Status',
          ),
          value: context.knobs.string(
            label: 'Value',
            initialValue: 'Failed',
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Trailing',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InfoCard(
              label: 'LC Document',
              value: 'LC-2024-0042',
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: TossColors.gray400,
              ),
              onTap: () {},
            ),
            SizedBox(height: TossSpacing.space3),
            InfoCard.highlight(
              label: 'Total Balance',
              value: '12,500,000',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
                child: Text(
                  '+5.2%',
                  style: TossTextStyles.labelSmall.copyWith(
                    color: TossColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Multiple Cards',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InfoCard(
              label: 'Supplier',
              value: 'ABC Trading Co., Ltd.',
            ),
            SizedBox(height: TossSpacing.space2),
            InfoCard(
              label: 'PO Number',
              value: 'PO-2024-0128',
            ),
            SizedBox(height: TossSpacing.space2),
            InfoCard.highlight(
              label: 'Order Amount',
              value: '\$25,000.00',
            ),
          ],
        ),
      ),
    ),
  ],
);
