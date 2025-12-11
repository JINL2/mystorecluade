import '../enums/template_enums.dart';

/// Template Debt Configuration Value Object
/// 
/// Represents debt configuration settings for transaction templates.
/// This is used when templates involve payable/receivable accounts.
class TemplateDebtConfiguration {
  final String counterpartyId;
  final String direction; // 'receivable' or 'payable'
  final String category; // 'sales', 'purchase', 'loan', etc.
  final String? linkedCompanyId; // For internal transfers
  final String? linkedStoreId; // For internal transfers
  final double? interestRate;
  final DateTime? dueDate;
  final DateTime? issueDate;
  final Map<String, dynamic>? additionalData;

  const TemplateDebtConfiguration({
    required this.counterpartyId,
    required this.direction,
    required this.category,
    this.linkedCompanyId,
    this.linkedStoreId,
    this.interestRate,
    this.dueDate,
    this.issueDate,
    this.additionalData,
  });

  /// Create from Map (for database serialization)
  factory TemplateDebtConfiguration.fromMap(Map<String, dynamic> map) {
    return TemplateDebtConfiguration(
      counterpartyId: map['counterparty_id'] as String,
      direction: map['direction'] as String,
      category: map['category'] as String,
      linkedCompanyId: map['linkedCounterparty_companyId'] as String?,
      linkedStoreId: map['linkedCounterparty_store_id'] as String?,
      interestRate: map['interest_rate'] as double?,
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date'] as String) : null,
      issueDate: map['issue_date'] != null ? DateTime.parse(map['issue_date'] as String) : null,
      additionalData: map['additional_data'] as Map<String, dynamic>?,
    );
  }

  /// Convert to Map (for database serialization)
  Map<String, dynamic> toMap() {
    return {
      'counterparty_id': counterpartyId,
      'direction': direction,
      'category': category,
      if (linkedCompanyId != null) 'linkedCounterparty_companyId': linkedCompanyId,
      if (linkedStoreId != null) 'linkedCounterparty_store_id': linkedStoreId,
      if (interestRate != null) 'interest_rate': interestRate,
      if (dueDate != null) 'due_date': dueDate!.toIso8601String(),
      if (issueDate != null) 'issue_date': issueDate!.toIso8601String(),
      if (additionalData != null) 'additional_data': additionalData,
    };
  }

  /// Check if this is an internal transaction
  bool get isInternal => linkedCompanyId != null && linkedCompanyId!.isNotEmpty;

  /// Check if this has complex terms (interest, specific dates)
  bool get hasComplexTerms => interestRate != null && interestRate! > 0 || 
                              dueDate != null || 
                              issueDate != null;
  
  /// Check if configuration is valid
  bool get isValid => validate().isEmpty;
  
  /// Get principal amount (for adapter compatibility)
  double? get principal => null; // Templates don't have fixed principal amounts
  
  /// Get date range as string representation
  String? get dateRange {
    if (issueDate != null && dueDate != null) {
      return '${issueDate!.toIso8601String().split('T')[0]} - ${dueDate!.toIso8601String().split('T')[0]}';
    }
    if (issueDate != null) {
      return 'From ${issueDate!.toIso8601String().split('T')[0]}';
    }
    return null;
  }

  /// Validate debt configuration
  List<String> validate() {
    final errors = <String>[];

    if (counterpartyId.isEmpty) {
      errors.add('Counterparty ID is required');
    }

    if (direction != 'receivable' && direction != 'payable') {
      errors.add('Direction must be receivable or payable');
    }

    if (category.isEmpty) {
      errors.add('Category is required');
    }

    if (isInternal && (linkedStoreId == null || linkedStoreId!.isEmpty)) {
      errors.add('Internal transactions require linked store ID');
    }

    if (interestRate != null && interestRate! < 0) {
      errors.add('Interest rate cannot be negative');
    }

    return errors;
  }

  /// Create a copy with updated values
  TemplateDebtConfiguration copyWith({
    String? counterpartyId,
    String? direction,
    String? category,
    String? linkedCompanyId,
    String? linkedStoreId,
    double? interestRate,
    DateTime? dueDate,
    DateTime? issueDate,
    Map<String, dynamic>? additionalData,
  }) {
    return TemplateDebtConfiguration(
      counterpartyId: counterpartyId ?? this.counterpartyId,
      direction: direction ?? this.direction,
      category: category ?? this.category,
      linkedCompanyId: linkedCompanyId ?? this.linkedCompanyId,
      linkedStoreId: linkedStoreId ?? this.linkedStoreId,
      interestRate: interestRate ?? this.interestRate,
      dueDate: dueDate ?? this.dueDate,
      issueDate: issueDate ?? this.issueDate,
      additionalData: additionalData ?? this.additionalData,
    );
  }
  
  /// Factory constructors for adapter compatibility
  /// Create debt configuration for different scenarios
  factory TemplateDebtConfiguration.create({
    required String counterpartyId,
    required String direction,
    required String category,
    String? linkedCompanyId,
    String? linkedStoreId,
    double? interestRate,
    DateTime? dueDate,
    DateTime? issueDate,
    Map<String, dynamic>? additionalData,
  }) {
    return TemplateDebtConfiguration(
      counterpartyId: counterpartyId,
      direction: direction,
      category: category,
      linkedCompanyId: linkedCompanyId,
      linkedStoreId: linkedStoreId,
      interestRate: interestRate,
      dueDate: dueDate,
      issueDate: issueDate,
      additionalData: additionalData,
    );
  }
  
  /// Create loan debt configuration
  factory TemplateDebtConfiguration.loan({
    required String counterpartyId,
    required String direction,
    double? interestRate,
    DateTime? dueDate,
    Map<String, dynamic>? additionalData,
  }) {
    return TemplateDebtConfiguration.create(
      counterpartyId: counterpartyId,
      direction: direction,
      category: 'loan',
      interestRate: interestRate,
      dueDate: dueDate,
      additionalData: additionalData,
    );
  }
  
  /// Create credit debt configuration
  factory TemplateDebtConfiguration.credit({
    required String counterpartyId,
    required String direction,
    DateTime? dueDate,
    Map<String, dynamic>? additionalData,
  }) {
    return TemplateDebtConfiguration.create(
      counterpartyId: counterpartyId,
      direction: direction,
      category: 'credit',
      dueDate: dueDate,
      additionalData: additionalData,
    );
  }
  
  /// Create note debt configuration
  factory TemplateDebtConfiguration.note({
    required String counterpartyId,
    required String direction,
    DateTime? dueDate,
    Map<String, dynamic>? additionalData,
  }) {
    return TemplateDebtConfiguration.create(
      counterpartyId: counterpartyId,
      direction: direction,
      category: 'note',
      dueDate: dueDate,
      additionalData: additionalData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TemplateDebtConfiguration &&
        other.counterpartyId == counterpartyId &&
        other.direction == direction &&
        other.category == category &&
        other.linkedCompanyId == linkedCompanyId &&
        other.linkedStoreId == linkedStoreId &&
        other.interestRate == interestRate &&
        other.dueDate == dueDate &&
        other.issueDate == issueDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      counterpartyId,
      direction,
      category,
      linkedCompanyId,
      linkedStoreId,
      interestRate,
      dueDate,
      issueDate,
    );
  }

  @override
  String toString() {
    return 'TemplateDebtConfiguration(counterpartyId: $counterpartyId, direction: $direction, category: $category${isInternal ? ', internal' : ''})';
  }
}