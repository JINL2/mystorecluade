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

  // Helper method to get a formatted transaction for display
  TransactionDisplay? getTransactionDisplay(String locationType) {
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

    // Create a meaningful title from the counterpart
    String title = '';
    if (counterpartLine.accountName.isNotEmpty) {
      title = _formatTitle(counterpartLine.accountName);
    } else if (journalDescription.isNotEmpty) {
      title = journalDescription;
    } else {
      title = isIncome ? 'Cash In' : 'Cash Out';
    }

    return TransactionDisplay(
      date: entryDate,
      time: _formatTime(transactionDate),
      title: title,
      locationName: cashLine.locationName ?? 'Unknown',
      personName: '',
      amount: amount,
      isIncome: isIncome,
      description: journalDescription,
      journalEntry: this,
    );
  }

  static String _formatTitle(String accountName) {
    final words = accountName.toLowerCase()
        .replaceAll('expenses', '')
        .replaceAll('expense', '')
        .replaceAll('_', ' ')
        .trim()
        .split(' ');

    return words.map((word) =>
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '',
    ).join(' ');
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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

@freezed
class TransactionDisplay with _$TransactionDisplay {
  const factory TransactionDisplay({
    required String date,
    required String time,
    required String title,
    required String locationName,
    required String personName,
    required double amount,
    required bool isIncome,
    required String description,
    required JournalEntry journalEntry,
  }) = _TransactionDisplay;

  factory TransactionDisplay.fromJson(Map<String, dynamic> json) =>
      _$TransactionDisplayFromJson(json);
}
