import '../database.dart';

class DebtsReceivableTable extends SupabaseTable<DebtsReceivableRow> {
  @override
  String get tableName => 'debts_receivable';

  @override
  DebtsReceivableRow createRow(Map<String, dynamic> data) =>
      DebtsReceivableRow(data);
}

class DebtsReceivableRow extends SupabaseDataRow {
  DebtsReceivableRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DebtsReceivableTable();

  String get debtId => getField<String>('debt_id')!;
  set debtId(String value) => setField<String>('debt_id', value);

  String get companyId => getField<String>('company_id')!;
  set companyId(String value) => setField<String>('company_id', value);

  String? get storeId => getField<String>('store_id');
  set storeId(String? value) => setField<String>('store_id', value);

  String get counterpartyId => getField<String>('counterparty_id')!;
  set counterpartyId(String value) =>
      setField<String>('counterparty_id', value);

  String get direction => getField<String>('direction')!;
  set direction(String value) => setField<String>('direction', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  String get accountId => getField<String>('account_id')!;
  set accountId(String value) => setField<String>('account_id', value);

  String? get relatedJournalId => getField<String>('related_journal_id');
  set relatedJournalId(String? value) =>
      setField<String>('related_journal_id', value);

  double get originalAmount => getField<double>('original_amount')!;
  set originalAmount(double value) =>
      setField<double>('original_amount', value);

  double get remainingAmount => getField<double>('remaining_amount')!;
  set remainingAmount(double value) =>
      setField<double>('remaining_amount', value);

  double? get interestRate => getField<double>('interest_rate');
  set interestRate(double? value) => setField<double>('interest_rate', value);

  String? get interestAccountId => getField<String>('interest_account_id');
  set interestAccountId(String? value) =>
      setField<String>('interest_account_id', value);

  int? get interestDueDay => getField<int>('interest_due_day');
  set interestDueDay(int? value) => setField<int>('interest_due_day', value);

  DateTime get issueDate => getField<DateTime>('issue_date')!;
  set issueDate(DateTime value) => setField<DateTime>('issue_date', value);

  DateTime? get dueDate => getField<DateTime>('due_date');
  set dueDate(DateTime? value) => setField<DateTime>('due_date', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get linkedCompanyId => getField<String>('linked_company_id');
  set linkedCompanyId(String? value) =>
      setField<String>('linked_company_id', value);

  String? get linkedCompanyStoreId =>
      getField<String>('linked_company_store_id');
  set linkedCompanyStoreId(String? value) =>
      setField<String>('linked_company_store_id', value);
}
