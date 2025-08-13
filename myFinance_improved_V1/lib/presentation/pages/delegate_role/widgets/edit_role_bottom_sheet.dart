import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../providers/delegate_role_providers.dart';

class EditRoleBottomSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> role;

  const EditRoleBottomSheet({
    super.key,
    required this.role,
  });

  static Future<void> show(BuildContext context, Map<String, dynamic> role) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditRoleBottomSheet(role: role),
    );
  }

  @override
  ConsumerState<EditRoleBottomSheet> createState() => _EditRoleBottomSheetState();
}

class _EditRoleBottomSheetState extends ConsumerState<EditRoleBottomSheet> {
  late TextEditingController _roleNameController;
  late List<String> _selectedPermissions;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _roleNameController = TextEditingController(text: widget.role['roleName']);
    _selectedPermissions = List<String>.from(widget.role['permissions']);
  }

  @override
  void dispose() {
    _roleNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.85 + keyboardHeight,
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.lg),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.all(TossSpacing.space5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Role',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: TossColors.gray600),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role name field
                  Text(
                    'Role Name',
                    style: TossTextStyles.label.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  TextField(
                    controller: _roleNameController,
                    style: TossTextStyles.body,
                    decoration: InputDecoration(
                      hintText: 'Enter role name',
                      hintStyle: TossTextStyles.body.copyWith(
                        color: TossColors.gray400,
                      ),
                      filled: true,
                      fillColor: TossColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        borderSide: BorderSide(color: TossColors.gray200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        borderSide: BorderSide(color: TossColors.gray200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        borderSide: BorderSide(color: TossColors.primary),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: TossSpacing.space5),
                  
                  // Permissions section
                  Text(
                    'Permissions',
                    style: TossTextStyles.label.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      border: Border.all(color: TossColors.gray200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: TossColors.gray600,
                        ),
                        SizedBox(width: TossSpacing.space2),
                        Expanded(
                          child: Text(
                            'This role currently has ${_selectedPermissions.length} permissions. Permission management will be available in the next update.',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: TossSpacing.space5),
                  
                  // Warning for system roles
                  if (_isSystemRole()) ...[
                    Container(
                      padding: EdgeInsets.all(TossSpacing.space3),
                      decoration: BoxDecoration(
                        color: TossColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        border: Border.all(color: TossColors.warning.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_outlined,
                            size: 20,
                            color: TossColors.warning,
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Expanded(
                            child: Text(
                              'This is a system role. Editing system roles may affect core functionality.',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: TossSpacing.space5),
                  ],
                ],
              ),
            ),
          ),
          
          // Bottom action buttons
          Container(
            padding: EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.background,
              border: Border(
                top: BorderSide(color: TossColors.gray200),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                      side: BorderSide(color: TossColors.gray300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TossTextStyles.label.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveRole,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.primary,
                      padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: TossTextStyles.label.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isSystemRole() {
    final roleName = widget.role['roleName'].toString().toLowerCase();
    return ['owner', 'manager', 'employee'].contains(roleName);
  }

  Future<void> _saveRole() async {
    final roleName = _roleNameController.text.trim();
    if (roleName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a role name'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implement actual role update logic
      // For now, just simulate an API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        // Refresh the roles list
        ref.invalidate(allCompanyRolesProvider);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Role updated successfully'),
            backgroundColor: TossColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update role: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}