import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'session_user_card.dart';
import 'session_user_model.dart';

/// Session User section with list of users and action buttons
class SessionUserSection extends StatelessWidget {
  final List<SessionUser> sessionUsers;
  final String currentUserId;
  final bool isCounting;
  final bool isOwner;
  final bool isLoadingUsers;
  final bool isJoining;
  final bool hasCurrentUserJoined;
  final VoidCallback onRefresh;
  final VoidCallback onMerge;
  final VoidCallback onJoin;
  final void Function(SessionUser user) onUserTap;

  const SessionUserSection({
    super.key,
    required this.sessionUsers,
    required this.currentUserId,
    required this.isCounting,
    required this.isOwner,
    required this.isLoadingUsers,
    required this.isJoining,
    required this.hasCurrentUserJoined,
    required this.onRefresh,
    required this.onMerge,
    required this.onJoin,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        _buildSectionHeader(),
        // Session users list or empty state
        if (sessionUsers.isEmpty)
          _buildEmptyState()
        else
          _buildUserList(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Session User',
            style: TossTextStyles.titleMedium.copyWith(
              fontWeight: TossFontWeight.bold,
              color: TossColors.gray900,
            ),
          ),
          Row(
            children: [
              // Refresh button
              GestureDetector(
                onTap: isLoadingUsers ? null : onRefresh,
                child: isLoadingUsers
                    ? TossLoadingView.inline(size: TossSpacing.iconMD, color: TossColors.gray400)
                    : const Icon(
                        Icons.refresh,
                        color: TossColors.gray500,
                        size: TossSpacing.iconMD + 2,
                      ),
              ),
              const SizedBox(width: TossSpacing.space3),
              // Merge button - only visible to session owner
              if (isOwner)
                GestureDetector(
                  onTap: onMerge,
                  child: Text(
                    'Merge',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray700,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ),
              if (isOwner) const SizedBox(width: TossSpacing.space3),
              // Join button - disabled if current user already joined
              GestureDetector(
                onTap: (isJoining || hasCurrentUserJoined) ? null : onJoin,
                child: isJoining
                    ? TossLoadingView.inline(size: TossSpacing.iconMD)
                    : Text(
                        '+ Join',
                        style: TossTextStyles.body.copyWith(
                          color: hasCurrentUserJoined
                              ? TossColors.gray400
                              : TossColors.primary,
                          fontWeight: TossFontWeight.semibold,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space6,
      ),
      child: Center(
        child: Text(
          isCounting
              ? 'Join the session to start your inventory count.'
              : 'Join the session to start your receiving.',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sessionUsers.length,
      itemBuilder: (context, index) {
        final user = sessionUsers[index];
        final isCurrentUser = user.id == currentUserId;
        return SessionUserCard(
          user: user,
          isCurrentUser: isCurrentUser,
          onTap: isCurrentUser ? () => onUserTap(user) : null,
        );
      },
    );
  }
}
