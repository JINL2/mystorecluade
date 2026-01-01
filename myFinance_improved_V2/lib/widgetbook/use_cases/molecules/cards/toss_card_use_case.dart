import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/molecules/cards/toss_card.dart';
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
            child: Text(
              context.knobs.string(
                label: 'Content',
                initialValue: 'Card Content',
              ),
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
            child: Row(
              children: [
                const Icon(Icons.touch_app, color: TossColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tappable Card',
                          style: TossTextStyles.body
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text('Tap to see effect', style: TossTextStyles.caption),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: TossColors.gray400),
              ],
            ),
          ),
        ),
      ),
    ),
  ],
);
