import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../di/delegate_role_providers.dart';
import '../../providers/role_providers.dart';
import 'add_member_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Members Tab for role management - displays and manages role members
class MembersTab extends ConsumerStatefulWidget {
  final String roleId;
  final String roleName;
  final bool canEdit;

  const MembersTab({
    super.key,
    required this.roleId,
    required this.roleName,
    required this.canEdit,
  });

  @override
  ConsumerState<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends ConsumerState<MembersTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header section with title, description and Add Member button
        _buildHeaderSection(),

        // Members content
        Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _getRoleMembers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: TossLoadingView(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: TossColors.error, size: 48),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'Failed to load members',
                        style:
                            TossTextStyles.body.copyWith(color: TossColors.error),
                      ),
                    ],
                  ),
                );
              }

              final members = snapshot.data ?? [];

              if (members.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return _buildMemberItem(
                    userId: member['user_id'] as String,
                    name: (member['name'] as String?) ?? 'Unknown User',
                    email: (member['email'] as String?) ?? '',
                    joinedDate: _formatJoinDate(member['created_at'] as String?),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space5,
        TossSpacing.space5,
        TossSpacing.space5,
        TossSpacing.space3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team Members',
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      'Users assigned to this role',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.canEdit)
                IconButton(
                  icon: const Icon(Icons.add,
                      size: 24, color: TossColors.primary),
                  onPressed: () => _showAddMemberModal(),
                  tooltip: 'Add Member',
                ),
            ],
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
            Icons.people_outline,
            size: 64,
            color: TossColors.gray300,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'No team members yet',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'No users are currently assigned to this role',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMemberItem({
    required String userId,
    required String name,
    required String email,
    required String joinedDate,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            ),
            child: const Icon(Icons.person, color: TossColors.gray600),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                Text(
                  email,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                Text(
                  joinedDate,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getRoleMembers() async {
    try {
      final getRoleMembersUseCase = ref.read(getRoleMembersUseCaseProvider);
      final members = await getRoleMembersUseCase.execute(widget.roleId);
      return members;
    } catch (e) {
      debugPrint('Error fetching role members: $e');
      return [];
    }
  }

  String _formatJoinDate(dynamic createdAt) {
    if (createdAt == null) return 'Role assigned recently';

    try {
      final date = DateTime.parse(createdAt.toString());
      final dateLocal = date.isUtc ? date.toLocal() : date;
      final now = DateTime.now();
      final difference = now.difference(dateLocal);

      if (difference.inDays == 0) {
        return 'Role assigned today';
      } else if (difference.inDays == 1) {
        return 'Role assigned yesterday';
      } else if (difference.inDays < 7) {
        return 'Role assigned ${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return 'Role assigned $weeks week${weeks == 1 ? '' : 's'} ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return 'Role assigned $months month${months == 1 ? '' : 's'} ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return 'Role assigned $years year${years == 1 ? '' : 's'} ago';
      }
    } catch (e) {
      return 'Role assigned recently';
    }
  }

  void _showAddMemberModal() {
    // Refresh data before showing the modal
    ref.invalidate(companyUsersProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black54,
      useRootNavigator: true,
      enableDrag: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewInsets.bottom -
                MediaQuery.of(context).padding.top -
                100,
            minHeight: 300,
          ),
          child: AddMemberSheet(
            roleId: widget.roleId,
            roleName: widget.roleName,
            onMemberAdded: () {
              ref.invalidate(companyUsersProvider);
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
