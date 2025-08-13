import '../database.dart';

class AccountsTable extends SupabaseTable<AccountsRow> {
  @override
  String get tableName => 'accounts';

  @override
  AccountsRow createRow(Map<String, dynamic> data) => AccountsRow(data);
}

class AccountsRow extends SupabaseDataRow {
  AccountsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AccountsTable();

  String get accountId => getField<String>('account_id')!;
  set accountId(String value) => setField<String>('account_id', value);

  String get accountName => getField<String>('account_name')!;
  set accountName(String value) => setField<String>('account_name', value);

  String get accountType => getField<String>('account_type')!;
  set accountType(String value) => setField<String>('account_type', value);

  String? get expenseNature => getField<String>('expense_nature');
  set expenseNature(String? value) => setField<String>('expense_nature', value);

  String? get categoryTag => getField<String>('category_tag');
  set categoryTag(String? value) => setField<String>('category_tag', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get debtTag => getField<String>('debt_tag');
  set debtTag(String? value) => setField<String>('debt_tag', value);

  String? get statementCategory => getField<String>('statement_category');
  set statementCategory(String? value) =>
      setField<String>('statement_category', value);

  String? get statementDetailCategory =>
      getField<String>('statement_detail_category');
  set statementDetailCategory(String? value) =>
      setField<String>('statement_detail_category', value);
}
