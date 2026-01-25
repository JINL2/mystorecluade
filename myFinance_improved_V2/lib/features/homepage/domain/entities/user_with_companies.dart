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
    this.totalStoreCount = 0,
    this.totalEmployeeCount = 0,
    this.ownedCompanyCount,
  });

  final String userId;
  final String userFirstName;
  final String userLastName;
  final List<Company> companies;
  final String profileImage;
  /// Total store count across all companies (from RPC)
  final int totalStoreCount;
  /// Total employee count across all companies (from RPC)
  final int totalEmployeeCount;
  /// Owned company count from RPC (only companies where user is Owner)
  /// Used for subscription limit checking
  /// null means not yet loaded from RPC
  final int? ownedCompanyCount;

  /// Total company count (all companies user has access to)
  int get totalCompanyCount => companies.length;

  /// Company count for subscription limit (owned companies only)
  /// Falls back to totalCompanyCount if ownedCompanyCount not available
  int get companyCount => ownedCompanyCount ?? companies.length;

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

  // ============================================
  // Mock Factory (for skeleton loading)
  // ============================================

  static UserWithCompanies mock() => UserWithCompanies(
        userId: 'mock-user-id',
        userFirstName: 'Mock',
        userLastName: 'User',
        companies: Company.mockList(2),
        profileImage: '',
      );
}
