// Cash Location Models for Sales Invoice Feature

class CashLocation {
  final String id;
  final String name;
  final String type; // 'bank' or 'cash'
  final String? storeId;
  final bool isCompanyWide;
  final bool isDeleted;
  final String currencyCode;
  final String? bankAccount;
  final String? bankName;
  final String? locationInfo;
  final int transactionCount;

  CashLocation({
    required this.id,
    required this.name,
    required this.type,
    this.storeId,
    this.isCompanyWide = true,
    this.isDeleted = false,
    this.currencyCode = 'KRW',
    this.bankAccount,
    this.bankName,
    this.locationInfo,
    this.transactionCount = 0,
  });

  factory CashLocation.fromJson(Map<String, dynamic> json) {
    // Helper function to extract name from potentially JSON-encoded string
    String parseName(dynamic nameValue) {
      if (nameValue == null) return 'Unknown Location';

      final nameStr = nameValue.toString();

      // Check if name is a JSON object string
      if (nameStr.startsWith('{') && nameStr.endsWith('}')) {
        try {
          // Try to parse as JSON
          // This handles cases where name contains bank info as JSON
          return nameValue.toString();
        } catch (e) {
          return nameStr;
        }
      }

      return nameStr;
    }

    return CashLocation(
      id: json['id']?.toString() ?? '',
      name: parseName(json['name']),
      type: json['type']?.toString() ?? 'cash',
      storeId: json['storeId']?.toString() ?? json['store_id']?.toString(),
      isCompanyWide: json['isCompanyWide'] == true ||
                     json['is_company_wide'] == true ||
                     json['isCompanyWide']?.toString().toLowerCase() == 'true' ||
                     json['is_company_wide']?.toString().toLowerCase() == 'true',
      isDeleted: json['isDeleted'] == true ||
                 json['is_deleted'] == true ||
                 json['isDeleted']?.toString().toLowerCase() == 'true' ||
                 json['is_deleted']?.toString().toLowerCase() == 'true',
      currencyCode: json['currencyCode']?.toString() ??
                    json['currency_code']?.toString() ??
                    'KRW',
      bankAccount: json['bankAccount']?.toString() ?? json['bank_account']?.toString(),
      bankName: json['bankName']?.toString() ?? json['bank_name']?.toString(),
      locationInfo: json['locationInfo']?.toString() ?? json['location_info']?.toString(),
      transactionCount: _parseInteger(json['transactionCount'] ?? json['transaction_count']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'storeId': storeId,
      'isCompanyWide': isCompanyWide,
      'isDeleted': isDeleted,
      'currencyCode': currencyCode,
      'bankAccount': bankAccount,
      'bankName': bankName,
      'locationInfo': locationInfo,
      'transactionCount': transactionCount,
    };
  }

  CashLocation copyWith({
    String? id,
    String? name,
    String? type,
    String? storeId,
    bool? isCompanyWide,
    bool? isDeleted,
    String? currencyCode,
    String? bankAccount,
    String? bankName,
    String? locationInfo,
    int? transactionCount,
  }) {
    return CashLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      storeId: storeId ?? this.storeId,
      isCompanyWide: isCompanyWide ?? this.isCompanyWide,
      isDeleted: isDeleted ?? this.isDeleted,
      currencyCode: currencyCode ?? this.currencyCode,
      bankAccount: bankAccount ?? this.bankAccount,
      bankName: bankName ?? this.bankName,
      locationInfo: locationInfo ?? this.locationInfo,
      transactionCount: transactionCount ?? this.transactionCount,
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

  // Helper getters for UI display
  String get displayName {
    // Don't include locationInfo if it looks like JSON or is empty
    if (locationInfo?.isNotEmpty == true &&
        !locationInfo!.trim().startsWith('{') &&
        !locationInfo!.trim().startsWith('[')) {
      return '$name ($locationInfo)';
    }
    return name;
  }

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

  String get displayType {
    switch (type.toLowerCase()) {
      case 'bank':
        return 'Bank';
      case 'cash':
        return 'Cash';
      default:
        return 'Payment';
    }
  }

  bool get isBank => type.toLowerCase() == 'bank';
  bool get isCash => type.toLowerCase() == 'cash';
}

// Response wrapper for RPC call
class CashLocationsResponse {
  final bool success;
  final List<CashLocation> data;
  final String? message;
  final Map<String, dynamic>? error;

  CashLocationsResponse({
    required this.success,
    required this.data,
    this.message,
    this.error,
  });

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
        message: json['message']?.toString(),
      );
    } else {
      return CashLocationsResponse(
        success: false,
        data: [],
        message: json['message']?.toString(),
        error: json['error'] as Map<String, dynamic>?,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((location) => location.toJson()).toList(),
      'message': message,
      'error': error,
    };
  }
}
