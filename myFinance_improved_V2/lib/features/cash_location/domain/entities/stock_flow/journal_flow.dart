// lib/features/cash_location/domain/entities/stock_flow/journal_flow.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import 'shared_entities.dart';

part 'journal_flow.freezed.dart';

/// Domain entity for journal flow tracking
@freezed
class JournalFlow with _$JournalFlow {
  const factory JournalFlow({
    required String flowId,
    required String createdAt,
    required String systemTime,
    required double balanceBefore,
    required double flowAmount,
    required double balanceAfter,
    required String journalId,
    required String journalDescription,
    String? journalAiDescription,
    required String journalType,
    required String accountId,
    required String accountName,
    required CreatedBy createdBy,
    CounterAccount? counterAccount,
    @Default([]) List<JournalAttachment> attachments,
  }) = _JournalFlow;
}

/// Attachment entity for journal flows
@freezed
class JournalAttachment with _$JournalAttachment {
  const JournalAttachment._();

  const factory JournalAttachment({
    required String attachmentId,
    required String fileName,
    required String fileType,
    String? fileUrl,
    String? ocrText,
    String? ocrStatus,
  }) = _JournalAttachment;

  /// Check if this is an image file
  bool get isImage => fileType.startsWith('image/');

  /// Check if this is a PDF file
  bool get isPdf => fileType == 'application/pdf';

  /// Check if this attachment has OCR text
  bool get hasOcr => ocrText != null && ocrText!.isNotEmpty;
}
