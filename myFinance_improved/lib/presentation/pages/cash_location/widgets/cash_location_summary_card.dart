import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../providers/cash_location_provider.dart';

class CashLocationSummaryCard extends ConsumerWidget {
  const CashLocationSummaryCard({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(cashLocationSummaryProvider);
    
    return summaryAsync.when(
      data: (summary) {
        final byType = summary['byType'] as Map<String, int>;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildCount(
                count: summary['total'],
                label: 'locations',
                color: TossColors.gray900,
              ),
              const Spacer(),
              _buildTypeCount(Icons.payments_outlined, byType['cash'] ?? 0, TossColors.success),
              const SizedBox(width: 16),
              _buildTypeCount(Icons.account_balance_outlined, byType['bank'] ?? 0, TossColors.info),
              const SizedBox(width: 16),
              _buildTypeCount(Icons.lock_outline, byType['vault'] ?? 0, TossColors.warning),
            ],
          ),
        );
      },
      loading: () => const SizedBox(height: 32),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
  
  Widget _buildCount({
    required int count,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Text(
          count.toString(),
          style: TossTextStyles.h2.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
      ],
    );
  }
  
  Widget _buildTypeCount(IconData icon, int count, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray700,
          ),
        ),
      ],
    );
  }
}