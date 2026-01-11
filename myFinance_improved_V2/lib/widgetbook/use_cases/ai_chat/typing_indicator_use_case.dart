import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/ai_chat/presentation/widgets/typing_indicator.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final typingIndicatorComponent = WidgetbookComponent(
  name: 'TypingIndicator',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Container(
        color: TossColors.surface,
        padding: const EdgeInsets.all(16),
        child: const TypingIndicator(),
      ),
    ),
    WidgetbookUseCase(
      name: 'In Chat Context',
      builder: (context) => Container(
        color: TossColors.surface,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User message
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(16).copyWith(
                    bottomRight: const Radius.circular(4),
                  ),
                ),
                child: Text(
                  'How are my sales today?',
                  style: TossTextStyles.body.copyWith(color: TossColors.white),
                ),
              ),
            ),
            // AI typing
            const TypingIndicator(),
          ],
        ),
      ),
    ),
  ],
);
