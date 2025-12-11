/// Mapper for converting between UserWithCompanies Entity and Map
///
/// This mapper handles bidirectional conversion between:
/// - Domain Entity (UserWithCompanies, Company, Store)
/// - Map<String, dynamic> (for AppState compatibility)
library;

import '../../../../core/domain/entities/company.dart';
import '../../../../core/domain/entities/store.dart';
import '../entities/user_with_companies.dart';

/// Convert UserWithCompanies entity to Map for AppState
///
/// Used for backward compatibility with global AppState
Map<String, dynamic> convertUserEntityToMap(UserWithCompanies entity) {
  return {
    'user_id': entity.userId,
    'user_first_name': entity.userFirstName,
    'user_last_name': entity.userLastName,
    'profile_image': entity.profileImage,
    'companies': entity.companies
        .map((company) => convertCompanyToMap(company))
        .toList(),
  };
}

/// Convert Company entity to Map
Map<String, dynamic> convertCompanyToMap(Company company) {
  return {
    'company_id': company.id,
    'company_name': company.companyName,
    'company_code': company.companyCode,
    'stores': company.stores
        .map((store) => convertStoreToMap(store))
        .toList(),
    'role': {
      'role_name': company.role.roleName,
      'permissions': company.role.permissions,
    },
    if (company.subscription != null)
      'subscription': company.subscription!.toMap(),
  };
}

/// Convert Store entity to Map
Map<String, dynamic> convertStoreToMap(Store store) {
  return {
    'store_id': store.id,
    'store_name': store.storeName,
    'store_code': store.storeCode,
  };
}

/// Convert Map to UserWithCompanies entity
///
/// Used for converting AppState Map back to Entity
UserWithCompanies convertMapToUserEntity(Map<String, dynamic> map) {
  return UserWithCompanies(
    userId: map['user_id'] as String,
    userFirstName: map['user_first_name'] as String,
    userLastName: map['user_last_name'] as String,
    profileImage: map['profile_image'] as String,
    companies: (map['companies'] as List<dynamic>)
        .map((c) => Company.fromMap(c as Map<String, dynamic>))
        .toList(),
  );
}

