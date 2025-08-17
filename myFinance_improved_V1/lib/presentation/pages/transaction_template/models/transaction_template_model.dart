class TransactionTemplate {
  final String templateId;
  final String name;
  final dynamic data; // Can be List or Map
  final String? permission;
  final dynamic tags; // Can be Map or List
  final String? visibilityLevel;
  final bool isActive;
  final String? updatedBy;
  final String? companyId;
  final String? storeId;
  final String? counterpartyId;
  final String? counterpartyCashLocationId;

  TransactionTemplate({
    required this.templateId,
    required this.name,
    required this.data,
    this.permission,
    this.tags,
    this.visibilityLevel,
    required this.isActive,
    this.updatedBy,
    this.companyId,
    this.storeId,
    this.counterpartyId,
    this.counterpartyCashLocationId,
  });

  factory TransactionTemplate.fromJson(Map<String, dynamic> json) {
    return TransactionTemplate(
      templateId: json['template_id'] ?? '',
      name: json['name'] ?? '',
      data: json['data'] ?? [],
      permission: json['permission'],
      tags: json['tags'],
      visibilityLevel: json['visibility_level'],
      isActive: json['is_active'] ?? true,
      updatedBy: json['updated_by'],
      companyId: json['company_id'],
      storeId: json['store_id'],
      counterpartyId: json['counterparty_id'],
      counterpartyCashLocationId: json['counterparty_cash_location_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'template_id': templateId,
      'name': name,
      'data': data,
      'permission': permission,
      'tags': tags,
      'visibility_level': visibilityLevel,
      'is_active': isActive,
      'updated_by': updatedBy,
      'company_id': companyId,
      'store_id': storeId,
      'counterparty_id': counterpartyId,
      'counterparty_cash_location_id': counterpartyCashLocationId,
    };
  }

  // Helper methods to extract data from the template
  String get transactionType {
    // Since data is now an array, check the first transaction
    if (data is List && (data as List).isNotEmpty) {
      final firstTransaction = (data as List)[0];
      if (firstTransaction['debit'] != '0') {
        return 'expense';
      } else if (firstTransaction['credit'] != '0') {
        return 'income';
      }
    }
    return 'expense'; // default
  }

  String get amount {
    // Get amount from the first transaction in the array
    if (data is List && (data as List).isNotEmpty) {
      final firstTransaction = (data as List)[0];
      if (firstTransaction['amount'] != null) {
        // Convert to int to remove decimals, then to string
        final amountValue = firstTransaction['amount'];
        if (amountValue is num) {
          return amountValue.toInt().toString();
        }
        return amountValue.toString();
      }
    }
    return '0';
  }

  String get frequency {
    // This might be stored elsewhere or not used anymore
    return 'As needed';
  }

  bool get isStoreTemplate {
    return visibilityLevel == 'store' || storeId != null;
  }
  
  // Additional helper to get description
  String get description {
    if (data is List && (data as List).isNotEmpty) {
      final firstTransaction = (data as List)[0];
      return firstTransaction['description'] ?? '';
    }
    return '';
  }
}