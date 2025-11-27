import 'package:flutter/material.dart';
import '../../../../shared/widgets/common/avatar_stack_interact.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../models/schedule_models.dart';
import 'employee_action_row.dart';

/// Shift Management Card Widget
///
/// Displays a shift with assigned employees, applicants, and waitlist.
///
/// Features:
/// - Expandable/collapsible card
/// - Header with shift name and time
/// - Roster row with avatar stack
/// - Applicants section with approve buttons
/// - Waitlist section with overbook buttons
class ShiftManagementCard extends StatefulWidget {
  final ShiftData shift;
  final Function(Employee)? onApprove;
  final Function(Employee)? onReject;
  final Function(Employee)? onOverbook;
  final Function(Employee)? onRemoveFromWaitlist;
  final Function(Employee)? onAddToShift;
  final Function(Employee)? onRemoveFromShift;

  const ShiftManagementCard({
    super.key,
    required this.shift,
    this.onApprove,
    this.onReject,
    this.onOverbook,
    this.onRemoveFromWaitlist,
    this.onAddToShift,
    this.onRemoveFromShift,
  });

  @override
  State<ShiftManagementCard> createState() => _ShiftManagementCardState();
}

class _ShiftManagementCardState extends State<ShiftManagementCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        border: Border.all(color: TossColors.gray200),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRosterRow(),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: widget.shift.applicants.isNotEmpty
                            ? Column(
                                children: [
                                  _buildDivider(),
                                  _buildApplicantsSection(),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: widget.shift.waitlist.isNotEmpty
                            ? Column(
                                children: [
                                  _buildDivider(),
                                  _buildWaitlistSection(),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// Build card header with shift name, time, and expand/collapse icon
  Widget _buildHeader() {
    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      borderRadius: BorderRadius.vertical(
        top: const Radius.circular(TossBorderRadius.xl),
        bottom: _isExpanded
            ? Radius.zero
            : const Radius.circular(TossBorderRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shift name
                  Text(
                    widget.shift.name,
                    style: TossTextStyles.titleMedium.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Time with clock icon
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: TossColors.gray800,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.shift.startTime} – ${widget.shift.endTime}',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Expand/collapse icon
            Icon(
              _isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: TossColors.gray600,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  /// Build roster row with avatar stack
  Widget _buildRosterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space3,
        0,
        TossSpacing.space3,
        TossSpacing.space3,
      ),
      child: AvatarStackInteract(
        users: widget.shift.assignedEmployees
            .map((emp) => AvatarUser(
                  id: emp.id,
                  name: emp.name,
                  avatarUrl: emp.avatarUrl,
                  actionState: null,
                ))
            .toList(),
        title: 'Assigned Employees',
        countTextFormat:
            '${widget.shift.assignedCount}/${widget.shift.maxCapacity} assigned',
        maxVisibleAvatars: 4,
        avatarSize: 24,
        overlapOffset: 18,
        showCount: true,
        actionButtons: widget.onRemoveFromShift != null
            ? [
                UserActionButton(
                  id: 'remove',
                  label: 'Remove',
                  icon: Icons.close,
                  backgroundColor: TossColors.error,
                  textColor: TossColors.white,
                ),
              ]
            : null,
        onActionTap: (user, actionId) {
          final employee = widget.shift.assignedEmployees.firstWhere(
            (emp) => emp.id == user.id,
          );
          if (actionId == 'remove' && widget.onRemoveFromShift != null) {
            widget.onRemoveFromShift!(employee);
          }
        },
      ),
    );
  }

  /// Build applicants section
  Widget _buildApplicantsSection() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Applicants (${widget.shift.applicants.length})',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // Employee list with animation
          ...widget.shift.applicants.map(
            (employee) => TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 200),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: EmployeeActionRow(
                employee: employee,
                buttonText: 'Approve',
                buttonIcon: Icons.check,
                onTap: () => widget.onApprove?.call(employee),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build waitlist section
  Widget _buildWaitlistSection() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Waitlist (${widget.shift.waitlist.length})',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // Employee list with animation
          ...widget.shift.waitlist.map(
            (employee) => TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 200),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: EmployeeActionRow(
                employee: employee,
                buttonText: '+ Overbook',
                onTap: () => widget.onOverbook?.call(employee),
                buttonColor: TossColors.gray100,
                buttonTextColor: TossColors.gray900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build divider
  Widget _buildDivider() {
    return Container(
      height: 1,
      color: TossColors.gray200,
    );
  }
}
