// lib/presentation/pages/delegate_role/widgets/role_update_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/delegate_role_provider.dart';
import '../../../widgets/toss/toss_primary_button.dart';

class RoleUpdateBottomSheet extends ConsumerStatefulWidget {
  final UserRoleInfo user;

  const RoleUpdateBottomSheet({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<RoleUpdateBottomSheet> createState() => _RoleUpdateBottomSheetState();
}

class _RoleUpdateBottomSheetState extends ConsumerState<RoleUpdateBottomSheet> {
  String? _selectedRoleId;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _selectedRoleId = widget.user.roleId;
  }

  Future<void> _updateUserRole() async {
    if (_selectedRoleId == null || _selectedRoleId == widget.user.roleId) {
      return;
    }

    setState(() => _isUpdating = true);

    try {
      final supabase = Supabase.instance.client;
      
      // Check if user already has a role
      if (widget.user.userRoleId.startsWith('temp_')) {
        // User doesn't have a role yet, create one
        await supabase
            .from('user_roles')
            .insert({
              'user_id': widget.user.userId,
              'role_id': _selectedRoleId,
              'company_id': widget.user.companyId,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
              'is_deleted': false,
            });
      } else {
        // Update existing role
        await supabase
            .from('user_roles')
            .update({
              'role_id': _selectedRoleId,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('user_role_id', widget.user.userRoleId);
      }
      
      // Refresh the user list
      ref.invalidate(companyUserRolesProvider(widget.user.companyId));
      
      if (mounted) {
        Navigator.pop(context);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Role updated successfully'),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isUpdating = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update role: ${e.toString()}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableRolesAsync = ref.watch(availableRolesProvider(widget.user.companyId));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // User info header
            Container(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Role',
                    style: TossTextStyles.h2.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space4),
                  
                  // User info
                  Row(
                    children: [
                      _buildUserAvatar(),
                      SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.user.displayName,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: TossSpacing.space1),
                            Text(
                              widget.user.email,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space5),
            
            // Warning for owner role
            if (!widget.user.canEditRole)
              Container(
                margin: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  border: Border.all(
                    color: TossColors.warning.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: TossColors.warning,
                      size: 20,
                    ),
                    SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: Text(
                        'Owner roles cannot be changed for security reasons.',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            if (widget.user.canEditRole) ...[
              // Role options
              Flexible(
                child: availableRolesAsync.when(
                  data: (roles) => ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                    itemCount: roles.length,
                    itemBuilder: (context, index) {
                      final role = roles[index];
                      final roleId = role['role_id'] as String;
                      final roleName = role['role_name'] as String;
                      final roleType = role['role_type'] as String? ?? 'custom';
                      final isSelected = _selectedRoleId == roleId;
                      final isCurrentRole = roleId == widget.user.roleId;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRoleId = roleId;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: TossSpacing.space3),
                          padding: EdgeInsets.all(TossSpacing.space3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? TossColors.primary : TossColors.gray200,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            color: isSelected ? TossColors.primary.withOpacity(0.05) : Colors.white,
                          ),
                          child: Row(
                            children: [
                              // Role Color Indicator
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _getRoleColor(roleName),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: TossSpacing.space3),
                              
                              // Role Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          roleName,
                                          style: TossTextStyles.body.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: isSelected ? TossColors.primary : TossColors.gray900,
                                          ),
                                        ),
                                        if (isCurrentRole) ...[
                                          SizedBox(width: TossSpacing.space2),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: TossSpacing.space2,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: TossColors.success.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'Current',
                                              style: TossTextStyles.caption.copyWith(
                                                color: TossColors.success,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: TossSpacing.space1),
                                    Text(
                                      _displayRoleType(roleType),
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Selection indicator
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? TossColors.primary : TossColors.gray400,
                                    width: 2,
                                  ),
                                  color: isSelected ? TossColors.primary : Colors.transparent,
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  loading: () => Center(
                    child: Padding(
                      padding: EdgeInsets.all(TossSpacing.space6),
                      child: CircularProgressIndicator(
                        color: TossColors.primary,
                      ),
                    ),
                  ),
                  error: (error, _) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(TossSpacing.space6),
                      child: Text(
                        'Failed to load roles',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.error,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Update button
              Padding(
                padding: EdgeInsets.all(TossSpacing.space5),
                child: SizedBox(
                  width: double.infinity,
                  child: TossPrimaryButton(
                    text: 'Update Role',
                    onPressed: (_selectedRoleId != null && 
                              _selectedRoleId != widget.user.roleId && 
                              !_isUpdating)
                        ? _updateUserRole
                        : null,
                    isLoading: _isUpdating,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    if (widget.user.hasProfileImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          widget.user.profileImage!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
        ),
      );
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: TossColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          widget.user.initials,
          style: TossTextStyles.body.copyWith(
            color: TossColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(String roleName) {
    final Map<String, Color> roleColors = {
      'Owner': TossColors.error,
      'Admin': TossColors.primary,
      'Manager': TossColors.warning,
      'Employee': TossColors.success,
      'Staff': TossColors.info,
    };
    
    return roleColors[roleName] ?? TossColors.gray500;
  }

  String _displayRoleType(String roleType) {
    switch (roleType) {
      case 'owner':
        return 'Owner Role';
      case 'admin':
        return 'Administrator';
      case 'custom':
        return 'Custom Role';
      default:
        return roleType;
    }
  }
}