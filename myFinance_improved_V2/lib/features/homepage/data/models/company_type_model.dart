import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/company_type.dart';

part 'company_type_model.freezed.dart';
part 'company_type_model.g.dart';

/// Data Transfer Object for CompanyType
@freezed
class CompanyTypeModel with _$CompanyTypeModel {
  const CompanyTypeModel._();

  const factory CompanyTypeModel({
    @JsonKey(name: 'company_type_id') required String id,
    @JsonKey(name: 'type_name') required String typeName,
  }) = _CompanyTypeModel;

  factory CompanyTypeModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyTypeModelFromJson(json);

  CompanyType toEntity() => CompanyType(id: id, typeName: typeName);
}
