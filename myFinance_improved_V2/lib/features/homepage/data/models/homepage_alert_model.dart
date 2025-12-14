import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/homepage_alert.dart';

part 'homepage_alert_model.freezed.dart';
part 'homepage_alert_model.g.dart';

/// Homepage Alert Model - handles JSON serialization and domain conversion
///
/// Consolidates DTO and Mapper responsibilities:
/// - JSON serialization (via freezed + json_serializable)
/// - Conversion to/from domain entities
/// - Maps Supabase RPC response to domain HomepageAlert entity
@freezed
class HomepageAlertModel with _$HomepageAlertModel {
  const HomepageAlertModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HomepageAlertModel({
    @JsonKey(name: 'is_show') @Default(false) bool isShow,
    @JsonKey(name: 'is_checked') @Default(false) bool isChecked,
    String? content,
  }) = _HomepageAlertModel;

  /// Create from JSON (Supabase RPC response)
  factory HomepageAlertModel.fromJson(Map<String, dynamic> json) =>
      _$HomepageAlertModelFromJson(json);

  /// Convert Model to Domain Entity
  HomepageAlert toEntity() {
    return HomepageAlert(
      isShow: isShow,
      isChecked: isChecked,
      content: content,
    );
  }

  /// Create Model from Domain Entity
  factory HomepageAlertModel.fromDomain(HomepageAlert entity) {
    return HomepageAlertModel(
      isShow: entity.isShow,
      isChecked: entity.isChecked,
      content: entity.content,
    );
  }
}
