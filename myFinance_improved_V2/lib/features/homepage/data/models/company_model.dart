import 'package:myfinance_improved/features/homepage/domain/entities/company.dart';

/// Data Transfer Object for Company
/// Handles JSON serialization/deserialization from Supabase
///
/// This is a pure DTO that does not extend the domain entity.
/// It follows Clean Architecture principles by keeping data layer
/// separate from domain layer.
class CompanyModel {
  const CompanyModel({
    required this.id,
    required this.name,
    required this.code,
    required this.companyTypeId,
    required this.baseCurrencyId,
  });

  final String id;
  final String name;
  final String code;
  final String companyTypeId;
  final String baseCurrencyId;

  /// Create from JSON (from Supabase response after creation)
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['company_id'] as String,
      name: json['company_name'] as String,
      code: json['company_code'] as String,
      companyTypeId: json['company_type_id'] as String,
      baseCurrencyId: json['base_currency_id'] as String,
    );
  }

  /// Convert to JSON (for Supabase request)
  Map<String, dynamic> toJson() {
    return {
      'company_id': id,
      'company_name': name,
      'company_code': code,
      'company_type_id': companyTypeId,
      'base_currency_id': baseCurrencyId,
    };
  }

  /// Convert to domain entity
  Company toEntity() {
    return Company(
      id: id,
      name: name,
      code: code,
      companyTypeId: companyTypeId,
      baseCurrencyId: baseCurrencyId,
    );
  }
}
