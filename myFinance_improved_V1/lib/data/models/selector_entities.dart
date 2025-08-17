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
    String? storeId,
    @Default(false) bool isCompanyWide,
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
typedef MultiSelectionCallback = void Function(List<String>? selectedIds);
typedef DataSelectionCallback<T> = void Function(T? selectedData);
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
      
  List<CashLocationData> get companyWide => filterByScope(true);
  List<CashLocationData> get storeSpecific => filterByScope(false);
  List<CashLocationData> get cashLocations => filterByType('cash');
  List<CashLocationData> get bankAccounts => filterByType('bank');
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