import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/session_review_item.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Receiving Result Page - Shows stock changes after session submit
/// Tab view with "New" (new products) and "All" (all changes)
class ReceivingResultPage extends ConsumerStatefulWidget {
  final SessionSubmitResponse response;

  const ReceivingResultPage({
    super.key,
    required this.response,
  });

  @override
  ConsumerState<ReceivingResultPage> createState() => _ReceivingResultPageState();
}

class _ReceivingResultPageState extends ConsumerState<ReceivingResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<StockChangeItem> _newItems;
  late List<StockChangeItem> _allItems;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _newItems = widget.response.stockChanges
        .where((item) => item.needsDisplay)
        .toList();
    _allItems = widget.response.stockChanges;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: AppBar(
        backgroundColor: TossColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Receiving Complete',
          style: TossTextStyles.titleMedium.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Summary Header
          _buildSummaryHeader(_newItems.length),

          // Tab Bar
          _buildTabBar(),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // New Items Tab
                _buildStockChangesList(_newItems, isEmpty: _newItems.isEmpty),
                // All Items Tab
                _buildStockChangesList(_allItems, isEmpty: _allItems.isEmpty),
              ],
            ),
          ),

          // Bottom Button
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          bottom: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: TossColors.primary,
        unselectedLabelColor: TossColors.gray500,
        labelStyle: TossTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TossTextStyles.body.copyWith(
          fontWeight: FontWeight.w400,
        ),
        indicatorColor: TossColors.primary,
        indicatorWeight: 2,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('New'),
                if (_newItems.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.warning,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Text(
                      '${_newItems.length}',
                      style: TossTextStyles.small.copyWith(
                        color: TossColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('All'),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.gray300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_allItems.length}',
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(int newDisplayCount) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          bottom: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: Column(
        children: [
          // Success Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: TossColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: TossColors.success,
              size: 32,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // Receiving Number
          Text(
            widget.response.receivingNumber,
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.response.itemsCount} items',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: TossColors.gray400,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                '${widget.response.totalQuantity} total qty',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              if (newDisplayCount > 0) ...[
                const SizedBox(width: TossSpacing.space2),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: TossColors.gray400,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  '$newDisplayCount new',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockChangesList(List<StockChangeItem> items, {bool isEmpty = false}) {
    if (isEmpty) {
      return Center(
        child: Text(
          'No items',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        color: TossColors.gray100,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _StockChangeRow(item: item);
      },
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: SafeArea(
        child: TossButton.primary(
          text: 'Done',
          onPressed: () => context.go('/session'),
          fullWidth: true,
        ),
      ),
    );
  }
}

/// Simple row showing product name and quantity
class _StockChangeRow extends StatelessWidget {
  final StockChangeItem item;

  const _StockChangeRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final isNew = item.needsDisplay;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          // NEW badge for new products
          if (isNew) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: TossColors.warning,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
              child: Text(
                'NEW',
                style: TossTextStyles.small.copyWith(
                  color: TossColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
          ],

          // Product name
          Expanded(
            child: Text(
              item.productName,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: isNew ? FontWeight.w600 : FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: TossSpacing.space3),

          // Quantity change: before -> after
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${item.quantityBefore}',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward,
                size: 14,
                color: TossColors.gray400,
              ),
              const SizedBox(width: 6),
              Text(
                '${item.quantityAfter}',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(width: TossSpacing.space3),

          // Received quantity badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: TossColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
            child: Text(
              '+${item.quantityReceived}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
