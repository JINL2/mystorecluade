import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/domain/entities/company.dart';
import '../../../../core/domain/entities/store.dart';
import '../../../../core/domain/entities/subscription.dart';
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
  UserWithCompanies toEntity() {
    return UserWithCompanies(
      userId: userId,
      userFirstName: userFirstName ?? '',
      userLastName: userLastName ?? '',
      profileImage: profileImage ?? '',
      companies: companies.map((model) => model.toEntity()).toList(),
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
    SubscriptionModel? subscription,  // ✅ Company subscription plan info
    // ✅ User salary info for this company
    String? salaryType,  // hourly or monthly
    String? currencyCode,  // USD, KRW, THB, etc.
    String? currencySymbol,  // $, ₩, ฿, etc.
  }) = _CompanyModel;

  /// Create from JSON
  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  /// Convert to Domain Entity
  Company toEntity() {
    return Company(
      id: companyId,
      companyName: companyName,
      companyCode: companyCode ?? '',
      role: role?.toEntity() ?? const UserRole(roleName: 'User', permissions: []),  // ✅ Provide default role
      stores: stores.map((model) => model.toEntity(companyId)).toList(),
      subscription: subscription?.toEntity(),  // ✅ Convert subscription model to entity
      salaryType: salaryType,
      currencyCode: currencyCode,
      currencySymbol: currencySymbol,
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
      subscription: entity.subscription != null
          ? SubscriptionModel.fromDomain(entity.subscription!)
          : null,
      salaryType: entity.salaryType,
      currencyCode: entity.currencyCode,
      currencySymbol: entity.currencySymbol,
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
  Store toEntity(String companyId) {
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
  UserRole toEntity() {
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

/// Subscription Model - nested model for company subscription/plan info
@freezed
class SubscriptionModel with _$SubscriptionModel {
  const SubscriptionModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SubscriptionModel({
    required String planId,
    required String planName,
    String? displayName,
    required String planType,
    @Default(1) int maxCompanies,
    @Default(1) int maxStores,
    @Default(5) int maxEmployees,
    @Default(2) int aiDailyLimit,
    @Default(0) double priceMonthly,
    @Default([]) List<String> features,
  }) = _SubscriptionModel;

  /// Create from JSON
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);

  /// Convert to Domain Entity
  Subscription toEntity() {
    return Subscription(
      planId: planId,
      planName: planName,
      displayName: displayName ?? planName,
      planType: planType,
      maxCompanies: maxCompanies,
      maxStores: maxStores,
      maxEmployees: maxEmployees,
      aiDailyLimit: aiDailyLimit,
      priceMonthly: priceMonthly,
      features: features,
    );
  }

  /// Create from Domain Entity
  factory SubscriptionModel.fromDomain(Subscription entity) {
    return SubscriptionModel(
      planId: entity.planId,
      planName: entity.planName,
      displayName: entity.displayName,
      planType: entity.planType,
      maxCompanies: entity.maxCompanies,
      maxStores: entity.maxStores,
      maxEmployees: entity.maxEmployees,
      aiDailyLimit: entity.aiDailyLimit,
      priceMonthly: entity.priceMonthly,
      features: entity.features,
    );
  }

  /// Check if this is a free plan
  bool get isFree => planType == 'free';

  /// Check if this is a paid plan
  bool get isPaid => planType != 'free';

  /// Check if stores are unlimited (-1 means unlimited)
  bool get hasUnlimitedStores => maxStores == -1;

  /// Check if employees are unlimited (-1 means unlimited)
  bool get hasUnlimitedEmployees => maxEmployees == -1;

  /// Check if AI is unlimited (-1 means unlimited)
  bool get hasUnlimitedAI => aiDailyLimit == -1;
}
