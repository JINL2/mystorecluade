import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/core/constants/ui_constants.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/toss/toss_modal.dart';
import '../../widgets/toss/toss_bottom_sheet.dart';
import '../debt_account_settings/widgets/account_mapping_form.dart';
import '../delegate_role/widgets/role_management_sheet.dart';

class ComponentTestPage extends ConsumerWidget {
  const ComponentTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Component Handle Test',
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TossColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Drag Handle Component Tests',
              style: TossTextStyles.h2.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            Text(
              'Test different drag handle implementations across components',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
              ),
            ),
            
            SizedBox(height: TossSpacing.space6),
            
            // Test buttons
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTestSection(
                      'Core Toss Components',
                      [
                        _buildTestButton(
                          context,
                          'TossModal',
                          'Handle bar (TossColors.gray300)',
                          Icons.web_asset,
                          () => _showTossModal(context),
                        ),
                        _buildTestButton(
                          context,
                          'TossBottomSheet',
                          'Handle bar (TossColors.gray300)',
                          Icons.view_agenda,
                          () => _showTossBottomSheet(context),
                        ),
                        _buildTestButton(
                          context,
                          'TossDropdown',
                          'Handle bar (TossColors.gray300)',
                          Icons.arrow_drop_down,
                          () => _showTossDropdown(context),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: TossSpacing.space6),
                    
                    _buildTestSection(
                      'Role Management Components',
                      [
                        _buildTestButton(
                          context,
                          'Role Management Sheet',
                          '3 handle bars (TossColors.gray300)',
                          Icons.admin_panel_settings,
                          () => _showRoleManagementSheet(context),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: TossSpacing.space6),
                    
                    _buildTestSection(
                      'Account Mapping Components',
                      [
                        _buildTestButton(
                          context,
                          'Account Mapping Form',
                          'Handle bar restored to grey (TossColors.gray300)',
                          Icons.account_balance,
                          () => _showAccountMappingForm(context),
                        ),
                        _buildTestButton(
                          context,
                          'Account Mapping List Item',
                          'Handle bar (TossColors.gray300)',
                          Icons.list_alt,
                          () => _showAccountMappingListOptions(context),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: TossSpacing.space6),
                    
                    _buildTestSection(
                      'Theme Level',
                      [
                        Container(
                          padding: EdgeInsets.all(TossSpacing.space4),
                          decoration: BoxDecoration(
                            color: TossColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            border: Border.all(
                              color: TossColors.info.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: TossColors.info,
                                size: UIConstants.iconSizeMedium,
                              ),
                              SizedBox(width: TossSpacing.space3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'app_theme.dart',
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Disabled default drag handle (showDragHandle: false)',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.info,
                                      ),
                                    ),
                                  ],
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
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTestSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TossTextStyles.h4.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space3),
        ...children,
      ],
    );
  }
  
  Widget _buildTestButton(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.surface,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.borderLight,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: UIConstants.featureIconContainerSize,
                  height: UIConstants.featureIconContainerSize,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(
                    icon,
                    color: TossColors.primary,
                    size: UIConstants.iconSizeLarge,
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        description,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: TossColors.textTertiary,
                  size: UIConstants.iconSizeMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _showTossModal(BuildContext context) {
    TossModal.show<void>(
      context: context,
      title: 'Sample Modal Title',
      subtitle: 'This is a subtitle for testing',
      showHandleBar: true, // Test with handle bar visible
      child: Container(
        height: 300,
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modal Content',
              style: TossTextStyles.h4.copyWith(
                color: TossColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: TossSpacing.space3),
            Text(
              'This modal tests the drag handle implementation. The handle uses TossColors.gray300 for visibility.',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
              ),
            ),
            SizedBox(height: TossSpacing.space4),
            Container(
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Text(
                'Handle Status: TossColors.gray300 (grey)',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
      ],
    );
  }
  
  void _showTossBottomSheet(BuildContext context) {
    TossBottomSheet.show<void>(
      context: context,
      title: 'Sample Bottom Sheet',
      content: Container(
        height: 350,
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: UIConstants.featureIconContainerSize,
                  height: UIConstants.featureIconContainerSize,
                  decoration: BoxDecoration(
                    color: TossColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(
                    Icons.settings,
                    color: TossColors.success,
                    size: UIConstants.iconSizeLarge,
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bottom Sheet Settings',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Configure your preferences',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space4),
            Container(
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Text(
                'Handle Status: TossColors.gray300 (grey)',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: TossSpacing.space4),
            Text(
              'This bottom sheet component tests the drag handle visibility. The handle uses TossColors.gray300 for consistent appearance.',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showTossDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 450,
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: Column(
          children: [
            // Manual drag handle to test - simulating TossDropdown handle
            Container(
              margin: EdgeInsets.only(top: TossSpacing.space3, bottom: TossSpacing.space4),
              width: UIConstants.modalDragHandleWidth,
              height: UIConstants.modalDragHandleHeight,
              decoration: BoxDecoration(
                color: TossColors.gray300, // TossDropdown uses grey handle now
                borderRadius: BorderRadius.circular(UIConstants.modalDragHandleBorderRadius),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Company',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    '5 options available',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space4),
                  
                  // Dummy dropdown options
                  ...['Samsung Electronics', 'Apple Inc.', 'Microsoft Corp.', 'Google LLC', 'Amazon.com Inc.'].map((company) =>
                    Container(
                      margin: EdgeInsets.only(bottom: TossSpacing.space2),
                      child: Material(
                        color: TossColors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          child: Container(
                            padding: EdgeInsets.all(TossSpacing.space3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              border: Border.all(color: TossColors.borderLight),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: UIConstants.featureIconContainerCompact,
                                  height: UIConstants.featureIconContainerCompact,
                                  decoration: BoxDecoration(
                                    color: TossColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.business,
                                    color: TossColors.primary,
                                    size: UIConstants.iconSizeSmall,
                                  ),
                                ),
                                SizedBox(width: TossSpacing.space3),
                                Expanded(
                                  child: Text(
                                    company,
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).toList(),
                  
                  SizedBox(height: TossSpacing.space3),
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Text(
                      'Handle Status: Grey handle (TossColors.gray300)',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.info,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showRoleManagementSheet(BuildContext context) {
    RoleManagementSheet.show(
      context,
      roleId: '22222',
      roleName: '22222',
      description: 'Custom role with specific permissions tailored to unique business requirements.',
      tags: ['Support', 'Temporary', 'Marketing', 'Customer Service', 'Technical'],
      permissions: [
        'View Dashboard', 'Manage Users', 'Edit Profiles', 'Delete Records',
        'Create Reports', 'Export Data', 'Import Data', 'Manage Settings',
        'View Analytics', 'Manage Roles', 'Assign Permissions', 'Manage Tags',
        'Create Backups', 'Restore Data', 'Monitor System', 'Configure API',
        'Manage Billing', 'View Logs', 'Send Notifications', 'Manage Templates',
        'Approve Requests', 'Reject Requests', 'Manage Workflows', 'Audit Trails'
      ], // 24 realistic permissions
      memberCount: 3,
      canEdit: true,
      canDelegate: true,
    );
  }
  
  void _showAccountMappingForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) => AccountMappingForm(
        counterpartyId: 'cp_samsung_electronics',
        counterpartyName: 'Samsung Electronics Co., Ltd.',
      ),
    );
  }
  
  void _showAccountMappingListOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle from account_mapping_list_item.dart
              Container(
                margin: EdgeInsets.only(top: TossSpacing.space2),
                width: UIConstants.modalDragHandleWidth,
                height: UIConstants.modalDragHandleHeight,
                decoration: BoxDecoration(
                  color: TossColors.gray300, // Consistent grey handle
                  borderRadius: BorderRadius.circular(UIConstants.modalDragHandleBorderRadius),
                ),
              ),
              
              SizedBox(height: TossSpacing.space4),
              
              Text(
                'Account Mapping List Item Handle Test',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              SizedBox(height: TossSpacing.space2),
              
              Text(
                'Handle bar uses TossColors.gray300',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
              
              SizedBox(height: TossSpacing.space6),
              
              Container(
                padding: EdgeInsets.all(TossSpacing.space4),
                margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Text(
                  'This simulates the options bottom sheet from AccountMappingListItem',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              SizedBox(height: TossSpacing.space6),
            ],
          ),
        ),
      ),
    );
  }
}