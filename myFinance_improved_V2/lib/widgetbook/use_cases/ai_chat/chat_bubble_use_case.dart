import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/ai_chat/presentation/widgets/chat_bubble.dart';
import 'package:myfinance_improved/shared/widgets/ai_chat/domain/models/chat_message.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final chatBubbleComponent = WidgetbookComponent(
  name: 'ChatBubble',
  useCases: [
    WidgetbookUseCase(
      name: 'User Message',
      builder: (context) => Container(
        color: TossColors.surface,
        padding: const EdgeInsets.all(16),
        child: ChatBubble(
          message: ChatMessage(
            id: '1',
            content: context.knobs.string(
              label: 'Message',
              initialValue: 'How much revenue did we make today?',
            ),
            isUser: true,
            timestamp: DateTime.now(),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'AI Message',
      builder: (context) => Container(
        color: TossColors.surface,
        padding: const EdgeInsets.all(16),
        child: ChatBubble(
          message: ChatMessage(
            id: '2',
            content: context.knobs.string(
              label: 'Message',
              initialValue: 'Based on your sales data, today\'s revenue is **₩2,500,000**. This is 15% higher than yesterday.',
            ),
            isUser: false,
            timestamp: DateTime.now(),
          ),
          isStreaming: context.knobs.boolean(
            label: 'Streaming',
            initialValue: false,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'AI with Result Data',
      builder: (context) => Container(
        color: TossColors.surface,
        padding: const EdgeInsets.all(16),
        child: ChatBubble(
          message: ChatMessage(
            id: '3',
            content: 'Here are your top selling products today:',
            isUser: false,
            timestamp: DateTime.now(),
            resultData: [
              {'product': 'Coffee', 'quantity': 50, 'revenue': 250000},
              {'product': 'Cake', 'quantity': 30, 'revenue': 180000},
              {'product': 'Sandwich', 'quantity': 25, 'revenue': 125000},
            ],
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Streaming State',
      builder: (context) => Container(
        color: TossColors.surface,
        padding: const EdgeInsets.all(16),
        child: ChatBubble(
          message: ChatMessage(
            id: '4',
            content: 'Analyzing your sales data',
            isUser: false,
            timestamp: DateTime.now(),
          ),
          isStreaming: true,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Conversation',
      builder: (context) => Container(
        color: TossColors.surface,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChatBubble(
              message: ChatMessage(
                id: '1',
                content: 'Show me today\'s sales summary',
                isUser: true,
                timestamp: DateTime.now(),
              ),
            ),
            const SizedBox(height: 8),
            ChatBubble(
              message: ChatMessage(
                id: '2',
                content: '''Here's your sales summary for today:

- **Total Revenue**: ₩2,500,000
- **Transactions**: 150
- **Average Order**: ₩16,667

Your best selling category is **Beverages** with 45% of sales.''',
                isUser: false,
                timestamp: DateTime.now(),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
);
