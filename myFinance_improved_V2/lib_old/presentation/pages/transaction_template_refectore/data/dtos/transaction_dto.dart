/// Transaction DTO - Data Transfer Object for transaction operations
///
/// Purpose: Type-safe JSON mapping for transaction database operations:
/// - Provides consistent snake_case ↔ camelCase conversion
/// - Ensures type safety for all transaction fields
/// - Matches TemplateDto pattern for architectural consistency
/// - Handles complex nested objects (cash, debt, context)
/// - Supports bidirectional JSON serialization/deserialization
///
/// Clean Architecture: DATA LAYER - DTO Pattern
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'transaction_dto.g.dart';

@JsonSerializable()
class TransactionDto extends Equatable {
  /// Transaction unique identifier
  @JsonKey(name: 'id')
  final String id;

  /// Associated template identifier for tracking
  @JsonKey(name: 'template_id')
  final String templateId;

  /// Main debit account identifier
  @JsonKey(name: 'debit_account_id')
  final String debitAccountId;

  /// Main credit account identifier
  @JsonKey(name: 'credit_account_id')
  final String creditAccountId;

  /// Transaction amount in base currency
  @JsonKey(name: 'amount')
  final double amount;

  /// When the transaction occurred
  @JsonKey(name: 'transaction_date')
  final DateTime transactionDate;

  /// Optional transaction description
  @JsonKey(name: 'description')
  final String? description;

  /// Transaction status (pending, completed, cancelled)
  @JsonKey(name: 'status')
  final String status;

  /// Company context identifier
  @JsonKey(name: 'company_id')
  final String companyId;

  /// Store context identifier (optional)
  @JsonKey(name: 'store_id')
  final String? storeId;

  /// User who created the transaction
  @JsonKey(name: 'created_by')
  final String createdBy;

  /// When transaction was created in system
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// When transaction was last updated
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// User who last updated the transaction
  @JsonKey(name: 'updated_by')
  final String updatedBy;

  /// Counterparty information (optional)
  @JsonKey(name: 'counterparty_id')
  final String? counterpartyId;

  /// Cash location for cash transactions (optional)
  @JsonKey(name: 'cash_location_id')
  final String? cashLocationId;

  /// Counterparty cash location (for transfers, optional)
  @JsonKey(name: 'counterparty_cash_location_id')
  final String? counterpartyCashLocationId;

  /// Additional metadata and tags
  @JsonKey(name: 'tags')
  final Map<String, dynamic> tags;

  const TransactionDto({
    required this.id,
    required this.templateId,
    required this.debitAccountId,
    required this.creditAccountId,
    required this.amount,
    required this.transactionDate,
    this.description,
    required this.status,
    required this.companyId,
    this.storeId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedBy,
    this.counterpartyId,
    this.cashLocationId,
    this.counterpartyCashLocationId,
    required this.tags,
  });

  /// Create TransactionDto from JSON
  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  /// Convert TransactionDto to JSON
  Map<String, dynamic> toJson() => _$TransactionDtoToJson(this);

  /// Create copy with modified fields
  TransactionDto copyWith({
    String? id,
    String? templateId,
    String? debitAccountId,
    String? creditAccountId,
    double? amount,
    DateTime? transactionDate,
    String? description,
    String? status,
    String? companyId,
    String? storeId,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? updatedBy,
    String? counterpartyId,
    String? cashLocationId,
    String? counterpartyCashLocationId,
    Map<String, dynamic>? tags,
  }) {
    return TransactionDto(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      debitAccountId: debitAccountId ?? this.debitAccountId,
      creditAccountId: creditAccountId ?? this.creditAccountId,
      amount: amount ?? this.amount,
      transactionDate: transactionDate ?? this.transactionDate,
      description: description ?? this.description,
      status: status ?? this.status,
      companyId: companyId ?? this.companyId,
      storeId: storeId ?? this.storeId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      counterpartyId: counterpartyId ?? this.counterpartyId,
      cashLocationId: cashLocationId ?? this.cashLocationId,
      counterpartyCashLocationId: counterpartyCashLocationId ?? this.counterpartyCashLocationId,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        templateId,
        debitAccountId,
        creditAccountId,
        amount,
        transactionDate,
        description,
        status,
        companyId,
        storeId,
        createdBy,
        createdAt,
        updatedAt,
        updatedBy,
        counterpartyId,
        cashLocationId,
        counterpartyCashLocationId,
        tags,
      ];

  @override
  String toString() => 'TransactionDto(id: $id, templateId: $templateId, amount: $amount)';
}