import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/core/utils/tag_validator.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Tag Selection Bottom Sheet for editing role tags
class TagSelectionSheet extends StatefulWidget {
  final List<String> selectedTags;
  final Function(List<String>) onTagsSelected;

  const TagSelectionSheet({
    super.key,
    required this.selectedTags,
    required this.onTagsSelected,
  });

  @override
  State<TagSelectionSheet> createState() => _TagSelectionSheetState();
}

class _TagSelectionSheetState extends State<TagSelectionSheet> {
  late List<String> _selectedTags;

  // Predefined suggested tags
  static const List<String> _suggestedTags = [
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

  // Tag colors mapping using Toss color system
  static final Map<String, Color> _tagColors = {
    'Critical': TossColors.error,
    'Support': TossColors.info,
    'Management': TossColors.primary,
    'Operations': TossColors.success,
    'Temporary': TossColors.warning,
    'Finance': TossColors.primary,
    'Sales': TossColors.success,
    'Marketing': TossColors.info,
    'Technical': TossColors.textSecondary,
    'Customer Service': TossColors.info,
    'Admin': TossColors.primary,
    'Restricted': TossColors.error,
  };

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
  }

  Color _getTagColor(String tag) {
    return _tagColors[tag] ?? TossColors.gray600;
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        if (_selectedTags.length < TagValidator.MAX_TAGS) {
          _selectedTags.add(tag);
        } else {
          // Show warning dialog
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: TossDimensions.dragHandleWidth,
            height: TossDimensions.dragHandleHeight,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Tags',
                        style: TossTextStyles.h2.copyWith(
                          fontWeight: TossFontWeight.bold,
                          color: TossColors.gray900,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space1),
                      Text(
                        'Add up to ${TagValidator.MAX_TAGS} tags to help categorize this role',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: TossColors.gray600),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected tags display
                  if (_selectedTags.isNotEmpty) ...[
                    _buildSelectedTagsSection(),
                    const SizedBox(height: TossSpacing.space4),
                  ],

                  // Suggested tags
                  if (_selectedTags.length < TagValidator.MAX_TAGS) ...[
                    _buildSuggestedTagsSection(),
                  ],

                  const SizedBox(height: TossSpacing.space10),
                ],
              ),
            ),
          ),

          // Bottom action
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildSelectedTagsSection() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Tags',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                  fontWeight: TossFontWeight.semibold,
                ),
              ),
              Text(
                '${_selectedTags.length}/${TagValidator.MAX_TAGS}',
                style: TossTextStyles.caption.copyWith(
                  color: _selectedTags.length >= TagValidator.MAX_TAGS
                      ? TossColors.primary
                      : TossColors.textSecondary,
                  fontWeight: TossFontWeight.semibold,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: _selectedTags
                .map((tag) => _buildSelectedTagChip(tag))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          _getTagColor(tag).withValues(alpha: TossOpacity.light),
          TossColors.background,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: Color.alphaBlend(
            _getTagColor(tag).withValues(alpha: TossOpacity.heavy),
            TossColors.background,
          ),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: TossTextStyles.caption.copyWith(
              color: _getTagColor(tag),
              fontWeight: TossFontWeight.semibold,
            ),
          ),
          const SizedBox(width: TossSpacing.space1),
          InkWell(
            onTap: () => _toggleTag(tag),
            borderRadius: BorderRadius.circular(TossBorderRadius.full),
            child: Icon(
              Icons.close,
              size: TossSpacing.iconXS,
              color: _getTagColor(tag),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggested Tags',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: _suggestedTags
              .where((tag) => !_selectedTags.contains(tag))
              .map((tag) => _buildSuggestedTagChip(tag))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSuggestedTagChip(String tag) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => _toggleTag(tag),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            border: Border.all(
              color: TossColors.gray200,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add,
                size: TossSpacing.iconXS,
                color: TossColors.textSecondary,
              ),
              const SizedBox(width: TossSpacing.space1),
              Text(
                tag,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                  fontWeight: TossFontWeight.semibold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.background,
        border: Border(top: BorderSide(color: TossColors.gray200)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            TossSpacing.space5,
            TossSpacing.space4,
            TossSpacing.space5,
            TossSpacing.space4,
          ),
          child: SizedBox(
            width: double.infinity,
            height: TossSpacing.buttonHeightLG,
            child: Material(
              color: TossColors.primary,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              child: InkWell(
                onTap: () {
                  widget.onTagsSelected(_selectedTags);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                splashColor: TossColors.white.withValues(alpha: TossOpacity.light),
                highlightColor: TossColors.white.withValues(alpha: TossOpacity.subtle),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Save Tags',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.white,
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
