import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_badge.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final tossBadgeComponent = WidgetbookComponent(
  name: 'TossBadge',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossBadge(
          label: context.knobs.string(
            label: 'Label',
            initialValue: 'Badge',
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Status Badges',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            TossBadge(
              label: 'Success',
              backgroundColor: TossColors.successLight,
              textColor: TossColors.success,
            ),
            TossBadge(
              label: 'Warning',
              backgroundColor: TossColors.warningLight,
              textColor: TossColors.warning,
            ),
            TossBadge(
              label: 'Error',
              backgroundColor: TossColors.errorLight,
              textColor: TossColors.error,
            ),
            TossBadge(
              label: 'Info',
              backgroundColor: TossColors.infoLight,
              textColor: TossColors.info,
            ),
          ],
        ),
      ),
    ),
  ],
);

final tossStatusBadgeComponent = WidgetbookComponent(
  name: 'TossStatusBadge',
  useCases: [
    WidgetbookUseCase(
      name: 'All Statuses',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            TossStatusBadge(label: 'Success', status: BadgeStatus.success),
            TossStatusBadge(label: 'Warning', status: BadgeStatus.warning),
            TossStatusBadge(label: 'Error', status: BadgeStatus.error),
            TossStatusBadge(label: 'Info', status: BadgeStatus.info),
          ],
        ),
      ),
    ),
  ],
);
