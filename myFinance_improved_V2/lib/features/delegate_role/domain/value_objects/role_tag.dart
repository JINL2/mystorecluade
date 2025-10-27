/// Value object for Role tags with validation
class RoleTag {
  final String value;

  const RoleTag._(this.value);

  /// Create RoleTag from string with validation
  factory RoleTag.fromString(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Tag cannot be empty');
    }
    if (trimmed.length > 50) {
      throw ArgumentError('Tag cannot exceed 50 characters');
    }
    return RoleTag._(trimmed);
  }

  /// Create list of RoleTags from string list
  static List<RoleTag> fromStringList(List<String> tags) {
    return tags.map((tag) => RoleTag.fromString(tag)).toList();
  }

  /// Convert list of RoleTags to string list
  static List<String> toStringList(List<RoleTag> tags) {
    return tags.map((tag) => tag.value).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleTag &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
