import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../widgets/overview/attention_card.dart';

/// Attention List Page
///
/// Full page showing all items that need attention in a 2-column grid.
class AttentionListPage extends StatelessWidget {
  final List<AttentionItemData> items;

  const AttentionListPage({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: AppBar(
        backgroundColor: TossColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TossColors.gray900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Need Attention (${items.length})',
          style: TossTextStyles.h3.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: items.isEmpty
          ? _buildEmptyState()
          : GridView.builder(
              padding: const EdgeInsets.all(TossSpacing.space3),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: TossSpacing.space3,
                mainAxisSpacing: TossSpacing.space3,
                childAspectRatio: 0.85,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return AttentionCard(item: items[index]);
              },
            ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 64,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            'All caught up!',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'No items need attention',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }
}
