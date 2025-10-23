/// Permissions Form - Visibility and permission settings for template creation
///
/// Purpose: Manages template access control in Step 3:
/// - Visibility level (Public/Private) selection
/// - Permission level (Manager/Common) selection  
/// - Clear explanations of each option
/// - Informational guidance about template usage
///
/// Usage: PermissionsForm(onVisibilityChanged: callback, onPermissionChanged: callback)
import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';

class PermissionsForm extends StatelessWidget {
  final String selectedVisibility;
  final String selectedPermission;
  final void Function(String?) onVisibilityChanged;
  final void Function(String?) onPermissionChanged;
  final bool enabled;
  
  const PermissionsForm({
    super.key,
    required this.selectedVisibility,
    required this.selectedPermission,
    required this.onVisibilityChanged,
    required this.onPermissionChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 3: Permissions & Tags',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: TossSpacing.space5),
          
          // Visibility Level Dropdown
          TossDropdown<String>(
            label: 'Visibility Level',
            value: selectedVisibility,
            onChanged: enabled ? onVisibilityChanged : null,
            items: const [
              TossDropdownItem(
                value: 'public',
                label: 'Public',
                subtitle: 'Visible to all users in the company',
              ),
              TossDropdownItem(
                value: 'private',
                label: 'Private',
                subtitle: 'Only visible to you',
              ),
            ],
          ),

          SizedBox(height: TossSpacing.space4),

          // Permission Level Dropdown
          TossDropdown<String>(
            label: 'Permission',
            value: selectedPermission,
            onChanged: enabled ? onPermissionChanged : null,
            items: const [
              TossDropdownItem(
                value: 'admin',
                label: 'Admin',
                subtitle: 'Only admins can use this template',
              ),
              TossDropdownItem(
                value: 'common',
                label: 'Common',
                subtitle: 'All authorized users can use this template',
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space4),
          
          // Info box about permissions
          _buildInfoBox(),
          
          // Add padding at bottom for better scroll experience
          SizedBox(height: TossSpacing.space5),
        ],
      ),
    );
  }
  
  Widget _buildInfoBox() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primarySurface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.primarySurface,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: TossColors.primary,
          ),
          SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Templates help standardize common transactions. Set visibility to control who can see this template, and permission to control who can use it.',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Validate permissions form
  PermissionsValidationResult validate() {
    final errors = <String>[];
    
    if (!_isValidVisibility(selectedVisibility)) {
      errors.add('Please select a valid visibility level');
    }
    
    if (!_isValidPermission(selectedPermission)) {
      errors.add('Please select a valid permission level');
    }
    
    return PermissionsValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      visibility: selectedVisibility,
      permission: selectedPermission,
    );
  }
  
  bool _isValidVisibility(String visibility) {
    return visibility == 'public' || visibility == 'private';
  }

  bool _isValidPermission(String permission) {
    return permission == 'admin' || permission == 'common';
  }
  
  /// Get form data
  TemplatePermissions get formData => TemplatePermissions(
    visibility: selectedVisibility,
    permission: selectedPermission,
  );
}

class PermissionsValidationResult {
  final bool isValid;
  final List<String> errors;
  final String visibility;
  final String permission;
  
  const PermissionsValidationResult({
    required this.isValid,
    required this.errors,
    required this.visibility,
    required this.permission,
  });
}

class TemplatePermissions {
  final String visibility;
  final String permission;
  
  const TemplatePermissions({
    required this.visibility,
    required this.permission,
  });
  
  /// Check if permissions are restrictive
  bool get isRestrictive => visibility == 'private' || permission == 'admin';

  /// Get description of access level
  String get accessDescription {
    if (visibility == 'private') {
      return 'Private template - only you can see and use it';
    } else if (permission == 'admin') {
      return 'Public template - visible to all, usable by admins only';
    } else {
      return 'Public template - visible and usable by all authorized users';
    }
  }
}