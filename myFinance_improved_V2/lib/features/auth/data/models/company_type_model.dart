// lib/features/auth/data/models/company_type_model.dart

import '../../domain/value_objects/company_type.dart';

/// Company Type Model
///
/// 📦 Reference data model for company types
class CompanyTypeModel {
  final String companyTypeId;
  final String typeName;

  const CompanyTypeModel({
    required this.companyTypeId,
    required this.typeName,
  });

  /// Create from Supabase JSON
  factory CompanyTypeModel.fromJson(Map<String, dynamic> json) {
    return CompanyTypeModel(
      companyTypeId: json['company_type_id'] as String,
      typeName: json['type_name'] as String,
    );
  }

  /// Convert to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'company_type_id': companyTypeId,
      'type_name': typeName,
    };
  }

  /// Convert to Domain Value Object
  CompanyType toValueObject() {
    return CompanyType(
      companyTypeId: companyTypeId,
      typeName: typeName,
    );
  }
}
