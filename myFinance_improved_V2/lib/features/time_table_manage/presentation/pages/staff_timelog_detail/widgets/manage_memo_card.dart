import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/manager_memo.dart';

/// Manage memo card for shift details
///
/// Shows existing memos (read-only) and allows manager to add new memo
/// v4: Added existingMemos parameter to display previous memos
class ManageMemoCard extends StatelessWidget {
  final TextEditingController memoController;
  final ValueChanged<String>? onChanged;
  final String? hintText;

  /// v4: List of existing memos from RPC (read-only display)
  final List<ManagerMemo> existingMemos;

  const ManageMemoCard({
    super.key,
    required this.memoController,
    this.onChanged,
    this.hintText,
    this.existingMemos = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray200, width: 1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Manage memo',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),

          // v4: Show existing memos (read-only)
          if (existingMemos.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildExistingMemos(),
          ],

          const SizedBox(height: 12),

          // Memo text field for new memo
          TextField(
            controller: memoController,
            maxLines: 3,
            minLines: 2,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
            ),
            decoration: InputDecoration(
              hintText: hintText ?? 'Add a memo for this shift...',
              hintStyle: TossTextStyles.body.copyWith(
                color: TossColors.gray400,
              ),
              filled: true,
              fillColor: TossColors.gray50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                borderSide: const BorderSide(color: TossColors.primary, width: 1),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  /// Build existing memos list (read-only)
  Widget _buildExistingMemos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: existingMemos.map((memo) => _buildMemoItem(memo)).toList(),
    );
  }

  /// Build a single memo item (content only, no date)
  Widget _buildMemoItem(ManagerMemo memo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Text(
        memo.content,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray800,
        ),
      ),
    );
  }
}
