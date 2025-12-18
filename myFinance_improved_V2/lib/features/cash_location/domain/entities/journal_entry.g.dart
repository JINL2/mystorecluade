// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JournalEntryImpl _$$JournalEntryImplFromJson(Map<String, dynamic> json) =>
    _$JournalEntryImpl(
      journalId: json['journalId'] as String,
      journalDescription: json['journalDescription'] as String,
      entryDate: json['entryDate'] as String,
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      lines: (json['lines'] as List<dynamic>)
          .map((e) => JournalLine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$JournalEntryImplToJson(_$JournalEntryImpl instance) =>
    <String, dynamic>{
      'journalId': instance.journalId,
      'journalDescription': instance.journalDescription,
      'entryDate': instance.entryDate,
      'transactionDate': instance.transactionDate.toIso8601String(),
      'lines': instance.lines,
    };

_$JournalLineImpl _$$JournalLineImplFromJson(Map<String, dynamic> json) =>
    _$JournalLineImpl(
      lineId: json['lineId'] as String,
      cashLocationId: json['cashLocationId'] as String?,
      locationName: json['locationName'] as String?,
      locationType: json['locationType'] as String?,
      accountId: json['accountId'] as String,
      accountName: json['accountName'] as String,
      debit: (json['debit'] as num).toDouble(),
      credit: (json['credit'] as num).toDouble(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$$JournalLineImplToJson(_$JournalLineImpl instance) =>
    <String, dynamic>{
      'lineId': instance.lineId,
      'cashLocationId': instance.cashLocationId,
      'locationName': instance.locationName,
      'locationType': instance.locationType,
      'accountId': instance.accountId,
      'accountName': instance.accountName,
      'debit': instance.debit,
      'credit': instance.credit,
      'description': instance.description,
    };

_$TransactionDataImpl _$$TransactionDataImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionDataImpl(
      cashLine: JournalLine.fromJson(json['cashLine'] as Map<String, dynamic>),
      counterpartLine:
          JournalLine.fromJson(json['counterpartLine'] as Map<String, dynamic>),
      isIncome: json['isIncome'] as bool,
      amount: (json['amount'] as num).toDouble(),
      journalEntry:
          JournalEntry.fromJson(json['journalEntry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TransactionDataImplToJson(
        _$TransactionDataImpl instance) =>
    <String, dynamic>{
      'cashLine': instance.cashLine,
      'counterpartLine': instance.counterpartLine,
      'isIncome': instance.isIncome,
      'amount': instance.amount,
      'journalEntry': instance.journalEntry,
    };
