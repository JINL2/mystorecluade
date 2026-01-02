import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_animations.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../domain/entities/bs_summary.dart';

/// B/S Detail Section - Expandable account breakdown
class BsDetailSection extends StatefulWidget {
  final List<BsDetailRow> details;
  final BsSummary summary;
  final String currencySymbol;

  const BsDetailSection({
    super.key,
    required this.details,
    required this.summary,
    required this.currencySymbol,
  });

  @override
  State<BsDetailSection> createState() => _BsDetailSectionState();
}

class _BsDetailSectionState extends State<BsDetailSection> {
  final Set<String> _expandedSections = {};

  @override
  Widget build(BuildContext context) {
    // Group details by section
    final sections = <String, List<BsDetailRow>>{};
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
                  'Account Details',
                  style: TossTextStyles.bodyMedium.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${sortedSections.length} sections',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
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

  Widget _buildSection(String sectionName, List<BsDetailRow> accounts) {
    final isExpanded = _expandedSections.contains(sectionName);
    final sectionTotal = accounts.fold<double>(0, (sum, a) => sum + a.balance);
    final formatter = NumberFormat('#,##0', 'en_US');

    // Section styling
    final isAsset = sectionName.contains('Asset');
    final isLiability = sectionName.contains('Liabilit');

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
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Section total
                Text(
                  '${widget.currencySymbol}${formatter.format(sectionTotal.abs())}',
                  style: TossTextStyles.bodyMedium.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
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

  Widget _buildAccountRow(BsDetailRow account) {
    final formatter = NumberFormat('#,##0', 'en_US');
    final hasBalance = account.balance != 0;

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
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
            child: Text(
              account.accountCode,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
                fontSize: 10,
                fontFamily: 'JetBrains Mono',
              ),
            ),
          ),

          const SizedBox(width: TossSpacing.space2),

          // Account name
          Expanded(
            child: Text(
              account.accountName,
              style: TossTextStyles.bodySmall.copyWith(
                color: hasBalance ? TossColors.gray700 : TossColors.gray500,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          // Balance
          Text(
            '${widget.currencySymbol}${formatter.format(account.balance.abs())}',
            style: TossTextStyles.bodySmall.copyWith(
              color: hasBalance ? TossColors.gray700 : TossColors.gray400,
              fontWeight: hasBalance ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
