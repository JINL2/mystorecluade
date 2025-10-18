import 'package:equatable/equatable.dart';

/// Value object representing transaction location information
/// 
/// Encapsulates comprehensive location context for transactions including
/// all debit/credit location mappings from templates. This is an immutable value object.
/// Expanded to support Template → Transaction mapping with full fidelity.
class TransactionLocation extends Equatable {
  // Enhanced location mapping to support Template requirements
  final String? debitCashLocationId;       // Maps to selectedDebitCashLocationId
  final String? creditCashLocationId;      // Maps to selectedCreditCashLocationId  
  final String? debitMyCashLocationId;     // Maps to selectedDebitMyCashLocationId
  final String? creditMyCashLocationId;    // Maps to selectedCreditMyCashLocationId
  final String? counterpartyCashLocationId; // Maps to counterpartyCashLocationId
  
  // Legacy fields (kept for backward compatibility)
  final String? storeId;
  final String? cashLocationId;
  final String? locationName;
  final String? address;
  final LocationType type;
  final Map<String, dynamic> additionalInfo;

  const TransactionLocation({
    // Enhanced location fields
    this.debitCashLocationId,
    this.creditCashLocationId,
    this.debitMyCashLocationId,
    this.creditMyCashLocationId,
    this.counterpartyCashLocationId,
    // Legacy fields
    this.storeId,
    this.cashLocationId,
    this.locationName,
    this.address,
    required this.type,
    this.additionalInfo = const {},
  });

  /// Factory constructor for Template → Transaction mapping
  /// Supports complete mapping of all Template location fields
  factory TransactionLocation.fromTemplate({
    String? debitCashLocationId,
    String? creditCashLocationId,
    String? debitMyCashLocationId,
    String? creditMyCashLocationId,
    String? counterpartyCashLocationId,
    LocationType type = LocationType.office,
    Map<String, dynamic> additionalInfo = const {},
  }) {
    return TransactionLocation(
      debitCashLocationId: debitCashLocationId,
      creditCashLocationId: creditCashLocationId,
      debitMyCashLocationId: debitMyCashLocationId,
      creditMyCashLocationId: creditMyCashLocationId,
      counterpartyCashLocationId: counterpartyCashLocationId,
      type: type,
      additionalInfo: additionalInfo,
    );
  }

  /// Factory constructor for cash register location
  factory TransactionLocation.cashRegister({
    required String storeId,
    required String cashLocationId,
    String? locationName,
    String? address,
    Map<String, dynamic> additionalInfo = const {},
  }) {
    return TransactionLocation(
      storeId: storeId,
      cashLocationId: cashLocationId,
      locationName: locationName,
      address: address,
      type: LocationType.cashRegister,
      additionalInfo: additionalInfo,
    );
  }

  /// Factory constructor for ATM location
  factory TransactionLocation.atm({
    String? storeId,
    required String cashLocationId,
    String? locationName,
    String? address,
    Map<String, dynamic> additionalInfo = const {},
  }) {
    return TransactionLocation(
      storeId: storeId,
      cashLocationId: cashLocationId,
      locationName: locationName,
      address: address,
      type: LocationType.atm,
      additionalInfo: additionalInfo,
    );
  }

  /// Factory constructor for bank branch location
  factory TransactionLocation.bankBranch({
    String? storeId,
    String? cashLocationId,
    String? locationName,
    String? address,
    Map<String, dynamic> additionalInfo = const {},
  }) {
    return TransactionLocation(
      storeId: storeId,
      cashLocationId: cashLocationId,
      locationName: locationName,
      address: address,
      type: LocationType.bankBranch,
      additionalInfo: additionalInfo,
    );
  }

  /// Factory constructor for online transaction
  factory TransactionLocation.online({
    String? storeId,
    Map<String, dynamic> additionalInfo = const {},
  }) {
    return TransactionLocation(
      storeId: storeId,
      type: LocationType.online,
      additionalInfo: additionalInfo,
    );
  }

  /// Factory constructor for mobile transaction
  factory TransactionLocation.mobile({
    String? storeId,
    String? locationName,
    Map<String, dynamic> additionalInfo = const {},
  }) {
    return TransactionLocation(
      storeId: storeId,
      locationName: locationName,
      type: LocationType.mobile,
      additionalInfo: additionalInfo,
    );
  }

  /// Factory constructor for office location
  factory TransactionLocation.office({
    required String storeId,
    String? locationName,
    String? address,
    Map<String, dynamic> additionalInfo = const {},
  }) {
    return TransactionLocation(
      storeId: storeId,
      locationName: locationName,
      address: address,
      type: LocationType.office,
      additionalInfo: additionalInfo,
    );
  }

  /// Checks if location has debit cash location
  bool get hasDebitCashLocation => debitCashLocationId != null && debitCashLocationId!.isNotEmpty;

  /// Checks if location has credit cash location
  bool get hasCreditCashLocation => creditCashLocationId != null && creditCashLocationId!.isNotEmpty;

  /// Checks if location has debit my cash location
  bool get hasDebitMyCashLocation => debitMyCashLocationId != null && debitMyCashLocationId!.isNotEmpty;

  /// Checks if location has credit my cash location
  bool get hasCreditMyCashLocation => creditMyCashLocationId != null && creditMyCashLocationId!.isNotEmpty;

  /// Checks if location has counterparty cash location
  bool get hasCounterpartyCashLocation => counterpartyCashLocationId != null && counterpartyCashLocationId!.isNotEmpty;

  /// Checks if location has any enhanced location information
  bool get hasEnhancedLocation => hasDebitCashLocation || hasCreditCashLocation || 
                                  hasDebitMyCashLocation || hasCreditMyCashLocation || 
                                  hasCounterpartyCashLocation;

  /// Checks if location has store information (legacy)
  bool get hasStore => storeId != null && storeId!.isNotEmpty;

  /// Checks if location has cash location information (legacy)
  bool get hasCashLocation => cashLocationId != null && cashLocationId!.isNotEmpty;

  /// Checks if location has a name
  bool get hasName => locationName != null && locationName!.isNotEmpty;

  /// Checks if location has address information
  bool get hasAddress => address != null && address!.isNotEmpty;

  /// Checks if location has additional information
  bool get hasAdditionalInfo => additionalInfo.isNotEmpty;

  /// Checks if this is a physical location
  bool get isPhysicalLocation {
    return type != LocationType.online && type != LocationType.mobile;
  }

  /// Checks if this is a digital location
  bool get isDigitalLocation {
    return type == LocationType.online || type == LocationType.mobile;
  }

  /// Checks if this location requires cash handling
  bool get requiresCashHandling {
    return type == LocationType.cashRegister ||
           type == LocationType.atm ||
           type == LocationType.office;
  }

  /// Validates the location according to business rules
  bool get isValid {
    // Cash register must have store and cash location
    if (type == LocationType.cashRegister) {
      return hasStore && hasCashLocation;
    }
    
    // ATM must have cash location
    if (type == LocationType.atm) {
      return hasCashLocation;
    }
    
    // Office must have store
    if (type == LocationType.office) {
      return hasStore;
    }
    
    // Online and mobile can be minimal
    return true;
  }

  /// Gets validation errors if any
  List<String> getValidationErrors() {
    final errors = <String>[];
    
    if (type == LocationType.cashRegister) {
      if (!hasStore) {
        errors.add('Cash register location must have store ID');
      }
      if (!hasCashLocation) {
        errors.add('Cash register location must have cash location ID');
      }
    }
    
    if (type == LocationType.atm && !hasCashLocation) {
      errors.add('ATM location must have cash location ID');
    }
    
    if (type == LocationType.office && !hasStore) {
      errors.add('Office location must have store ID');
    }
    
    // Check for empty values when provided
    if (storeId != null && storeId!.trim().isEmpty) {
      errors.add('Store ID cannot be empty when provided');
    }
    
    if (cashLocationId != null && cashLocationId!.trim().isEmpty) {
      errors.add('Cash location ID cannot be empty when provided');
    }
    
    if (locationName != null && locationName!.trim().isEmpty) {
      errors.add('Location name cannot be empty when provided');
    }
    
    if (address != null && address!.trim().isEmpty) {
      errors.add('Address cannot be empty when provided');
    }
    
    return errors;
  }

  /// Gets display name for the location
  String getDisplayName() {
    if (hasName) {
      return '$locationName (${type.displayName})';
    }
    
    if (hasCashLocation) {
      return 'Location $cashLocationId (${type.displayName})';
    }
    
    if (hasStore) {
      return 'Store $storeId (${type.displayName})';
    }
    
    return type.displayName;
  }

  /// Gets a detailed description of the location
  String getDetailedDescription() {
    final parts = <String>[type.displayName];
    
    if (hasName) parts.add('Name: $locationName');
    if (hasStore) parts.add('Store: $storeId');
    if (hasCashLocation) parts.add('Cash Location: $cashLocationId');
    if (hasAddress) parts.add('Address: $address');
    
    return parts.join(', ');
  }

  /// Gets specific additional information by key
  T? getAdditionalInfo<T>(String key) {
    return additionalInfo[key] as T?;
  }

  /// Checks if additional info contains specific key
  bool hasAdditionalInfoKey(String key) {
    return additionalInfo.containsKey(key);
  }

  /// Creates a new location with updated information
  TransactionLocation copyWith({
    // Enhanced location fields
    String? debitCashLocationId,
    String? creditCashLocationId,
    String? debitMyCashLocationId,
    String? creditMyCashLocationId,
    String? counterpartyCashLocationId,
    // Legacy fields
    String? storeId,
    String? cashLocationId,
    String? locationName,
    String? address,
    LocationType? type,
    Map<String, dynamic>? additionalInfo,
  }) {
    return TransactionLocation(
      debitCashLocationId: debitCashLocationId ?? this.debitCashLocationId,
      creditCashLocationId: creditCashLocationId ?? this.creditCashLocationId,
      debitMyCashLocationId: debitMyCashLocationId ?? this.debitMyCashLocationId,
      creditMyCashLocationId: creditMyCashLocationId ?? this.creditMyCashLocationId,
      counterpartyCashLocationId: counterpartyCashLocationId ?? this.counterpartyCashLocationId,
      storeId: storeId ?? this.storeId,
      cashLocationId: cashLocationId ?? this.cashLocationId,
      locationName: locationName ?? this.locationName,
      address: address ?? this.address,
      type: type ?? this.type,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  /// Converts to a map for serialization
  Map<String, dynamic> toMap() {
    return {
      // Enhanced location fields
      if (debitCashLocationId != null) 'debitCashLocationId': debitCashLocationId,
      if (creditCashLocationId != null) 'creditCashLocationId': creditCashLocationId,
      if (debitMyCashLocationId != null) 'debitMyCashLocationId': debitMyCashLocationId,
      if (creditMyCashLocationId != null) 'creditMyCashLocationId': creditMyCashLocationId,
      if (counterpartyCashLocationId != null) 'counterpartyCashLocationId': counterpartyCashLocationId,
      // Legacy fields
      if (storeId != null) 'storeId': storeId,
      if (cashLocationId != null) 'cashLocationId': cashLocationId,
      if (locationName != null) 'locationName': locationName,
      if (address != null) 'address': address,
      'type': type.name,
      'additionalInfo': additionalInfo,
    };
  }

  /// Creates location from map
  factory TransactionLocation.fromMap(Map<String, dynamic> map) {
    return TransactionLocation(
      // Enhanced location fields
      debitCashLocationId: map['debitCashLocationId'] as String?,
      creditCashLocationId: map['creditCashLocationId'] as String?,
      debitMyCashLocationId: map['debitMyCashLocationId'] as String?,
      creditMyCashLocationId: map['creditMyCashLocationId'] as String?,
      counterpartyCashLocationId: map['counterpartyCashLocationId'] as String?,
      // Legacy fields
      storeId: map['storeId'] as String?,
      cashLocationId: map['cashLocationId'] as String?,
      locationName: map['locationName'] as String?,
      address: map['address'] as String?,
      type: LocationType.fromString(map['type'] as String),
      additionalInfo: Map<String, dynamic>.from((map['additionalInfo'] as Map<dynamic, dynamic>?) ?? {}),
    );
  }

  @override
  List<Object?> get props => [
        // Enhanced location fields
        debitCashLocationId,
        creditCashLocationId,
        debitMyCashLocationId,
        creditMyCashLocationId,
        counterpartyCashLocationId,
        // Legacy fields
        storeId,
        cashLocationId,
        locationName,
        address,
        type,
        additionalInfo,
      ];

  @override
  String toString() => getDisplayName();
}

/// Enumeration of location types
enum LocationType {
  cashRegister,
  atm,
  bankBranch,
  online,
  mobile,
  office,
  other;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case LocationType.cashRegister:
        return 'Cash Register';
      case LocationType.atm:
        return 'ATM';
      case LocationType.bankBranch:
        return 'Bank Branch';
      case LocationType.online:
        return 'Online';
      case LocationType.mobile:
        return 'Mobile';
      case LocationType.office:
        return 'Office';
      case LocationType.other:
        return 'Other';
    }
  }

  /// Icon name for UI
  String get iconName {
    switch (this) {
      case LocationType.cashRegister:
        return 'point_of_sale';
      case LocationType.atm:
        return 'local_atm';
      case LocationType.bankBranch:
        return 'account_balance';
      case LocationType.online:
        return 'language';
      case LocationType.mobile:
        return 'smartphone';
      case LocationType.office:
        return 'business';
      case LocationType.other:
        return 'location_on';
    }
  }

  /// Creates type from string
  static LocationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'cashregister':
      case 'cash_register':
        return LocationType.cashRegister;
      case 'atm':
        return LocationType.atm;
      case 'bankbranch':
      case 'bank_branch':
        return LocationType.bankBranch;
      case 'online':
        return LocationType.online;
      case 'mobile':
        return LocationType.mobile;
      case 'office':
        return LocationType.office;
      case 'other':
        return LocationType.other;
      default:
        throw ArgumentError('Invalid location type: $value');
    }
  }

  /// String representation for storage
  String get storageValue => name;
}