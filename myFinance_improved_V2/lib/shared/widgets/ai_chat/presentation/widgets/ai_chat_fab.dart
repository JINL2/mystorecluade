import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../themes/toss_colors.dart';
import '../providers/ai_chat_provider.dart';
import 'ai_chat_bottom_sheet.dart';

class AiChatFab extends ConsumerStatefulWidget {
  final String featureName;
  final Map<String, dynamic>? pageContext;
  final String? featureId;

  const AiChatFab({
    super.key,
    required this.featureName,
    this.pageContext,
    this.featureId,
  });

  @override
  ConsumerState<AiChatFab> createState() => _AiChatFabState();
}

class _AiChatFabState extends ConsumerState<AiChatFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildTypingDots() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final progress = _animationController.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            // Each dot animates with a delay
            final dotProgress = ((progress - (index * 0.2)) % 1.0);
            final opacity = dotProgress < 0.5
                ? (dotProgress * 2) // Fade in
                : (2 - dotProgress * 2); // Fade out

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Opacity(
                opacity: opacity.clamp(0.3, 1.0),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: TossColors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use featureName as the provider key
    final state = ref.watch(aiChatProvider(widget.featureName));

    return FloatingActionButton(
      onPressed: () {
        // Mark as read when opening
        ref.read(aiChatProvider(widget.featureName).notifier).setChatOpen(true);

        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => AiChatBottomSheet(
            featureName: widget.featureName,
            pageContext: widget.pageContext,
            featureId: widget.featureId,
          ),
        ).then((_) {
          // Mark as closed when bottom sheet is dismissed
          ref.read(aiChatProvider(widget.featureName).notifier).setChatOpen(false);
        });
      },
      backgroundColor: state.hasUnreadResponse
          ? TossColors.success // Green when unread
          : TossColors.primary, // Blue normally
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (state.isLoading)
            // Show typing dots animation when AI is thinking
            _buildTypingDots()
          else
            Icon(
              state.hasUnreadResponse
                  ? Icons.mark_chat_unread // Unread icon
                  : Icons.chat_bubble_outline, // Normal chat icon
              color: TossColors.white,
            ),
          // Red badge when unread
          if (state.hasUnreadResponse && !state.isLoading)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: TossColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(color: TossColors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
