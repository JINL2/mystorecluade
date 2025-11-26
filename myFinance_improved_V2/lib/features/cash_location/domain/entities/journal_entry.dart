// Domain Layer - Journal Entry Entity
// Pure business object with business logic

import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_entry.freezed.dart';
part 'journal_entry.g.dart';

@freezed
class JournalEntry with _$JournalEntry {
  const JournalEntry._();

  const factory JournalEntry({
    required String journalId,
    required String journalDescription,
    required String entryDate,
    required DateTime transactionDate,
    required List<JournalLine> lines,
  }) = _JournalEntry;

  // Business logic: Get transaction data by location type (no formatting)
  TransactionData? getTransactionData(String locationType) {
    // Filter lines by location type (cash, bank, or vault)
    final relevantLines = lines.where((line) =>
      line.locationType == locationType ||
      (line.locationType == null && line.accountName.toLowerCase().contains('expense')),
    ).toList();

    if (relevantLines.isEmpty) return null;

    // Find the cash location line (where money moves in/out)
    final cashLine = lines.firstWhere(
      (line) => line.locationType == locationType,
      orElse: () => lines.first,
    );

    // Find the counterpart line (expense/income account or other location)
    final counterpartLine = lines.firstWhere(
      (line) => line.lineId != cashLine.lineId,
      orElse: () => cashLine,
    );

    // Determine if it's income (debit to cash) or expense (credit from cash)
    final isIncome = cashLine.debit > 0;
    final amount = isIncome ? cashLine.debit : cashLine.credit;

    return TransactionData(
      cashLine: cashLine,
      counterpartLine: counterpartLine,
      isIncome: isIncome,
      amount: amount,
      journalEntry: this,
    );
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);
}

@freezed
class JournalLine with _$JournalLine {
  const factory JournalLine({
    required String lineId,
    String? cashLocationId,
    String? locationName,
    String? locationType,
    required String accountId,
    required String accountName,
    required double debit,
    required double credit,
    required String description,
  }) = _JournalLine;

  factory JournalLine.fromJson(Map<String, dynamic> json) =>
      _$JournalLineFromJson(json);
}

/// Business data for transaction (no UI formatting)
@freezed
class TransactionData with _$TransactionData {
  const factory TransactionData({
    required JournalLine cashLine,
    required JournalLine counterpartLine,
    required bool isIncome,
    required double amount,
    required JournalEntry journalEntry,
  }) = _TransactionData;

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataFromJson(json);
}
