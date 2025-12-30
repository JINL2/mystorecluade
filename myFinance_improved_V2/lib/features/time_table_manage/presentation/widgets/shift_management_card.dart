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
      child: _AssignedEmployeesStack(
        shift: widget.shift,
        onRemoveFromShift: widget.onRemoveFromShift,
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

/// Stateful wrapper for assigned employees stack
/// This allows the bottom sheet to properly update when employees are removed
class _AssignedEmployeesStack extends StatefulWidget {
  final ShiftData shift;
  final Function(Employee)? onRemoveFromShift;

  const _AssignedEmployeesStack({
    required this.shift,
    this.onRemoveFromShift,
  });

  @override
  State<_AssignedEmployeesStack> createState() => _AssignedEmployeesStackState();
}

class _AssignedEmployeesStackState extends State<_AssignedEmployeesStack> {
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            decoration: const BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(TossBorderRadius.xl),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  decoration: BoxDecoration(
                    color: TossColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Text(
                  'Assigned Employees',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Divider(height: 1, thickness: 1, color: TossColors.gray100),
                ),
                const SizedBox(height: 8),
                // Employee list
                Flexible(
                  child: Builder(
                    builder: (context) {
                      // Get the current employee list (this will be fresh after state updates)
                      final currentEmployees = widget.shift.assignedEmployees;

                      if (currentEmployees.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(TossSpacing.space10),
                            child: Text(
                              'No assigned employees',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: currentEmployees.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          thickness: 1,
                          color: TossColors.gray50,
                          indent: 68,
                        ),
                        itemBuilder: (context, index) {
                          final employee = currentEmployees[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: TossColors.gray200,
                              backgroundImage: NetworkImage(employee.avatarUrl),
                              onBackgroundImageError: (_, __) {},
                            ),
                            const SizedBox(width: 12),
                            // Name
                            Expanded(
                              child: Text(
                                employee.name,
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Remove button
                            GestureDetector(
                              onTap: () async {
                                if (widget.onRemoveFromShift != null) {
                                  widget.onRemoveFromShift!(employee);
                                  // Wait for parent to process the state change
                                  await Future.delayed(const Duration(milliseconds: 10));
                                  // Rebuild the bottom sheet with updated data
                                  if (context.mounted) {
                                    setSheetState(() {});
                                  }
                                }
                              },
                              child: Container(
                                height: 32,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: TossColors.gray100,
                                  borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                                  border: Border.all(color: TossColors.gray200, width: 1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: TossColors.gray700,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Remove',
                                      style: TossTextStyles.labelSmall.copyWith(
                                        color: TossColors.gray700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employees = widget.shift.assignedEmployees;

    return GestureDetector(
      onTap: _showBottomSheet,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar stack
          if (employees.isNotEmpty) _buildAvatarStack(employees),

          // Count text
          if (employees.isNotEmpty) const SizedBox(width: 8),
          Text(
            '${widget.shift.assignedCount}/${widget.shift.maxCapacity} assigned',
            style: TossTextStyles.labelSmall.copyWith(
              color: TossColors.gray600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Build the avatar stack manually
  Widget _buildAvatarStack(List<Employee> employees) {
    const maxVisible = 4;
    const avatarSize = 24.0;
    const overlapOffset = 18.0;

    final displayCount = employees.length.clamp(0, maxVisible);
    final hasMore = employees.length > maxVisible;

    return SizedBox(
      height: avatarSize,
      width: (displayCount * overlapOffset) + (avatarSize - overlapOffset) + (hasMore ? overlapOffset : 0),
      child: Stack(
        children: [
          // Avatar circles
          ...List.generate(
            displayCount,
            (index) => Positioned(
              left: index * overlapOffset,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: TossColors.white, width: 1),
                ),
                child: CircleAvatar(
                  radius: avatarSize / 2,
                  backgroundColor: TossColors.gray200,
                  backgroundImage: NetworkImage(employees[index].avatarUrl),
                  onBackgroundImageError: (_, __) {},
                ),
              ),
            ),
          ),

          // "+N more" indicator
          if (hasMore)
            Positioned(
              left: displayCount * overlapOffset,
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: TossColors.gray700,
                  border: Border.all(color: TossColors.white, width: 1),
                ),
                child: Center(
                  child: Text(
                    '+${employees.length - maxVisible}',
                    style: TossTextStyles.labelSmall.copyWith(
                      color: TossColors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
