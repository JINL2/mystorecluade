import 'package:flutter/material.dart';

import '../../../../themes/toss_colors.dart';
import '../../../../themes/toss_spacing.dart';

class ChatInputField extends StatefulWidget {
  final void Function(String) onSend;
  final bool isLoading;

  const ChatInputField({
    super.key,
    required this.onSend,
    required this.isLoading,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isLoading) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: const BoxDecoration(
        color: TossColors.surface,
        border: Border(
          top: BorderSide(color: TossColors.gray300, width: 1),
        ),
      ),
      child: SafeArea(
        child: TextField(
          controller: _controller,
          enabled: !widget.isLoading,
          decoration: InputDecoration(
            hintText: 'Ask about your store...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: TossColors.gray300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: TossColors.gray300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: TossColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
          ),
          maxLines: null,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => _handleSend(),
        ),
      ),
    );
  }
}
