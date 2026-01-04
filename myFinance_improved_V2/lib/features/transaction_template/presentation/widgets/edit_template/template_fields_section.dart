/// Template Fields Section - Editable template-level settings
///
/// Purpose: Form section for template-level editable fields
/// - Template name and description
/// - Required attachment toggle
/// - Permission selector (Admin/General)
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:myfinance_improved/shared/widgets/index.dart';

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/enums/template_constants.dart';

/// Template-level editable fields section
class TemplateFieldsSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String? nameError;
  final bool requiredAttachment;
  final String permission;
  final bool canChangeToAdmin;
  final ValueChanged<bool> onRequiredAttachmentChanged;
  final ValueChanged<String> onPermissionChanged;

  const TemplateFieldsSection({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.nameError,
    required this.requiredAttachment,
    required this.permission,
    required this.canChangeToAdmin,
    required this.onRequiredAttachmentChanged,
    required this.onPermissionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              const Icon(
                Icons.settings,
                color: TossColors.primary,
                size: 20,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Template Settings',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),

          // Template name
          TossTextField(
            controller: nameController,
            label: 'Template Name',
            isRequired: true,
            hintText: 'Enter template name',
          ),
          if (nameError != null) ...[
            const SizedBox(height: TossSpacing.space1),
            Text(
              nameError!,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.error,
              ),
            ),
          ],

          const SizedBox(height: TossSpacing.space3),

          // Template description
          TossTextField(
            controller: descriptionController,
            label: 'Description',
            hintText: 'Add a description (optional)',
            maxLines: 2,
          ),

          const SizedBox(height: TossSpacing.space3),

          // Required attachment toggle
          _ToggleRow(
            label: 'Require Attachment',
            description:
                'Require receipt or document when using this template',
            value: requiredAttachment,
            onChanged: onRequiredAttachmentChanged,
          ),

          const SizedBox(height: TossSpacing.space3),

          // Permission selector (Admin/General)
          _PermissionSelector(
            permission: permission,
            canChangeToAdmin: canChangeToAdmin,
            onPermissionChanged: onPermissionChanged,
          ),
        ],
      ),
    );
  }
}

/// Toggle row widget for boolean settings
class _ToggleRow extends StatelessWidget {
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                description,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: TossColors.white,
          activeTrackColor: TossColors.primary,
          inactiveThumbColor: TossColors.white,
          inactiveTrackColor: TossColors.gray300,
        ),
      ],
    );
  }
}

/// Permission selector (Admin/General)
class _PermissionSelector extends StatelessWidget {
  final String permission;
  final bool canChangeToAdmin;
  final ValueChanged<String> onPermissionChanged;

  const _PermissionSelector({
    required this.permission,
    required this.canChangeToAdmin,
    required this.onPermissionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = permission == TemplateConstants.adminPermissionUUID;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Access Level',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Tooltip(
              message:
                  'Admin: Only visible in Admin tab\nGeneral: Visible in General tab',
              child: Icon(
                Icons.info_outline,
                size: 16,
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          children: [
            _PermissionChip(
              value: TemplateConstants.commonPermissionUUID,
              label: 'General',
              icon: Icons.people_outline,
              isSelected: permission == TemplateConstants.commonPermissionUUID,
              onTap: () =>
                  onPermissionChanged(TemplateConstants.commonPermissionUUID),
            ),
            if (canChangeToAdmin)
              _PermissionChip(
                value: TemplateConstants.adminPermissionUUID,
                label: 'Admin',
                icon: Icons.admin_panel_settings_outlined,
                isSelected:
                    permission == TemplateConstants.adminPermissionUUID,
                onTap: () =>
                    onPermissionChanged(TemplateConstants.adminPermissionUUID),
              ),
          ],
        ),
        if (!canChangeToAdmin && isAdmin)
          Padding(
            padding: const EdgeInsets.only(top: TossSpacing.space2),
            child: Text(
              'Only admins can change access level',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
      ],
    );
  }
}

/// Permission chip widget
class _PermissionChip extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PermissionChip({
    required this.value,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? TossColors.white : TossColors.gray700,
            ),
            const SizedBox(width: TossSpacing.space1),
            Text(
              label,
              style: TossTextStyles.label.copyWith(
                color: isSelected ? TossColors.white : TossColors.gray700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
