import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/info_row.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final infoRowComponent = WidgetbookComponent(
  name: 'InfoRow',
  useCases: [
    WidgetbookUseCase(
      name: 'Fixed Width',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow.fixed(
              label: context.knobs.string(
                label: 'Label',
                initialValue: 'Name',
              ),
              value: context.knobs.string(
                label: 'Value',
                initialValue: 'John Doe',
              ),
              labelWidth: context.knobs.double.slider(
                label: 'Label Width',
                initialValue: 80,
                min: 60,
                max: 150,
              ),
              showEmptyStyle: context.knobs.boolean(
                label: 'Show Empty Style',
                initialValue: false,
              ),
            ),
            const SizedBox(height: 12),
            InfoRow.fixed(
              label: 'Email',
              value: 'john@example.com',
            ),
            const SizedBox(height: 12),
            InfoRow.fixed(
              label: 'Status',
              value: 'Active',
              valueColor: TossColors.success,
            ),
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Space Between',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InfoRow.between(
              label: context.knobs.string(
                label: 'Label',
                initialValue: 'Base Pay',
              ),
              value: context.knobs.string(
                label: 'Value',
                initialValue: '500,000',
              ),
              isTotal: context.knobs.boolean(
                label: 'Is Total',
                initialValue: false,
              ),
            ),
            const SizedBox(height: 12),
            InfoRow.between(
              label: 'Bonus',
              value: '100,000',
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: TossColors.gray100),
            const SizedBox(height: 12),
            InfoRow.between(
              label: 'Total Payment',
              value: '600,000',
              isTotal: true,
            ),
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Change (Original Value)',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InfoRow.between(
              label: 'Confirmed Time',
              value: context.knobs.string(
                label: 'New Value',
                initialValue: '8h 30m',
              ),
              originalValue: context.knobs.string(
                label: 'Original Value',
                initialValue: '8h 00m',
              ),
            ),
            const SizedBox(height: 12),
            InfoRow.between(
              label: 'Base Pay',
              value: '550,000',
              originalValue: '500,000',
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: TossColors.gray100),
            const SizedBox(height: 12),
            InfoRow.between(
              label: 'Total Payment',
              value: '650,000',
              originalValue: '600,000',
              isTotal: true,
            ),
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Trailing Widget',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InfoRow.fixed(
              label: 'Account',
              value: '123-456-789',
              trailing: IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
            const SizedBox(height: 16),
            InfoRow.between(
              label: 'Status',
              value: 'Pending',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: TossColors.warning,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Review',
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
  ],
);
