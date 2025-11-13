import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_search_field.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_secondary_button.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/role.dart';
import '../providers/employee_providers.dart';
class RoleManagementModal extends ConsumerStatefulWidget {
  final String userId;
  final String? currentRole;
  final Function(String?) onSave;

  const RoleManagementModal({
    super.key,
    required this.userId,
    required this.currentRole,
    required this.onSave,
  });

  @override
  ConsumerState<RoleManagementModal> createState() => 
      _RoleManagementModalState();
}

class _RoleManagementModalState extends ConsumerState<RoleManagementModal> {
  String? _selectedRoleId;
  String? _selectedRoleName;
  String _searchQuery = '';
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _selectedRoleName = widget.currentRole;
  }

  @override
  Widget build(BuildContext context) {
    final rolesAsync = ref.watch(rolesProvider);

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside text field
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
        children: [
          // Drag handle for visual cue
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          // Header
          _buildHeader(),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: TossSearchField(
              hintText: 'Search available roles...',
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Available Roles List
          Expanded(
            child: rolesAsync.when(
              data: (roles) {
                final filteredRoles = roles.where((role) {
                  // Exclude current role from available options
                  if (role.roleName == widget.currentRole) return false;
                  
                  if (_searchQuery.isEmpty) return true;
                  return role.roleName.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();
                
                if (filteredRoles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 64,
                          color: TossColors.gray400,
                        ),
                        const SizedBox(height: TossSpacing.space3),
                        Text(
                          _searchQuery.isEmpty 
                              ? 'No other roles available to assign' 
                              : 'No matching roles found',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                  itemCount: filteredRoles.length,
                  itemBuilder: (context, index) {
                    final role = filteredRoles[index];
                    final isSelected = _selectedRoleName == role.roleName;
                    
                    return _RoleItem(
                      role: role,
                      isSelected: isSelected,
                      isCurrent: false,  // No longer needed since current role is excluded
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedRoleId = null;
                            _selectedRoleName = null;
                          } else {
                            _selectedRoleId = role.roleId;
                            _selectedRoleName = role.roleName;
                          }
                          _hasChanges = _selectedRoleName != widget.currentRole;
                        });
                      },
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
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: TossColors.error,
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    Text(
                      'Failed to load roles',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.error,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    TextButton(
                      onPressed: () => ref.invalidate(rolesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom Actions
          _buildBottomActions(),
        ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Role',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  'Assign or update role for this employee',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: TossColors.gray600),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
  
  
  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.background,
        border: const Border(
          top: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TossSecondaryButton(
                text: 'Cancel',
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              flex: 2,
              child: TossPrimaryButton(
                text: 'Apply Changes',
                onPressed: _hasChanges ? _saveChanges : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _saveChanges() async {
    if (_selectedRoleId == null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Role Required',
          message: 'Please select a role before saving',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: TossLoadingView(),
      ),
    );
    
    try {
      // Update user role in database with timeout
      final roleRepository = ref.read(roleRepositoryProvider);
      await roleRepository.updateUserRole(widget.userId, _selectedRoleId!).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out. Please check your connection and try again.');
        },
      );
      
      
      // Close loading dialog
      Navigator.of(context, rootNavigator: false).pop();
      
      
      // Return updated role name to parent
      widget.onSave(_selectedRoleName);
      
      
      // Refresh employees data
      await refreshEmployees(ref);
      
      
      // Close modal with success result
      Navigator.of(context, rootNavigator: false).pop(true);

      // Show success dialog on parent context
      Future.delayed(const Duration(milliseconds: 500), () async {
        if (context.mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => TossDialog.success(
              title: 'Role Updated!',
              message: 'Employee role has been updated successfully',
              primaryButtonText: 'Done',
              onPrimaryPressed: () => context.pop(),
            ),
          );
        }
      });
    } catch (e) {

      // Close loading dialog
      Navigator.of(context, rootNavigator: false).pop();

      // Show error dialog
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Failed to Update Role',
            message: 'Could not update employee role: ${e.toString()}',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => context.pop(),
          ),
        );
      }
    }
  }
}

class _RoleItem extends StatelessWidget {
  final Role role;
  final bool isSelected;
  final bool isCurrent;
  final VoidCallback onTap;

  const _RoleItem({
    required this.role,
    required this.isSelected,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: TossSpacing.space3),
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withValues(alpha: 0.05) : TossColors.background,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? TossColors.primary : TossColors.background,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                border: Border.all(
                  color: isSelected ? TossColors.primary : TossColors.gray300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: TossColors.background,
                    )
                  : null,
            ),
            
            const SizedBox(width: TossSpacing.space4),
            
            // Role Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          role.roleName,
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? TossColors.primary : TossColors.gray900,
                          ),
                        ),
                      ),
                      if (isCurrent) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: TossSpacing.space1,
                          ),
                          decoration: BoxDecoration(
                            color: TossColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          ),
                          child: Text(
                            'Current',
                            style: TossTextStyles.small.copyWith(
                              color: TossColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}