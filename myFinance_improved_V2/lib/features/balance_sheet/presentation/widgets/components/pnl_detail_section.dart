import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_animations.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../domain/entities/pnl_summary.dart';

/// P&L Detail Section - Expandable account breakdown
class PnlDetailSection extends StatefulWidget {
  final List<PnlDetailRow> details;
  final PnlSummary summary;
  final String currencySymbol;

  const PnlDetailSection({
    super.key,
    required this.details,
    required this.summary,
    required this.currencySymbol,
  });

  @override
  State<PnlDetailSection> createState() => _PnlDetailSectionState();
}

class _PnlDetailSectionState extends State<PnlDetailSection> {
  final Set<String> _expandedSections = {};

  @override
  Widget build(BuildContext context) {
    // Group details by section
    final sections = <String, List<PnlDetailRow>>{};
    for (final row in widget.details) {
      sections.putIfAbsent(row.section, () => []).add(row);
    }

    // Sort sections by order
    final sortedSections = sections.entries.toList()
      ..sort((a, b) {
        final aOrder = a.value.isNotEmpty ? a.value.first.sectionOrder : 99;
        final bOrder = b.value.isNotEmpty ? b.value.first.sectionOrder : 99;
        return aOrder.compareTo(bOrder);
      });

    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              children: [
                Text(
                  'Breakdown',
                  style: TossTextStyles.bodyMediumBold,
                ),
                const Spacer(),
                Text(
                  '${sortedSections.length} sections',
                  style: TossTextStyles.captionGray500,
                ),
              ],
            ),
          ),

          Container(height: 1, color: TossColors.gray100),

          // Sections
          ...sortedSections.map((entry) => _buildSection(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildSection(String sectionName, List<PnlDetailRow> accounts) {
    final isExpanded = _expandedSections.contains(sectionName);
    final sectionTotal = accounts.fold<double>(0, (sum, a) => sum + a.amount);
    final formatter = NumberFormat('#,##0', 'en_US');

    // Section styling based on type
    final isRevenue = sectionName == 'Revenue';
    final isExpense = sectionName.contains('Expense') || sectionName == 'COGS';

    return Column(
      children: [
        // Section Header
        InkWell(
          onTap: () {
            setState(() {
              if (isExpanded) {
                _expandedSections.remove(sectionName);
              } else {
                _expandedSections.add(sectionName);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            child: Row(
              children: [
                // Expand icon
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: TossAnimations.fast,
                  child: Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: TossColors.gray400,
                  ),
                ),

                const SizedBox(width: TossSpacing.space2),

                // Section name
                Expanded(
                  child: Text(
                    sectionName,
                    style: TossTextStyles.bodyMedium,
                  ),
                ),

                // Section total
                Text(
                  '${widget.currencySymbol}${formatter.format(sectionTotal.abs())}',
                  style: TossTextStyles.bodyMediumBold.copyWith(
                    color: isExpense ? TossColors.gray600 : TossColors.gray900,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Account Details (when expanded)
        AnimatedCrossFade(
          duration: TossAnimations.fast,
          crossFadeState:
              isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Container(
            color: TossColors.gray50,
            child: Column(
              children: accounts.map((account) => _buildAccountRow(account)).toList(),
            ),
          ),
          secondChild: const SizedBox.shrink(),
        ),

        // Divider
        Container(height: 1, color: TossColors.gray100),
      ],
    );
  }

  Widget _buildAccountRow(PnlDetailRow account) {
    final formatter = NumberFormat('#,##0', 'en_US');
    final hasActivity = account.amount != 0;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
          // Indent + Code
          const SizedBox(width: TossSpacing.space7),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: TossColors.white,
              border: Border.all(color: TossColors.gray200),
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
            child: Text(
              account.accountCode,
              style: TossTextStyles.codeSmall.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),

          const SizedBox(width: TossSpacing.space2),

          // Account name
          Expanded(
            child: Text(
              account.accountName,
              style: hasActivity
                  ? TossTextStyles.bodySmallGray700
                  : TossTextStyles.bodySmallGray500,
            ),
          ),

          // Amount
          Text(
            '${widget.currencySymbol}${formatter.format(account.amount.abs())}',
            style: hasActivity
                ? TossTextStyles.bodySmall.copyWith(color: TossColors.gray700)
                : TossTextStyles.bodySmallGray400,
          ),
        ],
      ),
    );
  }
}
