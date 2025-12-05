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
  /// Called when Approve button is clicked. Returns true on RPC success.
  final Future<bool> Function(String shiftRequestId) onApprove;
  /// Called when Remove button is clicked in bottom sheet. Returns true on RPC success.
  final Future<bool> Function(String shiftRequestId) onRemove;

  const ScheduleShiftCard({
    super.key,
    required this.shiftId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.assignedEmployees,
    required this.onApprove,
    required this.onRemove,
  });

  @override
  State<ScheduleShiftCard> createState() => _ScheduleShiftCardState();
}

class _ScheduleShiftCardState extends State<ScheduleShiftCard> {
  late bool _isExpanded;
  // Track loading state per shift_request_id
  final Set<String> _loadingRequests = {};
  // Local copy of employees for state management
  late List<Map<String, dynamic>> _localEmployees;

  @override
  void initState() {
    super.initState();
    // Initialize local copy
    _localEmployees = List<Map<String, dynamic>>.from(
      widget.assignedEmployees.map((e) => Map<String, dynamic>.from(e)),
    );
    // Only expand if there are pending applicants
    final pendingEmployees = _localEmployees
        .where((e) => e['is_approved'] == false)
        .toList();
    _isExpanded = pendingEmployees.isNotEmpty;
  }

  @override
  void didUpdateWidget(ScheduleShiftCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset local state when shift changes OR when assigned employees change significantly
    if (oldWidget.shiftId != widget.shiftId) {
      _localEmployees = List<Map<String, dynamic>>.from(
        widget.assignedEmployees.map((e) => Map<String, dynamic>.from(e)),
      );
      final pendingEmployees = _localEmployees
          .where((e) => e['is_approved'] == false)
          .toList();
      setState(() {
        _isExpanded = pendingEmployees.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use local state for employees
    final pendingEmployees = _localEmployees
        .where((e) => e['is_approved'] == false)
        .toList();
    final approvedEmployees = _localEmployees
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
                          backgroundColor: TossColors.gray200,
                          textColor: TossColors.gray700,
                        ),
                      ],
                      onActionTap: (user, actionId) async {
                        if (actionId == 'remove') {
                          await _handleRemove(user.id);
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

  /// Build applicant row - only shows Approve button (for pending employees)
  Widget _buildApplicantRow(Map<String, dynamic> employee) {
    final userName = employee['user_name'] as String? ?? 'Unknown';
    final shiftRequestId = employee['shift_request_id'] as String? ?? '';
    final isLoading = _loadingRequests.contains(shiftRequestId);

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
          // Only Approve button - no Assigned button
          TossButton1.primary(
            text: 'Approve',
            leadingIcon: isLoading ? null : const Icon(Icons.check, size: 16),
            isLoading: isLoading,
            onPressed: isLoading ? null : () => _handleApprove(shiftRequestId),
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

  /// Handle Approve button click
  /// Calls RPC and updates local state on success
  Future<void> _handleApprove(String shiftRequestId) async {
    if (shiftRequestId.isEmpty) return;

    HapticFeedback.selectionClick();

    // Set loading state
    setState(() {
      _loadingRequests.add(shiftRequestId);
    });

    try {
      // Call the RPC through the callback
      final success = await widget.onApprove(shiftRequestId);

      if (success && mounted) {
        // Update local state - change is_approved to true
        setState(() {
          final index = _localEmployees.indexWhere(
            (e) => e['shift_request_id'] == shiftRequestId,
          );
          if (index != -1) {
            _localEmployees[index]['is_approved'] = true;
          }
        });
        HapticFeedback.mediumImpact();
      }
    } finally {
      // Clear loading state
      if (mounted) {
        setState(() {
          _loadingRequests.remove(shiftRequestId);
        });
      }
    }
  }

  /// Handle Remove button click from bottom sheet
  /// Calls RPC and updates local state on success
  Future<void> _handleRemove(String shiftRequestId) async {
    if (shiftRequestId.isEmpty) return;

    HapticFeedback.selectionClick();

    // Set loading state
    setState(() {
      _loadingRequests.add(shiftRequestId);
    });

    try {
      // Call the RPC through the callback
      final success = await widget.onRemove(shiftRequestId);

      if (success && mounted) {
        // Update local state - change is_approved to false
        setState(() {
          final index = _localEmployees.indexWhere(
            (e) => e['shift_request_id'] == shiftRequestId,
          );
          if (index != -1) {
            _localEmployees[index]['is_approved'] = false;
          }
          // Auto-expand to show the returned applicant
          _isExpanded = true;
        });
        HapticFeedback.mediumImpact();
        // Close bottom sheet if open
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } finally {
      // Clear loading state
      if (mounted) {
        setState(() {
          _loadingRequests.remove(shiftRequestId);
        });
      }
    }
  }
}
