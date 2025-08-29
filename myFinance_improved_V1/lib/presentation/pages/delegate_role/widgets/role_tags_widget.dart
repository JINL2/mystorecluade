import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';

class RoleTagsWidget extends StatefulWidget {
  final List<String> initialTags;
  final ValueChanged<List<String>> onTagsChanged;
  final bool isEditable;

  const RoleTagsWidget({
    super.key,
    required this.initialTags,
    required this.onTagsChanged,
    this.isEditable = true,
  });

  @override
  State<RoleTagsWidget> createState() => _RoleTagsWidgetState();
}

class _RoleTagsWidgetState extends State<RoleTagsWidget> {
  late List<String> _tags;
  final TextEditingController _tagController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isAddingTag = false;

  // Predefined tag suggestions
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

  // Tag colors mapping
  static final Map<String, Color> _tagColors = {
    'Critical': TossColors.error,
    'Support': TossColors.info,
    'Management': TossColors.primary,
    'Operations': TossColors.success,
    'Temporary': TossColors.warning,
    'Finance': Colors.green,
    'Sales': Colors.blue,
    'Marketing': Colors.purple,
    'Technical': Colors.indigo,
    'Customer Service': Colors.orange,
    'Admin': Colors.teal,
    'Restricted': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags);
  }

  @override
  void dispose() {
    _tagController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Color _getTagColor(String tag) {
    return _tagColors[tag] ?? TossColors.gray600;
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
        _isAddingTag = false;
      });
      widget.onTagsChanged(_tags);
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
    widget.onTagsChanged(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tags display
        Wrap(
          spacing: TossSpacing.space2,
          runSpacing: TossSpacing.space2,
          children: [
            ..._tags.map((tag) => _buildTagChip(tag)),
            if (widget.isEditable)
              _isAddingTag ? _buildTagInput() : _buildAddTagButton(),
          ],
        ),
        
        // Suggested tags (only show when editing and no tags or adding)
        if (widget.isEditable && (_tags.isEmpty || _isAddingTag)) ...[
          SizedBox(height: TossSpacing.space3),
          Text(
            'Suggested tags',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: _suggestedTags
                .where((tag) => !_tags.contains(tag))
                .map((tag) => _buildSuggestedTagChip(tag))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildTagChip(String tag) {
    final color = _getTagColor(tag);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
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
          if (widget.isEditable) ...[
            SizedBox(width: TossSpacing.space1),
            InkWell(
              onTap: () => _removeTag(tag),
              child: Icon(
                Icons.close,
                size: 14,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestedTagChip(String tag) {
    return InkWell(
      onTap: () => _addTag(tag),
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space1,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          border: Border.all(
            color: TossColors.gray300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 14, color: TossColors.gray600),
            SizedBox(width: TossSpacing.space1),
            Text(
              tag,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTagInput() {
    return Container(
      constraints: BoxConstraints(minWidth: 120),
      child: TextField(
        controller: _tagController,
        focusNode: _focusNode,
        style: TossTextStyles.caption.copyWith(
          color: TossColors.gray700,
        ),
        decoration: InputDecoration(
          hintText: 'Add tag...',
          hintStyle: TossTextStyles.caption.copyWith(
            color: TossColors.gray400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            borderSide: BorderSide(
              color: TossColors.gray300,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            borderSide: BorderSide(
              color: TossColors.primary,
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space1,
          ),
          isDense: true,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => _addTag(_tagController.text.trim()),
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: TossColors.success,
                ),
              ),
              SizedBox(width: TossSpacing.space1),
              InkWell(
                onTap: () {
                  setState(() {
                    _isAddingTag = false;
                    _tagController.clear();
                  });
                  _focusNode.unfocus();
                },
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: TossColors.gray500,
                ),
              ),
              SizedBox(width: TossSpacing.space1),
            ],
          ),
        ),
        onSubmitted: (value) => _addTag(value.trim()),
        onTapOutside: (_) {
          setState(() {
            _isAddingTag = false;
            _tagController.clear();
          });
          _focusNode.unfocus();
        },
      ),
    );
  }
  
  Widget _buildAddTagButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _isAddingTag = true;
        });
        // Focus on the input after the widget rebuilds
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
        });
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space1,
        ),
        decoration: BoxDecoration(
          color: TossColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          border: Border.all(
            color: TossColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              size: 14,
              color: TossColors.primary,
            ),
            SizedBox(width: TossSpacing.space1),
            Text(
              'Add tag',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}