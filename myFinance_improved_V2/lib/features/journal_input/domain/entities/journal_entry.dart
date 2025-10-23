// Domain Entity: JournalEntry
// Pure business entity with no dependencies on frameworks

import 'transaction_line.dart';

class JournalEntry {
  final List<TransactionLine> transactionLines;
  final DateTime entryDate;
  final String? overallDescription;
  final String? selectedCompanyId;
  final String? selectedStoreId;
  final String? counterpartyCashLocationId;

  const JournalEntry({
    this.transactionLines = const [],
    required this.entryDate,
    this.overallDescription,
    this.selectedCompanyId,
    this.selectedStoreId,
    this.counterpartyCashLocationId,
  });

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

  JournalEntry copyWith({
    List<TransactionLine>? transactionLines,
    DateTime? entryDate,
    String? overallDescription,
    String? selectedCompanyId,
    String? selectedStoreId,
    String? counterpartyCashLocationId,
  }) {
    return JournalEntry(
      transactionLines: transactionLines ?? this.transactionLines,
      entryDate: entryDate ?? this.entryDate,
      overallDescription: overallDescription ?? this.overallDescription,
      selectedCompanyId: selectedCompanyId ?? this.selectedCompanyId,
      selectedStoreId: selectedStoreId ?? this.selectedStoreId,
      counterpartyCashLocationId: counterpartyCashLocationId ?? this.counterpartyCashLocationId,
    );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JournalEntry &&
      other.selectedCompanyId == selectedCompanyId &&
      other.entryDate == entryDate &&
      other.transactionLines.length == transactionLines.length;
  }

  @override
  int get hashCode => Object.hash(selectedCompanyId, entryDate, transactionLines.length);
}
