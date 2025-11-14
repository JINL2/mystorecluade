import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Schedule Shift Card
///
/// Displays a shift with assigned employees for the Schedule tab
class ScheduleShiftCard extends StatelessWidget {
  final String shiftId;
  final String shiftName;
  final String startTime;
  final String endTime;
  final List<Map<String, dynamic>> assignedEmployees;
  final Set<String> selectedShiftRequests;
  final void Function(String shiftRequestId, bool isApproved, String shiftRequestIdFromData) onEmployeeTap;

  const ScheduleShiftCard({
    super.key,
    required this.shiftId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.assignedEmployees,
    required this.selectedShiftRequests,
    required this.onEmployeeTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasEmployee = assignedEmployees.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: hasEmployee
              ? (assignedEmployees.any((e) => e['is_approved'] == true)
                  ? TossColors.success.withValues(alpha: 0.3)
                  : TossColors.warning.withValues(alpha: 0.3))
              : TossColors.error.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shift Header
          _buildShiftHeader(hasEmployee),

          // Employee Assignments
          if (hasEmployee)
            ...assignedEmployees.map((empShift) => _buildEmployeeRow(empShift))
          else
            _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildShiftHeader(bool hasEmployee) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: hasEmployee
            ? TossColors.gray50
            : TossColors.error.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(11),
          topRight: Radius.circular(11),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: hasEmployee
                  ? TossColors.primary.withValues(alpha: 0.1)
                  : TossColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(
              Icons.access_time,
              size: 18,
              color: hasEmployee ? TossColors.primary : TossColors.error,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shiftName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '$startTime - $endTime',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          if (!hasEmployee)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
              ),
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Text(
                'Empty',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmployeeRow(Map<String, dynamic> empShift) {
    final userName = empShift['user_name'] as String? ?? 'Unknown Employee';
    final isApproved = (empShift['is_approved'] as bool?) ?? false;
    final shiftRequestIdFromData = empShift['shift_request_id'] as String? ?? '';
    final profileImage = empShift['profile_image'] as String?;

    // Create unique identifier for this shift request
    final shiftRequestId = '${shiftId}_$userName';
    final isSelected = selectedShiftRequests.contains(shiftRequestId);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onEmployeeTap(shiftRequestId, isApproved, shiftRequestIdFromData);
      },
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: isSelected
              ? TossColors.primary.withValues(alpha: 0.08)
              : (isApproved
                  ? TossColors.success.withValues(alpha: 0.03)
                  : TossColors.warning.withValues(alpha: 0.03)),
          border: Border(
            top: const BorderSide(
              color: TossColors.gray100,
              width: 1,
            ),
            left: BorderSide(
              color: isSelected ? TossColors.primary : TossColors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primary.withValues(alpha: 0.15)
                    : (isApproved
                        ? TossColors.success.withValues(alpha: 0.1)
                        : TossColors.warning.withValues(alpha: 0.1)),
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: TossColors.primary,
                    )
                  : (profileImage != null && profileImage.isNotEmpty)
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profileImage,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            memCacheWidth: 96,
                            memCacheHeight: 96,
                            maxWidthDiskCache: 96,
                            maxHeightDiskCache: 96,
                            placeholder: (context, url) => const Icon(
                              Icons.person_outline,
                              size: 16,
                              color: TossColors.gray500,
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person_outline,
                              size: 16,
                              color: TossColors.gray500,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person_outline,
                          size: 16,
                          color: isApproved
                              ? TossColors.success
                              : TossColors.warning,
                        ),
            ),
            const SizedBox(width: TossSpacing.space3),

            // Employee name
            Expanded(
              child: Text(
                userName,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primary.withValues(alpha: 0.15)
                    : (isApproved
                        ? TossColors.success.withValues(alpha: 0.1)
                        : TossColors.warning.withValues(alpha: 0.1)),
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                border: isSelected
                    ? Border.all(
                        color: TossColors.primary.withValues(alpha: 0.3),
                        width: 1,
                      )
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected)
                    const Icon(
                      Icons.check,
                      size: 12,
                      color: TossColors.primary,
                    ),
                  if (isSelected) const SizedBox(width: 2),
                  Text(
                    isSelected
                        ? 'Selected'
                        : (isApproved ? 'Approved' : 'Pending'),
                    style: TossTextStyles.caption.copyWith(
                      color: isSelected
                          ? TossColors.primary
                          : (isApproved
                              ? TossColors.success
                              : TossColors.warning),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: TossColors.error.withValues(alpha: 0.7),
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            'No employee assigned',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.error.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
