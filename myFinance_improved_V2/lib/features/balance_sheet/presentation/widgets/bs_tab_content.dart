import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../providers/financial_statements_provider.dart';
import 'components/bs_hero_card.dart';
import 'components/bs_detail_section.dart';
import 'excel_view_modal.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// B/S Tab Content - Balance Sheet
class BsTabContent extends ConsumerWidget {
  final String companyId;
  final String? storeId;
  final String currencySymbol;

  const BsTabContent({
    super.key,
    required this.companyId,
    this.storeId,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageState = ref.watch(financialStatementsPageNotifierProvider);

    // B/S uses end date as "as of" date
    final asOfDate = pageState.endDate;
    final prevDates = pageState.prevPeriodDates;

    final params = BsParams(
      companyId: companyId,
      asOfDate: asOfDate,
      storeId: storeId,
      compareDate: prevDates.end,
    );

    final summaryAsync = ref.watch(bsSummaryProvider(params));
    final detailAsync = ref.watch(bsDetailProvider(params));

    return Column(
      children: [
        // Header
        _buildHeader(context, ref, pageState, asOfDate),

        // Content
        Expanded(
          child: summaryAsync.when(
            data: (summary) => RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(bsSummaryProvider(params));
                ref.invalidate(bsDetailProvider(params));
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      child: Column(
                        children: [
                          // Hero Card
                          BsHeroCard(
                            summary: summary,
                            currencySymbol: currencySymbol,
                          ),

                          const SizedBox(height: TossSpacing.space4),

                          // Detail Section
                          detailAsync.when(
                            data: (details) => BsDetailSection(
                              details: details,
                              summary: summary,
                              currencySymbol: currencySymbol,
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),

                          const SizedBox(height: TossSpacing.space8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const TossLoadingView(),
            error: (error, _) => _buildError(error.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
      BuildContext context, WidgetRef ref, FinancialStatementsPageState state, DateTime asOfDate) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          // As of date
          Text(
            'As of ${DateFormat('MMM d, yyyy').format(asOfDate)}',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),

          const Spacer(),

          // Excel View Button
          _buildExcelButton(context, ref, state),
        ],
      ),
    );
  }

  Widget _buildExcelButton(
      BuildContext context, WidgetRef ref, FinancialStatementsPageState state) {
    return GestureDetector(
      onTap: () => _showExcelView(context, ref, state),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.table_chart_outlined,
              size: 16,
              color: TossColors.gray600,
            ),
            const SizedBox(width: TossSpacing.space1),
            Text(
              'Excel',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExcelView(
      BuildContext context, WidgetRef ref, FinancialStatementsPageState state) {
    final prevDates = state.prevPeriodDates;
    final params = BsParams(
      companyId: companyId,
      asOfDate: state.endDate,
      storeId: storeId,
      compareDate: prevDates.end,
    );

    final detailAsync = ref.read(bsDetailProvider(params));
    final summaryAsync = ref.read(bsSummaryProvider(params));

    // 데이터가 로드되지 않았으면 로딩 표시
    if (!detailAsync.hasValue || !summaryAsync.hasValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loading data...')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => ExcelViewModal(
        title: 'Balance Sheet',
        dateRange: 'As of ${DateFormat('yyyy-MM-dd').format(state.endDate)}',
        currencySymbol: currencySymbol,
        bsDetails: detailAsync.value ?? [],
        bsSummary: summaryAsync.value,
        type: ExcelViewType.bs,
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Failed to load data',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              error,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
