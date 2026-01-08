import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/session_history_item.dart';

/// Members section for history detail
class HistoryMembersSection extends StatelessWidget {
  final List<SessionHistoryMember> members;

  const HistoryMembersSection({
    super.key,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space5,
              TossSpacing.space4,
              TossSpacing.space5,
              TossSpacing.space3,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.group_outlined,
                  size: TossSpacing.iconMD,
                  color: TossColors.textSecondary,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Members',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: TossFontWeight.semibold,
                    color: TossColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    '${members.length}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (members.isEmpty)
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Center(
                child: Text(
                  'No members',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: members.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
              itemBuilder: (context, index) {
                final member = members[index];
                return _buildMemberTile(member);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(SessionHistoryMember member) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          Container(
            width: TossSpacing.iconXL,
            height: TossSpacing.iconXL,
            decoration: BoxDecoration(
              color: TossColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member.userName.isNotEmpty ? member.userName[0].toUpperCase() : '?',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: TossFontWeight.semibold,
                ),
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.userName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: TossFontWeight.medium,
                  ),
                ),
                Text(
                  'Joined: ${_formatDateTime(member.joinedAt)}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          if (member.isActive)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: TossColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Text(
                'Active',
                style: TossTextStyles.micro.copyWith(
                  color: TossColors.success,
                  fontWeight: TossFontWeight.medium,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateString) {
    final date = DateTime.tryParse(dateString);
    if (date == null) return dateString;

    final now = DateTime.now();
    final diff = now.difference(date);

    String timeStr =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    if (diff.inDays == 0) {
      return 'Today $timeStr';
    } else if (diff.inDays == 1) {
      return 'Yesterday $timeStr';
    } else {
      return '${date.month}/${date.day}/${date.year} $timeStr';
    }
  }
}
