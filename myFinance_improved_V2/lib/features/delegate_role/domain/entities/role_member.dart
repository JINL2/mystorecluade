import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_member.freezed.dart';

/// RoleMember domain entity
/// Represents a user assigned to a role
@freezed
class RoleMember with _$RoleMember {
  const RoleMember._();

  const factory RoleMember({
    required String userId,
    required String name,
    required String email,
    DateTime? assignedAt,
  }) = _RoleMember;

  // Business logic methods
  bool get hasValidEmail => email.isNotEmpty && email != 'No email';
  bool get hasAssignmentDate => assignedAt != null;
}
