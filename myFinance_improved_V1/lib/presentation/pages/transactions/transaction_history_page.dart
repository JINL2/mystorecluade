import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/common/toss_error_view.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../widgets/toss/toss_icon_button.dart';
import '../../widgets/toss/toss_refresh_indicator.dart';
import '../../widgets/toss/toss_card.dart';
import 'providers/transaction_history_provider.dart';
import '../../../data/models/transaction_history_model.dart';
import 'widgets/transaction_list_item.dart';
import 'widgets/transaction_filter_sheet.dart';

class TransactionHistoryPage extends ConsumerStatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  ConsumerState<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends ConsumerState<TransactionHistoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
      backgroundColor: Colors.transparent,
      builder: (context) => const TransactionFilterSheet(),
    );
  }


  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionHistoryProvider);
    final groupedTransactions = ref.watch(groupedTransactionsProvider);
    final filter = ref.watch(transactionFilterStateProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: TossAppBar(
        title: 'Transaction History',
        actions: [],
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return TossEmptyView(
              icon: Icon(Icons.receipt_long_outlined),
              title: 'No Transactions',
              description: 'Start recording your financial transactions',
            );
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
                    margin: EdgeInsets.all(TossSpacing.space4),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _showFilterSheet,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: EdgeInsets.all(TossSpacing.space3),
                              decoration: BoxDecoration(
                                color: _hasActiveFilters(filter) 
                                    ? TossColors.primary.withOpacity(0.1)
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
                                  SizedBox(width: TossSpacing.space2),
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
                          SizedBox(width: TossSpacing.space3),
                          InkWell(
                            onTap: () {
                              ref.read(transactionFilterStateProvider.notifier).clearFilter();
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: EdgeInsets.all(TossSpacing.space3),
                              decoration: BoxDecoration(
                                color: TossColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: TossColors.error.withOpacity(0.3)),
                              ),
                              child: Icon(
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
                            padding: EdgeInsets.symmetric(
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
                                SizedBox(width: TossSpacing.space2),
                                _buildCountBadge(dayTransactions.length),
                              ],
                            ),
                          ),
                          
                          // Transactions for this date
                          ...dayTransactions.map((transaction) => 
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: TossSpacing.space4,
                                vertical: TossSpacing.space1,
                              ),
                              child: TransactionListItem(
                                transaction: transaction,
                              ),
                            ),
                          ),
                          
                          SizedBox(height: TossSpacing.space3),
                        ],
                      );
                    },
                    childCount: groupedTransactions.keys.length,
                  ),
                ),

                // Loading indicator for pagination
                if (transactionsAsync.isLoading && transactions.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(TossSpacing.space4),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
                        ),
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
        filter.cashLocationId != null ||
        filter.counterpartyId != null ||
        filter.journalType != null;
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
      padding: EdgeInsets.symmetric(
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