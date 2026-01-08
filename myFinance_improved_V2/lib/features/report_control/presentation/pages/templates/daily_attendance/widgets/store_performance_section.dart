// lib/features/report_control/presentation/pages/templates/daily_attendance/widgets/store_performance_section.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/index.dart';
import '../../../../../domain/entities/templates/daily_attendance/attendance_report.dart';

/// Store Performance Section - Store summary with issues
class StorePerformanceSection extends StatelessWidget {
  final List<StorePerformance> stores;

  const StorePerformanceSection({
    super.key,
    required this.stores,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingLG),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  LucideIcons.building2,
                  size: TossSpacing.iconSM,
                  color: TossColors.gray600,
                ),
              ),
              SizedBox(width: TossSpacing.gapMD),
              Text(
                'Store Performance',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.gapLG),

          // Store List - Stores with issues first
          ...stores.map((store) => _buildStoreItem(store)),
        ],
      ),
    );
  }

  Widget _buildStoreItem(StorePerformance store) {
    final hasIssues = store.issuesCount > 0;
    final status = store.status;

    Color statusColor;
    IconData statusIcon;

    if (status == 'critical') {
      statusColor = TossColors.error;
      statusIcon = LucideIcons.xCircle;
    } else if (status == 'warning') {
      statusColor = TossColors.warning;
      statusIcon = LucideIcons.alertCircle;
    } else {
      statusColor = TossColors.success;
      statusIcon = LucideIcons.checkCircle;
    }

    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space2),
      padding: EdgeInsets.all(TossSpacing.paddingSM),
      decoration: BoxDecoration(
        color: hasIssues
            ? statusColor.withValues(alpha: TossOpacity.subtle)
            : TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: hasIssues
              ? statusColor.withValues(alpha: TossOpacity.strong)
              : TossColors.gray200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            statusIcon,
            size: TossSpacing.iconXS,
            color: statusColor,
          ),
          SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              store.storeName,
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.gray900,
              ),
            ),
          ),
          if (hasIssues)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: TossOpacity.light),
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
              child: Text(
                '${store.issuesCount} issues',
                style: TossTextStyles.labelMedium.copyWith(
                  color: statusColor,
                ),
              ),
            )
          else
            Text(
              'No issues',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.success,
              ),
            ),
        ],
      ),
    );
  }
}
