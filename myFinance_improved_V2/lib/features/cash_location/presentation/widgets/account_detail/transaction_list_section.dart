import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';

import '../../providers/cash_location_providers.dart';
import '../../formatters/cash_location_formatters.dart';
import '../journal_flow_item.dart';
import '../actual_flow_item.dart';

/// Transaction list section widget that displays Journal and Real tabs
/// with filtering and pagination support
class TransactionListSection extends StatelessWidget {
  final TabController tabController;
  final int selectedTab;
  final String selectedFilter;
  final VoidCallback onFilterTap;
  final List<JournalFlow> journalFlows;
  final List<ActualFlow> actualFlows;
  final bool hasMoreData;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final String Function(JournalFlow) getJournalDisplayText;
  final String Function(double, [String?]) formatTransactionAmount;
  final String Function(double, [String?]) formatBalance;
  final void Function(JournalFlow) onJournalItemTap;
  final void Function(ActualFlow) onRealItemTap;
  final String currencySymbol;
  final String? baseCurrencySymbol;

  const TransactionListSection({
    super.key,
    required this.tabController,
    required this.selectedTab,
    required this.selectedFilter,
    required this.onFilterTap,
    required this.journalFlows,
    required this.actualFlows,
    required this.hasMoreData,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.getJournalDisplayText,
    required this.formatTransactionAmount,
    required this.formatBalance,
    required this.onJournalItemTap,
    required this.onRealItemTap,
    required this.currencySymbol,
    this.baseCurrencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Transaction container with tab bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            boxShadow: TossShadows.card,
          ),
          child: Column(
            children: [
              // Tab bar for Journal/Real
              _buildTabBar(),

              // Header with filter
              _buildFilterHeader(context),

              // Transaction items based on selected tab
              if (selectedTab == 0)
                ..._buildJournalItems()
              else
                ..._buildRealItems(),

              // Load more indicator
              if (hasMoreData && !isLoadingMore) _buildLoadMoreButton(context),

              // Loading indicator when fetching more
              if (isLoadingMore) _buildLoadingIndicator(),
            ],
          ),
        ),

        // Bottom spacing
        SizedBox(height: TossSpacing.space4),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray300,
            width: 1,
          ),
        ),
      ),
      child: Theme(
        data: ThemeData(
          splashColor: TossColors.transparent,
          highlightColor: TossColors.transparent,
        ),
        child: TabBar(
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 2.0,
              color: TossColors.black87,
            ),
            insets: EdgeInsets.zero,
          ),
          indicatorColor: TossColors.black87,
          labelColor: TossColors.black87,
          unselectedLabelColor: TossColors.gray400,
          labelStyle: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
          unselectedLabelStyle: TossTextStyles.body.copyWith(
            fontSize: 17,
          ),
          overlayColor: WidgetStateProperty.all(TossColors.transparent),
          tabs: const [
            Tab(text: 'Journal'),
            Tab(text: 'Real'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: TossSpacing.space5,
        right: TossSpacing.space4,
        top: TossSpacing.space5,
        bottom: TossSpacing.space3,
      ),
      child: GestureDetector(
        onTap: onFilterTap,
        child: Row(
          children: [
            Text(
              selectedFilter,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: TossColors.gray600,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildJournalItems() {
    List<Widget> items = [];
    String? lastDate;

    // Apply filters
    var filteredFlows = _applyJournalFilters(journalFlows);

    // Sort by date in descending order (newest first)
    filteredFlows.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.createdAt);
        final dateB = DateTime.parse(b.createdAt);
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });

    for (int i = 0; i < filteredFlows.length; i++) {
      final flow = filteredFlows[i];
      final currentDate = CashLocationFormatters.formatJournalFlowDate(flow);
      final bool showDate = currentDate != lastDate;

      if (showDate) {
        lastDate = currentDate;
      }

      items.add(
        JournalFlowItem(
          flow: flow,
          showDate: showDate,
          currencySymbol: currencySymbol,
          onTap: () => onJournalItemTap(flow),
          formatTransactionAmount: formatTransactionAmount,
          formatBalance: formatBalance,
          getJournalDisplayText: getJournalDisplayText,
        ),
      );
    }

    if (items.isEmpty) {
      items.add(_buildEmptyState('No journal entries found'));
    }

    return items;
  }

  List<JournalFlow> _applyJournalFilters(List<JournalFlow> flows) {
    var filteredFlows = List<JournalFlow>.from(flows);

    if (selectedFilter == 'Money In') {
      filteredFlows = filteredFlows.where((f) => f.flowAmount > 0).toList();
    } else if (selectedFilter == 'Money Out') {
      filteredFlows = filteredFlows.where((f) => f.flowAmount < 0).toList();
    } else if (selectedFilter == 'Today') {
      final today = DateTime.now();
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (selectedFilter == 'Yesterday') {
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == yesterday.year &&
              date.month == yesterday.month &&
              date.day == yesterday.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (selectedFilter == 'Last Week') {
      final lastWeek = DateTime.now().subtract(Duration(days: 7));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.isAfter(lastWeek);
        } catch (e) {
          return false;
        }
      }).toList();
    }

    return filteredFlows;
  }

  List<Widget> _buildRealItems() {
    List<Widget> items = [];
    String? lastDate;

    // Apply filters
    var filteredFlows = _applyRealFilters(actualFlows);

    // Sort by date in descending order (newest first)
    filteredFlows.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.createdAt);
        final dateB = DateTime.parse(b.createdAt);
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });

    for (int i = 0; i < filteredFlows.length; i++) {
      final flow = filteredFlows[i];
      final currentDate = CashLocationFormatters.formatActualFlowDate(flow);
      final bool showDate = currentDate != lastDate;

      if (showDate) {
        lastDate = currentDate;
      }

      final symbolToUse = baseCurrencySymbol ?? flow.currency.symbol;

      items.add(
        ActualFlowItem(
          flow: flow,
          showDate: showDate,
          currencySymbol: symbolToUse,
          onTap: () => onRealItemTap(flow),
          formatBalance: formatBalance,
        ),
      );
    }

    if (items.isEmpty) {
      items.add(_buildEmptyState('No real entries found'));
    }

    return items;
  }

  List<ActualFlow> _applyRealFilters(List<ActualFlow> flows) {
    var filteredFlows = List<ActualFlow>.from(flows);

    if (selectedFilter == 'Today') {
      final today = DateTime.now();
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (selectedFilter == 'Yesterday') {
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == yesterday.year &&
              date.month == yesterday.month &&
              date.day == yesterday.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (selectedFilter == 'Last Week') {
      final lastWeek = DateTime.now().subtract(Duration(days: 7));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.isAfter(lastWeek);
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (selectedFilter == 'Last Month') {
      final lastMonth = DateTime.now().subtract(Duration(days: 30));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.isAfter(lastMonth);
        } catch (e) {
          return false;
        }
      }).toList();
    }

    return filteredFlows;
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      child: Center(
        child: Text(
          message,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: onLoadMore,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Load More',
                style: TossTextStyles.body.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: TossSpacing.space2),
              Icon(
                Icons.arrow_downward,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
      child: Center(
        child: const TossLoadingView(),
      ),
    );
  }
}
