import 'package:freezed_annotation/freezed_annotation.dart';

part 'cash_location_models.freezed.dart';

@freezed
class CashLocation with _$CashLocation {
  const factory CashLocation({
    required String id,
    required String name,
    required String type,
    String? storeId,
    @Default(true) bool isCompanyWide,
    @Default(false) bool isDeleted,
    @Default('KRW') String currencyCode,
    String? bankAccount,
    String? bankName,
    String? locationInfo,
    @Default(0) int transactionCount,
    CashLocationAdditionalData? additionalData,
  }) = _CashLocation;

  factory CashLocation.fromJson(Map<String, dynamic> json) {
    // Handle potential null values and type issues
    return CashLocation(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Location',
      type: json['type']?.toString() ?? 'cash',
      storeId: json['storeId']?.toString(),
      isCompanyWide: json['isCompanyWide'] == true || json['isCompanyWide']?.toString().toLowerCase() == 'true',
      isDeleted: json['isDeleted'] == true || json['isDeleted']?.toString().toLowerCase() == 'true',
      currencyCode: json['currencyCode']?.toString() ?? json['currency_code']?.toString() ?? 'KRW',
      bankAccount: json['bankAccount']?.toString(),
      bankName: json['bankName']?.toString(),
      locationInfo: json['locationInfo']?.toString(),
      transactionCount: _parseInteger(json['transactionCount']) ?? 0,
      additionalData: json['additionalData'] != null 
          ? CashLocationAdditionalData.fromJson(json['additionalData'] as Map<String, dynamic>)
          : null,
    );
  }
  
  static int? _parseInteger(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}

@freezed
class CashLocationAdditionalData with _$CashLocationAdditionalData {
  const factory CashLocationAdditionalData({
    @JsonKey(name: 'cash_location_id') required String cashLocationId,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'location_name') required String locationName,
    @JsonKey(name: 'location_type') required String locationType,
    @JsonKey(name: 'location_info') String? locationInfo,
    @JsonKey(name: 'currency_code') @Default('KRW') String currencyCode,
    @JsonKey(name: 'bank_account') String? bankAccount,
    @JsonKey(name: 'bank_name') String? bankName,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _CashLocationAdditionalData;

  factory CashLocationAdditionalData.fromJson(Map<String, dynamic> json) {
    // Handle potential null values safely
    return CashLocationAdditionalData(
      cashLocationId: json['cash_location_id']?.toString() ?? json['cashLocationId']?.toString() ?? '',
      companyId: json['company_id']?.toString() ?? json['companyId']?.toString() ?? '',
      storeId: json['store_id']?.toString() ?? json['storeId']?.toString(),
      locationName: json['location_name']?.toString() ?? json['locationName']?.toString() ?? 'Unknown',
      locationType: json['location_type']?.toString() ?? json['locationType']?.toString() ?? 'cash',
      locationInfo: json['location_info']?.toString() ?? json['locationInfo']?.toString(),
      currencyCode: json['currency_code']?.toString() ?? json['currencyCode']?.toString() ?? 'KRW',
      bankAccount: json['bank_account']?.toString() ?? json['bankAccount']?.toString(),
      bankName: json['bank_name']?.toString() ?? json['bankName']?.toString(),
      isDeleted: json['is_deleted'] == true || json['isDeleted'] == true || 
                 json['is_deleted']?.toString().toLowerCase() == 'true' ||
                 json['isDeleted']?.toString().toLowerCase() == 'true',
      deletedAt: json['deleted_at']?.toString() ?? json['deletedAt']?.toString(),
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString() ?? '',
    );
  }
}

// Response wrapper for RPC call
@freezed
class CashLocationsResponse with _$CashLocationsResponse {
  const factory CashLocationsResponse({
    required bool success,
    required List<CashLocation> data,
    String? message,
    Map<String, dynamic>? error,
  }) = _CashLocationsResponse;

  factory CashLocationsResponse.fromJson(Map<String, dynamic> json) {
    // Handle direct array response or wrapped response
    if (json is List) {
      return CashLocationsResponse(
        success: true,
        data: (json as List<dynamic>)
            .map((item) => CashLocation.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } else if (json.containsKey('success') && json['success'] == true) {
      return CashLocationsResponse(
        success: true,
        data: (json['data'] as List<dynamic>)
            .map((item) => CashLocation.fromJson(item as Map<String, dynamic>))
            .toList(),
        message: json['message'],
      );
    } else {
      return CashLocationsResponse(
        success: false,
        data: [],
        message: json['message'],
        error: json['error'],
      );
    }
  }
}

extension CashLocationExtensions on CashLocation {
  String get displayName => name;
  
  String get displayInfo => locationInfo ?? '';
  
  String get typeIcon {
    switch (type.toLowerCase()) {
      case 'bank':
        return '🏦';
      case 'cash':
        return '💰';
      default:
        return '💼';
    }
  }
  
  // Clean type display without emojis
  String get typeDisplayName {
    switch (type.toLowerCase()) {
      case 'bank':
        return 'Bank Account';
      case 'cash':
        return 'Cash Register';
      default:
        return 'Payment Location';
    }
  }
  
  String get fullDisplayName {
    if (locationInfo?.isNotEmpty == true) {
      return '$name ($locationInfo)';
    }
    return name;
  }
}