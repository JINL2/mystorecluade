/// Employee Info Entity
///
/// Represents basic employee information for shift management.
class EmployeeInfo {
  final String userId;
  final String userName;
  final String? profileImage;
  final String? position;
  final double? hourlyWage;

  const EmployeeInfo({
    required this.userId,
    required this.userName,
    this.profileImage,
    this.position,
    this.hourlyWage,
  });

  /// Check if employee has profile image
  bool get hasProfileImage => profileImage != null && profileImage!.isNotEmpty;

  /// Get display name with position
  String get displayName {
    if (position != null && position!.isNotEmpty) {
      return '$userName ($position)';
    }
    return userName;
  }

  /// Copy with method for immutability
  EmployeeInfo copyWith({
    String? userId,
    String? userName,
    String? profileImage,
    String? position,
    double? hourlyWage,
  }) {
    return EmployeeInfo(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      profileImage: profileImage ?? this.profileImage,
      position: position ?? this.position,
      hourlyWage: hourlyWage ?? this.hourlyWage,
    );
  }

  @override
  String toString() => 'EmployeeInfo(id: $userId, name: $userName)';
}
