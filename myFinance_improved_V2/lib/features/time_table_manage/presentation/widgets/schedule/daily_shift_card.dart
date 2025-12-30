import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/employee_profile_avatar.dart';
import '../../../domain/entities/daily_shift_data.dart';
import '../../../domain/entities/shift.dart';
import '../../../domain/entities/shift_request.dart';
import '../../../domain/value_objects/shift_time_range.dart';
import '../common/shift_time_display.dart';

/// Daily Shift Card
///
/// Displays shift details with employees in a card format
class DailyShiftCard extends StatelessWidget {
  final ShiftWithRequests shiftWithRequests;
  final VoidCallback? onTap;
  final void Function(ShiftRequest)? onApprovalToggle;

  const DailyShiftCard({
    super.key,
    required this.shiftWithRequests,
    this.onTap,
    this.onApprovalToggle,
  });

  @override
  Widget build(BuildContext context) {
    final shift = shiftWithRequests.shift;
    final pendingRequests = shiftWithRequests.pendingRequests;
    final approvedRequests = shiftWithRequests.approvedRequests;

    // Create time range from shift times
    final timeRange = ShiftTimeRange(
      startTime: shift.planStartTime,
      endTime: shift.planEndTime,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: TossSpacing.marginMD),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        side: BorderSide(
          color: shift.isUnderStaffed ? TossColors.error : TossColors.gray200,
          width: shift.isUnderStaffed ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Time and staffing status
              Row(
                children: [
                  Expanded(
                    child: ShiftTimeDisplay(
                      timeRange: timeRange,
                      showDuration: true,
                    ),
                  ),
                  _buildStaffingBadge(shift),
                ],
              ),

              const SizedBox(height: TossSpacing.marginMD),

              // Approved employees
              if (approvedRequests.isNotEmpty) ...[
                _buildSectionTitle('Approved Workers (${approvedRequests.length})'),
                const SizedBox(height: TossSpacing.marginSM),
                _buildEmployeeList(approvedRequests, isApproved: true),
                const SizedBox(height: TossSpacing.marginMD),
              ],

              // Pending requests
              if (pendingRequests.isNotEmpty) ...[
                _buildSectionTitle('Pending Requests (${pendingRequests.length})'),
                const SizedBox(height: TossSpacing.marginSM),
                _buildEmployeeList(pendingRequests, isApproved: false),
              ],

              // Empty state
              if (approvedRequests.isEmpty && pendingRequests.isEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(TossSpacing.paddingLG),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Center(
                    child: Text(
                      'No workers applied yet',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaffingBadge(Shift shift) {
    final color = shift.isFullyStaffed
        ? TossColors.success
        : shift.isUnderStaffed
            ? TossColors.error
            : TossColors.warning;

    final bgColor = shift.isFullyStaffed
        ? TossColors.successLight
        : shift.isUnderStaffed
            ? TossColors.errorLight
            : TossColors.warningLight;

    final text = '${shift.currentCount}/${shift.targetCount}';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.paddingMD,
        vertical: TossSpacing.paddingXS,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Text(
        text,
        style: TossTextStyles.button.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TossTextStyles.h4.copyWith(
        color: TossColors.gray700,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildEmployeeList(
    List<ShiftRequest> requests, {
    required bool isApproved,
  }) {
    return Column(
      children: requests.map((request) {
        return Container(
          margin: const EdgeInsets.only(bottom: TossSpacing.marginSM),
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          decoration: BoxDecoration(
            color: isApproved ? TossColors.gray50 : TossColors.warningLight,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Row(
            children: [
              // Avatar
              EmployeeProfileAvatar(
                imageUrl: request.employee.profileImage,
                name: request.employee.userName,
                size: 40,
              ),
              const SizedBox(width: TossSpacing.marginMD),

              // Employee info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.employee.userName,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray900,
                      ),
                    ),
                    if (request.employee.position?.isNotEmpty ?? false)
                      Text(
                        request.employee.position!,
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                  ],
                ),
              ),

              // Status indicator or action button
              if (isApproved)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.successLight,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                  child: Text(
                    'Approve',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else if (onApprovalToggle != null)
                IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  color: TossColors.success,
                  onPressed: () => onApprovalToggle!(request),
                  tooltip: 'Approve',
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
