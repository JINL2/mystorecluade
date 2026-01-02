import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../providers/role_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Permissions Tab for role management - displays and edits permissions
class PermissionsTab extends ConsumerStatefulWidget {
  final String roleId;
  final String roleName;
  final bool canEdit;
  final Set<String> selectedPermissions;
  final ValueChanged<Set<String>> onPermissionsChanged;

  const PermissionsTab({
    super.key,
    required this.roleId,
    required this.roleName,
    required this.canEdit,
    required this.selectedPermissions,
    required this.onPermissionsChanged,
  });

  @override
  ConsumerState<PermissionsTab> createState() => _PermissionsTabState();
}

class _PermissionsTabState extends ConsumerState<PermissionsTab> {
  Set<String> _expandedCategories = {};

  @override
  Widget build(BuildContext context) {
    final rolePermissionsAsync =
        ref.watch(rolePermissionsProvider(widget.roleId));

    return rolePermissionsAsync.when(
      data: (permissionData) {
        final categories = permissionData['categories'] as List;

        return SingleChildScrollView(
          primary: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            TossSpacing.space5,
            TossSpacing.space5,
            TossSpacing.space5,
            TossSpacing.space10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              _buildHeaderSection(categories),
              const SizedBox(height: TossSpacing.space4),

              // Permission categories
              ...categories.map((category) {
                final categoryName = category['category_name'] as String;
                final features = (category['features'] as List? ?? [])
                    .cast<Map<String, dynamic>>();

                if (features.isEmpty) return const SizedBox.shrink();

                return _buildPermissionCategory(categoryName, features);
              }),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space10),
          child: TossLoadingView(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: TossColors.error, size: 48),
              const SizedBox(height: TossSpacing.space3),
              Text(
                'Failed to load permissions',
                style: TossTextStyles.body.copyWith(color: TossColors.error),
              ),
              const SizedBox(height: TossSpacing.space2),
              TossButton.primary(
                text: 'Retry',
                onPressed: () =>
                    ref.invalidate(rolePermissionsProvider(widget.roleId)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(List categories) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Role Permissions',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                widget.roleName.toLowerCase() == 'owner'
                    ? 'Owner role always has full permissions'
                    : widget.canEdit
                        ? 'Configure what this role can access and do'
                        : 'View permissions for this role',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ),
        // Quick actions
        if (widget.canEdit)
          TossButton.textButton(
            text: widget.selectedPermissions.isEmpty ? 'Select all' : 'Clear all',
            onPressed: () {
              if (widget.selectedPermissions.isEmpty) {
                // Select all available permissions
                final allFeatureIds = <String>{};
                for (final category in categories) {
                  final features = (category['features'] as List? ?? [])
                      .cast<Map<String, dynamic>>();
                  for (final feature in features) {
                    allFeatureIds.add(feature['feature_id'] as String);
                  }
                }
                widget.onPermissionsChanged(allFeatureIds);
              } else {
                // Clear all selected permissions
                widget.onPermissionsChanged({});
              }
            },
            textColor: TossColors.gray600,
          ),
      ],
    );
  }

  Widget _buildPermissionCategory(
      String title, List<Map<String, dynamic>> features) {
    final isExpanded = _expandedCategories.contains(title);
    final featureIds = features.map((f) => f['feature_id'] as String).toList();
    final selectedCount = featureIds
        .where((id) => widget.selectedPermissions.contains(id))
        .length;
    final allSelected =
        selectedCount == features.length && features.isNotEmpty;
    final someSelected = selectedCount > 0 && selectedCount < features.length;

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Collapsible header with select all
          _buildCategoryHeader(
            title,
            features,
            featureIds,
            isExpanded,
            allSelected,
            someSelected,
            selectedCount,
          ),

          // Expanded content
          if (isExpanded) ...[
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: TossColors.gray200, width: 1),
                ),
              ),
              child: Column(
                children: features.map((feature) {
                  final featureId = feature['feature_id'] as String;
                  final featureName = feature['feature_name'] as String;
                  final isSelected =
                      widget.selectedPermissions.contains(featureId);

                  return _buildPermissionItem(featureId, featureName, isSelected);
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(
    String title,
    List<Map<String, dynamic>> features,
    List<String> featureIds,
    bool isExpanded,
    bool allSelected,
    bool someSelected,
    int selectedCount,
  ) {
    return Material(
      color: TossColors.transparent,
      borderRadius: BorderRadius.vertical(
        top: const Radius.circular(TossBorderRadius.md),
        bottom: Radius.circular(isExpanded ? 0 : TossBorderRadius.md),
      ),
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        excludeFromSemantics: true,
        onTap: () {
          setState(() {
            if (isExpanded) {
              _expandedCategories.remove(title);
            } else {
              _expandedCategories.add(title);
            }
          });
        },
        borderRadius: BorderRadius.vertical(
          top: const Radius.circular(TossBorderRadius.md),
          bottom: Radius.circular(isExpanded ? 0 : TossBorderRadius.md),
        ),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Row(
            children: [
              // Select all checkbox
              _buildCategoryCheckbox(featureIds, allSelected, someSelected),
              const SizedBox(width: TossSpacing.space3),
              // Category title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.gray900,
                      ),
                    ),
                    if (selectedCount > 0)
                      Text(
                        '$selectedCount of ${features.length} selected',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                  ],
                ),
              ),
              // Expand/collapse icon
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                child: AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: TossAnimations.normal,
                  child: const Icon(
                    Icons.expand_more,
                    color: TossColors.gray600,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCheckbox(
    List<String> featureIds,
    bool allSelected,
    bool someSelected,
  ) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: widget.canEdit
            ? () {
                _toggleCategoryPermissions(featureIds, !allSelected);
              }
            : null,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: TossAnimations.normal,
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: allSelected || someSelected
                  ? TossColors.primary
                  : TossColors.background,
              border: Border.all(
                color: allSelected || someSelected
                    ? TossColors.primary
                    : TossColors.gray300,
                width: allSelected || someSelected ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: allSelected
                ? const Icon(
                    Icons.check,
                    size: 14,
                    color: TossColors.white,
                  )
                : someSelected
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 2,
                          decoration: BoxDecoration(
                            color: TossColors.white,
                            borderRadius:
                                BorderRadius.circular(TossBorderRadius.xs),
                          ),
                        ),
                      )
                    : null,
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem(
      String featureId, String featureName, bool isSelected) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        excludeFromSemantics: true,
        onTap: widget.canEdit ? () => _togglePermission(featureId) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: TossColors.gray100,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: TossSpacing.space8),
              // Individual checkbox
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: TossAnimations.normal,
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? TossColors.primary : TossColors.background,
                    border: Border.all(
                      color:
                          isSelected ? TossColors.primary : TossColors.gray300,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: TossColors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Text(
                  featureName,
                  style: TossTextStyles.body.copyWith(
                    color:
                        widget.canEdit ? TossColors.gray900 : TossColors.gray500,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePermission(String featureId) {
    if (!widget.canEdit) return;

    final newPermissions = Set<String>.from(widget.selectedPermissions);
    if (newPermissions.contains(featureId)) {
      newPermissions.remove(featureId);
    } else {
      newPermissions.add(featureId);
    }
    widget.onPermissionsChanged(newPermissions);
  }

  void _toggleCategoryPermissions(List<String> featureIds, bool select) {
    if (!widget.canEdit) return;

    final newPermissions = Set<String>.from(widget.selectedPermissions);
    if (select) {
      newPermissions.addAll(featureIds);
    } else {
      newPermissions.removeAll(featureIds);
    }
    widget.onPermissionsChanged(newPermissions);
  }
}
