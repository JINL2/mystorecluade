import 'package:equatable/equatable.dart';

/// Value object representing transaction counterparty information
/// 
/// Encapsulates comprehensive counterparty information for transactions including
/// debit/credit side counterparty mappings from templates. This is an immutable value object.
/// Expanded to support Template → Transaction mapping with full fidelity.
class TransactionCounterparty extends Equatable {
  // Enhanced counterparty mapping to support Template requirements
  final String? debitCounterpartyId;           // Maps to selectedDebitCounterpartyId
  final Map<String, dynamic>? debitCounterpartyData;  // Maps to selectedDebitCounterpartyData
  final String? creditCounterpartyId;          // Maps to selectedCreditCounterpartyId  
  final Map<String, dynamic>? creditCounterpartyData; // Maps to selectedCreditCounterpartyData
  
  // Legacy fields (kept for backward compatibility)
  final String id;
  final String name;
  final CounterpartyType type;
  final String? contactInfo;
  final String? taxId;
  final Map<String, dynamic> additionalData;

  const TransactionCounterparty({
    // Enhanced counterparty fields
    this.debitCounterpartyId,
    this.debitCounterpartyData,
    this.creditCounterpartyId,
    this.creditCounterpartyData,
    // Legacy fields (required for backward compatibility)
    required this.id,
    required this.name,
    required this.type,
    this.contactInfo,
    this.taxId,
    this.additionalData = const {},
  });

  /// Factory constructor for Template → Transaction mapping
  /// Supports complete mapping of all Template counterparty fields
  factory TransactionCounterparty.fromTemplate({
    String? debitCounterpartyId,
    Map<String, dynamic>? debitCounterpartyData,
    String? creditCounterpartyId,
    Map<String, dynamic>? creditCounterpartyData,
    // Default values for legacy fields (required)
    String id = 'template-mapped',
    String name = 'Template Counterparty',
    CounterpartyType type = CounterpartyType.other,
    Map<String, dynamic> additionalData = const {},
  }) {
    return TransactionCounterparty(
      debitCounterpartyId: debitCounterpartyId,
      debitCounterpartyData: debitCounterpartyData,
      creditCounterpartyId: creditCounterpartyId,
      creditCounterpartyData: creditCounterpartyData,
      id: id,
      name: name,
      type: type,
      additionalData: additionalData,
    );
  }

  /// Factory constructor for creating customer counterparty
  factory TransactionCounterparty.customer({
    required String id,
    required String name,
    String? contactInfo,
    String? taxId,
    Map<String, dynamic> additionalData = const {},
  }) {
    return TransactionCounterparty(
      id: id,
      name: name,
      type: CounterpartyType.customer,
      contactInfo: contactInfo,
      taxId: taxId,
      additionalData: additionalData,
    );
  }

  /// Factory constructor for creating vendor counterparty
  factory TransactionCounterparty.vendor({
    required String id,
    required String name,
    String? contactInfo,
    String? taxId,
    Map<String, dynamic> additionalData = const {},
  }) {
    return TransactionCounterparty(
      id: id,
      name: name,
      type: CounterpartyType.vendor,
      contactInfo: contactInfo,
      taxId: taxId,
      additionalData: additionalData,
    );
  }

  /// Factory constructor for creating employee counterparty
  factory TransactionCounterparty.employee({
    required String id,
    required String name,
    String? contactInfo,
    String? taxId,
    Map<String, dynamic> additionalData = const {},
  }) {
    return TransactionCounterparty(
      id: id,
      name: name,
      type: CounterpartyType.employee,
      contactInfo: contactInfo,
      taxId: taxId,
      additionalData: additionalData,
    );
  }

  /// Factory constructor for creating bank counterparty
  factory TransactionCounterparty.bank({
    required String id,
    required String name,
    String? contactInfo,
    String? taxId,
    Map<String, dynamic> additionalData = const {},
  }) {
    return TransactionCounterparty(
      id: id,
      name: name,
      type: CounterpartyType.bank,
      contactInfo: contactInfo,
      taxId: taxId,
      additionalData: additionalData,
    );
  }

  /// Factory constructor for creating government counterparty
  factory TransactionCounterparty.government({
    required String id,
    required String name,
    String? contactInfo,
    String? taxId,
    Map<String, dynamic> additionalData = const {},
  }) {
    return TransactionCounterparty(
      id: id,
      name: name,
      type: CounterpartyType.government,
      contactInfo: contactInfo,
      taxId: taxId,
      additionalData: additionalData,
    );
  }

  /// Checks if counterparty has debit counterparty information
  bool get hasDebitCounterparty => debitCounterpartyId != null && debitCounterpartyId!.isNotEmpty;

  /// Checks if counterparty has credit counterparty information  
  bool get hasCreditCounterparty => creditCounterpartyId != null && creditCounterpartyId!.isNotEmpty;

  /// Checks if counterparty has debit counterparty data
  bool get hasDebitCounterpartyData => debitCounterpartyData != null && debitCounterpartyData!.isNotEmpty;

  /// Checks if counterparty has credit counterparty data
  bool get hasCreditCounterpartyData => creditCounterpartyData != null && creditCounterpartyData!.isNotEmpty;

  /// Checks if counterparty has any enhanced counterparty information
  bool get hasEnhancedCounterparty => hasDebitCounterparty || hasCreditCounterparty;

  /// Checks if counterparty has any enhanced counterparty data
  bool get hasEnhancedCounterpartyData => hasDebitCounterpartyData || hasCreditCounterpartyData;

  /// Checks if counterparty has contact information (legacy)
  bool get hasContactInfo => contactInfo != null && contactInfo!.isNotEmpty;

  /// Checks if counterparty has tax ID (legacy)
  bool get hasTaxId => taxId != null && taxId!.isNotEmpty;

  /// Checks if counterparty has additional data
  bool get hasAdditionalData => additionalData.isNotEmpty;

  /// Checks if this is a business entity (requires tax ID)
  bool get isBusinessEntity {
    return type == CounterpartyType.vendor ||
           type == CounterpartyType.bank ||
           type == CounterpartyType.government;
  }

  /// Checks if this is an individual person
  bool get isIndividual {
    return type == CounterpartyType.customer ||
           type == CounterpartyType.employee;
  }

  /// Validates the counterparty according to business rules
  bool get isValid {
    // ID cannot be empty
    if (id.trim().isEmpty) return false;
    
    // Name cannot be empty
    if (name.trim().isEmpty) return false;
    
    // Business entities should have tax ID
    if (isBusinessEntity && !hasTaxId) return false;
    
    // Contact info, if provided, cannot be empty
    if (contactInfo != null && contactInfo!.trim().isEmpty) return false;
    
    // Tax ID, if provided, cannot be empty
    if (taxId != null && taxId!.trim().isEmpty) return false;
    
    return true;
  }

  /// Gets validation errors if any
  List<String> getValidationErrors() {
    final errors = <String>[];
    
    if (id.trim().isEmpty) {
      errors.add('Counterparty ID cannot be empty');
    }
    
    if (name.trim().isEmpty) {
      errors.add('Counterparty name cannot be empty');
    }
    
    if (isBusinessEntity && !hasTaxId) {
      errors.add('Business entities must have a tax ID');
    }
    
    if (contactInfo != null && contactInfo!.trim().isEmpty) {
      errors.add('Contact info cannot be empty when provided');
    }
    
    if (taxId != null && taxId!.trim().isEmpty) {
      errors.add('Tax ID cannot be empty when provided');
    }
    
    return errors;
  }

  /// Gets display name with type indication
  String getDisplayName() {
    final typeLabel = type.displayName;
    return '$name ($typeLabel)';
  }

  /// Gets a summary for audit purposes
  String getAuditSummary() {
    final parts = <String>['ID: $id', 'Name: $name', 'Type: ${type.displayName}'];
    
    if (hasContactInfo) parts.add('Contact: $contactInfo');
    if (hasTaxId) parts.add('Tax ID: $taxId');
    
    return parts.join(', ');
  }

  /// Gets specific additional data by key
  T? getAdditionalData<T>(String key) {
    return additionalData[key] as T?;
  }

  /// Checks if additional data contains specific key
  bool hasAdditionalDataKey(String key) {
    return additionalData.containsKey(key);
  }

  /// Creates a new counterparty with updated information
  TransactionCounterparty copyWith({
    // Enhanced counterparty fields
    String? debitCounterpartyId,
    Map<String, dynamic>? debitCounterpartyData,
    String? creditCounterpartyId,
    Map<String, dynamic>? creditCounterpartyData,
    // Legacy fields
    String? id,
    String? name,
    CounterpartyType? type,
    String? contactInfo,
    String? taxId,
    Map<String, dynamic>? additionalData,
  }) {
    return TransactionCounterparty(
      debitCounterpartyId: debitCounterpartyId ?? this.debitCounterpartyId,
      debitCounterpartyData: debitCounterpartyData ?? this.debitCounterpartyData,
      creditCounterpartyId: creditCounterpartyId ?? this.creditCounterpartyId,
      creditCounterpartyData: creditCounterpartyData ?? this.creditCounterpartyData,
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      contactInfo: contactInfo ?? this.contactInfo,
      taxId: taxId ?? this.taxId,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  /// Converts to a map for serialization
  Map<String, dynamic> toMap() {
    return {
      // Enhanced counterparty fields
      if (debitCounterpartyId != null) 'debitCounterpartyId': debitCounterpartyId,
      if (debitCounterpartyData != null) 'debitCounterpartyData': debitCounterpartyData,
      if (creditCounterpartyId != null) 'creditCounterpartyId': creditCounterpartyId,
      if (creditCounterpartyData != null) 'creditCounterpartyData': creditCounterpartyData,
      // Legacy fields
      'id': id,
      'name': name,
      'type': type.name,
      if (contactInfo != null) 'contactInfo': contactInfo,
      if (taxId != null) 'taxId': taxId,
      'additionalData': additionalData,
    };
  }

  /// Creates counterparty from map
  factory TransactionCounterparty.fromMap(Map<String, dynamic> map) {
    return TransactionCounterparty(
      // Enhanced counterparty fields
      debitCounterpartyId: map['debitCounterpartyId'] as String?,
      debitCounterpartyData: map['debitCounterpartyData'] as Map<String, dynamic>?,
      creditCounterpartyId: map['creditCounterpartyId'] as String?,
      creditCounterpartyData: map['creditCounterpartyData'] as Map<String, dynamic>?,
      // Legacy fields
      id: map['id'] as String,
      name: map['name'] as String,
      type: CounterpartyType.fromString(map['type'] as String),
      contactInfo: map['contactInfo'] as String?,
      taxId: map['taxId'] as String?,
      additionalData: Map<String, dynamic>.from((map['additionalData'] as Map<dynamic, dynamic>?) ?? {}),
    );
  }

  @override
  List<Object?> get props => [
        // Enhanced counterparty fields
        debitCounterpartyId,
        debitCounterpartyData,
        creditCounterpartyId,
        creditCounterpartyData,
        // Legacy fields
        id,
        name,
        type,
        contactInfo,
        taxId,
        additionalData,
      ];

  @override
  String toString() => getDisplayName();
}

/// Enumeration of counterparty types
enum CounterpartyType {
  customer,
  vendor,
  employee,
  bank,
  government,
  other;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case CounterpartyType.customer:
        return 'Customer';
      case CounterpartyType.vendor:
        return 'Vendor';
      case CounterpartyType.employee:
        return 'Employee';
      case CounterpartyType.bank:
        return 'Bank';
      case CounterpartyType.government:
        return 'Government';
      case CounterpartyType.other:
        return 'Other';
    }
  }

  /// Creates type from string
  static CounterpartyType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'customer':
        return CounterpartyType.customer;
      case 'vendor':
        return CounterpartyType.vendor;
      case 'employee':
        return CounterpartyType.employee;
      case 'bank':
        return CounterpartyType.bank;
      case 'government':
        return CounterpartyType.government;
      case 'other':
        return CounterpartyType.other;
      default:
        throw ArgumentError('Invalid counterparty type: $value');
    }
  }

  /// String representation for storage
  String get storageValue => name;
}