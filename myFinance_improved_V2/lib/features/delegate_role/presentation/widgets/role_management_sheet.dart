import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/auth_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../providers/role_providers.dart';
import 'role_management/role_management.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Role Management Sheet - Main container for role editing
///
/// Refactored from 2005 lines to ~250 lines by extracting:
/// - [DetailsTab] - Role details and tags editing
/// - [PermissionsTab] - Permission management
/// - [MembersTab] - Member list and assignment
/// - [AddMemberSheet] - Bottom sheet for adding members
/// - [TagSelectionSheet] - Bottom sheet for tag selection
class RoleManagementSheet extends ConsumerStatefulWidget {
  final String roleId;
  final String roleName;
  final String companyId;
  final String? description;
  final List<String> tags;
  final List<String> permissions;
  final int memberCount;
  final bool canEdit;
  final bool canDelegate;

  const RoleManagementSheet({
    super.key,
    required this.roleId,
    required this.roleName,
    required this.companyId,
    this.description,
    required this.tags,
    required this.permissions,
    required this.memberCount,
    required this.canEdit,
    required this.canDelegate,
  });

  static Future<void> show(
    BuildContext context, {
    required String roleId,
    required String roleName,
    required String companyId,
    String? description,
    required List<String> tags,
    required List<String> permissions,
    required int memberCount,
    required bool canEdit,
    required bool canDelegate,
  }) {
    return TossBottomSheet.showWithBuilder(
      context: context,
      heightFactor: 0.85,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(TossBorderRadius.bottomSheet),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: TossDimensions.dragHandleWidth,
              height: TossDimensions.dragHandleHeight,
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs / 2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                children: [
                  Text(
                    roleName,
                    style: TossTextStyles.h4.copyWith(
                      fontWeight: TossFontWeight.bold,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    canEdit ? 'Edit role details and permissions' : 'View role details',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: RoleManagementSheet(
                roleId: roleId,
                roleName: roleName,
                companyId: companyId,
                description: description,
                tags: tags,
                permissions: permissions,
                memberCount: memberCount,
                canEdit: canEdit,
                canDelegate: canDelegate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ConsumerState<RoleManagementSheet> createState() => _RoleManagementSheetState();
}

class _RoleManagementSheetState extends ConsumerState<RoleManagementSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _roleNameController;
  late TextEditingController _descriptionController;
  final FocusNode _roleNameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  bool _isLoading = false;
  bool _isDeleting = false;
  bool _isEditingText = false;
  Set<String> _selectedPermissions = {};
  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: TossAnimations.medium,
    );
    _roleNameController = TextEditingController(text: widget.roleName);
    _descriptionController = TextEditingController(
        text: widget.description ?? _getDefaultRoleDescription());
    _selectedPermissions = Set.from(widget.permissions);
    _selectedTags = List.from(widget.tags);

    _roleNameFocus.addListener(_onTextEditingStateChanged);
    _descriptionFocus.addListener(_onTextEditingStateChanged);
  }

  @override
  void dispose() {
    _roleNameFocus.removeListener(_onTextEditingStateChanged);
    _descriptionFocus.removeListener(_onTextEditingStateChanged);
    _tabController.dispose();
    _roleNameController.dispose();
    _descriptionController.dispose();
    _roleNameFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  void _onTextEditingStateChanged() {
    final isEditing = _roleNameFocus.hasFocus || _descriptionFocus.hasFocus;
    if (_isEditingText != isEditing) {
      setState(() {
        _isEditingText = isEditing;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tab bar
        TossTabBar(
          tabs: const ['Details', 'Permissions', 'Members'],
          controller: _tabController,
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
        ),

        // Tab content
        SizedBox(
          height: screenHeight * 0.5,
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              DetailsTab(
                roleName: widget.roleName,
                memberCount: widget.memberCount,
                permissionCount: widget.permissions.length,
                canEdit: widget.canEdit,
                roleNameController: _roleNameController,
                descriptionController: _descriptionController,
                roleNameFocus: _roleNameFocus,
                descriptionFocus: _descriptionFocus,
                selectedTags: _selectedTags,
                onTagsChanged: (tags) {
                  setState(() {
                    _selectedTags = tags;
                  });
                },
              ),
              PermissionsTab(
                roleId: widget.roleId,
                roleName: widget.roleName,
                canEdit: widget.canEdit,
                selectedPermissions: _selectedPermissions,
                onPermissionsChanged: (permissions) {
                  setState(() {
                    _selectedPermissions = permissions;
                  });
                },
              ),
              MembersTab(
                roleId: widget.roleId,
                roleName: widget.roleName,
                companyId: widget.companyId,
                canEdit: widget.canEdit,
              ),
            ],
          ),
        ),

        // Bottom action - Save button
        if (widget.canEdit && !_isEditingText)
          _buildBottomAction(),
      ],
    );
  }

  Widget _buildBottomAction() {
    // Check if role is deletable (custom roles only, not Owner/Employee)
    final isDeletableRole = !['owner', 'employee'].contains(
      widget.roleName.toLowerCase(),
    );

    return Container(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TossButton.primary(
                text: 'Save Changes',
                fullWidth: true,
                isLoading: _isLoading,
                onPressed: _isLoading || _isDeleting ? null : _saveChanges,
              ),
              // Delete button for custom roles only
              if (isDeletableRole) ...[
                const SizedBox(height: TossSpacing.space3),
                TossButton.destructive(
                  text: 'Delete Role',
                  fullWidth: true,
                  isLoading: _isDeleting,
                  onPressed: _isLoading || _isDeleting ? null : _confirmDeleteRole,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getDefaultRoleDescription() {
    switch (widget.roleName.toLowerCase()) {
      case 'owner':
        return 'Full system access with company management capabilities. Can oversee all operations, manage finances, and make strategic decisions.';
      case 'manager':
        return 'Team oversight and operational control. Responsible for managing staff, schedules, and day-to-day operations.';
      case 'employee':
        return 'Standard access for daily operations. Can perform assigned tasks, view schedules, and access basic system functions.';
      case 'salesman':
        return 'Customer-facing sales operations. Handles client interactions, processes orders, and manages customer relationships.';
      case 'managerstore':
        return 'Store management and inventory control. Oversees store operations, manages stock, and ensures smooth daily activities.';
      default:
        return 'Custom role with specific permissions tailored to unique business requirements.';
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    try {
      // Use RoleActionsNotifier for mutations
      final roleActions = ref.read(roleActionsNotifierProvider.notifier);

      // Update role details (name, description, and tags)
      await roleActions.updateRoleDetails(
        roleId: widget.roleId,
        roleName: _roleNameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        tags: _selectedTags,
      );

      // Update role permissions
      await roleActions.updateRolePermissions(
        widget.roleId,
        _selectedPermissions,
      );

      if (mounted) {
        Navigator.pop(context);

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Role Updated Successfully!',
            message: 'Role permissions have been updated',
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
            title: 'Failed to Update Role',
            message: 'Could not update role permissions: $e',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Show delete confirmation dialog
  Future<void> _confirmDeleteRole() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossDialog.warning(
        title: 'Delete Role?',
        message:
            'Are you sure you want to delete "${widget.roleName}"? '
            'Members will be reassigned to the Employee role.',
        primaryButtonText: 'Delete',
        secondaryButtonText: 'Cancel',
        onPrimaryPressed: () => context.pop(true),
        onSecondaryPressed: () => context.pop(false),
      ),
    );

    if (confirmed == true && mounted) {
      await _deleteRole();
    }
  }

  /// Delete the role
  Future<void> _deleteRole() async {
    // Get current user ID for audit trail
    final currentUserId = ref.read(currentUserIdProvider);
    if (currentUserId == null) {
      if (mounted) {
        await showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Authentication Error',
            message: 'Please log in again to delete this role.',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
      return;
    }

    setState(() => _isDeleting = true);

    try {
      final roleActions = ref.read(roleActionsNotifierProvider.notifier);

      await roleActions.deleteRole(
        roleId: widget.roleId,
        companyId: widget.companyId,
        deletedBy: currentUserId,
      );

      if (mounted) {
        // Close the management sheet
        Navigator.pop(context);

        // Show success dialog
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Role Deleted',
            message: '"${widget.roleName}" has been deleted successfully.',
            primaryButtonText: 'Done',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        await showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Failed to Delete Role',
            message: 'Could not delete role: $e',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }
}
