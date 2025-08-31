import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../widgets/toss/toss_refresh_indicator.dart';
import 'providers/transaction_history_provider.dart';
import '../../../data/models/transaction_history_model.dart';
import 'widgets/transaction_list_item.dart';
import 'widgets/transaction_filter_sheet.dart';

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
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(transactionHistoryProvider.notifier).loadMore();
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => const TransactionFilterSheet(),
    );
  }


  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionHistoryProvider);
    final groupedTransactions = ref.watch(groupedTransactionsProvider);
    final filter = ref.watch(transactionFilterStateProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: widget.counterpartyName != null 
          ? '${widget.counterpartyName} Transactions'
          : 'Transaction History',
        backgroundColor: TossColors.gray100,
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
                                color: TossColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.filter_alt,
                                  size: 16,
                                  color: TossColors.primary,
                                ),
                                const SizedBox(width: TossSpacing.space2),
                                Text(
                                  'Filters Active',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.primary,
                                    fontWeight: FontWeight.w600,
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
                              color: TossColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 20,
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
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(TossSpacing.space3),
                              decoration: BoxDecoration(
                                color: _hasActiveFilters(filter) 
                                    ? TossColors.primarySurface
                                    : TossColors.gray100,
                                borderRadius: BorderRadius.circular(8),
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
                                    size: 18,
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
                                      fontWeight: FontWeight.w600,
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
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(TossSpacing.space3),
                              decoration: BoxDecoration(
                                color: TossColors.errorLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: TossColors.error.withValues(alpha: 0.3)),
                              ),
                              child: const Icon(
                                Icons.clear,
                                size: 18,
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
                                    fontWeight: FontWeight.w600,
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
                        child: const TossLoadingView(),
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

  bool _hasActiveFilters(TransactionFilter filter) {
    return filter.dateFrom != null ||
        filter.dateTo != null ||
        filter.accountId != null ||
        (filter.accountIds != null && filter.accountIds!.isNotEmpty) ||
        filter.cashLocationId != null ||
        filter.counterpartyId != null ||
        filter.journalType != null ||
        filter.createdBy != null;
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
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$count',
        style: TossTextStyles.caption.copyWith(
          color: TossColors.gray600,
          fontSize: 11,
        ),
      ),
    );
  }
}