import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import 'tag_selection_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Details Tab for role management - displays and edits role info
class DetailsTab extends StatelessWidget {
  final String roleName;
  final int memberCount;
  final int permissionCount;
  final bool canEdit;
  final TextEditingController roleNameController;
  final TextEditingController descriptionController;
  final FocusNode roleNameFocus;
  final FocusNode descriptionFocus;
  final List<String> selectedTags;
  final ValueChanged<List<String>> onTagsChanged;

  const DetailsTab({
    super.key,
    required this.roleName,
    required this.memberCount,
    required this.permissionCount,
    required this.canEdit,
    required this.roleNameController,
    required this.descriptionController,
    required this.roleNameFocus,
    required this.descriptionFocus,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          // Header section with title and description
          _buildHeaderSection(),

          // Scrollable form content with keyboard handling
          Expanded(
            child: ScrollableFormWrapper(
              padding: const EdgeInsets.fromLTRB(
                TossSpacing.space5,
                0,
                TossSpacing.space5,
                TossSpacing.space10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role name
                  _buildRoleNameField(context),

                  const SizedBox(height: TossSpacing.space5),

                  // Role description
                  _buildDescriptionField(context),

                  const SizedBox(height: TossSpacing.space5),

                  // Tags section
                  _buildTagsSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
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
          Text(
            'Role Details',
            style: TossTextStyles.h3.copyWith(
              fontWeight: TossFontWeight.bold,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            'Manage role information and configuration',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          // Compact stats
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: TossSpacing.iconSM,
                        color: TossColors.gray600,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Text(
                        '$memberCount Members',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray700,
                          fontWeight: TossFontWeight.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: TossSpacing.iconSM2,
                  color: TossColors.gray300,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        size: TossSpacing.iconSM,
                        color: TossColors.gray600,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Text(
                        '$permissionCount Permissions',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray700,
                          fontWeight: TossFontWeight.medium,
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
    );
  }

  Widget _buildRoleNameField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Role Name',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossEnhancedTextField(
          controller: roleNameController,
          focusNode: roleNameFocus,
          enabled: canEdit,
          hintText: 'Enter role name',
          textInputAction: TextInputAction.next,
          showKeyboardToolbar: true,
          keyboardDoneText: 'Next',
          onKeyboardDone: () => descriptionFocus.requestFocus(),
          enableTapDismiss: false,
        ),
      ],
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossEnhancedTextField(
          controller: descriptionController,
          focusNode: descriptionFocus,
          enabled: canEdit,
          hintText: 'Describe what this role does...',
          maxLines: 3,
          textInputAction: TextInputAction.done,
          showKeyboardToolbar: true,
          keyboardDoneText: 'Done',
          onKeyboardDone: () => FocusScope.of(context).unfocus(),
          enableTapDismiss: false,
        ),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tags',
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray700,
                fontWeight: TossFontWeight.semibold,
              ),
            ),
            if (canEdit)
              InkWell(
                onTap: () => _showTagSelectionSheet(context),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                child: Padding(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  child: Icon(
                    Icons.edit,
                    size: TossSpacing.iconSM2,
                    color: TossColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: TossSpacing.space2),
        _buildTagsDisplay(),
      ],
    );
  }

  Widget _buildTagsDisplay() {
    if (selectedTags.isNotEmpty) {
      return Wrap(
        spacing: TossSpacing.space2,
        runSpacing: TossSpacing.space2,
        children: selectedTags
            .map((tag) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    border: Border.all(
                      color: TossColors.primary,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tag,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.primary,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ))
            .toList(),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          border: Border.all(color: TossColors.gray200),
        ),
        child: Row(
          children: [
            const Icon(Icons.label_outline,
                color: TossColors.gray400, size: TossSpacing.iconSM),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'No tags assigned',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showTagSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
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
          child: TagSelectionSheet(
            selectedTags: List.from(selectedTags),
            onTagsSelected: onTagsChanged,
          ),
        ),
      ),
    );
  }
}
