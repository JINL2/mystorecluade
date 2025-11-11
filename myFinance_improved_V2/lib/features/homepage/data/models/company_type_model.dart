import 'package:myfinance_improved/features/homepage/domain/entities/company_type.dart';

/// Data Transfer Object for CompanyType
/// Handles JSON serialization/deserialization from Supabase
///
/// Pure DTO that does not extend domain entity
class CompanyTypeModel {
  const CompanyTypeModel({
    required this.id,
    required this.typeName,
  });

  final String id;
  final String typeName;

  /// Create from JSON (from Supabase response)
  factory CompanyTypeModel.fromJson(Map<String, dynamic> json) {
    return CompanyTypeModel(
      id: json['company_type_id'] as String,
      typeName: json['type_name'] as String,
    );
  }

  /// Convert to JSON (for Supabase request)
  Map<String, dynamic> toJson() {
    return {
      'company_type_id': id,
      'type_name': typeName,
    };
  }

  /// Convert to domain entity
  CompanyType toEntity() {
    return CompanyType(
      id: id,
      typeName: typeName,
    );
  }
}
