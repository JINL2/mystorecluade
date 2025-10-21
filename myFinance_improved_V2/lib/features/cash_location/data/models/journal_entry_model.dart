import '../../domain/entities/journal_entry.dart';

/// Journal Entry Model - extends entity with JSON serialization
class JournalEntryModel extends JournalEntry {
  JournalEntryModel({
    required super.journalId,
    required super.journalDescription,
    required super.entryDate,
    required super.transactionDate,
    required super.lines,
  });

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) {
    return JournalEntryModel(
      journalId: (json['journal_id'] ?? '').toString(),
      journalDescription: (json['journal_description'] ?? '').toString(),
      entryDate: (json['entry_date'] ?? '').toString(),
      transactionDate: DateTime.parse((json['transaction_date'] ?? DateTime.now().toIso8601String()).toString()),
      lines: (json['lines'] as List? ?? [])
          .map((line) => JournalLineModel.fromJson(line as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'journal_id': journalId,
      'journal_description': journalDescription,
      'entry_date': entryDate,
      'transaction_date': transactionDate.toIso8601String(),
      'lines': lines.map((line) => (line as JournalLineModel).toJson()).toList(),
    };
  }
}

/// Journal Line Model - extends entity with JSON serialization
class JournalLineModel extends JournalLine {
  JournalLineModel({
    required super.lineId,
    super.cashLocationId,
    super.locationName,
    super.locationType,
    required super.accountId,
    required super.accountName,
    required super.debit,
    required super.credit,
    required super.description,
  });

  factory JournalLineModel.fromJson(Map<String, dynamic> json) {
    return JournalLineModel(
      lineId: (json['line_id'] ?? '').toString(),
      cashLocationId: json['cash_location_id']?.toString(),
      locationName: json['location_name']?.toString(),
      locationType: json['location_type']?.toString(),
      accountId: (json['account_id'] ?? '').toString(),
      accountName: (json['account_name'] ?? '').toString(),
      debit: (json['debit'] as num?)?.toDouble() ?? 0.0,
      credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
      description: (json['description'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'line_id': lineId,
      'cash_location_id': cashLocationId,
      'location_name': locationName,
      'location_type': locationType,
      'account_id': accountId,
      'account_name': accountName,
      'debit': debit,
      'credit': credit,
      'description': description,
    };
  }
}
