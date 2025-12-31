import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_history_model.freezed.dart';
part 'transaction_history_model.g.dart';

@freezed
class TransactionData with _$TransactionData {
  const factory TransactionData({
    @JsonKey(name: 'journal_id') required String journalId,
    @JsonKey(name: 'journal_number') required String journalNumber,
    @JsonKey(name: 'entry_date') required DateTime entryDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'journal_type') required String journalType,
    @JsonKey(name: 'is_draft') required bool isDraft,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'store_name') String? storeName,
    @JsonKey(name: 'store_code') String? storeCode,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_by_name') required String createdByName,
    @JsonKey(name: 'currency_code') required String currencyCode,
    @JsonKey(name: 'currency_symbol') required String currencySymbol,
    @JsonKey(name: 'total_debit') required double totalDebit,
    @JsonKey(name: 'total_credit') required double totalCredit,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'lines') required List<TransactionLine> lines,
    @JsonKey(name: 'attachments') required List<TransactionAttachment> attachments,
  }) = _TransactionData;

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    try {
      
      // Parse lines from JSON array
      final linesData = json['lines'] as List<dynamic>? ?? [];
      
      final lines = <TransactionLine>[];
      for (int i = 0; i < linesData.length; i++) {
        try {
          final line = TransactionLine.fromJson(linesData[i] as Map<String, dynamic>);
          lines.add(line);
        } catch (e) {
          // Skip invalid lines
        }
      }
      
      // Parse attachments from JSON array
      final attachmentsData = json['attachments'] as List<dynamic>? ?? [];
      
      final attachments = <TransactionAttachment>[];
      for (int i = 0; i < attachmentsData.length; i++) {
        try {
          final att = TransactionAttachment.fromJson(attachmentsData[i] as Map<String, dynamic>);
          attachments.add(att);
        } catch (e) {
          // Skip invalid attachments
        }
      }
      
      final transaction = TransactionData(
        journalId: json['journal_id']?.toString() ?? '',
        journalNumber: json['journal_number'] as String? ?? '',
        entryDate: DateTime.tryParse(json['entry_date'] as String? ?? '') ?? DateTime.now(),
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
        description: json['description'] as String? ?? '',
        journalType: json['journal_type'] as String? ?? '',
        isDraft: json['is_draft'] as bool? ?? false,
        storeId: json['store_id']?.toString(),
        storeName: json['store_name'] as String?,
        storeCode: json['store_code'] as String?,
        createdBy: json['created_by']?.toString(),
        createdByName: json['created_by_name'] as String? ?? 'Unknown',
        currencyCode: json['currency_code'] as String? ?? 'USD',
        currencySymbol: json['currency_symbol'] as String? ?? '\$',
        totalDebit: ((json['total_debit'] ?? 0.0) as num).toDouble(),
        totalCredit: ((json['total_credit'] ?? 0.0) as num).toDouble(),
        totalAmount: ((json['total_amount'] ?? 0.0) as num).toDouble(),
        lines: lines,
        attachments: attachments,
      );
      
      return transaction;
    } catch (e) {
      rethrow;
    }
  }
}

// Add TransactionAttachment model
@freezed
class TransactionAttachment with _$TransactionAttachment {
  const factory TransactionAttachment({
    @JsonKey(name: 'attachment_id') required String attachmentId,
    @JsonKey(name: 'file_name') required String fileName,
    @JsonKey(name: 'file_type') required String fileType,
    @JsonKey(name: 'file_size') required int fileSize,
    @JsonKey(name: 'file_url') String? fileUrl,
  }) = _TransactionAttachment;

  factory TransactionAttachment.fromJson(Map<String, dynamic> json) {
    return TransactionAttachment(
      attachmentId: json['attachment_id']?.toString() ?? '',
      fileName: json['file_name'] as String? ?? '',
      fileType: json['file_type'] as String? ?? '',
      fileSize: json['file_size'] as int? ?? 0,
      fileUrl: json['file_url'] as String?,
    );
  }
}

@freezed
class TransactionLine with _$TransactionLine {
  const factory TransactionLine({
    @JsonKey(name: 'line_id') required String lineId,
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'account_name') required String accountName,
    @JsonKey(name: 'account_type') required String accountType,
    @JsonKey(name: 'debit') required double debit,
    @JsonKey(name: 'credit') required double credit,
    @JsonKey(name: 'is_debit') required bool isDebit,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'counterparty') Map<String, dynamic>? counterparty,
    @JsonKey(name: 'cash_location') Map<String, dynamic>? cashLocation,
    @JsonKey(name: 'display_location') required String displayLocation,
    @JsonKey(name: 'display_counterparty') required String displayCounterparty,
  }) = _TransactionLine;

  factory TransactionLine.fromJson(Map<String, dynamic> json) {
    try {
      
      final line = TransactionLine(
        lineId: json['line_id']?.toString() ?? '',
        accountId: json['account_id']?.toString() ?? '',
        accountName: json['account_name'] as String? ?? '',
        accountType: json['account_type'] as String? ?? '',
        debit: ((json['debit'] ?? 0.0) as num).toDouble(),
        credit: ((json['credit'] ?? 0.0) as num).toDouble(),
        isDebit: json['is_debit'] as bool? ?? false,
        description: json['description'] as String?,
        counterparty: json['counterparty'] as Map<String, dynamic>?,
        cashLocation: json['cash_location'] as Map<String, dynamic>?,
        displayLocation: json['display_location'] as String? ?? '',
        displayCounterparty: json['display_counterparty'] as String? ?? '',
      );
      
      return line;
    } catch (e) {
      rethrow;
    }
  }
}

// Enum for transaction scope
enum TransactionScope {
  store,  // Show only current store (default)
  company // Show all stores in company
}

@freezed
class TransactionFilter with _$TransactionFilter {
  const factory TransactionFilter({
    @Default(TransactionScope.store) TransactionScope scope, // Default to store view
    DateTime? dateFrom,
    DateTime? dateTo,
    String? accountId,
    List<String>? accountIds, // Support multiple accounts
    String? cashLocationId,
    String? counterpartyId,
    String? journalType,
    String? createdBy, // Filter by who created the transaction
    String? searchQuery,
    @Default(50) int limit,
    @Default(0) int offset,
  }) = _TransactionFilter;

  factory TransactionFilter.fromJson(Map<String, dynamic> json) => _$TransactionFilterFromJson(json);
}

@freezed
class TransactionSummary with _$TransactionSummary {
  const factory TransactionSummary({
    @Default(0.0) double totalIncome,
    @Default(0.0) double totalExpenses,
    @Default(0.0) double netAmount,
    @Default(0) int transactionCount,
    @Default(0.0) double todayTotal,
    @Default(0) int todayCount,
  }) = _TransactionSummary;

  factory TransactionSummary.fromJson(Map<String, dynamic> json) => _$TransactionSummaryFromJson(json);
}

class FilterOption {
  final String? id;
  final String name;
  final String? type;
  final int transactionCount;

  const FilterOption({
    this.id,
    required this.name,
    this.type,
    this.transactionCount = 0,
  });

  factory FilterOption.fromJson(Map<String, dynamic> json) {
    // The RPC returns 'id' and 'name' fields
    return FilterOption(
      id: json['id']?.toString(),
      name: json['name'] as String? ?? json['label'] as String? ?? '',
      type: json['type'] as String?,
      transactionCount: json['transaction_count'] as int? ?? 0,
    );
  }
}