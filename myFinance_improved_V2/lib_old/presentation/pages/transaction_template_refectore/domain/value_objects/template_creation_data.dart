import 'package:equatable/equatable.dart';

/// Value object representing template creation data
/// 
/// Encapsulates all the data required to create a new transaction template.
/// This is an immutable value object following Clean Architecture principles.
/// Acts as a data transfer object between layers while maintaining domain integrity.
class TemplateCreationData extends Equatable {
  /// Template name (2-100 characters)
  final String name;
  
  /// Optional description providing additional context
  final String? templateDescription;
  
  /// 🚨 CORE: Transaction data JSONB array - contains all transaction lines
  /// Each line: {account_id, debit, credit, description, cash?, debt?, fix_asset?}
  final List<Map<String, dynamic>> data;
  
  /// Template categorization tags
  final Map<String, dynamic> tags;
  
  /// Template visibility and permission
  final String visibilityLevel;
  final String permission;
  
  /// Single counterparty ID (for templates with counterparty)
  final String? counterpartyId;
  
  /// Counterparty cash location (for internal transactions)
  final String? counterpartyCashLocationId;

  const TemplateCreationData({
    required this.name,
    this.templateDescription,
    required this.data,
    this.tags = const {},
    required this.visibilityLevel,
    required this.permission,
    this.counterpartyId,
    this.counterpartyCashLocationId,
  });

  /// Factory constructor for creating template data from user input
  factory TemplateCreationData.fromUserInput({
    required String name,
    String? templateDescription,
    required List<Map<String, dynamic>> data,
    String visibilityLevel = 'private',
    String permission = 'edit',
    String? counterpartyId,
    String? counterpartyCashLocationId,
    Map<String, dynamic>? tags,
  }) {
    return TemplateCreationData(
      name: name,
      templateDescription: templateDescription,
      data: data,
      tags: tags ?? {},
      visibilityLevel: visibilityLevel,
      permission: permission,
      counterpartyId: counterpartyId,
      counterpartyCashLocationId: counterpartyCashLocationId,
    );
  }

  /// Factory constructor for basic template creation
  factory TemplateCreationData.basic({
    required String name,
    required List<Map<String, dynamic>> data,
    String? templateDescription,
  }) {
    return TemplateCreationData(
      name: name,
      templateDescription: templateDescription,
      data: data,
      visibilityLevel: 'private',
      permission: 'edit',
    );
  }

  /// Validates the creation data according to business rules
  bool get isValid {
    // Name validation
    if (name.trim().isEmpty || name.trim().length < 2 || name.trim().length > 100) {
      return false;
    }

    // Description validation
    if (templateDescription != null && templateDescription!.length > 500) {
      return false;
    }

    // Data validation - must have at least one line
    if (data.isEmpty) {
      return false;
    }

    // Basic data structure validation
    for (final line in data) {
      if (line['account_id'] == null || 
          line['debit'] == null || 
          line['credit'] == null) {
        return false;
      }
    }

    return true;
  }

  /// Gets validation errors if any
  List<String> getValidationErrors() {
    final errors = <String>[];
    
    if (name.trim().isEmpty) {
      errors.add('Template name is required');
    } else if (name.trim().length < 2) {
      errors.add('Template name must be at least 2 characters');
    } else if (name.trim().length > 100) {
      errors.add('Template name must not exceed 100 characters');
    }

    if (templateDescription != null && templateDescription!.length > 500) {
      errors.add('Description cannot exceed 500 characters');
    }

    if (data.isEmpty) {
      errors.add('Template must have at least one journal line');
    }

    // Basic data structure validation
    for (int i = 0; i < data.length; i++) {
      final line = data[i];
      final lineNum = i + 1;
      
      if (line['account_id'] == null || line['account_id'].toString().trim().isEmpty) {
        errors.add('Line $lineNum: account_id is required');
      }
      
      if (line['debit'] == null) {
        errors.add('Line $lineNum: debit field is required');
      }
      
      if (line['credit'] == null) {
        errors.add('Line $lineNum: credit field is required');
      }
    }
    
    return errors;
  }

  /// Checks if template has counterparty information
  bool get hasCounterparty => counterpartyId != null && counterpartyId!.isNotEmpty;

  /// Checks if template has counterparty cash location
  bool get hasCounterpartyCashLocation => counterpartyCashLocationId != null && counterpartyCashLocationId!.isNotEmpty;

  /// Gets the number of journal lines
  int get lineCount => data.length;

  /// Gets total debit amount (for validation)
  double get totalDebit {
    double total = 0;
    for (final line in data) {
      final debit = double.tryParse(line['debit']?.toString() ?? '0') ?? 0;
      total += debit;
    }
    return total;
  }

  /// Gets total credit amount (for validation)
  double get totalCredit {
    double total = 0;
    for (final line in data) {
      final credit = double.tryParse(line['credit']?.toString() ?? '0') ?? 0;
      total += credit;
    }
    return total;
  }

  /// Checks if debits equal credits
  bool get isBalanced => totalDebit == totalCredit;

  /// Creates a copy with updated values
  TemplateCreationData copyWith({
    String? name,
    String? templateDescription,
    List<Map<String, dynamic>>? data,
    Map<String, dynamic>? tags,
    String? visibilityLevel,
    String? permission,
    String? counterpartyId,
    String? counterpartyCashLocationId,
  }) {
    return TemplateCreationData(
      name: name ?? this.name,
      templateDescription: templateDescription ?? this.templateDescription,
      data: data ?? this.data,
      tags: tags ?? this.tags,
      visibilityLevel: visibilityLevel ?? this.visibilityLevel,
      permission: permission ?? this.permission,
      counterpartyId: counterpartyId ?? this.counterpartyId,
      counterpartyCashLocationId: counterpartyCashLocationId ?? this.counterpartyCashLocationId,
    );
  }

  /// Converts to a map for serialization
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      if (templateDescription != null) 'templateDescription': templateDescription,
      'data': data,
      'tags': tags,
      'visibilityLevel': visibilityLevel,
      'permission': permission,
      if (counterpartyId != null) 'counterpartyId': counterpartyId,
      if (counterpartyCashLocationId != null) 'counterpartyCashLocationId': counterpartyCashLocationId,
    };
  }

  /// Creates template creation data from map
  factory TemplateCreationData.fromMap(Map<String, dynamic> map) {
    return TemplateCreationData(
      name: map['name'] as String,
      templateDescription: map['templateDescription'] as String?,
      data: List<Map<String, dynamic>>.from(map['data'] as List),
      tags: Map<String, dynamic>.from(map['tags'] as Map? ?? {}),
      visibilityLevel: map['visibilityLevel'] as String,
      permission: map['permission'] as String,
      counterpartyId: map['counterpartyId'] as String?,
      counterpartyCashLocationId: map['counterpartyCashLocationId'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        name,
        templateDescription,
        data,
        tags,
        visibilityLevel,
        permission,
        counterpartyId,
        counterpartyCashLocationId,
      ];

  @override
  String toString() => 'TemplateCreationData(name: $name, lines: ${data.length})';
}