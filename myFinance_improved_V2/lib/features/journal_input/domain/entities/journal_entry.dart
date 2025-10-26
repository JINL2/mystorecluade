// Domain Entity: JournalEntry
// Pure business entity with no dependencies on frameworks

import 'package:freezed_annotation/freezed_annotation.dart';
import 'transaction_line.dart';

part 'journal_entry.freezed.dart';

@freezed
class JournalEntry with _$JournalEntry {
  const JournalEntry._();

  const factory JournalEntry({
    @Default([]) List<TransactionLine> transactionLines,
    required DateTime entryDate,
    String? overallDescription,
    String? selectedCompanyId,
    String? selectedStoreId,
    String? counterpartyCashLocationId,
  }) = _JournalEntry;

  // Calculated values
  double get totalDebits => transactionLines
      .where((line) => line.isDebit)
      .fold(0.0, (sum, line) => sum + line.amount);

  double get totalCredits => transactionLines
      .where((line) => !line.isDebit)
      .fold(0.0, (sum, line) => sum + line.amount);

  double get difference => totalDebits - totalCredits;

  bool get isBalanced => difference.abs() < 0.01; // Allow for small rounding differences

  int get debitCount => transactionLines.where((line) => line.isDebit).length;

  int get creditCount => transactionLines.where((line) => !line.isDebit).length;

  bool canSubmit() {
    return transactionLines.isNotEmpty &&
           isBalanced &&
           selectedCompanyId != null &&
           selectedCompanyId!.isNotEmpty;
  }

  JournalEntry addTransactionLine(TransactionLine line) {
    return copyWith(
      transactionLines: [...transactionLines, line],
    );
  }

  JournalEntry removeTransactionLine(int index) {
    if (index >= 0 && index < transactionLines.length) {
      final newLines = List<TransactionLine>.from(transactionLines);
      newLines.removeAt(index);
      return copyWith(transactionLines: newLines);
    }
    return this;
  }

  JournalEntry updateTransactionLine(int index, TransactionLine line) {
    if (index >= 0 && index < transactionLines.length) {
      final newLines = List<TransactionLine>.from(transactionLines);
      newLines[index] = line;
      return copyWith(transactionLines: newLines);
    }
    return this;
  }

  JournalEntry clear() {
    return JournalEntry(
      transactionLines: const [],
      entryDate: DateTime.now(),
      overallDescription: null,
      selectedCompanyId: selectedCompanyId, // Keep company ID
      selectedStoreId: selectedStoreId, // Keep store ID
      counterpartyCashLocationId: null,
    );
  }
}
