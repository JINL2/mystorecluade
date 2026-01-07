import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../themes/toss_border_radius.dart';
import '../../../../themes/toss_colors.dart';
import '../../../../themes/toss_spacing.dart';
import '../../../../themes/toss_text_styles.dart';
import '../../domain/models/chat_message.dart';
import 'result_data_card.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isStreaming;

  const ChatBubble({
    super.key,
    required this.message,
    this.isStreaming = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: TossSpacing.space1,
          horizontal: TossSpacing.space4,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: message.isUser ? _buildUserBubble() : _buildAiBubble(),
      ),
    );
  }

  Widget _buildUserBubble() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: TossColors.primary,
        borderRadius: BorderRadius.circular(TossBorderRadius.bottomSheet).copyWith(
          bottomRight: const Radius.circular(TossBorderRadius.xs),
        ),
      ),
      child: Text(
        message.content,
        style: TossTextStyles.body.copyWith(
          color: TossColors.white,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildAiBubble() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Result data card (if available) - Blue tinted
        if (message.hasResultData) ResultDataCard(data: message.resultData!),

        // AI text response - Neutral gray
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5), // Light neutral gray
            borderRadius: BorderRadius.circular(TossBorderRadius.bottomSheet).copyWith(
              bottomLeft: const Radius.circular(TossBorderRadius.xs),
            ),
          ),
          child: MarkdownBody(
            data: isStreaming ? '${message.content}▌' : message.content,
            styleSheet: MarkdownStyleSheet(
              p: TossTextStyles.body.copyWith(
                color: TossColors.textPrimary,
                height: 1.5,
              ),
              h1: TossTextStyles.h1.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              h2: TossTextStyles.h2.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              h3: TossTextStyles.h3.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              strong: TossTextStyles.body.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              listBullet: TossTextStyles.body.copyWith(
                color: TossColors.textPrimary,
              ),
              code: TossTextStyles.body.copyWith(
                fontFamily: 'monospace',
                backgroundColor: const Color(0xFFEEEEEE),
                color: TossColors.textPrimary,
                fontSize: 13,
              ),
              codeblockDecoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              blockSpacing: TossSpacing.space2,
              listIndent: TossSpacing.space4,
              tableBorder: TableBorder.all(
                color: TossColors.gray300,
                width: 1,
              ),
              tableHead: TossTextStyles.body.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              tableBody: TossTextStyles.body.copyWith(
                color: TossColors.textPrimary,
              ),
              tableCellsPadding: const EdgeInsets.all(TossSpacing.space2),
            ),
          ),
        ),
      ],
    );
  }
}
