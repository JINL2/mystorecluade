// Cash Location Model
class CashLocationModel {
  final String id;
  final String companyId;
  final String storeId;
  final String locationName;
  final String locationType; // 'cash', 'bank', 'vault'
  final String? locationInfo; // JSON string for additional info
  final String currencyCode;
  final String? bankAccount;
  final String? bankName;
  final DateTime? deletedAt;
  final DateTime createdAt;
  
  // Additional fields from view
  final String? storeName;
  final double? currentBalance;
  final DateTime? lastActivity;
  final String? lastUser;
  
  CashLocationModel({
    required this.id,
    required this.companyId,
    required this.storeId,
    required this.locationName,
    required this.locationType,
    this.locationInfo,
    required this.currencyCode,
    this.bankAccount,
    this.bankName,
    this.deletedAt,
    required this.createdAt,
    this.storeName,
    this.currentBalance,
    this.lastActivity,
    this.lastUser,
  });
  
  factory CashLocationModel.fromJson(Map<String, dynamic> json) {
    return CashLocationModel(
      id: json['cash_location_id'] ?? '',
      companyId: json['company_id'] ?? '',
      storeId: json['store_id'] ?? '',
      locationName: json['location_name'] ?? '',
      locationType: json['location_type'] ?? 'cash',
      locationInfo: json['location_info'],
      currencyCode: json['currency_code'] ?? 'USD',
      bankAccount: json['bank_account'],
      bankName: json['bank_name'],
      deletedAt: json['deleted_at'] != null 
        ? DateTime.parse(json['deleted_at']) 
        : null,
      createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : DateTime.now(),
      storeName: json['store_name'],
      currentBalance: json['current_balance']?.toDouble(),
      lastActivity: json['last_activity'] != null
        ? DateTime.parse(json['last_activity'])
        : null,
      lastUser: json['last_user'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'cash_location_id': id,
      'company_id': companyId,
      'store_id': storeId,
      'location_name': locationName,
      'location_type': locationType,
      'location_info': locationInfo,
      'currency_code': currencyCode,
      'bank_account': bankAccount,
      'bank_name': bankName,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
  
  bool get isActive => deletedAt == null;
  
  String get displayName {
    if (locationType == 'bank' && bankName != null) {
      return '$locationName - $bankName';
    }
    return locationName;
  }
  
  String get typeEmoji {
    switch (locationType) {
      case 'cash':
        return '💵';
      case 'bank':
        return '🏦';
      case 'vault':
        return '🔐';
      default:
        return '📍';
    }
  }
}

// Filter model for searching/filtering
class CashLocationFilter {
  final String? searchQuery;
  final String? locationType;
  final String? storeId;
  final bool showInactive;
  
  const CashLocationFilter({
    this.searchQuery,
    this.locationType,
    this.storeId,
    this.showInactive = false,
  });
  
  CashLocationFilter copyWith({
    String? searchQuery,
    String? locationType,
    String? storeId,
    bool? showInactive,
  }) {
    return CashLocationFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      locationType: locationType ?? this.locationType,
      storeId: storeId ?? this.storeId,
      showInactive: showInactive ?? this.showInactive,
    );
  }
}