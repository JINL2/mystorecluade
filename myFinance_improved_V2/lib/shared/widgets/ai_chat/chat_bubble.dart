import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../core/ai_chat/domain/entities/chat_message.dart';
import '../../themes/toss_border_radius.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_spacing.dart';
import '../../themes/toss_text_styles.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: TossSpacing.space2,
          horizontal: TossSpacing.space4,
        ),
        padding: const EdgeInsets.all(TossSpacing.space3),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? TossColors.primary : TossColors.gray200,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg).copyWith(
            bottomRight: message.isUser
                ? Radius.circular(4)
                : Radius.circular(TossBorderRadius.lg),
            bottomLeft: message.isUser
                ? Radius.circular(TossBorderRadius.lg)
                : Radius.circular(4),
          ),
        ),
        child: message.isUser
            ? Text(
                message.content,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.white,
                ),
              )
            : MarkdownBody(
                data: message.content,
                styleSheet: MarkdownStyleSheet(
                  p: TossTextStyles.body.copyWith(
                    color: TossColors.textPrimary,
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
                    backgroundColor: TossColors.gray100,
                    color: TossColors.textPrimary,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  blockSpacing: TossSpacing.space2,
                  listIndent: TossSpacing.space4,
                  // Table styling for better mobile display
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
    );
  }
}
