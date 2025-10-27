import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_delegation.freezed.dart';

@freezed
class RoleDelegation with _$RoleDelegation {
  const RoleDelegation._();

  const factory RoleDelegation({
    required String id,
    required String delegatorId,
    required String delegateId,
    required String companyId,
    required String roleId,
    required String roleName,
    required Map<String, dynamic> delegateUser,
    required List<String> permissions,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RoleDelegation;

  // Business logic methods
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isActiveNow => isActive && !isExpired;

  String get delegateUserName => (delegateUser['name'] as String?) ?? 'Unknown';
  String get delegateUserEmail => (delegateUser['email'] as String?) ?? '';
  String get delegateUserInitial {
    final name = delegateUserName;
    return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';
  }

  int get daysRemaining {
    if (isExpired) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }
}
