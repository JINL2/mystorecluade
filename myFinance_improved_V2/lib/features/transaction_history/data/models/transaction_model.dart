import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/transaction.dart';

part 'transaction_model.freezed.dart';

/// Data model for Transaction (DTO with JSON serialization)
@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    @JsonKey(name: 'journal_id') required String journalId,
    @JsonKey(name: 'journal_number') required String journalNumber,
    @JsonKey(name: 'entry_date') required DateTime entryDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'ai_description') String? aiDescription,
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
    @JsonKey(name: 'lines') required List<TransactionLineModel> lines,
    @JsonKey(name: 'attachments') required List<TransactionAttachmentModel> attachments,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse lines from JSON array
      final linesData = json['lines'] as List<dynamic>? ?? [];
      final lines = <TransactionLineModel>[];
      for (final lineJson in linesData) {
        try {
          lines.add(TransactionLineModel.fromJson(lineJson as Map<String, dynamic>));
        } catch (e) {
          // Skip invalid lines
        }
      }

      // Parse attachments from JSON array
      final attachmentsData = json['attachments'] as List<dynamic>? ?? [];
      final attachments = <TransactionAttachmentModel>[];
      for (final attachmentJson in attachmentsData) {
        try {
          attachments.add(TransactionAttachmentModel.fromJson(attachmentJson as Map<String, dynamic>));
        } catch (e) {
          // Skip invalid attachments
        }
      }

      return TransactionModel(
        journalId: json['journal_id']?.toString() ?? '',
        journalNumber: json['journal_number']?.toString() ?? '',
        entryDate: json['entry_date'] != null
            ? DateTimeUtils.toLocal(json['entry_date'] as String)
            : DateTime.now(),
        createdAt: json['created_at'] != null
            ? DateTimeUtils.toLocal(json['created_at'] as String)
            : DateTime.now(),
        description: json['description']?.toString() ?? '',
        aiDescription: json['ai_description']?.toString(),
        journalType: json['journal_type']?.toString() ?? '',
        isDraft: (json['is_draft'] as bool?) ?? false,
        storeId: json['store_id']?.toString(),
        storeName: json['store_name']?.toString(),
        storeCode: json['store_code']?.toString(),
        createdBy: json['created_by']?.toString(),
        createdByName: json['created_by_name']?.toString() ?? 'Unknown',
        currencyCode: json['currency_code']?.toString() ?? 'USD',
        currencySymbol: json['currency_symbol']?.toString() ?? '\$',
        totalDebit: ((json['total_debit'] as num?) ?? 0.0).toDouble(),
        totalCredit: ((json['total_credit'] as num?) ?? 0.0).toDouble(),
        totalAmount: ((json['total_amount'] as num?) ?? 0.0).toDouble(),
        lines: lines,
        attachments: attachments,
      );
    } catch (e) {
      rethrow;
    }
  }
}

/// Extension to convert model to domain entity
extension TransactionModelMapper on TransactionModel {
  Transaction toEntity() {
    return Transaction(
      journalId: journalId,
      journalNumber: journalNumber,
      entryDate: entryDate,
      createdAt: createdAt,
      description: description,
      aiDescription: aiDescription,
      journalType: journalType,
      isDraft: isDraft,
      storeId: storeId,
      storeName: storeName,
      storeCode: storeCode,
      createdBy: createdBy,
      createdByName: createdByName,
      currencyCode: currencyCode,
      currencySymbol: currencySymbol,
      totalDebit: totalDebit,
      totalCredit: totalCredit,
      totalAmount: totalAmount,
      lines: lines.map((line) => line.toEntity()).toList(),
      attachments: attachments.map((att) => att.toEntity()).toList(),
    );
  }
}

/// Transaction line model
@freezed
class TransactionLineModel with _$TransactionLineModel {
  const factory TransactionLineModel({
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
  }) = _TransactionLineModel;

  factory TransactionLineModel.fromJson(Map<String, dynamic> json) {
    try {
      return TransactionLineModel(
        lineId: json['line_id']?.toString() ?? '',
        accountId: json['account_id']?.toString() ?? '',
        accountName: json['account_name']?.toString() ?? '',
        accountType: json['account_type']?.toString() ?? '',
        debit: ((json['debit'] as num?) ?? 0.0).toDouble(),
        credit: ((json['credit'] as num?) ?? 0.0).toDouble(),
        isDebit: (json['is_debit'] as bool?) ?? false,
        description: json['description']?.toString(),
        counterparty: json['counterparty'] as Map<String, dynamic>?,
        cashLocation: json['cash_location'] as Map<String, dynamic>?,
        displayLocation: json['display_location']?.toString() ?? '',
        displayCounterparty: json['display_counterparty']?.toString() ?? '',
      );
    } catch (e) {
      rethrow;
    }
  }
}

/// Extension to convert line model to entity
extension TransactionLineModelMapper on TransactionLineModel {
  TransactionLine toEntity() {
    return TransactionLine(
      lineId: lineId,
      accountId: accountId,
      accountName: accountName,
      accountType: accountType,
      debit: debit,
      credit: credit,
      isDebit: isDebit,
      description: description,
      counterparty: counterparty,
      cashLocation: cashLocation,
      displayLocation: displayLocation,
      displayCounterparty: displayCounterparty,
    );
  }
}

/// Transaction attachment model
@freezed
class TransactionAttachmentModel with _$TransactionAttachmentModel {
  const TransactionAttachmentModel._();

  const factory TransactionAttachmentModel({
    @JsonKey(name: 'attachment_id') required String attachmentId,
    @JsonKey(name: 'file_name') required String fileName,
    @JsonKey(name: 'file_type') required String fileType,
    @JsonKey(name: 'file_url') String? fileUrl,
    @JsonKey(name: 'ocr_text') String? ocrText,
    @JsonKey(name: 'ocr_status') String? ocrStatus,
  }) = _TransactionAttachmentModel;

  factory TransactionAttachmentModel.fromJson(Map<String, dynamic> json) {
    final fileName = json['file_name']?.toString() ?? '';
    // Infer file_type from file_name if not provided
    final fileType = json['file_type']?.toString() ?? _inferMimeType(fileName);

    return TransactionAttachmentModel(
      attachmentId: json['attachment_id']?.toString() ?? '',
      fileName: fileName,
      fileType: fileType,
      fileUrl: json['file_url']?.toString(),
      ocrText: json['ocr_text']?.toString(),
      ocrStatus: json['ocr_status']?.toString(),
    );
  }

  /// Infer MIME type from file extension
  static String _inferMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  /// Check if this is an image file
  bool get isImage => fileType.startsWith('image/');

  /// Check if this is a PDF file
  bool get isPdf => fileType == 'application/pdf';
}

/// Extension to convert attachment model to entity
extension TransactionAttachmentModelMapper on TransactionAttachmentModel {
  TransactionAttachment toEntity() {
    return TransactionAttachment(
      attachmentId: attachmentId,
      fileName: fileName,
      fileType: fileType,
      fileUrl: fileUrl,
      ocrText: ocrText,
      ocrStatus: ocrStatus,
    );
  }
}
