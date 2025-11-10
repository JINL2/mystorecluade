import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_info.freezed.dart';
part 'employee_info.g.dart';

/// Employee Info Entity
///
/// Represents basic employee information for shift management.
@freezed
class EmployeeInfo with _$EmployeeInfo {
  const EmployeeInfo._();

  const factory EmployeeInfo({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_name') required String userName,
    @JsonKey(name: 'profile_image') String? profileImage,
    String? position,
    @JsonKey(name: 'hourly_wage') double? hourlyWage,
  }) = _EmployeeInfo;

  /// Create from JSON
  factory EmployeeInfo.fromJson(Map<String, dynamic> json) =>
      _$EmployeeInfoFromJson(json);

  /// Check if employee has profile image
  bool get hasProfileImage =>
      profileImage != null && profileImage!.isNotEmpty;

  /// Get display name with position
  String get displayName {
    if (position != null && position!.isNotEmpty) {
      return '$userName ($position)';
    }
    return userName;
  }
}
