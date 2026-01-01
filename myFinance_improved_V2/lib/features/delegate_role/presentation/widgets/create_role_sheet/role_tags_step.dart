import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/core/utils/tag_validator.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Step 3: Role Tags (Optional)
///
/// Allows adding up to 5 tags to categorize the role
class RoleTagsStep extends StatelessWidget {
  final List<String> selectedTags;
  final Function(String) onAddTag;
  final Function(String) onRemoveTag;

  static const List<String> suggestedTags = [
    'Critical',
    'Support',
    'Management',
    'Operations',
    'Temporary',
    'Finance',
    'Sales',
    'Marketing',
    'Technical',
    'Customer Service',
    'Admin',
    'Restricted',
  ];

  static final Map<String, Color> tagColors = {
    'Critical': TossColors.error,
    'Support': TossColors.info,
    'Management': TossColors.primary,
    'Operations': TossColors.success,
    'Temporary': TossColors.warning,
    'Finance': TossColors.primary,
    'Sales': TossColors.success,
    'Marketing': TossColors.info,
    'Technical': TossColors.gray700,
    'Customer Service': TossColors.info,
    'Admin': TossColors.primary,
    'Restricted': TossColors.error,
  };

  const RoleTagsStep({
    super.key,
    required this.selectedTags,
    required this.onAddTag,
    required this.onRemoveTag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Tags (Optional)',
            style: TossTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            'Add up to ${TagValidator.MAX_TAGS} tags to help categorize this role',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          _buildTagsSection(context),
        ],
      ),
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tags header with counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Suggested Tags',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${selectedTags.length}/${TagValidator.MAX_TAGS}',
              style: TossTextStyles.caption.copyWith(
                color: selectedTags.length >= TagValidator.MAX_TAGS
                    ? TossColors.primary
                    : TossColors.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        // All tags in one place
        _buildAllTagsWrap(context),
      ],
    );
  }

  Widget _buildSelectedTagsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Tags',
            style: TossTextStyles.labelMedium.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: selectedTags
                .map((tag) => _buildSelectedTag(tag))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTag(String tag) {
    final color = tagColors[tag] ?? TossColors.gray600;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: TossTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: TossSpacing.space1),
          InkWell(
            onTap: () => onRemoveTag(tag),
            borderRadius: BorderRadius.circular(TossBorderRadius.full),
            child: Icon(
              Icons.close,
              size: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllTagsWrap(BuildContext context) {
    return Wrap(
      spacing: TossSpacing.space2,
      runSpacing: TossSpacing.space2,
      children: suggestedTags.map((tag) => _buildTag(context, tag)).toList(),
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    final isSelected = selectedTags.contains(tag);
    final color = tagColors[tag] ?? TossColors.gray600;

    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () {
          if (isSelected) {
            onRemoveTag(tag);
          } else {
            _handleAddTag(context, tag);
          }
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: isSelected ? TossColors.primary : TossColors.gray300,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? Icons.check : Icons.add,
                size: 14,
                color: isSelected ? TossColors.primary : TossColors.primary,
              ),
              const SizedBox(width: TossSpacing.space1),
              Text(
                tag,
                style: TossTextStyles.caption.copyWith(
                  color: isSelected ? TossColors.primary : TossColors.gray700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllTagsSelectedMessage() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          'All suggested tags have been selected',
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.gray600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  void _handleAddTag(BuildContext context, String tag) {
    final validation = TagValidator.validateTag(tag);
    if (validation != null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Invalid Tag',
          message: validation,
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
      return;
    }

    final normalizedTag = tag.toLowerCase();
    final existingTag = selectedTags.firstWhere(
      (existingTag) => existingTag.toLowerCase() == normalizedTag,
      orElse: () => '',
    );

    if (existingTag.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Duplicate Tag',
          message: 'Tag "$tag" has already been added',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
      return;
    }

    if (selectedTags.length >= TagValidator.MAX_TAGS) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Maximum Tags Reached',
          message: 'You can only add up to ${TagValidator.MAX_TAGS} tags',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
      return;
    }

    onAddTag(tag);
  }
}
