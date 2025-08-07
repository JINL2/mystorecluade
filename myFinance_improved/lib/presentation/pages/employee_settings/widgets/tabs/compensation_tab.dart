// lib/presentation/pages/employee_settings/widgets/tabs/compensation_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/themes/toss_colors.dart';
import '../../../../../core/themes/toss_spacing.dart';
import '../../../../../core/themes/toss_text_styles.dart';
import '../../../../../core/themes/toss_border_radius.dart';
import '../../../../../core/themes/toss_shadows.dart';
import '../../../../../domain/entities/employee_detail.dart';
import '../../../../providers/employee_provider.dart';

class CompensationTab extends ConsumerWidget {
  final EmployeeDetail employee;

  const CompensationTab({super.key, required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenciesAsync = ref.watch(currenciesProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentSalaryCard(),
          SizedBox(height: TossSpacing.space6),
          _buildSalaryBreakdown(),
          SizedBox(height: TossSpacing.space6),
          _buildPaymentHistory(),
        ],
      ),
    );
  }

  Widget _buildCurrentSalaryCard() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TossColors.primary, TossColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.shadow2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Salary',
            style: TossTextStyles.body.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            employee.displaySalary,
            style: TossTextStyles.h1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: TossSpacing.space4),
          Row(
            children: [
              _buildSalaryBadge(
                'Type',
                employee.salaryType == 'hourly' ? 'Hourly' : 'Monthly',
              ),
              SizedBox(width: TossSpacing.space3),
              _buildSalaryBadge(
                'Currency',
                employee.currencyCode ?? 'USD',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryBadge(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compensation Details',
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space3),
        _buildBreakdownRow('Base Salary', employee.salaryAmount),
        _buildBreakdownRow('Bonus', employee.bonusAmount),
        if (employee.salaryAmount != null) ...[
          SizedBox(height: TossSpacing.space3),
          Container(height: 1, color: TossColors.gray200),
          SizedBox(height: TossSpacing.space3),
          _buildBreakdownRow(
            'Total',
            (employee.salaryAmount ?? 0) + (employee.bonusAmount ?? 0),
            isTotal: true,
          ),
        ],
      ],
    );
  }

  Widget _buildBreakdownRow(String label, double? amount, {bool isTotal = false}) {
    final symbol = employee.currencySymbol ?? '\$';
    final displayAmount = amount != null 
        ? '$symbol${amount.toStringAsFixed(2)}'
        : 'Not set';
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: isTotal ? TossColors.gray900 : TossColors.gray600,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            displayAmount,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment History',
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: TossSpacing.space4),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 48,
                color: TossColors.gray400,
              ),
              SizedBox(height: TossSpacing.space3),
              Text(
                'Payment history coming soon',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}