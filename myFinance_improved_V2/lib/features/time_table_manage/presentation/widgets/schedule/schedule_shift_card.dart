import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/avatar_stack_interact.dart';
import '../../../../../shared/widgets/toss/toss_button_1.dart';

/// Schedule Shift Card
///
/// Displays a shift with assigned employees for the Schedule tab
/// Shows applicants list similar to the reference design
class ScheduleShiftCard extends StatefulWidget {
  final String shiftId;
  final String shiftName;
  final String startTime;
  final String endTime;
  final List<Map<String, dynamic>> assignedEmployees;
  final Set<String> selectedShiftRequests;
  final void Function(String shiftRequestId, bool isApproved, String shiftRequestIdFromData) onEmployeeTap;
  final Future<void> Function(String shiftRequestId)? onRemoveApproved;

  const ScheduleShiftCard({
    super.key,
    required this.shiftId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.assignedEmployees,
    required this.selectedShiftRequests,
    required this.onEmployeeTap,
    this.onRemoveApproved,
  });

  @override
  State<ScheduleShiftCard> createState() => _ScheduleShiftCardState();
}

class _ScheduleShiftCardState extends State<ScheduleShiftCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    // Only expand if there are pending applicants
    final pendingEmployees = widget.assignedEmployees
        .where((e) => e['is_approved'] == false)
        .toList();
    _isExpanded = pendingEmployees.isNotEmpty;
  }

  @override
  void didUpdateWidget(ScheduleShiftCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset expansion state when shift changes OR when assigned employees change
    if (oldWidget.shiftId != widget.shiftId ||
        oldWidget.assignedEmployees.length != widget.assignedEmployees.length) {
      final pendingEmployees = widget.assignedEmployees
          .where((e) => e['is_approved'] == false)
          .toList();
      setState(() {
        _isExpanded = pendingEmployees.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingEmployees = widget.assignedEmployees
        .where((e) => e['is_approved'] == false)
        .toList();
    final approvedEmployees = widget.assignedEmployees
        .where((e) => e['is_approved'] == true)
        .toList();

    final hasApplicants = pendingEmployees.isNotEmpty;
    final totalAssigned = approvedEmployees.length;

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shift Header (expandable)
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with time and expand icon
                  Row(
                    children: [
                      // Time icon
                      const Icon(
                        Icons.access_time,
                        size: 20,
                        color: TossColors.gray700,
                      ),
                      const SizedBox(width: TossSpacing.space2),

                      // Shift name and time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.shiftName,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.startTime} - ${widget.endTime}',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Expand/collapse icon
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: TossColors.gray600,
                      ),
                    ],
                  ),

                  // Avatar stack below the time
                  if (approvedEmployees.isNotEmpty) ...[
                    const SizedBox(height: TossSpacing.space3),
                    AvatarStackInteract(
                      users: approvedEmployees
                          .map(
                            (emp) => AvatarUser(
                              id: emp['shift_request_id']?.toString() ?? '',
                              name: emp['user_name'] as String? ?? 'Unknown',
                              avatarUrl: emp['profile_image'] as String?,
                            ),
                          )
                          .toList(),
                      title: 'Approved Employees',
                      countTextFormat: '$totalAssigned/4 assigned',
                      maxVisibleAvatars: 3,
                      avatarSize: 24,
                      overlapOffset: 16,
                      actionButtons: const [
                        UserActionButton(
                          id: 'remove',
                          label: 'Remove',
                          icon: Icons.close,
                          backgroundColor: TossColors.error,
                          textColor: TossColors.white,
                        ),
                      ],
                      onActionTap: (user, actionId) async {
                        if (widget.onRemoveApproved != null) {
                          HapticFeedback.selectionClick();
                          // Call the removal handler with shift request ID
                          await widget.onRemoveApproved!(user.id);
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Applicants section (when expanded)
          if (_isExpanded && hasApplicants) ...[
            const Divider(height: 1, color: TossColors.gray200),
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Applicants (${pendingEmployees.length})',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  ...pendingEmployees.map((emp) => _buildApplicantRow(emp)),
                ],
              ),
            ),
          ],

          // Empty state
          if (_isExpanded && !hasApplicants)
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Center(
                child: Text(
                  'No applicants yet',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> employee, {double size = 32}) {
    final profileImage = employee['profile_image'] as String?;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: TossColors.gray200,
        shape: BoxShape.circle,
        border: Border.all(color: TossColors.white, width: 2),
      ),
      child: ClipOval(
        child: profileImage != null && profileImage.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: profileImage,
                width: size,
                height: size,
                fit: BoxFit.cover,
                memCacheWidth: (size * 3).toInt(),
                memCacheHeight: (size * 3).toInt(),
                placeholder: (context, url) => Icon(
                  Icons.person,
                  size: size * 0.6,
                  color: TossColors.gray500,
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: size * 0.6,
                  color: TossColors.gray500,
                ),
              )
            : Icon(
                Icons.person,
                size: size * 0.6,
                color: TossColors.gray500,
              ),
      ),
    );
  }

  Widget _buildApplicantRow(Map<String, dynamic> employee) {
    final userName = employee['user_name'] as String? ?? 'Unknown';
    final shiftRequestId = employee['shift_request_id'] as String? ?? '';
    final isSelected = widget.selectedShiftRequests.contains('${widget.shiftId}_$userName');

    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space2),
      child: Row(
        children: [
          _buildAvatar(employee, size: 32),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Text(
              userName,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Approve/Assigned button
          if (isSelected)
            TossButton1.secondary(
              text: 'Assigned',
              leadingIcon: const Icon(Icons.check, size: 16),
              onPressed: () {
                HapticFeedback.selectionClick();
                widget.onEmployeeTap('${widget.shiftId}_$userName', false, shiftRequestId);
              },
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              fontSize: 13,
            )
          else
            TossButton1.primary(
              text: 'Approve',
              leadingIcon: const Icon(Icons.check, size: 16),
              onPressed: () {
                HapticFeedback.selectionClick();
                widget.onEmployeeTap('${widget.shiftId}_$userName', false, shiftRequestId);
              },
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              fontSize: 13,
            ),
        ],
      ),
    );
  }
}
