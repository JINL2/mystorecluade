// lib/features/report_control/presentation/widgets/detail/performance_cards_section.dart

import 'package:flutter/material.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../../../../domain/entities/templates/financial_summary/financial_report.dart';

/// Performance Cards Section
///
/// 3-column grid of key metrics cards.
/// Follows Attendance Stats KPI card design pattern.
class PerformanceCardsSection extends StatelessWidget {
  final List<PerformanceCard> cards;

  const PerformanceCardsSection({
    super.key,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Performance Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: TossColors.gray900,
            ),
          ),
        ),

        // Cards grid
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: cards
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final card = entry.value;
                  return Expanded(
                    child: Row(
                      children: [
                        if (index > 0)
                          Container(
                            width: 1,
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            color: TossColors.gray200,
                          ),
                        Expanded(
                          child: _PerformanceCard(card: card),
                        ),
                      ],
                    ),
                  );
                })
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  final PerformanceCard card;

  const _PerformanceCard({required this.card});

  Color _getSeverityColor(String? severity) {
    switch (severity) {
      case 'high':
        return TossColors.error;
      case 'medium':
        return TossColors.warning;
      case 'low':
        return TossColors.success;
      default:
        return TossColors.gray900;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon + Label
        Row(
          children: [
            Text(
              card.icon,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                card.label,
                style: const TextStyle(
                  fontSize: 11,
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Value
        Text(
          card.value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: card.severity != null
                ? _getSeverityColor(card.severity)
                : TossColors.gray900,
          ),
        ),

        // Trend (if available)
        if (card.trend != null) ...[
          const SizedBox(height: 4),
          Text(
            card.trend!,
            style: TextStyle(
              fontSize: 11,
              color: card.trend!.startsWith('+')
                  ? TossColors.success
                  : card.trend!.startsWith('-')
                      ? TossColors.error
                      : TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
