import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:myfinance_improved/shared/widgets/ai_chat/presentation/widgets/chat_input_field.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

final chatInputFieldComponent = WidgetbookComponent(
  name: 'ChatInputField',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Container(
        color: TossColors.surface,
        child: ChatInputField(
          onSend: (text) {},
          isLoading: context.knobs.boolean(
            label: 'Loading',
            initialValue: false,
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Loading State',
      builder: (context) => Container(
        color: TossColors.surface,
        child: ChatInputField(
          onSend: (text) {},
          isLoading: true,
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Interactive',
      builder: (context) => const _InteractiveChatInputDemo(),
    ),
  ],
);

class _InteractiveChatInputDemo extends StatefulWidget {
  const _InteractiveChatInputDemo();

  @override
  State<_InteractiveChatInputDemo> createState() => _InteractiveChatInputDemoState();
}

class _InteractiveChatInputDemoState extends State<_InteractiveChatInputDemo> {
  String _lastMessage = '';
  bool _isLoading = false;

  void _handleSend(String text) {
    setState(() {
      _lastMessage = text;
      _isLoading = true;
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_lastMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Last sent: $_lastMessage',
                style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
              ),
            ),
          ChatInputField(
            onSend: _handleSend,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
