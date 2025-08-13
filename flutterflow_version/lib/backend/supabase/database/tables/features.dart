import '../database.dart';

class FeaturesTable extends SupabaseTable<FeaturesRow> {
  @override
  String get tableName => 'features';

  @override
  FeaturesRow createRow(Map<String, dynamic> data) => FeaturesRow(data);
}

class FeaturesRow extends SupabaseDataRow {
  FeaturesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FeaturesTable();

  String get featureId => getField<String>('feature_id')!;
  set featureId(String value) => setField<String>('feature_id', value);

  String? get categoryId => getField<String>('category_id');
  set categoryId(String? value) => setField<String>('category_id', value);

  String get featureName => getField<String>('feature_name')!;
  set featureName(String value) => setField<String>('feature_name', value);

  String? get icon => getField<String>('icon');
  set icon(String? value) => setField<String>('icon', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get route => getField<String>('route');
  set route(String? value) => setField<String>('route', value);
}
