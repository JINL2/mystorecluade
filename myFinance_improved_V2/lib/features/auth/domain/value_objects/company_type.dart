/// Company Type value object
///
/// Represents a business classification type (e.g., LLC, Corporation, Restaurant, Retail).
/// This is a read-only reference data that comes from the database.
class CompanyType {
  final String companyTypeId;
  final String typeName;

  const CompanyType({
    required this.companyTypeId,
    required this.typeName,
  });

  factory CompanyType.fromJson(Map<String, dynamic> json) {
    return CompanyType(
      companyTypeId: json['company_type_id'] as String,
      typeName: json['type_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_type_id': companyTypeId,
      'type_name': typeName,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompanyType && other.companyTypeId == companyTypeId;
  }

  @override
  int get hashCode => companyTypeId.hashCode;

  @override
  String toString() => 'CompanyType(id: $companyTypeId, name: $typeName)';
}
