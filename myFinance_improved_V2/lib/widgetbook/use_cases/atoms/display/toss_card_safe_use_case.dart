import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/atoms/display/toss_card_safe.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final tossCardSafeComponent = WidgetbookComponent(
  name: 'TossCardSafe',
  useCases: [
    WidgetbookUseCase(
      name: 'Default (No Animation)',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TossCardSafe(
          onTap: () {},
          enableAnimation: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: TossColors.success),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Memory-Safe Card',
                          style: TossTextStyles.body
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text('No animation for lists',
                          style: TossTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ],
);
