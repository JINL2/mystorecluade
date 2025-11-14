/// Tag Entity
///
/// Represents a tag associated with a shift card for categorization
/// and additional information (e.g., bonus, warning, note).
class Tag {
  /// Unique identifier for the tag
  final String tagId;

  /// ID of the card this tag is attached to
  final String cardId;

  /// Type of tag (e.g., 'bonus', 'warning', 'info', 'late')
  final String tagType;

  /// Content/description of the tag
  final String tagContent;

  /// When the tag was created
  final DateTime createdAt;

  /// User ID who created the tag
  final String createdBy;

  const Tag({
    required this.tagId,
    required this.cardId,
    required this.tagType,
    required this.tagContent,
    required this.createdAt,
    required this.createdBy,
  });

  /// Check if tag is a bonus tag
  bool get isBonus => tagType.toLowerCase() == 'bonus';

  /// Check if tag is a warning tag
  bool get isWarning => tagType.toLowerCase() == 'warning';

  /// Check if tag is an info tag
  bool get isInfo => tagType.toLowerCase() == 'info';

  /// Check if tag is a late tag
  bool get isLate => tagType.toLowerCase() == 'late';

  /// Copy with method for immutability
  Tag copyWith({
    String? tagId,
    String? cardId,
    String? tagType,
    String? tagContent,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return Tag(
      tagId: tagId ?? this.tagId,
      cardId: cardId ?? this.cardId,
      tagType: tagType ?? this.tagType,
      tagContent: tagContent ?? this.tagContent,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tag &&
        other.tagId == tagId &&
        other.cardId == cardId &&
        other.tagType == tagType &&
        other.tagContent == tagContent &&
        other.createdAt == createdAt &&
        other.createdBy == createdBy;
  }

  @override
  int get hashCode {
    return tagId.hashCode ^
        cardId.hashCode ^
        tagType.hashCode ^
        tagContent.hashCode ^
        createdAt.hashCode ^
        createdBy.hashCode;
  }

  @override
  String toString() {
    return 'Tag(id: $tagId, type: $tagType, content: $tagContent)';
  }
}
