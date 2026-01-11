import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/sheets/avatar_circle.dart';

final avatarCircleComponent = WidgetbookComponent(
  name: 'AvatarCircle',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Center(
        child: AvatarCircle(
          imageUrl: context.knobs.stringOrNull(
            label: 'Image URL',
            initialValue: null,
          ),
          size: context.knobs.double.slider(
            label: 'Size',
            initialValue: 40,
            min: 24,
            max: 80,
          ),
          isSelected: context.knobs.boolean(
            label: 'Selected',
            initialValue: false,
          ),
          fallbackIcon: Icons.person,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With Image',
      builder: (context) => Center(
        child: AvatarCircle(
          imageUrl: 'https://i.pravatar.cc/150?img=1',
          size: context.knobs.double.slider(
            label: 'Size',
            initialValue: 48,
            min: 24,
            max: 80,
          ),
          isSelected: context.knobs.boolean(
            label: 'Selected',
            initialValue: false,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Selected State',
      builder: (context) => Center(
        child: AvatarCircle(
          imageUrl: 'https://i.pravatar.cc/150?img=2',
          size: 48,
          isSelected: true,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Custom Fallback Icon',
      builder: (context) => Center(
        child: AvatarCircle(
          size: 48,
          fallbackIcon: context.knobs.list(
            label: 'Icon',
            options: [Icons.person, Icons.store, Icons.business, Icons.account_circle],
            initialOption: Icons.person,
            labelBuilder: (icon) {
              if (icon == Icons.person) return 'Person';
              if (icon == Icons.store) return 'Store';
              if (icon == Icons.business) return 'Business';
              return 'Account';
            },
          ),
        ),
      ),
    ),
  ],
);
