import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_party_models.freezed.dart';
part 'counter_party_models.g.dart';

// Helper function to convert type from JSON
CounterPartyType _typeFromJson(dynamic value) {
  if (value == null) return CounterPartyType.other;
  
  // Handle both uppercase and lowercase variations
  final normalizedValue = value.toString();
  
  switch (normalizedValue) {
    case 'My Company':
    case 'my company':
    case 'myCompany':
      return CounterPartyType.myCompany;
    case 'Team Member':
    case 'team member':
    case 'teamMember':
      return CounterPartyType.teamMember;
    case 'Suppliers':
    case 'suppliers':
    case 'supplier':
      return CounterPartyType.supplier;
    case 'Employees':
    case 'employees':
    case 'employee':
      return CounterPartyType.employee;
    case 'Customers':
    case 'customers':
    case 'customer':
      return CounterPartyType.customer;
    case 'Others':
    case 'others':
    case 'other':
    default:
      return CounterPartyType.other;
  }
}

// Helper function to convert type to JSON (for database)
String _typeToJson(CounterPartyType type) {
  return type.displayName;
}

// Counter Party Type Enum
enum CounterPartyType {
  @JsonValue('My Company')
  myCompany('My Company', 'Internal company within the group'),
  
  @JsonValue('Team Member')
  teamMember('Team Member', 'Internal team member'),
  
  @JsonValue('Suppliers')
  supplier('Suppliers', 'External supplier or vendor'),
  
  @JsonValue('Employees')
  employee('Employees', 'Company employee'),
  
  @JsonValue('Customers')
  customer('Customers', 'External customer or client'),
  
  @JsonValue('Others')
  other('Others', 'Other type of counterparty');

  final String displayName;
  final String description;

  const CounterPartyType(this.displayName, this.description);
}

// Main Counter Party Model
@freezed
class CounterParty with _$CounterParty {
  const CounterParty._();
  
  const factory CounterParty({
    @JsonKey(name: 'counterparty_id') required String counterpartyId,
    @JsonKey(name: 'company_id') required String companyId,
    required String name,
    @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson) required CounterPartyType type,
    String? email,
    String? phone,
    String? address,
    String? notes,
    @JsonKey(name: 'is_internal') @Default(false) bool isInternal,
    @JsonKey(name: 'linked_company_id') String? linkedCompanyId,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at', includeIfNull: false) DateTime? updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
    // Additional fields for enhanced functionality
    @JsonKey(name: 'last_transaction_date') DateTime? lastTransactionDate,
    @JsonKey(name: 'total_transactions') @Default(0) int totalTransactions,
    @JsonKey(name: 'balance') @Default(0.0) double balance,
  }) = _CounterParty;

  factory CounterParty.fromJson(Map<String, dynamic> json) =>
      _$CounterPartyFromJson(json);
}

// Counter Party Statistics Model
@freezed
class CounterPartyStats with _$CounterPartyStats {
  const factory CounterPartyStats({
    required int total,
    required int suppliers,
    required int customers,
    required int employees,
    required int teamMembers,
    required int myCompanies,
    required int others,
    required int activeCount,
    required int inactiveCount,
    @JsonKey(name: 'recent_additions') required List<CounterParty> recentAdditions,
  }) = _CounterPartyStats;

  factory CounterPartyStats.fromJson(Map<String, dynamic> json) =>
      _$CounterPartyStatsFromJson(json);

  factory CounterPartyStats.empty() => const CounterPartyStats(
    total: 0,
    suppliers: 0,
    customers: 0,
    employees: 0,
    teamMembers: 0,
    myCompanies: 0,
    others: 0,
    activeCount: 0,
    inactiveCount: 0,
    recentAdditions: [],
  );
}

// Form Data Model for Creating/Editing
@freezed
class CounterPartyFormData with _$CounterPartyFormData {
  const factory CounterPartyFormData({
    String? counterpartyId,
    required String companyId,
    @Default('') String name,
    @Default(CounterPartyType.other) CounterPartyType type,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String address,
    @Default('') String notes,
    @Default(false) bool isInternal,
    String? linkedCompanyId,
  }) = _CounterPartyFormData;

  factory CounterPartyFormData.fromJson(Map<String, dynamic> json) =>
      _$CounterPartyFormDataFromJson(json);

  factory CounterPartyFormData.fromCounterParty(CounterParty counterParty) {
    return CounterPartyFormData(
      counterpartyId: counterParty.counterpartyId,
      companyId: counterParty.companyId,
      name: counterParty.name,
      type: counterParty.type,
      email: counterParty.email ?? '',
      phone: counterParty.phone ?? '',
      address: counterParty.address ?? '',
      notes: counterParty.notes ?? '',
      isInternal: counterParty.isInternal,
      linkedCompanyId: counterParty.linkedCompanyId,
    );
  }
}

// Filter Options Model
@freezed
class CounterPartyFilter with _$CounterPartyFilter {
  const factory CounterPartyFilter({
    String? searchQuery,
    List<CounterPartyType>? types,
    @Default(CounterPartySortOption.isInternal) CounterPartySortOption sortBy,
    @Default(false) bool ascending,
    bool? isInternal,
    DateTime? createdAfter,
    DateTime? createdBefore,
    @Default(true) bool includeDeleted,
  }) = _CounterPartyFilter;

  factory CounterPartyFilter.fromJson(Map<String, dynamic> json) =>
      _$CounterPartyFilterFromJson(json);
}

// Sort Options
enum CounterPartySortOption {
  name('Name'),
  type('Type'),
  createdAt('Created Date'),
  isInternal('Internal/External');

  final String displayName;
  const CounterPartySortOption(this.displayName);
}

// Validation Result
@freezed
class ValidationResult with _$ValidationResult {
  const factory ValidationResult({
    required bool isValid,
    Map<String, String>? errors,
  }) = _ValidationResult;

  factory ValidationResult.valid() => const ValidationResult(
    isValid: true,
    errors: null,
  );

  factory ValidationResult.invalid(Map<String, String> errors) => ValidationResult(
    isValid: false,
    errors: errors,
  );
}

// API Response Models
@freezed
class CounterPartyResponse with _$CounterPartyResponse {
  const factory CounterPartyResponse.success({
    required CounterParty data,
    String? message,
  }) = CounterPartyResponseSuccess;

  const factory CounterPartyResponse.error({
    required String message,
    String? code,
  }) = CounterPartyResponseError;

  factory CounterPartyResponse.fromJson(Map<String, dynamic> json) =>
      _$CounterPartyResponseFromJson(json);
}

// Batch Operation Result
@freezed
class BatchOperationResult with _$BatchOperationResult {
  const factory BatchOperationResult({
    required int totalCount,
    required int successCount,
    required int failureCount,
    required List<String> failedIds,
    String? message,
  }) = _BatchOperationResult;

  factory BatchOperationResult.fromJson(Map<String, dynamic> json) =>
      _$BatchOperationResultFromJson(json);
}