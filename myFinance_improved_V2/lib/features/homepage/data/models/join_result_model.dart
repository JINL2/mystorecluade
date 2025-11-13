import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/join_result.dart';

part 'join_result_model.freezed.dart';
part 'join_result_model.g.dart';

/// Data model for JoinResult
/// Handles JSON serialization from Supabase RPC response
@freezed
class JoinResultModel with _$JoinResultModel {
  const JoinResultModel._();

  const factory JoinResultModel({
    @Default(false) bool success,
    @JsonKey(name: 'company_id') String? companyId,
    @JsonKey(name: 'company_name') String? companyName,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'store_name') String? storeName,
    @JsonKey(name: 'role_assigned') String? roleAssigned,
  }) = _JoinResultModel;

  factory JoinResultModel.fromJson(Map<String, dynamic> json) =>
      _$JoinResultModelFromJson(json);

  JoinResult toEntity() {
    return JoinResult(
      success: success,
      companyId: companyId,
      companyName: companyName,
      storeId: storeId,
      storeName: storeName,
      roleAssigned: roleAssigned,
    );
  }
}
