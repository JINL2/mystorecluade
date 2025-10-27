// Data Model: JournalEntryModel
// DTO (Data Transfer Object) with mapper to domain entity

import '../../domain/entities/journal_entry.dart';
import 'transaction_line_model.dart';

class JournalEntryModel {
  final List<TransactionLineModel> transactionLines;
  final DateTime entryDate;
  final String? overallDescription;
  final String? selectedCompanyId;
  final String? selectedStoreId;
  final String? counterpartyCashLocationId;

  const JournalEntryModel({
    this.transactionLines = const [],
    required this.entryDate,
    this.overallDescription,
    this.selectedCompanyId,
    this.selectedStoreId,
    this.counterpartyCashLocationId,
  });

  // Convert domain entity to model
  factory JournalEntryModel.fromEntity(JournalEntry entity) {
    return JournalEntryModel(
      transactionLines: entity.transactionLines
          .map((line) => TransactionLineModel.fromEntity(line))
          .toList(),
      entryDate: entity.entryDate,
      overallDescription: entity.overallDescription,
      selectedCompanyId: entity.selectedCompanyId,
      selectedStoreId: entity.selectedStoreId,
      counterpartyCashLocationId: entity.counterpartyCashLocationId,
    );
  }

  // Convert model to domain entity
  JournalEntry toEntity() {
    return JournalEntry(
      transactionLines: transactionLines
          .map((model) => model.toEntity())
          .toList(),
      entryDate: entryDate,
      overallDescription: overallDescription,
      selectedCompanyId: selectedCompanyId,
      selectedStoreId: selectedStoreId,
      counterpartyCashLocationId: counterpartyCashLocationId,
    );
  }

  // Get transaction lines as JSON for API submission
  List<Map<String, dynamic>> getTransactionLinesJson() {
    return transactionLines.map((line) => line.toJson()).toList();
  }

  // Find main counterparty ID from transaction lines
  String? getMainCounterpartyId() {
    for (final line in transactionLines) {
      if (line.counterpartyId != null && line.counterpartyId!.isNotEmpty) {
        return line.counterpartyId;
      }
    }
    return null;
  }
}
