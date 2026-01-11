import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/widgets/atoms/sheets/icon_container.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final iconContainerComponent = WidgetbookComponent(
  name: 'IconContainer',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Center(
        child: IconContainer(
          icon: context.knobs.list(
            label: 'Icon',
            options: [LucideIcons.home, LucideIcons.user, LucideIcons.settings, LucideIcons.bell],
            initialOption: LucideIcons.home,
            labelBuilder: (icon) {
              if (icon == LucideIcons.home) return 'Home';
              if (icon == LucideIcons.user) return 'User';
              if (icon == LucideIcons.settings) return 'Settings';
              return 'Bell';
            },
          ),
          isSelected: context.knobs.boolean(
            label: 'Selected',
            initialValue: false,
          ),
          size: context.knobs.double.slider(
            label: 'Size',
            initialValue: 40,
            min: 24,
            max: 64,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Selected State',
      builder: (context) => Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const IconContainer(icon: LucideIcons.home, isSelected: false),
            const SizedBox(width: 16),
            const IconContainer(icon: LucideIcons.home, isSelected: true),
          ],
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Custom Colors',
      builder: (context) => Center(
        child: IconContainer(
          icon: LucideIcons.star,
          isSelected: context.knobs.boolean(
            label: 'Selected',
            initialValue: true,
          ),
          selectedColor: TossColors.warning,
          selectedBackgroundColor: TossColors.warning.withOpacity(0.1),
          unselectedColor: TossColors.gray400,
          unselectedBackgroundColor: TossColors.gray100,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Multiple Icons',
      builder: (context) => Center(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            IconContainer(icon: LucideIcons.wallet, isSelected: false),
            IconContainer(icon: LucideIcons.creditCard, isSelected: true),
            IconContainer(icon: LucideIcons.banknote, isSelected: false),
            IconContainer(icon: LucideIcons.piggyBank, isSelected: false),
          ],
        ),
      ),
    ),
  ],
);
