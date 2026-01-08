import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../themes/toss_animations.dart';
import '../../../../themes/toss_border_radius.dart';
import '../../../../themes/toss_colors.dart';
import '../../../../themes/toss_spacing.dart';
import '../../../../themes/toss_text_styles.dart';
import '../../../atoms/feedback/toss_toast.dart';
import '../providers/ai_chat_provider.dart';
import '../providers/ai_chat_state.dart';
import 'chat_bubble.dart';
import 'chat_input_field.dart';
import 'result_data_card.dart';
import 'typing_indicator.dart';

class AiChatBottomSheet extends ConsumerStatefulWidget {
  final String featureName;
  final Map<String, dynamic>? pageContext;
  final String? featureId;

  const AiChatBottomSheet({
    super.key,
    required this.featureName,
    this.pageContext,
    this.featureId,
  });

  @override
  ConsumerState<AiChatBottomSheet> createState() => _AiChatBottomSheetState();
}

class _AiChatBottomSheetState extends ConsumerState<AiChatBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;
  int _lastStreamingLength = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool immediate = false}) {
    if (_scrollController.hasClients && !_isScrolling) {
      _isScrolling = true;

      if (immediate) {
        // Jump immediately for new messages
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
          _isScrolling = false;
        });
      } else {
        // Smooth scroll for streaming
        Future.delayed(TossAnimations.instant, () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: TossAnimations.fast,
              curve: TossAnimations.decelerate,
            );
          }
          _isScrolling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiChatProvider(widget.featureName));
    final notifier = ref.read(aiChatProvider(widget.featureName).notifier);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    ref.listen(aiChatProvider(widget.featureName), (previous, next) {
      // Scroll to bottom when new message is added
      if (next.messages.length > (previous?.messages.length ?? 0)) {
        _scrollToBottom(immediate: true);
      }

      // Scroll to bottom when streaming text grows significantly
      // Only scroll every ~50 characters to avoid excessive scrolling
      if (next.streamingText.isNotEmpty) {
        final currentLength = next.streamingText.length;
        if (currentLength - _lastStreamingLength > 50 ||
            (previous?.streamingText.isEmpty ?? true)) {
          _lastStreamingLength = currentLength;
          _scrollToBottom();
        }
      } else {
        _lastStreamingLength = 0;
      }

      // Scroll when result data arrives
      if (next.currentResultData != null &&
          (previous?.currentResultData == null)) {
        _scrollToBottom(immediate: true);
      }

      // Show error toast
      if (next.error != null) {
        TossToast.error(context, next.error!);
        notifier.clearError();
      }
    });

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      duration: TossAnimations.quick,
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
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
                  child: state.messages.isEmpty && !state.isLoading
                      ? _buildEmptyState()
                      : _buildMessageList(state),
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

  Widget _buildMessageList(AiChatState state) {
    // Calculate item count: messages + streaming content + typing indicator
    int itemCount = state.messages.length;
    final hasStreamingContent =
        state.isLoading && (state.streamingText.isNotEmpty || state.currentResultData != null);
    final showTypingIndicator = state.isLoading && !hasStreamingContent;

    if (hasStreamingContent) itemCount += 1; // For streaming bubble
    if (showTypingIndicator) itemCount += 1; // For typing indicator

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        vertical: TossSpacing.space4,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Regular messages
        if (index < state.messages.length) {
          return ChatBubble(message: state.messages[index]);
        }

        // Streaming content (result card + streaming text)
        if (hasStreamingContent && index == state.messages.length) {
          return _buildStreamingBubble(state);
        }

        // Typing indicator
        if (showTypingIndicator) {
          return const TypingIndicator();
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStreamingBubble(AiChatState state) {
    final hasResultData = state.currentResultData != null && state.currentResultData!.isNotEmpty;
    final isWaitingForText = hasResultData && state.streamingText.isEmpty;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: TossSpacing.space1,
          horizontal: TossSpacing.space4,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result data card - Collapsible with loading state
            if (hasResultData || isWaitingForText)
              ResultDataCard(
                data: state.currentResultData ?? [],
                isLoading: isWaitingForText,
              ),

            // Streaming text with cursor
            if (state.streamingText.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(TossBorderRadius.bottomSheet).copyWith(
                    bottomLeft: const Radius.circular(TossBorderRadius.xs),
                  ),
                ),
                child: Text(
                  '${state.streamingText}▌',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              )
            else if (!hasResultData)
              // Show typing indicator only if no result data yet
              const TypingIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: TossColors.gray300, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.smart_toy, color: TossColors.primary),
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
            icon: const Icon(Icons.close, color: TossColors.textSecondary),
            onPressed: () => Navigator.of(context).pop(),
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
          const Icon(
            Icons.chat_bubble_outline,
            size: TossSpacing.icon4XL,
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
