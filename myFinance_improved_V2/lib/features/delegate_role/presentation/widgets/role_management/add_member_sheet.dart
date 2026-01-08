import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../../di/delegate_role_providers.dart';
import '../../providers/role_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Add Member Bottom Sheet for assigning users to a role
class AddMemberSheet extends ConsumerStatefulWidget {
  final String roleId;
  final String roleName;
  final VoidCallback onMemberAdded;

  const AddMemberSheet({
    super.key,
    required this.roleId,
    required this.roleName,
    required this.onMemberAdded,
  });

  @override
  ConsumerState<AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends ConsumerState<AddMemberSheet> {
  Set<String> _selectedUserIds = {};
  bool _isAssigning = false;
  bool _isLoadingRoleAssignments = true;
  Map<String, String?> _userRoleAssignments = {}; // userId -> roleId mapping

  @override
  void initState() {
    super.initState();
    // Always load fresh role assignments when modal opens
    _loadUserRoleAssignments();
  }

  Future<void> _loadUserRoleAssignments() async {
    if (!mounted) return;

    setState(() => _isLoadingRoleAssignments = true);

    try {
      // ✅ Use GetUserRoleAssignmentsUseCase instead of direct Supabase access
      final getUserRoleAssignmentsUseCase =
          ref.read(getUserRoleAssignmentsUseCaseProvider);
      final roleRepository = ref.read(roleRepositoryProvider);

      // Get role to extract company ID
      final role = await roleRepository.getRoleById(widget.roleId);

      // Get all user role assignments for this company
      final assignments = await getUserRoleAssignmentsUseCase.execute(
        roleId: widget.roleId,
        companyId: role.companyId,
      );

      if (mounted) {
        setState(() {
          _userRoleAssignments = assignments;
          _isLoadingRoleAssignments = false;
        });
      }
    } catch (e) {
      // Graceful degradation: role name validation will still work
      debugPrint('Error loading user role assignments: $e');
      if (mounted) {
        setState(() => _isLoadingRoleAssignments = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // First get the role data to extract companyId
    final roleAsync = ref.watch(roleByIdProvider(widget.roleId));

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: TossDimensions.dragHandleWidth,
            height: TossDimensions.dragHandleHeight,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Member to ${widget.roleName}',
                        style: TossTextStyles.h2.copyWith(
                          fontWeight: TossFontWeight.bold,
                          color: TossColors.gray900,
                        ),
                      ),
                      Text(
                        'Select a user to assign to this role',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: TossColors.gray600),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Users list - fetch users after getting companyId from role
          Expanded(
            child: roleAsync.when(
              data: (role) {
                // Now fetch users for this company
                final companyUsersAsync =
                    ref.watch(companyUsersProvider(role.companyId));

                return companyUsersAsync.when(
                  data: (users) {
                    if (users.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.people_outline,
                              size: TossSpacing.icon4XL,
                              color: TossColors.gray300,
                            ),
                            const SizedBox(height: TossSpacing.space4),
                            Text(
                              'No users found',
                              style: TossTextStyles.h3.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space5),
                      itemCount: users.length,
                      separatorBuilder: (context, index) => Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: TossSpacing.space1),
                        height: 0.5,
                        color: TossColors.gray200,
                      ),
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final userId = user['id'] as String;
                        final userName = user['name'] as String;
                        final userEmail = user['email'] as String;
                        final currentRole = user['role'] as String;
                        final isSelected = _selectedUserIds.contains(userId);

                        // Check if user is owner or already has the target role
                        final isOwner = currentRole.toLowerCase() == 'owner';
                        final hasTargetRole =
                            _isUserAlreadyAssigned(userId, currentRole);
                        final isDisabled = isOwner || hasTargetRole;

                        return Material(
                          color: TossColors.transparent,
                          child: InkWell(
                            onTap: isDisabled
                                ? null
                                : () {
                                    setState(() {
                                      if (isSelected) {
                                        _selectedUserIds.remove(userId);
                                      } else {
                                        _selectedUserIds.add(userId);
                                      }
                                    });
                                  },
                            borderRadius:
                                BorderRadius.circular(TossBorderRadius.sm),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: TossSpacing.space3),
                              child: Row(
                                children: [
                                  Container(
                                    width: TossSpacing.iconXXL,
                                    height: TossSpacing.iconXXL,
                                    decoration: BoxDecoration(
                                      color: isOwner
                                          ? Color.alphaBlend(
                                              TossColors.primary
                                                  .withValues(alpha: TossOpacity.light),
                                              TossColors.background,
                                            )
                                          : isDisabled
                                              ? TossColors.gray100
                                              : TossColors.gray200,
                                      borderRadius: BorderRadius.circular(
                                          TossBorderRadius.xxl),
                                    ),
                                    child: Icon(
                                      isOwner ? Icons.star : Icons.person,
                                      color: isOwner
                                          ? TossColors.primary
                                          : isDisabled
                                              ? TossColors.gray400
                                              : TossColors.gray600,
                                    ),
                                  ),
                                  const SizedBox(width: TossSpacing.space3),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName,
                                          style: TossTextStyles.body.copyWith(
                                            fontWeight: TossFontWeight.semibold,
                                            color: isDisabled
                                                ? TossColors.gray500
                                                : TossColors.gray900,
                                          ),
                                        ),
                                        Text(
                                          userEmail,
                                          style:
                                              TossTextStyles.bodySmall.copyWith(
                                            color: isDisabled
                                                ? TossColors.gray400
                                                : TossColors.gray600,
                                          ),
                                        ),
                                        Text(
                                          'Current: $currentRole',
                                          style:
                                              TossTextStyles.caption.copyWith(
                                            color: isDisabled
                                                ? TossColors.gray400
                                                : TossColors.gray500,
                                            fontWeight: TossFontWeight.medium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _buildRoleBadge(currentRole, hasTargetRole),
                                  if (isSelected) ...[
                                    const SizedBox(width: TossSpacing.space2),
                                    const Icon(
                                      Icons.check,
                                      color: TossColors.primary,
                                      size: TossSpacing.iconMD2,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: TossLoadingView(),
                  ),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: TossColors.error, size: TossSpacing.iconXXL),
                        const SizedBox(height: TossSpacing.space3),
                        Text(
                          'Failed to load users',
                          style: TossTextStyles.body
                              .copyWith(color: TossColors.error),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(
                child: TossLoadingView(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: TossColors.error, size: TossSpacing.iconXXL),
                    const SizedBox(height: TossSpacing.space3),
                    Text(
                      'Failed to load role',
                      style:
                          TossTextStyles.body.copyWith(color: TossColors.error),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom action
          Container(
            decoration: const BoxDecoration(
              color: TossColors.background,
              border: Border(top: BorderSide(color: TossColors.gray200)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  TossSpacing.space5,
                  TossSpacing.space4,
                  TossSpacing.space5,
                  TossSpacing.space4,
                ),
                child: TossButton.primary(
                  text: 'Add Member',
                  fullWidth: true,
                  isLoading: _isAssigning,
                  onPressed: _selectedUserIds.isEmpty || _isAssigning
                      ? null
                      : _assignUsersToRole,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isUserAlreadyAssigned(String userId, String currentRole) {
    // Normalize inputs for reliable comparison
    final normalizedCurrentRole = currentRole.toLowerCase().trim();
    final normalizedTargetRole = widget.roleName.toLowerCase().trim();

    // Handle comma-separated roles from STRING_AGG (e.g., "Employee, Manager")
    final hasRoleByName = normalizedCurrentRole == normalizedTargetRole ||
        normalizedCurrentRole.contains(', $normalizedTargetRole') ||
        normalizedCurrentRole.contains('$normalizedTargetRole,');

    // Layer 2: Role ID validation (database-level accuracy)
    final hasRoleById = !_isLoadingRoleAssignments &&
        _userRoleAssignments.containsKey(userId) &&
        _userRoleAssignments[userId] == widget.roleId;

    // During loading, rely on role name; after loading, use both validations
    if (_isLoadingRoleAssignments) {
      return hasRoleByName;
    }

    // Post-loading: either validation method confirming assignment is sufficient
    return hasRoleByName || hasRoleById;
  }

  Widget _buildRoleBadge(String currentRole, bool hasTargetRole) {
    // Only show badge for users who already have the target role
    if (hasTargetRole) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space2,
          vertical: TossSpacing.space1,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          border: Border.all(
            color: TossColors.primary,
            width: 1,
          ),
        ),
        child: Text(
          'Assigned',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.primary,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
      );
    }

    // No badge for owners or normal users - clean design
    return const SizedBox.shrink();
  }

  Future<void> _assignUsersToRole() async {
    if (_selectedUserIds.isEmpty) return;

    setState(() => _isAssigning = true);

    try {
      // Get roleRepository to fetch companyId
      final roleRepository = ref.read(roleRepositoryProvider);
      final role = await roleRepository.getRoleById(widget.roleId);
      final companyId = role.companyId;

      // ✅ Use AssignUserToRoleUseCase to assign all selected users
      final assignUserUseCase = ref.read(assignUserToRoleUseCaseProvider);

      // Assign each selected user
      for (final userId in _selectedUserIds) {
        await assignUserUseCase.execute(
          userId: userId,
          roleId: widget.roleId,
          companyId: companyId,
        );

        // Update local role assignments to reflect the change immediately
        _userRoleAssignments[userId] = widget.roleId;
      }

      if (mounted) {
        Navigator.pop(context);

        // Reactive state management: invalidate providers for cross-screen updates
        ref.invalidate(companyUsersProvider); // Refresh user roles in Add Member modal
        ref.invalidate(allCompanyRolesProvider); // Refresh role member counts

        widget.onMemberAdded();

        // Show success dialog
        final memberCount = _selectedUserIds.length;
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Members Added Successfully!',
            message:
                '$memberCount ${memberCount == 1 ? "member has" : "members have"} been added to ${widget.roleName}',
            primaryButtonText: 'Done',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Failed to Add Members',
            message: 'Could not add members to role: $e',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAssigning = false);
      }
    }
  }
}
