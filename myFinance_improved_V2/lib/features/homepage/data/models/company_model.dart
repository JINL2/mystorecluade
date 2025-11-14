import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/company.dart';

part 'company_model.freezed.dart';
part 'company_model.g.dart';

/// Data Transfer Object for Company
/// Used for create company response
@freezed
class CompanyModel with _$CompanyModel {
  const CompanyModel._();

  const factory CompanyModel({
    @JsonKey(name: 'company_id') required String id,
    @JsonKey(name: 'company_name') required String name,
    @JsonKey(name: 'company_code') required String code,
    @JsonKey(name: 'company_type_id') required String companyTypeId,
    @JsonKey(name: 'base_currency_id') required String baseCurrencyId,
  }) = _CompanyModel;

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

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
