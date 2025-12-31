import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_card.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final tossCardComponent = WidgetbookComponent(
  name: 'TossCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.knobs.string(
                    label: 'Title',
                    initialValue: 'Card Title',
                  ),
                  style: TossTextStyles.h3,
                ),
                const SizedBox(height: 8),
                Text(
                  context.knobs.string(
                    label: 'Content',
                    initialValue: 'This is the card content.',
                  ),
                  style: TossTextStyles.body,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Tappable',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossCard(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Tap me! I have press animation.',
              style: TossTextStyles.body,
            ),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Custom Background',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossCard(
          backgroundColor: TossColors.primarySurface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Card with custom background',
              style: TossTextStyles.body.copyWith(color: TossColors.primary),
            ),
          ),
        ),
      ),
    ),
  ],
);
