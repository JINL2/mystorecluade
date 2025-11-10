import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ai_chat/presentation/providers/ai_chat_providers.dart';
import '../../themes/toss_border_radius.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_spacing.dart';
import '../../themes/toss_text_styles.dart';
import 'chat_bubble.dart';
import 'chat_input_field.dart';
import 'typing_indicator.dart';

class AiChatBottomSheet extends ConsumerStatefulWidget {
  final String featureName;
  final String sessionId;
  final Map<String, dynamic>? pageContext;
  final String? featureId;

  const AiChatBottomSheet({
    super.key,
    required this.featureName,
    required this.sessionId,
    this.pageContext,
    this.featureId,
  });

  @override
  ConsumerState<AiChatBottomSheet> createState() => _AiChatBottomSheetState();
}

class _AiChatBottomSheetState extends ConsumerState<AiChatBottomSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiChatProvider(widget.sessionId));
    final notifier = ref.read(aiChatProvider(widget.sessionId).notifier);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    ref.listen(aiChatProvider(widget.sessionId), (previous, next) {
      // Scroll to bottom when history loading completes
      if (previous?.isLoadingHistory == true && next.isLoadingHistory == false) {
        _scrollToBottom();
      }
      // Scroll to bottom when new message is added
      if (next.messages.length > (previous?.messages.length ?? 0)) {
        _scrollToBottom();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: TossColors.error,
          ),
        );
        notifier.clearError();
      }
    });

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      duration: const Duration(milliseconds: 100),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.bottomSheet),
                topRight: Radius.circular(TossBorderRadius.bottomSheet),
              ),
            ),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: state.isLoadingHistory
                      ? _buildLoadingState()
                      : state.messages.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(
                                vertical: TossSpacing.space4,
                              ),
                              itemCount: state.messages.length + (state.isLoading ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == state.messages.length) {
                                  return const TypingIndicator();
                                }
                                return ChatBubble(message: state.messages[index]);
                              },
                            ),
                ),
                ChatInputField(
                  onSend: (text) => notifier.sendMessage(
                    text,
                    featureName: widget.featureName,
                    pageContext: widget.pageContext,
                    featureId: widget.featureId,
                  ),
                  isLoading: state.isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: TossColors.gray300, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.smart_toy, color: TossColors.primary),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.textPrimary,
                  ),
                ),
                Text(
                  widget.featureName,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: TossColors.textSecondary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: TossColors.primary,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'Loading chat history...',
            style: TossTextStyles.body.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'Ask about ${widget.featureName}',
            style: TossTextStyles.body.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
