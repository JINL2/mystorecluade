import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/employee_monthly_detail.dart';
import 'activity_log_item.dart';

/// Recent activity section showing audit logs
class RecentActivitySection extends StatelessWidget {
  final EmployeeMonthlyDetail? monthlyData;

  const RecentActivitySection({
    super.key,
    this.monthlyData,
  });

  @override
  Widget build(BuildContext context) {
    final auditLogs = monthlyData?.auditLogs ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space4,
            TossSpacing.space4,
            0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TossTextStyles.titleMedium.copyWith(
                  fontWeight: TossFontWeight.bold,
                ),
              ),
              if (auditLogs.isNotEmpty)
                Text(
                  '${auditLogs.length} events',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        if (auditLogs.isEmpty)
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space6),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.history,
                    size: TossSpacing.icon3XL,
                    color: TossColors.gray300,
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  Text(
                    'No activity this month',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Column(
              children: auditLogs
                  .take(10)
                  .map((log) => ActivityLogItem(log: log))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
