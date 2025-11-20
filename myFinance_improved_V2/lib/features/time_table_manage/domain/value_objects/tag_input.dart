/// Tag Input Value Object
///
/// Represents a tag input with validation logic.
/// Ensures that tag type and content are both provided or both empty.
class TagInput {
  final String? tagType;
  final String? content;

  const TagInput({
    this.tagType,
    this.content,
  });

  /// Maximum content length
  static const int maxContentLength = 500;

  /// Check if tag has any input
  bool get hasInput =>
      (tagType != null && tagType!.trim().isNotEmpty) ||
      (content != null && content!.trim().isNotEmpty);

  /// Check if tag is complete (both fields provided)
  bool get isComplete =>
      tagType != null &&
      tagType!.trim().isNotEmpty &&
      content != null &&
      content!.trim().isNotEmpty;

  /// Check if tag is empty (both fields empty)
  bool get isEmpty =>
      (tagType == null || tagType!.trim().isEmpty) &&
      (content == null || content!.trim().isEmpty);

  /// Check if tag input is valid
  ///
  /// Valid means either:
  /// 1. Both fields are empty (no tag)
  /// 2. Both fields are filled and content is within max length
  bool get isValid {
    // Case 1: Both empty - valid (no tag)
    if (isEmpty) return true;

    // Case 2: Both filled - check content length
    if (isComplete) {
      return content!.trim().length <= maxContentLength;
    }

    // Case 3: Only one field filled - invalid
    return false;
  }

  /// Get validation error message
  String? get validationError {
    if (isEmpty) return null;

    // Check if both fields are provided
    final hasType = tagType != null && tagType!.trim().isNotEmpty;
    final hasContent = content != null && content!.trim().isNotEmpty;

    if (hasType && !hasContent) {
      return 'Please provide tag content';
    }

    if (!hasType && hasContent) {
      return 'Please select tag type';
    }

    if (hasType && hasContent) {
      // Check content length
      if (content!.trim().length > maxContentLength) {
        return 'Tag content cannot exceed $maxContentLength characters';
      }
    }

    return null;
  }

  /// Get trimmed tag type (null if empty)
  String? get trimmedType =>
      tagType?.trim().isEmpty ?? true ? null : tagType!.trim();

  /// Get trimmed content (null if empty)
  String? get trimmedContent =>
      content?.trim().isEmpty ?? true ? null : content!.trim();

  /// Create empty tag input
  factory TagInput.empty() => const TagInput();

  /// Copy with method
  TagInput copyWith({
    String? tagType,
    String? content,
  }) {
    return TagInput(
      tagType: tagType ?? this.tagType,
      content: content ?? this.content,
    );
  }

  @override
  String toString() => 'TagInput(type: $tagType, content: ${content?.substring(0, content!.length > 20 ? 20 : content!.length)}...)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TagInput &&
        other.tagType == tagType &&
        other.content == content;
  }

  @override
  int get hashCode => tagType.hashCode ^ content.hashCode;
}
