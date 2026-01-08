// lib/features/report_control/presentation/widgets/detail/red_flags_section.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
import '../../../../domain/entities/report_detail.dart';

/// Red Flags Section
///
/// Displays detected issues and anomalies that require attention.
class RedFlagsSection extends StatelessWidget {
  final RedFlags redFlags;

  const RedFlagsSection({
    super.key,
    required this.redFlags,
  });

  @override
  Widget build(BuildContext context) {
    final hasHighValue = redFlags.highValueTransactions.isNotEmpty;
    final hasMissingDesc = redFlags.missingDescriptions.isNotEmpty;

    if (!hasHighValue && !hasMissingDesc) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            const Icon(
              LucideIcons.alertTriangle,
              size: TossSpacing.iconMD,
              color: TossColors.error,
            ),
            SizedBox(width: TossSpacing.space2),
            Text(
              'Red Flags',
              style: TossTextStyles.titleMedium.copyWith(
                fontWeight: TossFontWeight.bold,
                color: TossColors.gray900,
              ),
            ),
          ],
        ),

        SizedBox(height: TossSpacing.space3),

        // High-value transactions
        if (hasHighValue) ...[
          _FlagCategoryCard(
            title: 'High-Value Transactions',
            icon: LucideIcons.dollarSign,
            color: TossColors.error,
            flags: redFlags.highValueTransactions,
          ),
          SizedBox(height: TossSpacing.space3),
        ],

        // Missing descriptions
        if (hasMissingDesc) ...[
          _FlagCategoryCard(
            title: 'Missing Descriptions',
            icon: LucideIcons.fileQuestion,
            color: TossColors.warning,
            flags: redFlags.missingDescriptions,
          ),
        ],
      ],
    );
  }
}

class _FlagCategoryCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<TransactionFlag> flags;

  const _FlagCategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.flags,
  });

  @override
  State<_FlagCategoryCard> createState() => _FlagCategoryCardState();
}

class _FlagCategoryCardState extends State<_FlagCategoryCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: widget.color.withValues(alpha: TossOpacity.strong),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: TossOpacity.subtle),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(TossBorderRadius.xl),
                  topRight: Radius.circular(TossBorderRadius.xl),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: TossOpacity.light),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Icon(
                      widget.icon,
                      size: TossSpacing.iconSM,
                      color: widget.color,
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TossTextStyles.body.copyWith(
                            fontWeight: TossFontWeight.semibold,
                            color: TossColors.gray900,
                          ),
                        ),
                        SizedBox(height: TossSpacing.space0_5),
                        Text(
                          '${widget.flags.length} items',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                    size: TossSpacing.iconMD,
                    color: TossColors.gray600,
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (_isExpanded)
            Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Column(
                children: widget.flags
                    .take(10) // Show max 10 items
                    .map((flag) => _TransactionFlagRow(flag: flag))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _TransactionFlagRow extends StatelessWidget {
  final TransactionFlag flag;

  const _TransactionFlagRow({required this.flag});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space3),
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount + Severity
          Row(
            children: [
              Text(
                flag.formatted,
                style: TossTextStyles.body.copyWith(
                  fontWeight: TossFontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
              const Spacer(),
              if (flag.severity != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(flag.severity).withValues(alpha: TossOpacity.light),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    flag.severity!.toUpperCase(),
                    style: TossTextStyles.labelSmall.copyWith(
                      fontWeight: TossFontWeight.bold,
                      color: _getSeverityColor(flag.severity),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: TossSpacing.space1_5),

          // Description
          if (flag.description != null)
            Text(
              flag.description!,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray700,
              ),
            ),

          SizedBox(height: TossSpacing.space1_5),

          // Employee + Store
          Row(
            children: [
              if (flag.employee != null) ...[
                const Icon(
                  LucideIcons.user,
                  size: TossSpacing.iconXS2,
                  color: TossColors.gray500,
                ),
                SizedBox(width: TossSpacing.space1),
                Expanded(
                  child: Text(
                    flag.employee!,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ),
              ],
              if (flag.store != null) ...[
                const Icon(
                  LucideIcons.store,
                  size: TossSpacing.iconXS2,
                  color: TossColors.gray500,
                ),
                SizedBox(width: TossSpacing.space1),
                Text(
                  flag.store!,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String? severity) {
    switch (severity) {
      case 'high':
        return TossColors.error;
      case 'medium':
        return TossColors.warning;
      case 'low':
        return TossColors.success;
      default:
        return TossColors.gray600;
    }
  }
}
