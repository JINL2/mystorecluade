import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/domain/entities/company.dart';
import '../../../../core/domain/entities/store.dart';
import '../../domain/entities/user_with_companies.dart';

part 'user_companies_model.freezed.dart';
part 'user_companies_model.g.dart';

/// User Companies Model - handles JSON serialization and domain conversion
///
/// Consolidates DTO and Mapper responsibilities:
/// - JSON serialization (via freezed + json_serializable)
/// - Conversion to/from domain entities
/// - Maps Supabase RPC response to domain UserWithCompanies entity
@freezed
class UserCompaniesModel with _$UserCompaniesModel {
  const UserCompaniesModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserCompaniesModel({
    required String userId,
    String? userFirstName,
    String? userLastName,
    String? profileImage,
    int? companyCount,
    required List<CompanyModel> companies,
  }) = _UserCompaniesModel;

  /// Create from JSON (Supabase RPC response)
  factory UserCompaniesModel.fromJson(Map<String, dynamic> json) =>
      _$UserCompaniesModelFromJson(json);

  /// Convert Model to Domain Entity
  UserWithCompanies toDomain() {
    return UserWithCompanies(
      userId: userId,
      userFirstName: userFirstName ?? '',
      userLastName: userLastName ?? '',
      profileImage: profileImage ?? '',
      companies: companies.map((model) => model.toDomain()).toList(),
    );
  }

  /// Create Model from Domain Entity
  factory UserCompaniesModel.fromDomain(UserWithCompanies entity) {
    return UserCompaniesModel(
      userId: entity.userId,
      userFirstName: entity.userFirstName,
      userLastName: entity.userLastName,
      profileImage: entity.profileImage,
      companies: entity.companies.map((c) => CompanyModel.fromDomain(c)).toList(),
    );
  }
}

/// Company Model - nested model with stores and role
@freezed
class CompanyModel with _$CompanyModel {
  const CompanyModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CompanyModel({
    required String companyId,
    required String companyName,
    String? companyCode,
    int? storeCount,
    RoleModel? role,  // ✅ Make nullable - some companies may not have role data
    @Default([]) List<StoreModel> stores,  // ✅ Provide default empty list
  }) = _CompanyModel;

  /// Create from JSON
  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  /// Convert to Domain Entity
  Company toDomain() {
    return Company(
      id: companyId,
      companyName: companyName,
      companyCode: companyCode ?? '',
      role: role?.toDomain() ?? UserRole(roleName: 'User', permissions: []),  // ✅ Provide default role
      stores: stores.map((model) => model.toDomain(companyId)).toList(),
    );
  }

  /// Create from Domain Entity
  factory CompanyModel.fromDomain(Company entity) {
    return CompanyModel(
      companyId: entity.id,
      companyName: entity.companyName,
      companyCode: entity.companyCode,
      role: RoleModel.fromDomain(entity.role),
      stores: entity.stores.map((s) => StoreModel.fromDomain(s)).toList(),
    );
  }
}

/// Store Model - nested model
@freezed
class StoreModel with _$StoreModel {
  const StoreModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory StoreModel({
    required String storeId,
    required String storeName,
    String? storeCode,
    String? storePhone,
  }) = _StoreModel;

  /// Create from JSON
  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);

  /// Convert to Domain Entity (requires companyId from parent)
  Store toDomain(String companyId) {
    return Store(
      id: storeId,
      storeName: storeName,
      storeCode: storeCode ?? '',
      companyId: companyId,
    );
  }

  /// Create from Domain Entity
  factory StoreModel.fromDomain(Store entity) {
    return StoreModel(
      storeId: entity.id,
      storeName: entity.storeName,
      storeCode: entity.storeCode,
    );
  }
}

/// Role Model - nested model for user permissions
@freezed
class RoleModel with _$RoleModel {
  const RoleModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RoleModel({
    String? roleId,
    required String roleName,
    required List<String> permissions,
  }) = _RoleModel;

  /// Create from JSON
  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  /// Convert to Domain Entity
  UserRole toDomain() {
    return UserRole(
      roleName: roleName,
      permissions: permissions,
    );
  }

  /// Create from Domain Entity
  factory RoleModel.fromDomain(UserRole entity) {
    return RoleModel(
      roleName: entity.roleName,
      permissions: entity.permissions,
    );
  }
}
