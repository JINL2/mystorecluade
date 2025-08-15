import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../widgets/toss/toss_checkbox.dart';
import '../../../widgets/toss/toss_search_field.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../models/role.dart';
import '../providers/employee_setting_providers.dart';

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

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Search Bar
          Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
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
                  if (_searchQuery.isEmpty) return true;
                  return role.roleName.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();
                
                if (filteredRoles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: TossColors.gray400,
                        ),
                        SizedBox(height: TossSpacing.space3),
                        Text(
                          _searchQuery.isEmpty ? 'No roles available' : 'No matching roles found',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                  itemCount: filteredRoles.length,
                  itemBuilder: (context, index) {
                    final role = filteredRoles[index];
                    final isSelected = _selectedRoleName == role.roleName;
                    
                    final isCurrent = role.roleName == widget.currentRole;
                    
                    return _RoleItem(
                      role: role,
                      isSelected: isSelected,
                      isCurrent: isCurrent,
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
              loading: () => Center(
                child: CircularProgressIndicator(color: TossColors.primary),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: TossColors.error,
                    ),
                    SizedBox(height: TossSpacing.space3),
                    Text(
                      'Failed to load roles',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.error,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    TextButton(
                      onPressed: () => ref.invalidate(rolesProvider),
                      child: Text('Retry'),
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
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
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
                  style: TossTextStyles.h2.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
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
            icon: Icon(Icons.close, color: TossColors.gray600),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
  
  
  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.background,
        border: Border(
          top: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
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
            SizedBox(width: TossSpacing.space3),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a role'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: TossColors.primary,
        ),
      ),
    );
    
    try {
      // Update user role in database with timeout
      final roleService = ref.read(roleServiceProvider);
      await roleService.updateUserRole(widget.userId, _selectedRoleId!).timeout(
        Duration(seconds: 10),
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
      
      
      // Show success message on parent context
      Future.delayed(Duration(milliseconds: 500), () {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Role updated successfully'),
              backgroundColor: TossColors.success,
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    } catch (e) {
      
      // Close loading dialog
      Navigator.of(context, rootNavigator: false).pop();
      
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update role: ${e.toString()}'),
            backgroundColor: TossColors.error,
            duration: Duration(seconds: 3),
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
        margin: EdgeInsets.only(bottom: TossSpacing.space3),
        padding: EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withOpacity(0.05) : TossColors.background,
          borderRadius: BorderRadius.circular(12),
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
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? TossColors.primary : TossColors.gray300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: TossColors.background,
                    )
                  : null,
            ),
            
            SizedBox(width: TossSpacing.space4),
            
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
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: TossSpacing.space1,
                          ),
                          decoration: BoxDecoration(
                            color: TossColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Current',
                            style: TossTextStyles.labelSmall.copyWith(
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