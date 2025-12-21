import 'package:flutter/material.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../widgets/common/toss_loading_view.dart';
import '../../../data/services/stock_flow_service.dart';

/// Real tab content widget for Cash Ending page
/// FROM PRODUCTION LINES 4827-4960
class RealTabContent extends StatelessWidget {
  final bool isLoadingFlows;
  final List<ActualFlow> actualFlows;
  final String selectedFilter;
  final bool hasMoreFlows;
  final String? selectedCashLocationIdForFlow;
  final Function(String, {bool isLoadMore}) fetchLocationStockFlow;
  final Widget Function(ActualFlow flow, bool showDate) buildRealItem;

  const RealTabContent({
    Key? key,
    required this.isLoadingFlows,
    required this.actualFlows,
    required this.selectedFilter,
    required this.hasMoreFlows,
    required this.selectedCashLocationIdForFlow,
    required this.fetchLocationStockFlow,
    required this.buildRealItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoadingFlows) {
      return Center(
        child: TossLoadingView(),
      );
    }
    
    if (actualFlows.isEmpty) {
      return Container(
        padding: EdgeInsets.all(TossSpacing.space5),
        child: Center(
          child: Text(
            'No real data available',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ),
      );
    }
    
    // Apply filters
    var filteredFlows = List<ActualFlow>.from(actualFlows);
    
    if (selectedFilter == 'Today') {
      final today = DateTime.now();
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == today.year && date.month == today.month && date.day == today.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (selectedFilter == 'Yesterday') {
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
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
    
    // Always sort filtered flows by createdAt in descending order (latest first)
    filteredFlows.sort((a, b) {
      DateTime dateA = DateTime.parse(a.createdAt);
      DateTime dateB = DateTime.parse(b.createdAt);
      return dateB.compareTo(dateA); // Descending order
    });
    
    if (filteredFlows.isEmpty) {
      return Container(
        padding: EdgeInsets.all(TossSpacing.space5),
        child: Center(
          child: Text(
            'No data for selected filter',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
      itemCount: filteredFlows.length + (hasMoreFlows && selectedFilter == 'All' ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= filteredFlows.length) {
          // Load more button
          return GestureDetector(
            onTap: () {
              if (selectedCashLocationIdForFlow != null) {
                fetchLocationStockFlow(selectedCashLocationIdForFlow!, isLoadMore: true);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Load More',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: TossSpacing.space2),
                    Icon(
                      Icons.arrow_downward,
                      size: 16,
                      color: TossColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        
        final flow = filteredFlows[index];
        final showDate = index == 0 || 
            flow.getFormattedDate() != filteredFlows[index - 1].getFormattedDate();
        
        return buildRealItem(flow, showDate);
      },
    );
  }
}