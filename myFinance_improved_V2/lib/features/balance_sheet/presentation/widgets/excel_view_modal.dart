import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../data/models/pnl_summary_model.dart';
import '../../data/models/bs_summary_model.dart';

enum ExcelViewType { pnl, bs }

/// CFA-style Excel View Modal
class ExcelViewModal extends StatelessWidget {
  final String title;
  final String dateRange;
  final String currencySymbol;
  final List<PnlDetailRowModel>? details;
  final PnlSummaryModel? summary;
  final List<BsDetailRowModel>? bsDetails;
  final BsSummaryModel? bsSummary;
  final ExcelViewType type;

  const ExcelViewModal({
    super.key,
    required this.title,
    required this.dateRange,
    required this.currencySymbol,
    this.details,
    this.summary,
    this.bsDetails,
    this.bsSummary,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(TossBorderRadius.bottomSheet),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: TossSpacing.space3),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              _buildHeader(context),

              // Divider
              Container(height: 1, color: TossColors.gray200),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: type == ExcelViewType.pnl
                      ? _buildPnlTable()
                      : _buildBsTable(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.h4.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  dateRange,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Icon(
                Icons.close,
                size: 20,
                color: TossColors.gray600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPnlTable() {
    if (details == null || summary == null) {
      return const Center(child: Text('No data'));
    }

    final formatter = NumberFormat('#,##0', 'en_US');

    // Group by section
    final sections = <String, List<PnlDetailRowModel>>{};
    for (final row in details!) {
      sections.putIfAbsent(row.section, () => []).add(row);
    }

    final sortedSections = sections.entries.toList()
      ..sort((a, b) {
        final aOrder = a.value.isNotEmpty ? a.value.first.sectionOrder : 99;
        final bOrder = b.value.isNotEmpty ? b.value.first.sectionOrder : 99;
        return aOrder.compareTo(bOrder);
      });

    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // Table Header
          _buildTableHeaderRow(['Account', 'Amount']),
          Container(height: 2, color: TossColors.gray900),

          // Revenue Section
          ...sortedSections.map((entry) {
            final sectionTotal = entry.value.fold<double>(0, (sum, r) => sum + r.amount);
            return Column(
              children: [
                const SizedBox(height: TossSpacing.space2),
                // Section Header
                _buildSectionHeaderRow(entry.key),

                // Account rows
                ...entry.value.map((row) => _buildAccountRow(
                      '  ${row.accountCode} ${row.accountName}',
                      formatter.format(row.amount.abs()),
                      isNegative: row.amount < 0,
                    )),

                // Section Total
                _buildTotalRow(
                  'Total ${entry.key}',
                  formatter.format(sectionTotal.abs()),
                ),
                Container(height: 1, color: TossColors.gray300),
              ],
            );
          }),

          const SizedBox(height: TossSpacing.space4),

          // Summary
          Container(height: 2, color: TossColors.gray900),
          _buildSummaryRow('Gross Profit', formatter.format(summary!.grossProfit)),
          _buildSummaryRow('Gross Margin', '${summary!.grossMargin.toStringAsFixed(1)}%', isPercentage: true),
          Container(height: 1, color: TossColors.gray200),
          _buildSummaryRow('Operating Income', formatter.format(summary!.operatingIncome)),
          _buildSummaryRow('Operating Margin', '${summary!.operatingMargin.toStringAsFixed(1)}%', isPercentage: true),
          Container(height: 1, color: TossColors.gray200),
          _buildSummaryRow('Net Income', formatter.format(summary!.netIncome), isHighlight: true),
          _buildSummaryRow('Net Margin', '${summary!.netMargin.toStringAsFixed(1)}%', isPercentage: true),
          Container(height: 2, color: TossColors.gray900),
        ],
      ),
    );
  }

  Widget _buildBsTable() {
    if (bsDetails == null || bsSummary == null) {
      return const Center(child: Text('No data'));
    }

    final formatter = NumberFormat('#,##0', 'en_US');

    // Group by section
    final sections = <String, List<BsDetailRowModel>>{};
    for (final row in bsDetails!) {
      sections.putIfAbsent(row.section, () => []).add(row);
    }

    final sortedSections = sections.entries.toList()
      ..sort((a, b) {
        final aOrder = a.value.isNotEmpty ? a.value.first.sectionOrder : 99;
        final bOrder = b.value.isNotEmpty ? b.value.first.sectionOrder : 99;
        return aOrder.compareTo(bOrder);
      });

    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // Table Header
          _buildTableHeaderRow(['Account', 'Balance']),
          Container(height: 2, color: TossColors.gray900),

          // Sections
          ...sortedSections.map((entry) {
            final sectionTotal = entry.value.fold<double>(0, (sum, r) => sum + r.balance);
            return Column(
              children: [
                const SizedBox(height: TossSpacing.space2),
                _buildSectionHeaderRow(entry.key),
                ...entry.value.map((row) => _buildAccountRow(
                      '  ${row.accountCode} ${row.accountName}',
                      formatter.format(row.balance.abs()),
                      isNegative: row.balance < 0,
                    )),
                _buildTotalRow(
                  'Total ${entry.key}',
                  formatter.format(sectionTotal.abs()),
                ),
                Container(height: 1, color: TossColors.gray300),
              ],
            );
          }),

          const SizedBox(height: TossSpacing.space4),

          // Summary
          Container(height: 2, color: TossColors.gray900),
          _buildSummaryRow('Total Assets', formatter.format(bsSummary!.totalAssets), isHighlight: true),
          Container(height: 1, color: TossColors.gray200),
          _buildSummaryRow('Total Liabilities', formatter.format(bsSummary!.totalLiabilities)),
          _buildSummaryRow('Total Equity', formatter.format(bsSummary!.totalEquity)),
          Container(height: 1, color: TossColors.gray200),
          _buildSummaryRow(
            'Liabilities + Equity',
            formatter.format(bsSummary!.totalLiabilities + bsSummary!.totalEquity),
            isHighlight: true,
          ),
          Container(height: 2, color: TossColors.gray900),

          if (!bsSummary!.isBalanced) ...[
            const SizedBox(height: TossSpacing.space2),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: TossColors.warning),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'Difference: $currencySymbol${formatter.format(bsSummary!.balanceCheck.abs())} (unclosed P&L)',
                      style: TossTextStyles.caption.copyWith(color: TossColors.gray700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTableHeaderRow(List<String> headers) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space3,
      ),
      color: TossColors.gray50,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              headers[0],
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              headers[1],
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeaderRow(String section) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space2,
      ),
      color: TossColors.gray50,
      child: Text(
        section.toUpperCase(),
        style: TossTextStyles.caption.copyWith(
          color: TossColors.gray700,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAccountRow(String name, String value, {bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray700,
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              isNegative ? '($value)' : value,
              style: TossTextStyles.bodySmall.copyWith(
                color: isNegative ? TossColors.error : TossColors.gray700,
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: TossColors.gray200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlight = false, bool isPercentage = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space2,
      ),
      color: isHighlight ? TossColors.gray100 : null,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray900,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TossTextStyles.bodySmall.copyWith(
                color: isPercentage ? TossColors.gray600 : TossColors.gray900,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
                fontFamily: isPercentage ? null : 'JetBrains Mono',
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
