import 'package:flutter/material.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/tag.dart';

/// Add Tag section widget
class AddTagSection extends StatelessWidget {
  final String? selectedTagType;
  final List<String> tagTypes;
  final ValueChanged<String?> onTagTypeChanged;
  final ValueChanged<String> onTagContentChanged;

  const AddTagSection({
    super.key,
    required this.selectedTagType,
    required this.tagTypes,
    required this.onTagTypeChanged,
    required this.onTagContentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.label_outline,
                size: 20,
                color: TossColors.gray700,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Add Tag',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),

          // Tag Type Selector
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedTagType,
                hint: Text(
                  'Select Tag Type',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray400,
                  ),
                ),
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: TossColors.gray500,
                ),
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                ),
                onChanged: onTagTypeChanged,
                items: tagTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // Tag Content Text Field
          Container(
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
            child: TextField(
              onChanged: onTagContentChanged,
              decoration: InputDecoration(
                hintText: 'Enter tag content...',
                hintStyle: TossTextStyles.body.copyWith(
                  color: TossColors.gray400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(TossSpacing.space3),
              ),
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
              ),
              maxLines: 3,
              minLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Existing Tags display section
class ExistingTagsSection extends StatelessWidget {
  final List<Tag> tags;
  final void Function(String tagId, String content)? onDeleteTag;

  const ExistingTagsSection({
    super.key,
    required this.tags,
    this.onDeleteTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Existing Tags',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          if (tags.isNotEmpty)
            Wrap(
              spacing: TossSpacing.space2,
              runSpacing: TossSpacing.space2,
              children: tags.map((tag) {
                final content = tag.tagContent;
                final tagId = tag.tagId;

                // Only show delete option if tag has a valid ID
                if (tagId.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                    ),
                    child: Text(
                      content,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () => onDeleteTag?.call(tagId.toString(), content),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                      border: Border.all(
                        color: TossColors.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          content,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Icon(
                          Icons.close,
                          size: 14,
                          color: TossColors.primary.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )
          else
            Text(
              'No tags added yet',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray400,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
