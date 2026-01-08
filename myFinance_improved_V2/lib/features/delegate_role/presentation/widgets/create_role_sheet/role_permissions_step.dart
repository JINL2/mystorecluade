import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/features/delegate_role/presentation/providers/role_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Step 2: Role Permissions
///
/// Displays feature categories and allows selecting permissions
class RolePermissionsStep extends ConsumerStatefulWidget {
  final Set<String> selectedPermissions;
  final Set<String> expandedCategories;
  final Function(String) onTogglePermission;
  final Function(List<String>, bool) onToggleCategoryPermissions;
  final VoidCallback onToggleExpandCategory;

  const RolePermissionsStep({
    super.key,
    required this.selectedPermissions,
    required this.expandedCategories,
    required this.onTogglePermission,
    required this.onToggleCategoryPermissions,
    required this.onToggleExpandCategory,
  });

  @override
  ConsumerState<RolePermissionsStep> createState() => _RolePermissionsStepState();
}

class _RolePermissionsStepState extends ConsumerState<RolePermissionsStep> {
  @override
  Widget build(BuildContext context) {
    final allFeaturesAsync = ref.watch(allFeaturesWithCategoriesProvider);

    return allFeaturesAsync.when(
      data: (categories) => _buildPermissionsContent(categories),
      loading: () => const TossLoadingView(message: 'Loading permissions...'),
      error: (error, stack) => TossErrorView(
        error: error,
        title: 'Failed to load permissions',
        onRetry: () => ref.invalidate(allFeaturesWithCategoriesProvider),
      ),
    );
  }

  Widget _buildPermissionsContent(List<Map<String, dynamic>> categories) {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        children: [
          _buildHeader(categories),
          const SizedBox(height: TossSpacing.space4),
          ...categories.map((category) {
            final categoryName = category['category_name'] as String;
            final features =
                (category['features'] as List? ?? []).cast<Map<String, dynamic>>();

            if (features.isEmpty) return const SizedBox.shrink();

            return _buildPermissionCategory(categoryName, features);
          }),
        ],
      ),
    );
  }

  Widget _buildHeader(List<Map<String, dynamic>> categories) {
    final allFeatureIds = <String>[];
    for (final category in categories) {
      final features = (category['features'] as List? ?? []).cast<Map<String, dynamic>>();
      for (final feature in features) {
        allFeatureIds.add(feature['feature_id'] as String);
      }
    }

    final isAllSelected = allFeatureIds.every(widget.selectedPermissions.contains);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Permissions',
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: TossFontWeight.semibold,
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(height: TossSpacing.space1),
            Text(
              '${widget.selectedPermissions.length} selected',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
        Material(
          color: TossColors.transparent,
          child: InkWell(
            onTap: () {
              if (isAllSelected) {
                for (final id in allFeatureIds) {
                  widget.onTogglePermission(id);
                }
              } else {
                for (final id in allFeatureIds) {
                  if (!widget.selectedPermissions.contains(id)) {
                    widget.onTogglePermission(id);
                  }
                }
              }
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              child: Text(
                isAllSelected ? 'Clear All' : 'Select All',
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.primary,
                  fontWeight: TossFontWeight.semibold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionCategory(String title, List<Map<String, dynamic>> features) {
    final isExpanded = widget.expandedCategories.contains(title);
    final featureIds = features.map((f) => f['feature_id'] as String).toList();
    final selectedCount = featureIds.where(widget.selectedPermissions.contains).length;
    final allSelected = selectedCount == features.length && features.isNotEmpty;
    final someSelected = selectedCount > 0 && selectedCount < features.length;

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        children: [
          _buildCategoryHeader(
            title,
            features,
            isExpanded,
            allSelected,
            someSelected,
            selectedCount,
            featureIds,
          ),
          if (isExpanded) _buildCategoryFeatures(features),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(
    String title,
    List<Map<String, dynamic>> features,
    bool isExpanded,
    bool allSelected,
    bool someSelected,
    int selectedCount,
    List<String> featureIds,
  ) {
    return Material(
      color: TossColors.transparent,
      borderRadius: BorderRadius.vertical(
        top: const Radius.circular(TossBorderRadius.lg),
        bottom: Radius.circular(isExpanded ? 0 : TossBorderRadius.lg),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            if (widget.expandedCategories.contains(title)) {
              widget.expandedCategories.remove(title);
            } else {
              widget.expandedCategories.add(title);
            }
          });
        },
        borderRadius: BorderRadius.vertical(
          top: const Radius.circular(TossBorderRadius.lg),
          bottom: Radius.circular(isExpanded ? 0 : TossBorderRadius.lg),
        ),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Row(
            children: [
              _buildCategoryCheckbox(allSelected, someSelected, featureIds),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: TossFontWeight.semibold,
                        color: TossColors.gray900,
                      ),
                    ),
                    if (selectedCount > 0) ...[
                      const SizedBox(height: TossSpacing.space1),
                      Text(
                        '$selectedCount of ${features.length} selected',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: TossAnimations.normal,
                child: const Icon(
                  Icons.expand_more,
                  color: TossColors.gray600,
                  size: TossSpacing.iconMD2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCheckbox(bool allSelected, bool someSelected, List<String> featureIds) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => widget.onToggleCategoryPermissions(featureIds, !allSelected),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space1),
          child: AnimatedContainer(
            duration: TossAnimations.normal,
            width: TossSpacing.iconMD,
            height: TossSpacing.iconMD,
            decoration: BoxDecoration(
              color: allSelected
                  ? TossColors.primary
                  : someSelected
                      ? TossColors.primary.withValues(alpha: TossOpacity.heavy)
                      : TossColors.white,
              border: Border.all(
                color: allSelected || someSelected
                    ? TossColors.primary
                    : TossColors.gray300,
                width: allSelected || someSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: allSelected
                ? const Icon(Icons.check, size: TossSpacing.iconXS, color: TossColors.white)
                : someSelected
                    ? Center(
                        child: Container(
                          width: TossSpacing.space2,
                          height: TossDimensions.timelineLineWidth,
                          color: TossColors.white,
                        ),
                      )
                    : null,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFeatures(List<Map<String, dynamic>> features) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: TossColors.gray200, width: 0.5),
        ),
      ),
      child: Column(
        children: features.asMap().entries.map((entry) {
          final index = entry.key;
          final feature = entry.value;
          final featureId = feature['feature_id'] as String;
          final featureName = feature['feature_name'] as String;
          final isSelected = widget.selectedPermissions.contains(featureId);
          final isLast = index == features.length - 1;

          return Column(
            children: [
              Material(
                color: TossColors.transparent,
                child: InkWell(
                  onTap: () => widget.onTogglePermission(featureId),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: TossSpacing.space6),
                        AnimatedContainer(
                          duration: TossAnimations.normal,
                          width: TossSpacing.iconMD,
                          height: TossSpacing.iconMD,
                          decoration: BoxDecoration(
                            color: isSelected ? TossColors.primary : TossColors.white,
                            border: Border.all(
                              color: isSelected ? TossColors.primary : TossColors.gray300,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: TossSpacing.iconXS, color: TossColors.white)
                              : null,
                        ),
                        const SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: Text(
                            featureName,
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  margin: const EdgeInsets.only(left: TossSpacing.space10),
                  height: 0.5,
                  color: TossColors.gray200,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
