import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/toss_theme.dart';
import '../../../../../providers/auth_state_provider.dart';

/// Individual shift card widget
class ShiftCardWidget extends ConsumerWidget {
  final Map<String, dynamic> shift;
  final DateTime selectedDate;
  final List<dynamic>? monthlyShiftStatus;
  final String? selectedShift;
  final Function(String shiftId, bool userHasRegistered) onShiftClick;

  const ShiftCardWidget({
    super.key,
    required this.shift,
    required this.selectedDate,
    required this.monthlyShiftStatus,
    required this.selectedShift,
    required this.onShiftClick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftData = _extractShiftData();
    final employeeData = _extractEmployeeData();
    final userRegistrationStatus = _getUserRegistrationStatus(ref, employeeData);

    return GestureDetector(
      onTap: () => onShiftClick(shiftData.id, userRegistrationStatus.hasRegistered),
      child: _buildCardContainer(shiftData, employeeData, userRegistrationStatus),
    );
  }

  _ShiftData _extractShiftData() {
    final shiftId = shift['shift_id'] ?? shift['id'] ?? shift['store_shift_id'];
    final shiftIdStr = shiftId?.toString() ?? '';
    final shiftName = shift['shift_name'] ?? shift['name'] ?? shift['shift_type'] ?? 'Shift ${shiftId ?? ""}';
    final startTime = shift['start_time'] ?? shift['shift_start_time'] ?? shift['default_start_time'] ?? '--:--';
    final endTime = shift['end_time'] ?? shift['shift_end_time'] ?? shift['default_end_time'] ?? '--:--';

    return _ShiftData(
      id: shiftIdStr,
      name: shiftName.toString(),
      startTime: startTime.toString(),
      endTime: endTime.toString(),
      rawId: shiftId,
    );
  }

  _EmployeeData _extractEmployeeData() {
    List<Map<String, dynamic>> pendingEmployees = [];
    List<Map<String, dynamic>> approvedEmployees = [];

    final dateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    if (monthlyShiftStatus != null && monthlyShiftStatus!.isNotEmpty) {
      for (final dayData in monthlyShiftStatus!) {
        if (dayData['request_date'] == dateStr) {
          final shifts = dayData['shifts'] as List? ?? [];

          for (final shiftData in shifts) {
            if (shiftData['shift_id'].toString() == shift['shift_id']?.toString() ||
                shiftData['shift_id'].toString() == shift['id']?.toString() ||
                shiftData['shift_id'].toString() == shift['store_shift_id']?.toString()) {
              if (shiftData['pending_employees'] != null) {
                final pending = shiftData['pending_employees'] as List;
                pendingEmployees = List<Map<String, dynamic>>.from(
                  pending.map((e) => Map<String, dynamic>.from(e as Map)),
                );
              }

              if (shiftData['approved_employees'] != null) {
                final approved = shiftData['approved_employees'] as List;
                approvedEmployees = List<Map<String, dynamic>>.from(
                  approved.map((e) => Map<String, dynamic>.from(e as Map)),
                );
              }
              break;
            }
          }
          break;
        }
      }
    }

    return _EmployeeData(
      pending: pendingEmployees,
      approved: approvedEmployees,
    );
  }

  _UserRegistrationStatus _getUserRegistrationStatus(WidgetRef ref, _EmployeeData employeeData) {
    final authStateAsync = ref.read(authStateProvider);
    final user = authStateAsync.value;
    bool hasRegistered = false;
    bool isPending = false;

    if (user != null) {
      for (final emp in employeeData.pending) {
        if (emp['user_id'] == user.id) {
          hasRegistered = true;
          isPending = true;
          break;
        }
      }

      if (!hasRegistered) {
        for (final emp in employeeData.approved) {
          if (emp['user_id'] == user.id) {
            hasRegistered = true;
            isPending = false;
            break;
          }
        }
      }
    }

    return _UserRegistrationStatus(
      hasRegistered: hasRegistered,
      isPending: isPending,
    );
  }

  Widget _buildCardContainer(
    _ShiftData shiftData,
    _EmployeeData employeeData,
    _UserRegistrationStatus userStatus,
  ) {
    final hasAnyRegistrations = employeeData.pending.isNotEmpty || employeeData.approved.isNotEmpty;
    final isSelected = selectedShift == shiftData.id;

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: _getCardColor(isSelected, userStatus, hasAnyRegistrations),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: _getBorderColor(isSelected, userStatus, hasAnyRegistrations),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(shiftData, isSelected, userStatus, hasAnyRegistrations, employeeData),
          const SizedBox(height: TossSpacing.space3),
          _buildTimeDisplay(shiftData),
          if (employeeData.approved.isNotEmpty || employeeData.pending.isNotEmpty)
            _buildEmployeeList(employeeData),
          if (employeeData.pending.isEmpty && employeeData.approved.isEmpty && !isSelected)
            _buildNoEmployeesMessage(),
          if (isSelected)
            _buildSelectedMessage(),
        ],
      ),
    );
  }

  Color _getCardColor(bool isSelected, _UserRegistrationStatus userStatus, bool hasAnyRegistrations) {
    if (isSelected) return TossColors.primary.withOpacity(0.08);
    if (userStatus.isPending) return TossColors.warning.withOpacity(0.08);
    if (userStatus.hasRegistered && !userStatus.isPending) return TossColors.success.withOpacity(0.08);
    if (hasAnyRegistrations) return TossColors.gray50;
    return TossColors.background;
  }

  Color _getBorderColor(bool isSelected, _UserRegistrationStatus userStatus, bool hasAnyRegistrations) {
    if (isSelected) return TossColors.primary;
    if (userStatus.isPending) return TossColors.warning.withOpacity(0.3);
    if (userStatus.hasRegistered && !userStatus.isPending) return TossColors.success.withOpacity(0.3);
    if (hasAnyRegistrations) return TossColors.gray300;
    return TossColors.gray200;
  }

  Widget _buildCardHeader(
    _ShiftData shiftData,
    bool isSelected,
    _UserRegistrationStatus userStatus,
    bool hasAnyRegistrations,
    _EmployeeData employeeData,
  ) {
    return Row(
      children: [
        _buildRadioButton(isSelected),
        const SizedBox(width: TossSpacing.space3),
        _buildClockIcon(hasAnyRegistrations),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: Text(
            shiftData.name,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (hasAnyRegistrations)
          _buildStatusBadge(userStatus, employeeData),
      ],
    );
  }

  Widget _buildRadioButton(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? TossColors.primary : TossColors.gray400,
          width: isSelected ? 2 : 1.5,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: TossColors.primary,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildClockIcon(bool hasAnyRegistrations) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Icon(
        Icons.access_time,
        size: 18,
        color: hasAnyRegistrations ? TossColors.primary : TossColors.gray600,
      ),
    );
  }

  Widget _buildStatusBadge(_UserRegistrationStatus userStatus, _EmployeeData employeeData) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getStatusBadgeColor(userStatus),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Text(
        _getStatusBadgeText(userStatus, employeeData),
        style: TossTextStyles.caption.copyWith(
          color: _getStatusBadgeTextColor(userStatus),
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Color _getStatusBadgeColor(_UserRegistrationStatus userStatus) {
    if (userStatus.hasRegistered && !userStatus.isPending) {
      return TossColors.success.withOpacity(0.1);
    }
    if (userStatus.isPending) {
      return TossColors.warning.withOpacity(0.1);
    }
    return TossColors.gray100;
  }

  String _getStatusBadgeText(_UserRegistrationStatus userStatus, _EmployeeData employeeData) {
    if (userStatus.hasRegistered && !userStatus.isPending) return 'Approved';
    if (userStatus.isPending) return 'Pending';
    return '${employeeData.approved.length + employeeData.pending.length} registered';
  }

  Color _getStatusBadgeTextColor(_UserRegistrationStatus userStatus) {
    if (userStatus.hasRegistered && !userStatus.isPending) return TossColors.success;
    if (userStatus.isPending) return TossColors.warning;
    return TossColors.gray700;
  }

  Widget _buildTimeDisplay(_ShiftData shiftData) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule_outlined,
            size: 14,
            color: TossColors.gray600,
          ),
          const SizedBox(width: TossSpacing.space1),
          Text(
            '${shiftData.startTime} - ${shiftData.endTime}',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList(_EmployeeData employeeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space2),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...employeeData.approved.map((employee) => _buildEmployeeRow(employee, isApproved: true)),
              ...employeeData.pending.map((employee) => _buildEmployeeRow(employee, isApproved: false)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeRow(Map<String, dynamic> employee, {required bool isApproved}) {
    final statusColor = isApproved ? TossColors.success : TossColors.warning;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          _buildEmployeeAvatar(employee, statusColor),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              (employee['user_name'] ?? 'Unknown').toString(),
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            isApproved ? 'Approved' : 'Pending',
            style: TossTextStyles.caption.copyWith(
              color: isApproved ? TossColors.success : TossColors.error,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeAvatar(Map<String, dynamic> employee, Color statusColor) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: employee['profile_image'] != null && employee['profile_image'].toString().isNotEmpty
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: employee['profile_image'].toString(),
                width: 32,
                height: 32,
                fit: BoxFit.contain,
                memCacheWidth: 64,
                memCacheHeight: 64,
                placeholder: (context, url) => _buildAvatarPlaceholder(statusColor),
                errorWidget: (context, url, error) => Icon(
                  Icons.person_outline,
                  size: 16,
                  color: statusColor,
                ),
              ),
            )
          : Icon(
              Icons.person_outline,
              size: 16,
              color: statusColor,
            ),
    );
  }

  Widget _buildAvatarPlaceholder(Color statusColor) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.person_outline,
          size: 16,
          color: statusColor,
        ),
      ),
    );
  }

  Widget _buildNoEmployeesMessage() {
    return Column(
      children: [
        const SizedBox(height: TossSpacing.space3),
        Text(
          'No employees registered for this shift',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedMessage() {
    return Column(
      children: [
        const SizedBox(height: TossSpacing.space3),
        Text(
          'Selected - Tap to deselect',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ShiftData {
  final String id;
  final String name;
  final String startTime;
  final String endTime;
  final dynamic rawId;

  _ShiftData({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.rawId,
  });
}

class _EmployeeData {
  final List<Map<String, dynamic>> pending;
  final List<Map<String, dynamic>> approved;

  _EmployeeData({
    required this.pending,
    required this.approved,
  });
}

class _UserRegistrationStatus {
  final bool hasRegistered;
  final bool isPending;

  _UserRegistrationStatus({
    required this.hasRegistered,
    required this.isPending,
  });
}
