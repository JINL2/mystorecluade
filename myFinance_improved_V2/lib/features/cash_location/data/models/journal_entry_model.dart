// Data Layer - Journal Entry Model (DTO + Mapper)
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/journal_entry.dart' as domain;

class JournalEntryModel {
  final String journalId;
  final String journalDescription;
  final String entryDate;
  final DateTime transactionDate;
  final List<JournalLineModel> lines;

  JournalEntryModel({
    required this.journalId,
    required this.journalDescription,
    required this.entryDate,
    required this.transactionDate,
    required this.lines,
  });

  // From JSON (Supabase)
  factory JournalEntryModel.fromJson(Map<String, dynamic> json) {
    // Convert UTC datetime string from database to local DateTime
    final transactionDateUtc = json['transaction_date'] as String? ?? DateTime.now().toIso8601String();

    return JournalEntryModel(
      journalId: (json['journal_id'] ?? '').toString(),
      journalDescription: (json['journal_description'] ?? '').toString(),
      entryDate: (json['entry_date'] ?? '').toString(),
      transactionDate: DateTimeUtils.toLocal(transactionDateUtc),
      lines: (json['lines'] as List? ?? [])
          .map((line) => JournalLineModel.fromJson(line as Map<String, dynamic>))
          .toList(),
    );
  }

  // Model → Domain Entity
  domain.JournalEntry toEntity() {
    return domain.JournalEntry(
      journalId: journalId,
      journalDescription: journalDescription,
      entryDate: entryDate,
      transactionDate: transactionDate,
      lines: lines.map((line) => line.toEntity()).toList(),
    );
  }

  // Domain Entity → Model
  factory JournalEntryModel.fromEntity(domain.JournalEntry entity) {
    return JournalEntryModel(
      journalId: entity.journalId,
      journalDescription: entity.journalDescription,
      entryDate: entity.entryDate,
      transactionDate: entity.transactionDate,
      lines: entity.lines.map((line) => JournalLineModel.fromEntity(line)).toList(),
    );
  }
}

class JournalLineModel {
  final String lineId;
  final String? cashLocationId;
  final String? locationName;
  final String? locationType;
  final String accountId;
  final String accountName;
  final double debit;
  final double credit;
  final String description;

  JournalLineModel({
    required this.lineId,
    this.cashLocationId,
    this.locationName,
    this.locationType,
    required this.accountId,
    required this.accountName,
    required this.debit,
    required this.credit,
    required this.description,
  });

  // From JSON
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

  // Model → Domain Entity
  domain.JournalLine toEntity() {
    return domain.JournalLine(
      lineId: lineId,
      cashLocationId: cashLocationId,
      locationName: locationName,
      locationType: locationType,
      accountId: accountId,
      accountName: accountName,
      debit: debit,
      credit: credit,
      description: description,
    );
  }

  // Domain Entity → Model
  factory JournalLineModel.fromEntity(domain.JournalLine entity) {
    return JournalLineModel(
      lineId: entity.lineId,
      cashLocationId: entity.cashLocationId,
      locationName: entity.locationName,
      locationType: entity.locationType,
      accountId: entity.accountId,
      accountName: entity.accountName,
      debit: entity.debit,
      credit: entity.credit,
      description: entity.description,
    );
  }
}
