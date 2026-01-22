import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';

import '../../domain/entities/transaction_filter.dart';
import '../providers/transaction_providers.dart';
import '../widgets/transaction_filter_sheet.dart';
import '../widgets/transaction_list_item.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class TransactionHistoryPage extends ConsumerStatefulWidget {
  final String? counterpartyId;
  final String? counterpartyName;
  final String? scope;
  
  const TransactionHistoryPage({
    super.key,
    this.counterpartyId,
    this.counterpartyName,
    this.scope,
  });

  @override
  ConsumerState<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends ConsumerState<TransactionHistoryPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isFilterSheetOpen = false;

  /// Threshold in pixels before the end of the list to trigger loading more items
  static const double _loadMoreThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Apply filters if provided from navigation
    if (widget.counterpartyId != null || widget.scope != null) {
      // Use addPostFrameCallback to ensure the widget tree is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final notifier = ref.read(transactionFilterStateProvider.notifier);

          // Set counterparty filter
          if (widget.counterpartyId != null) {
            notifier.setCounterparty(widget.counterpartyId);
          }

          // Set scope filter
          if (widget.scope != null) {
            final scope = widget.scope == 'store'
              ? TransactionScope.store
              : TransactionScope.company;
            notifier.setScope(scope);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - _loadMoreThreshold) {
      ref.read(transactionHistoryProvider.notifier).loadMore();
    }
  }

  void _showFilterSheet() {
    if (_isFilterSheetOpen) return;
    _isFilterSheetOpen = true;

    TossBottomSheet.show(
      context: context,
      title: 'Filter Transactions',
      content: const TransactionFilterSheet(),
    ).whenComplete(() {
      _isFilterSheetOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionHistoryProvider);
    final groupedTransactions = ref.watch(groupedTransactionsProvider);
    final filter = ref.watch(transactionFilterStateProvider);

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: TossAppBar(
        title: widget.counterpartyName != null
          ? '${widget.counterpartyName} Transactions'
          : 'Transaction History',
        backgroundColor: TossColors.white,
        actions: const [],
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            // Check if filters are active
            if (_hasActiveFilters(filter)) {
              // Show empty state with filter indicator
              return Column(
                children: [
                  // Filter indicator with clear button
                  Container(
                    margin: const EdgeInsets.all(TossSpacing.space4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space4,
                              vertical: TossSpacing.space3,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.primarySurface,
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              border: Border.all(
                                color: TossColors.primary.withValues(alpha: TossOpacity.strong),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.filter_alt,
                                  size: TossSpacing.iconXS,
                                  color: TossColors.primary,
                                ),
                                const SizedBox(width: TossSpacing.space2),
                                Text(
                                  'Filters Active',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.primary,
                                    fontWeight: TossFontWeight.semibold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        InkWell(
                          onTap: () {
                            ref.read(transactionFilterStateProvider.notifier).clearFilter();
                          },
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          child: Container(
                            padding: const EdgeInsets.all(TossSpacing.space3),
                            decoration: BoxDecoration(
                              color: TossColors.error.withValues(alpha: TossOpacity.light),
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: TossSpacing.iconSM,
                              color: TossColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Empty state
                  const Expanded(
                    child: TossEmptyView(
                      icon: Icon(Icons.filter_alt_off),
                      title: 'No Results Found',
                      description: 'Try adjusting your filters to see more transactions',
                    ),
                  ),
                ],
              );
            } else {
              // Show normal empty state when no filters
              return const TossEmptyView(
                icon: Icon(Icons.receipt_long_outlined),
                title: 'No Transactions',
                description: 'Start recording your financial transactions',
              );
            }
          }

          return TossRefreshIndicator(
            onRefresh: () => ref.read(transactionHistoryProvider.notifier).refresh(),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Filter Button
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(TossSpacing.space4),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _showFilterSheet,
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            child: Container(
                              padding: const EdgeInsets.all(TossSpacing.space3),
                              decoration: BoxDecoration(
                                color: _hasActiveFilters(filter)
                                    ? TossColors.primarySurface
                                    : TossColors.white,
                                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                border: Border.all(
                                  color: _hasActiveFilters(filter) 
                                      ? TossColors.primary
                                      : TossColors.gray200,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.filter_list,
                                    size: TossSpacing.iconSM,
                                    color: _hasActiveFilters(filter)
                                        ? TossColors.primary
                                        : TossColors.gray600,
                                  ),
                                  const SizedBox(width: TossSpacing.space2),
                                  Text(
                                    _hasActiveFilters(filter) ? 'Filters Active' : 'Filter Transactions',
                                    style: TossTextStyles.body.copyWith(
                                      color: _hasActiveFilters(filter) 
                                          ? TossColors.primary
                                          : TossColors.gray600,
                                      fontWeight: TossFontWeight.semibold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (_hasActiveFilters(filter)) ...[
                          const SizedBox(width: TossSpacing.space3),
                          InkWell(
                            onTap: () {
                              ref.read(transactionFilterStateProvider.notifier).clearFilter();
                            },
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            child: Container(
                              padding: const EdgeInsets.all(TossSpacing.space3),
                              decoration: BoxDecoration(
                                color: TossColors.errorLight,
                                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                border: Border.all(color: TossColors.error.withValues(alpha: TossOpacity.heavy)),
                              ),
                              child: const Icon(
                                Icons.clear,
                                size: TossSpacing.iconSM,
                                color: TossColors.error,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                // Grouped Transactions
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final dateKeys = groupedTransactions.keys.toList()
                        ..sort((a, b) => b.compareTo(a));
                      
                      if (index >= dateKeys.length) return null;
                      
                      final dateKey = dateKeys[index];
                      final dayTransactions = groupedTransactions[dateKey]!;
                      final date = DateTime.parse(dateKey);
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space4,
                              vertical: TossSpacing.space3,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _formatDateHeader(date),
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray500,
                                    fontWeight: TossFontWeight.semibold,
                                  ),
                                ),
                                const SizedBox(width: TossSpacing.space2),
                                _buildCountBadge(dayTransactions.length),
                              ],
                            ),
                          ),
                          
                          // Transactions for this date
                          ...dayTransactions.map((transaction) =>
                            Padding(
                              key: ValueKey(transaction.journalId),
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space4,
                                vertical: TossSpacing.space1,
                              ),
                              child: TransactionListItem(
                                transaction: transaction,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: TossSpacing.space3),
                        ],
                      );
                    },
                    childCount: groupedTransactions.keys.length,
                  ),
                ),

                // Loading indicator for pagination
                if (transactionsAsync.isLoading && transactions.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(TossSpacing.space4),
                      child: Center(
                        child: TossLoadingView(),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const TossLoadingView(),
        error: (error, stack) => TossErrorView(
          error: error.toString(),
          onRetry: () => ref.read(transactionHistoryProvider.notifier).refresh(),
        ),
      ),
    );
  }

  /// Check if any filters are active
  /// Delegates to the domain entity's hasActiveFilters getter
  bool _hasActiveFilters(TransactionFilter filter) {
    return filter.hasActiveFilters;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final inputDate = DateTime(date.year, date.month, date.day);

    if (inputDate == today) {
      return 'Today';
    } else if (inputDate == yesterday) {
      return 'Yesterday';
    } else if (inputDate.year == now.year) {
      return DateFormat('MMMM d').format(date);
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }
  
  Widget _buildCountBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1 / 2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Text(
        '$count',
        style: TossTextStyles.small.copyWith(
          color: TossColors.gray600,
        ),
      ),
    );
  }
}