import 'package:flutter/material.dart';

import '../../../../../../shared/themes/index.dart';
import '../../../../domain/entities/manager_memo.dart';

/// Manage memo card - Expandable card style
///
/// Clean, attendance-style design with:
/// - Expandable header
/// - Existing memos displayed as read-only items
/// - Text field for adding new memo
///
/// v5: Improved UI with expandable design
class ManageMemoCard extends StatefulWidget {
  final TextEditingController memoController;
  final ValueChanged<String>? onChanged;
  final String? hintText;

  /// List of existing memos from RPC (read-only display)
  final List<ManagerMemo> existingMemos;

  const ManageMemoCard({
    super.key,
    required this.memoController,
    this.onChanged,
    this.hintText,
    this.existingMemos = const [],
  });

  @override
  State<ManageMemoCard> createState() => _ManageMemoCardState();
}

class _ManageMemoCardState extends State<ManageMemoCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray200, width: 1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        children: [
          // Header - tappable to expand/collapse
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(TossBorderRadius.lg),
              bottom: _isExpanded
                  ? Radius.zero
                  : const Radius.circular(TossBorderRadius.lg),
            ),
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  // Title with memo count
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Manager Memo',
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: TossColors.gray900,
                            fontWeight: TossFontWeight.semibold,
                          ),
                        ),
                        if (widget.existingMemos.isNotEmpty) ...[
                          SizedBox(width: TossSpacing.space2),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space2,
                              vertical: TossSpacing.space0_5,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.gray100,
                              borderRadius: BorderRadius.circular(TossBorderRadius.full),
                            ),
                            child: Text(
                              '${widget.existingMemos.length}',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                                fontWeight: TossFontWeight.semibold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Expand/collapse icon
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: TossColors.gray500,
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (_isExpanded) ...[
            Container(
              width: double.infinity,
              height: 1,
              color: TossColors.gray100,
            ),
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Existing memos (read-only)
                  if (widget.existingMemos.isNotEmpty) ...[
                    _buildExistingMemos(),
                    SizedBox(height: TossSpacing.space4),
                  ],

                  // New memo text field
                  _buildNewMemoField(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build existing memos list (read-only)
  Widget _buildExistingMemos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Previous memos',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: TossFontWeight.medium,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        ...widget.existingMemos.map((memo) => _buildMemoItem(memo)),
      ],
    );
  }

  /// Build a single memo item
  Widget _buildMemoItem(ManagerMemo memo) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            memo.content,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray800,
            ),
          ),
          if (memo.createdAt != null && memo.createdAt!.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space1),
            Text(
              _formatDateString(memo.createdAt!),
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build new memo text field
  Widget _buildNewMemoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add new memo',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: TossFontWeight.medium,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        TextField(
          controller: widget.memoController,
          maxLines: 3,
          minLines: 2,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Add a memo for this shift...',
            hintStyle: TossTextStyles.body.copyWith(
              color: TossColors.gray400,
            ),
            filled: true,
            fillColor: TossColors.gray50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: const BorderSide(color: TossColors.gray200, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: const BorderSide(color: TossColors.gray200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              borderSide: const BorderSide(color: TossColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(TossSpacing.space3),
          ),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }

  /// Format ISO8601 date string for display
  String _formatDateString(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }
}
