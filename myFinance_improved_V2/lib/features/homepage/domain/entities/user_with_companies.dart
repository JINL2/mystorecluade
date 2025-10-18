import '../../../../core/domain/entities/company.dart';

/// User data with associated companies
///
/// Represents a user and their companies/stores from the database.
/// Used for company/store selection on homepage.
class UserWithCompanies {
  const UserWithCompanies({
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.companies,
    required this.profileImage,
  });

  final String userId;
  final String userFirstName;
  final String userLastName;
  final List<Company> companies;
  final String profileImage;

  /// Calculate total company count (computed property)
  int get companyCount => companies.length;

  /// Get full name
  String get fullName => '$userFirstName $userLastName'.trim();

  /// Check if user has any companies
  bool get hasCompanies => companies.isNotEmpty;

  /// Get first company (if exists)
  Company? get firstCompany => companies.isNotEmpty ? companies.first : null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserWithCompanies &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          userFirstName == other.userFirstName &&
          userLastName == other.userLastName &&
          profileImage == other.profileImage;

  @override
  int get hashCode =>
      userId.hashCode ^
      userFirstName.hashCode ^
      userLastName.hashCode ^
      profileImage.hashCode;

  @override
  String toString() {
    return 'UserWithCompanies(userId: $userId, name: $fullName, '
        'companies: ${companies.length})';
  }
}
