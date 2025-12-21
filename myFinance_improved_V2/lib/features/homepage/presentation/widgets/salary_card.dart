import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Salary Card - Shows user's monthly salary
///
/// Displayed when user doesn't have permission to view company revenue
class SalaryCard extends ConsumerWidget {
  const SalaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salaryAsync = ref.watch(userSalaryProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'My Salary',
            style: TossTextStyles.h3.copyWith(
              fontSize: 20,
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),

          // Salary Amount
          salaryAsync.when(
            data: (salary) => _buildSalaryContent(salary),
            loading: () => _buildLoadingState(),
            error: (error, _) => _buildErrorState(error.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryContent(Map<String, dynamic> salary) {
    final monthlySalary = salary['monthly_salary'] as double? ?? 0.0;
    final currencySymbol = salary['currency_symbol'] as String? ?? '\$';
    final overtimeBonus = salary['overtime_bonus'] as double? ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Amount
        Text(
          '$currencySymbol${_formatAmountWithComma(monthlySalary)}',
          style: TossTextStyles.h1.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: TossColors.textPrimary,
            letterSpacing: -1.0,
            height: 1.2,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),

        // Overtime bonus (if > 0)
        if (overtimeBonus > 0)
          Text(
            '+$currencySymbol${_formatAmountWithComma(overtimeBonus)}  overtime bonus',
            style: TossTextStyles.body.copyWith(
              color: TossColors.success,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

        const SizedBox(height: TossSpacing.space3),

        // Estimated Salary label
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: TossColors.primarySurface,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.calculate_outlined,
                size: 14,
                color: TossColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                'Estimated Salary',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space6),
        child: CircularProgressIndicator(
          color: TossColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: TossColors.error,
            size: 20,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Unable to load salary information',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  /// Format amount with comma separator (like 3,611,500)
  String _formatAmountWithComma(double amount) {
    final amountStr = amount.toStringAsFixed(0);
    final parts = <String>[];
    var remaining = amountStr;

    while (remaining.length > 3) {
      parts.insert(0, remaining.substring(remaining.length - 3));
      remaining = remaining.substring(0, remaining.length - 3);
    }

    if (remaining.isNotEmpty) {
      parts.insert(0, remaining);
    }

    return parts.join(',');
  }
}

/// Provider for fetching user's salary using userShiftStatsProvider
///
/// Reuses the existing userShiftStatsProvider from attendance feature
/// which calls user_shift_stats RPC
final userSalaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final stats = await ref.watch(userShiftStatsProvider.future);

  // Return default values if stats is null
  if (stats == null) {
    return {
      'monthly_salary': 0.0,
      'currency_symbol': '\$',
      'salary_type': 'monthly',
      'overtime_bonus': 0.0,
    };
  }

  // Extract salary info from user_shift_stats RPC response
  final salaryInfo = stats.salaryInfo;
  final thisMonth = stats.thisMonth;

  return {
    'monthly_salary': thisMonth.totalPayment,
    'salary_amount': salaryInfo.salaryAmount,
    'currency_symbol': salaryInfo.currencySymbol,
    'salary_type': salaryInfo.salaryType,
    'overtime_bonus': thisMonth.bonusPay,
  };
});
