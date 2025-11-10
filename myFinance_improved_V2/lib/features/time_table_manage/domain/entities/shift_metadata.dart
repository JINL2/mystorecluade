import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_metadata.freezed.dart';
part 'shift_metadata.g.dart';

/// Shift Metadata Entity
///
/// Contains metadata information about shift configurations for a store.
@freezed
class ShiftMetadata with _$ShiftMetadata {
  const ShiftMetadata._();

  const factory ShiftMetadata({
    @JsonKey(name: 'available_tags', defaultValue: <String>[])
        required List<String> availableTags,
    @JsonKey(defaultValue: <String, dynamic>{})
        required Map<String, dynamic> settings,
    @JsonKey(name: 'last_updated') DateTime? lastUpdated,
  }) = _ShiftMetadata;

  /// Create from JSON
  factory ShiftMetadata.fromJson(Map<String, dynamic> json) =>
      _$ShiftMetadataFromJson(json);

  /// Check if metadata has any tags
  bool get hasTags => availableTags.isNotEmpty;

  /// Get tag count
  int get tagCount => availableTags.length;
}
