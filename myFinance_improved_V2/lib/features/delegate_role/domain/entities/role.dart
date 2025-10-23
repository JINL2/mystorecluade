import 'package:freezed_annotation/freezed_annotation.dart';

part 'role.freezed.dart';

@freezed
class Role with _$Role {
  const Role._();

  const factory Role({
    required String roleId,
    required String companyId,
    required String roleName,
    String? description,
    required String roleType,
    required List<String> tags,
    required List<String> permissions,
    required int memberCount,
    required bool canEdit,
    required bool canDelegate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Role;

  // Business logic methods
  bool get isOwnerRole => roleName.toLowerCase() == 'owner';
  bool get isCustomRole => roleType == 'custom';
  bool get hasMembers => memberCount > 0;
  bool get hasPermissions => permissions.isNotEmpty;
  bool get hasTags => tags.isNotEmpty;
}
