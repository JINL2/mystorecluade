import 'package:freezed_annotation/freezed_annotation.dart';

part 'delegatable_role.freezed.dart';

@freezed
class DelegatableRole with _$DelegatableRole {
  const factory DelegatableRole({
    required String roleId,
    required String roleName,
    required String description,
    required List<String> permissions,
    required bool canDelegate,
  }) = _DelegatableRole;
}
