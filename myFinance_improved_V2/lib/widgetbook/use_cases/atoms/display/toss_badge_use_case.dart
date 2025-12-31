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
            initialValue: 'New',
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Icon',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: TossBadge(
          label: 'Verified',
          icon: Icons.check_circle,
          backgroundColor: TossColors.successLight,
          textColor: TossColors.success,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Error',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: TossBadge(
          label: 'Failed',
          backgroundColor: TossColors.errorLight,
          textColor: TossColors.error,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Primary',
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16),
        child: TossBadge(
          label: 'Active',
          backgroundColor: TossColors.primarySurface,
          textColor: TossColors.primary,
        ),
      ),
    ),
  ],
);
