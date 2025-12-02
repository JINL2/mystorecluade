// lib/features/report_control/presentation/widgets/detail/red_flags_section.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../../../../domain/entities/templates/financial_summary/financial_report.dart';

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
        const Row(
          children: [
            Icon(
              LucideIcons.alertTriangle,
              size: 20,
              color: TossColors.error,
            ),
            SizedBox(width: 8),
            Text(
              'Red Flags',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: TossColors.gray900,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // High-value transactions
        if (hasHighValue) ...[
          _FlagCategoryCard(
            title: 'High-Value Transactions',
            icon: LucideIcons.dollarSign,
            color: TossColors.error,
            flags: redFlags.highValueTransactions,
          ),
          const SizedBox(height: 12),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.color.withOpacity(0.2),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 18,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: TossColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.flags.length} items',
                          style: const TextStyle(
                            fontSize: 12,
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                    size: 20,
                    color: TossColors.gray600,
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(12),
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
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
              const Spacer(),
              if (flag.severity != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(flag.severity).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    flag.severity!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _getSeverityColor(flag.severity),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 6),

          // Description
          if (flag.description != null)
            Text(
              flag.description!,
              style: const TextStyle(
                fontSize: 13,
                color: TossColors.gray700,
              ),
            ),

          const SizedBox(height: 6),

          // Employee + Store
          Row(
            children: [
              if (flag.employee != null) ...[
                const Icon(
                  LucideIcons.user,
                  size: 12,
                  color: TossColors.gray500,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    flag.employee!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: TossColors.gray600,
                    ),
                  ),
                ),
              ],
              if (flag.store != null) ...[
                const Icon(
                  LucideIcons.store,
                  size: 12,
                  color: TossColors.gray500,
                ),
                const SizedBox(width: 4),
                Text(
                  flag.store!,
                  style: const TextStyle(
                    fontSize: 12,
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
