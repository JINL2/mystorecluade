import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

// Note: AI widgets require complex state management and external services.
// They are shown here as placeholder components to demonstrate the widget catalog.

final aiDirectory = WidgetbookCategory(
  name: 'AI Widgets (9)',
  children: [
    WidgetbookFolder(
      name: 'AI Display (3)',
      children: [
        _aiPlaceholder('AiAnalysisDetailsBox', 'ai/ai_analysis_details_box.dart'),
        _aiPlaceholder('AiDescriptionBox', 'ai/ai_description_box.dart'),
        _aiPlaceholder('AiDescriptionRow', 'ai/ai_description_row.dart'),
      ],
    ),
    WidgetbookFolder(
      name: 'AI Chat (6)',
      children: [
        _aiPlaceholder('AiChatFab', 'ai_chat/presentation/widgets/ai_chat_fab.dart'),
        _aiPlaceholder('AiChatBottomSheet', 'ai_chat/presentation/widgets/ai_chat_bottom_sheet.dart'),
        _aiPlaceholder('ChatBubble', 'ai_chat/presentation/widgets/chat_bubble.dart'),
        _aiPlaceholder('ChatInputField', 'ai_chat/presentation/widgets/chat_input_field.dart'),
        _aiPlaceholder('TypingIndicator', 'ai_chat/presentation/widgets/typing_indicator.dart'),
        _aiPlaceholder('ResultDataCard', 'ai_chat/presentation/widgets/result_data_card.dart'),
      ],
    ),
  ],
);

WidgetbookComponent _aiPlaceholder(String name, String path) {
  return WidgetbookComponent(
    name: name,
    useCases: [
      WidgetbookUseCase(
        name: 'Info',
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.smart_toy, size: 48, color: TossColors.primary),
              const SizedBox(height: 16),
              Text(
                name,
                style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'lib/shared/widgets/$path',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TossColors.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: TossColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'AI widget requires external services.\nTest in the actual app.',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
