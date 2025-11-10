import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

/// Tag Entity
///
/// Represents a tag associated with a shift card for categorization
/// and additional information (e.g., bonus, warning, note).
@freezed
class Tag with _$Tag {
  const Tag._();

  const factory Tag({
    /// Unique identifier for the tag
    @JsonKey(name: 'tag_id') required String tagId,

    /// ID of the card this tag is attached to
    @JsonKey(name: 'card_id') required String cardId,

    /// Type of tag (e.g., 'bonus', 'warning', 'info', 'late')
    @JsonKey(name: 'tag_type') required String tagType,

    /// Content/description of the tag
    @JsonKey(name: 'tag_content') required String tagContent,

    /// When the tag was created
    @JsonKey(name: 'created_at') required DateTime createdAt,

    /// User ID who created the tag
    @JsonKey(name: 'created_by') required String createdBy,
  }) = _Tag;

  /// Create from JSON
  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  /// Check if tag is a bonus tag
  bool get isBonus => tagType.toLowerCase() == 'bonus';

  /// Check if tag is a warning tag
  bool get isWarning => tagType.toLowerCase() == 'warning';

  /// Check if tag is an info tag
  bool get isInfo => tagType.toLowerCase() == 'info';

  /// Check if tag is a late tag
  bool get isLate => tagType.toLowerCase() == 'late';
}
