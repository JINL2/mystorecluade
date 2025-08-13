import '../database.dart';

class DebtPaymentsTable extends SupabaseTable<DebtPaymentsRow> {
  @override
  String get tableName => 'debt_payments';

  @override
  DebtPaymentsRow createRow(Map<String, dynamic> data) => DebtPaymentsRow(data);
}

class DebtPaymentsRow extends SupabaseDataRow {
  DebtPaymentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DebtPaymentsTable();

  String get paymentId => getField<String>('payment_id')!;
  set paymentId(String value) => setField<String>('payment_id', value);

  String get debtId => getField<String>('debt_id')!;
  set debtId(String value) => setField<String>('debt_id', value);

  String? get journalId => getField<String>('journal_id');
  set journalId(String? value) => setField<String>('journal_id', value);

  DateTime get paymentDate => getField<DateTime>('payment_date')!;
  set paymentDate(DateTime value) => setField<DateTime>('payment_date', value);

  double get amount => getField<double>('amount')!;
  set amount(double value) => setField<double>('amount', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
