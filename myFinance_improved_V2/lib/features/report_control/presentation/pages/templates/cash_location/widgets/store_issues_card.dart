// lib/features/report_control/presentation/pages/templates/cash_location/widgets/store_issues_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../domain/entities/cash_location_report.dart';
import 'issue_location_card.dart';

/// Store Issues Card
///
/// Minimalist Toss-style design:
/// - Store icon is GRAY (no color)
/// - Color only used for: total difference amount
/// - White-dominant, clean, modern UI
class StoreIssuesCard extends StatefulWidget {
  final String storeId;
  final String storeName;
  final List<CashLocationIssue> issues;
  final bool initiallyExpanded;

  const StoreIssuesCard({
    super.key,
    required this.storeId,
    required this.storeName,
    required this.issues,
    this.initiallyExpanded = true,
  });

  @override
  State<StoreIssuesCard> createState() => _StoreIssuesCardState();
}

class _StoreIssuesCardState extends State<StoreIssuesCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate store totals
    final totalDifference = widget.issues.fold<double>(
      0,
      (sum, issue) => sum + issue.difference,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          // Store header (tappable)
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Store icon - GRAY (no color)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      LucideIcons.store,
                      size: 18,
                      color: TossColors.gray600,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Store name and info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.storeName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: TossColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            // Issue count - gray badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.gray100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${widget.issues.length} issue${widget.issues.length > 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: TossColors.gray600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Total difference - COLORED (only colored element)
                            Text(
                              _formatAmount(totalDifference),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: totalDifference >= 0
                                    ? TossColors.warning
                                    : TossColors.error,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Expand/collapse icon - gray
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      LucideIcons.chevronDown,
                      size: 20,
                      color: TossColors.gray400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Issues list (collapsible)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: widget.issues
                        .map((issue) => IssueLocationCard(issue: issue))
                        .toList(),
                  ),
                ),
              ],
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    final prefix = amount >= 0 ? '+' : '';
    final absAmount = amount.abs();
    if (absAmount >= 1000000000) {
      return '$prefix${(amount / 1000000000).toStringAsFixed(1)}B ₫';
    } else if (absAmount >= 1000000) {
      return '$prefix${(amount / 1000000).toStringAsFixed(1)}M ₫';
    } else if (absAmount >= 1000) {
      return '$prefix${(amount / 1000).toStringAsFixed(0)}K ₫';
    }
    return '$prefix${amount.toStringAsFixed(0)} ₫';
  }
}
