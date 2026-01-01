import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/display/icon_info_row.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final iconInfoRowComponent = WidgetbookComponent(
  name: 'IconInfoRow',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            IconInfoRow(
              icon: Icons.store_outlined,
              label: context.knobs.string(
                label: 'Label',
                initialValue: 'Store',
              ),
              value: context.knobs.string(
                label: 'Value',
                initialValue: 'Main Branch',
              ),
            ),
            const SizedBox(height: 16),
            IconInfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: '2024-01-15',
            ),
            const SizedBox(height: 16),
            IconInfoRow(
              icon: Icons.access_time_outlined,
              label: 'Time',
              value: '09:00 - 18:00',
            ),
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Custom Icon Color',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            IconInfoRow(
              icon: Icons.check_circle_outline,
              label: 'Status',
              value: 'Completed',
              iconColor: TossColors.success,
            ),
            const SizedBox(height: 16),
            IconInfoRow(
              icon: Icons.warning_amber_outlined,
              label: 'Warning',
              value: 'Pending Review',
              iconColor: TossColors.warning,
            ),
            const SizedBox(height: 16),
            IconInfoRow(
              icon: Icons.error_outline,
              label: 'Error',
              value: 'Failed',
              iconColor: TossColors.error,
            ),
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Compact',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            IconInfoRow.compact(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: '+84 123 456 789',
            ),
            const SizedBox(height: 12),
            IconInfoRow.compact(
              icon: Icons.email_outlined,
              label: 'Email',
              value: 'contact@example.com',
            ),
            const SizedBox(height: 12),
            IconInfoRow.compact(
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: '123 Main Street, City',
            ),
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Trailing Action',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            IconInfoRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: '+84 123 456 789',
              trailing: IconButton(
                icon: const Icon(Icons.copy, size: 20),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: TossColors.gray500,
              ),
            ),
            const SizedBox(height: 16),
            IconInfoRow(
              icon: Icons.link_outlined,
              label: 'Website',
              value: 'www.example.com',
              trailing: IconButton(
                icon: const Icon(Icons.open_in_new, size: 20),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: TossColors.primary,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    ),
  ],
);
