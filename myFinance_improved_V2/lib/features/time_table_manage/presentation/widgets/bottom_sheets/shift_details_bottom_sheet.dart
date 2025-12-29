import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/shift_card.dart';
import '../shift_details/bonus_management_tab.dart';
import '../shift_details/shift_details_tab_bar.dart';
import '../shift_details/shift_info_tab.dart';
import '../shift_details/manage_tab_content.dart';

/// Bottom sheet for viewing and managing shift details
class ShiftDetailsBottomSheet extends ConsumerStatefulWidget {
  final ShiftCard card;
  final VoidCallback? onUpdate;

  const ShiftDetailsBottomSheet({
    super.key,
    required this.card,
    this.onUpdate,
  });

  @override
  ConsumerState<ShiftDetailsBottomSheet> createState() =>
      _ShiftDetailsBottomSheetState();
}

class _ShiftDetailsBottomSheetState
    extends ConsumerState<ShiftDetailsBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final hasUnsolvedProblem = card.hasProblem && !card.isProblemSolved;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8 -
            MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          _buildHandleBar(),
          // Header with user info
          _buildHeader(card),
          // Tab Bar
          ShiftDetailsTabBar(controller: _tabController),
          const SizedBox(height: TossSpacing.space3),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Info Tab
                ShiftInfoTab(card: card, hasUnsolvedProblem: hasUnsolvedProblem),
                // Manage Tab
                ManageTabContent(card: card),
                // Bonus Tab
                BonusManagementTab(card: card),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandleBar() {
    return Container(
      margin: const EdgeInsets.only(top: TossSpacing.space3),
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: TossColors.gray300,
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
      ),
    );
  }

  Widget _buildHeader(ShiftCard card) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space5,
        TossSpacing.space4,
        TossSpacing.space5,
        TossSpacing.space3,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TossColors.primary.withValues(alpha: 0.8),
                  TossColors.primary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            ),
            child: Center(
              child: Text(
                (card.employee.userName.isNotEmpty
                        ? card.employee.userName
                        : '?')[0]
                    .toUpperCase(),
                style: TossTextStyles.body.copyWith(
                  color: TossColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.employee.userName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${card.shift.shiftName ?? ''} • ${card.shiftDate}',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          // Close button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              ),
              child: const Icon(
                Icons.close,
                size: 18,
                color: TossColors.gray600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
