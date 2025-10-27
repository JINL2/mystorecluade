import '../../domain/entities/employee_info.dart';

/// Employee Info Model (DTO + Mapper)
///
/// Data Transfer Object for EmployeeInfo entity with JSON serialization.
class EmployeeInfoModel {
  final String userId;
  final String userName;
  final String? profileImage;
  final String? position;
  final double? hourlyWage;

  const EmployeeInfoModel({
    required this.userId,
    required this.userName,
    this.profileImage,
    this.position,
    this.hourlyWage,
  });

  /// Create from JSON
  factory EmployeeInfoModel.fromJson(Map<String, dynamic> json) {
    return EmployeeInfoModel(
      userId: json['user_id'] as String? ?? '',
      userName: json['user_name'] as String? ?? '',
      profileImage: json['profile_image'] as String?,
      position: json['position'] as String?,
      hourlyWage: (json['hourly_wage'] as num?)?.toDouble(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      if (profileImage != null) 'profile_image': profileImage,
      if (position != null) 'position': position,
      if (hourlyWage != null) 'hourly_wage': hourlyWage,
    };
  }

  /// Map to Domain Entity
  EmployeeInfo toEntity() {
    return EmployeeInfo(
      userId: userId,
      userName: userName,
      profileImage: profileImage,
      position: position,
      hourlyWage: hourlyWage,
    );
  }

  /// Create from Domain Entity
  factory EmployeeInfoModel.fromEntity(EmployeeInfo entity) {
    return EmployeeInfoModel(
      userId: entity.userId,
      userName: entity.userName,
      profileImage: entity.profileImage,
      position: entity.position,
      hourlyWage: entity.hourlyWage,
    );
  }
}
