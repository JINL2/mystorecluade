// =====================================================
// SELECTOR ENTITY DATA MODELS
// Autonomous data models for selector widgets
// =====================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'selector_entities.freezed.dart';
part 'selector_entities.g.dart';

// =====================================================
// BASE SELECTOR ENTITY
// =====================================================
@freezed
class SelectorEntity with _$SelectorEntity {
  const factory SelectorEntity({
    required String id,
    required String name,
    String? type,
    @Default(0) int transactionCount,
    Map<String, dynamic>? additionalData,
  }) = _SelectorEntity;

  factory SelectorEntity.fromJson(Map<String, dynamic> json) =>
      _$SelectorEntityFromJson(json);
}

// =====================================================
// ACCOUNT DATA MODEL
// =====================================================
@freezed
class AccountData with _$AccountData {
  const factory AccountData({
    required String id,
    required String name,
    required String type, // asset, liability, equity, income, expense
    String? categoryTag,
    String? expenseNature, // fixed, variable
    String? accountCode, // Account code (e.g., 5000-9999 for expense accounts)
    @Default(0) int transactionCount,
    Map<String, dynamic>? additionalData,
  }) = _AccountData;

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);

  // Helper methods
  const AccountData._();
  
  String get displayName => name;
  
  String get subtitle {
    final parts = <String>[];
    if (type.isNotEmpty) parts.add(type.toUpperCase());
    if (categoryTag != null) parts.add(categoryTag!);
    if (transactionCount > 0) parts.add('$transactionCount transactions');
    return parts.join(' • ');
  }
  
  bool get isAsset => type.toLowerCase() == 'asset';
  bool get isLiability => type.toLowerCase() == 'liability';
  bool get isEquity => type.toLowerCase() == 'equity';
  bool get isIncome => type.toLowerCase() == 'income';
  bool get isExpense => type.toLowerCase() == 'expense';

  // Category tag helpers
  bool get requiresCounterparty =>
      categoryTag?.toLowerCase() == 'payable' ||
      categoryTag?.toLowerCase() == 'receivable';
  bool get isCash => categoryTag?.toLowerCase() == 'cash';
  bool get isPayable => categoryTag?.toLowerCase() == 'payable';
  bool get isReceivable => categoryTag?.toLowerCase() == 'receivable';

  /// Check if account is an expense account based on account_code (5000-9999)
  /// Returns false if accountCode is null (legacy data compatibility)
  bool get isExpenseByCode {
    if (accountCode == null || accountCode!.isEmpty) return false;
    final code = int.tryParse(accountCode!);
    if (code == null) return false;
    return code >= 5000 && code <= 9999;
  }
}

// =====================================================
// QUICK ACCESS ACCOUNT DATA MODEL
// =====================================================
@freezed
class QuickAccessAccount with _$QuickAccessAccount {
  const factory QuickAccessAccount({
    @JsonKey(name: 'account_id')
    required String accountId,
    @JsonKey(name: 'account_name')
    required String accountName,
    @JsonKey(name: 'account_type')
    required String accountType,
    @JsonKey(name: 'usage_count')
    required int usageCount,
    @JsonKey(name: 'last_used')
    required DateTime lastUsed,
    @JsonKey(name: 'usage_score')
    required double usageScore,
    @JsonKey(name: 'exists_in_system')
    @Default(true) bool existsInSystem,
  }) = _QuickAccessAccount;

  factory QuickAccessAccount.fromJson(Map<String, dynamic> json) =>
      _$QuickAccessAccountFromJson(json);

  // Helper methods
  const QuickAccessAccount._();

  String get displayName => accountName;

  bool get isHighlyUsed => usageCount > 5;

  bool get isRecentlyUsed =>
      lastUsed.isAfter(DateTime.now().subtract(const Duration(days: 7)));

  bool get isModeratelyUsed =>
      lastUsed.isAfter(DateTime.now().subtract(const Duration(days: 30)));

  /// Convert to AccountData for selector usage
  AccountData toAccountData() {
    return AccountData(
      id: accountId,
      name: accountName,
      type: accountType,
      transactionCount: usageCount,
    );
  }
}

// =====================================================
// CASH LOCATION DATA MODEL
// =====================================================
@freezed
class CashLocationData with _$CashLocationData {
  const factory CashLocationData({
    required String id,
    required String name,
    required String type,
    String? storeId, // RPC returns camelCase
    String? companyId, // For explicit company ID from RPC
    @Default(false) bool isCompanyWide,
    @Default(false) bool isDeleted,
    String? currencyCode,
    String? bankAccount,
    String? bankName,
    String? locationInfo,
    @Default(0) int transactionCount,
    Map<String, dynamic>? additionalData,
  }) = _CashLocationData;

  factory CashLocationData.fromJson(Map<String, dynamic> json) =>
      _$CashLocationDataFromJson(json);

  // Helper methods
  const CashLocationData._();
  
  String get displayName => name;
  
  String get subtitle {
    final parts = <String>[];
    if (type.isNotEmpty) parts.add(type);
    if (bankName != null) parts.add(bankName!);
    if (transactionCount > 0) parts.add('$transactionCount transactions');
    return parts.join(' • ');
  }
  
  String get scopeLabel => isCompanyWide ? 'Company-wide' : 'Store-specific';
  
  bool get isCash => type.toLowerCase().contains('cash');
  bool get isBank => type.toLowerCase().contains('bank');
  bool get isVault => type.toLowerCase().contains('vault');
  
  // Company validation helper
  bool belongsToCompany(String targetCompanyId) {
    // Check direct companyId field from RPC response
    if (companyId != null && companyId!.isNotEmpty) {
      return companyId == targetCompanyId;
    }
    
    // Fallback to additionalData (for backward compatibility)
    final additionalCompanyId = additionalData?['company_id'];
    if (additionalCompanyId != null) {
      return additionalCompanyId == targetCompanyId;
    }
    
    // If no company ID found, assume it doesn't belong
    return false;
  }
}

// =====================================================
// COUNTERPARTY DATA MODEL
// =====================================================
@freezed
class CounterpartyData with _$CounterpartyData {
  const factory CounterpartyData({
    required String id,
    required String name,
    required String type,
    String? email,
    String? phone,
    @Default(false) bool isInternal,
    @Default(0) int transactionCount,
    Map<String, dynamic>? additionalData,
  }) = _CounterpartyData;

  factory CounterpartyData.fromJson(Map<String, dynamic> json) =>
      _$CounterpartyDataFromJson(json);

  // Helper methods
  const CounterpartyData._();
  
  String get displayName => name;
  
  String get subtitle {
    final parts = <String>[];
    if (type.isNotEmpty) parts.add(type);
    if (isInternal) parts.add('Internal');
    if (transactionCount > 0) parts.add('$transactionCount transactions');
    return parts.join(' • ');
  }
  
  String get contactInfo {
    final parts = <String>[];
    if (email != null) parts.add(email!);
    if (phone != null) parts.add(phone!);
    return parts.join(' • ');
  }
  
  bool get isCustomer => type.toLowerCase().contains('customer');
  bool get isVendor => type.toLowerCase().contains('vendor');
  bool get isSupplier => type.toLowerCase().contains('supplier');

  // ✅ Type-safe accessor for linked_company_id
  String? get linkedCompanyId =>
      additionalData?['linked_company_id'] as String?;

  bool get hasLinkedCompany => linkedCompanyId != null && linkedCompanyId!.isNotEmpty;
}

// =====================================================
// STORE DATA MODEL
// =====================================================
@freezed
class StoreData with _$StoreData {
  const factory StoreData({
    required String id,
    required String name,
    required String code,
    String? address,
    String? phone,
    @Default(0) int transactionCount,
    Map<String, dynamic>? additionalData,
  }) = _StoreData;

  factory StoreData.fromJson(Map<String, dynamic> json) =>
      _$StoreDataFromJson(json);

  // Helper methods
  const StoreData._();
  
  String get displayName => name;
  
  String get subtitle {
    final parts = <String>[];
    if (code.isNotEmpty) parts.add('Code: $code');
    if (transactionCount > 0) parts.add('$transactionCount transactions');
    return parts.join(' • ');
  }
  
  String get fullInfo {
    final parts = <String>[];
    if (address != null) parts.add(address!);
    if (phone != null) parts.add(phone!);
    return parts.join(' • ');
  }
}

// =====================================================
// USER DATA MODEL
// =====================================================
@freezed
class UserData with _$UserData {
  const factory UserData({
    required String id,
    required String name,
    String? firstName,
    String? lastName,
    String? email,
    @Default(0) int transactionCount,
    Map<String, dynamic>? additionalData,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  // Helper methods
  const UserData._();
  
  String get displayName => name.isNotEmpty ? name : email ?? 'Unknown User';
  
  String get subtitle {
    final parts = <String>[];
    if (email != null) parts.add(email!);
    if (transactionCount > 0) parts.add('$transactionCount transactions');
    return parts.join(' • ');
  }
  
  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }
    if (name.isNotEmpty) {
      final names = name.split(' ');
      if (names.length >= 2) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    return 'U';
  }
}

// =====================================================
// SELECTOR ITEM (UI Helper)
// =====================================================
@freezed
class SelectorItem with _$SelectorItem {
  const factory SelectorItem({
    required String id,
    required String title,
    String? subtitle,
    String? iconPath,
    String? avatarUrl,
    bool? isSelected,
    Object? data, // Original entity data
  }) = _SelectorItem;

  factory SelectorItem.fromJson(Map<String, dynamic> json) =>
      _$SelectorItemFromJson(json);
}

// =====================================================
// TYPE DEFINITIONS FOR CALLBACKS
// =====================================================
typedef SingleSelectionCallback = void Function(String? selectedId);
typedef SingleSelectionWithNameCallback = void Function(String? selectedId, String? selectedName);
typedef MultiSelectionCallback = void Function(List<String>? selectedIds);
typedef DataSelectionCallback<T> = void Function(T? selectedData);

// ✅ Type-safe callback types for entity-based selectors
typedef OnCounterpartySelectedCallback = void Function(CounterpartyData counterparty);
typedef OnCashLocationSelectedCallback = void Function(CashLocationData cashLocation);
typedef OnMultiCounterpartySelectedCallback = void Function(List<CounterpartyData> counterparties);
typedef MultiDataSelectionCallback<T> = void Function(List<T>? selectedData);

// =====================================================
// HELPER EXTENSIONS
// =====================================================
extension AccountDataExtensions on List<AccountData> {
  List<AccountData> filterByType(String accountType) =>
      where((account) => account.type.toLowerCase() == accountType.toLowerCase()).toList();
      
  List<AccountData> filterByCategory(String categoryTag) =>
      where((account) => account.categoryTag == categoryTag).toList();
      
  List<AccountData> get assets => filterByType('asset');
  List<AccountData> get liabilities => filterByType('liability');
  List<AccountData> get equity => filterByType('equity');
  List<AccountData> get income => filterByType('income');
  List<AccountData> get expenses => filterByType('expense');
}

extension CashLocationDataExtensions on List<CashLocationData> {
  List<CashLocationData> filterByType(String locationType) =>
      where((location) => location.type.toLowerCase() == locationType.toLowerCase()).toList();
      
  List<CashLocationData> filterByScope(bool isCompanyWide) =>
      where((location) => location.isCompanyWide == isCompanyWide).toList();
      
  List<CashLocationData> filterByStore(String storeId) =>
      where((location) => location.storeId == storeId).toList();
      
  List<CashLocationData> filterActive() =>
      where((location) => !location.isDeleted).toList();
      
  List<CashLocationData> get companyWide => filterByScope(true);
  List<CashLocationData> get storeSpecific => filterByScope(false);
  List<CashLocationData> get cashLocations => filterByType('cash');
  List<CashLocationData> get bankAccounts => filterByType('bank');
  List<CashLocationData> get active => filterActive();
}

extension CounterpartyDataExtensions on List<CounterpartyData> {
  List<CounterpartyData> filterByType(String counterpartyType) =>
      where((cp) => cp.type.toLowerCase() == counterpartyType.toLowerCase()).toList();
      
  List<CounterpartyData> filterByInternal(bool isInternal) =>
      where((cp) => cp.isInternal == isInternal).toList();
      
  List<CounterpartyData> get customers => filterByType('customer');
  List<CounterpartyData> get vendors => filterByType('vendor');
  List<CounterpartyData> get internal => filterByInternal(true);
  List<CounterpartyData> get external => filterByInternal(false);
}