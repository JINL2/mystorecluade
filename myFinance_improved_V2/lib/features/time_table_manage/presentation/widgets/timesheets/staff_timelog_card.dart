import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_badge.dart';

/// Model for staff time record
class StaffTimeRecord {
  final String staffId;
  final String staffName;
  final String? avatarUrl;
  final String clockIn;
  final String clockOut;
  final bool isLate;
  final bool isOvertime;
  final bool needsConfirm;
  final bool isConfirmed;

  const StaffTimeRecord({
    required this.staffId,
    required this.staffName,
    this.avatarUrl,
    required this.clockIn,
    required this.clockOut,
    this.isLate = false,
    this.isOvertime = false,
    this.needsConfirm = false,
    this.isConfirmed = false,
  });
}

/// Card displaying staff clock in/out record
class StaffTimelogCard extends StatelessWidget {
  final StaffTimeRecord record;
  final VoidCallback? onTap;

  const StaffTimelogCard({
    super.key,
    required this.record,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Avatar
            if (record.avatarUrl != null)
              CircleAvatar(
                radius: 14,
                backgroundColor: TossColors.gray200,
                backgroundImage: NetworkImage(record.avatarUrl!),
                onBackgroundImageError: (_, __) {},
              )
            else
              CircleAvatar(
                radius: 14,
                backgroundColor: TossColors.gray200,
                child: const Icon(Icons.person, size: 14, color: TossColors.gray500),
              ),

            const SizedBox(width: TossSpacing.space3),

            // Name and Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.staffName,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      // Start time (colored if late)
                      Text(
                        record.clockIn,
                        style: TossTextStyles.caption.copyWith(
                          color: record.isLate
                              ? (record.isConfirmed ? TossColors.primary : TossColors.error)
                              : TossColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ' - ',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // End time (colored if OT)
                      Text(
                        record.clockOut,
                        style: TossTextStyles.caption.copyWith(
                          color: record.isOvertime
                              ? (record.isConfirmed ? TossColors.primary : TossColors.error)
                              : TossColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Show text only if there's a problem (Late or OT)
                      if (record.isLate || record.isOvertime) ...[
                        const SizedBox(width: 4),
                        Text(
                          record.isConfirmed ? '• Confirmed' : '• Need Confirm',
                          style: TossTextStyles.caption.copyWith(
                            color: record.isConfirmed ? TossColors.gray500 : TossColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: TossSpacing.space2),

            // Status Badge
            if (record.isLate)
              const TossStatusBadge(
                label: 'Late',
                status: BadgeStatus.error,
              )
            else if (record.isOvertime)
              const TossStatusBadge(
                label: 'OT',
                status: BadgeStatus.error,
              ),

            const SizedBox(width: TossSpacing.space2),

            // Chevron
            Icon(
              Icons.chevron_right,
              size: 20,
              color: TossColors.gray400,
            ),
          ],
        ),
      ),
    );
  }
}
