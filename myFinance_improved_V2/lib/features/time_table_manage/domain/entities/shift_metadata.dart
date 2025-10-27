/// Shift Metadata Entity
///
/// Contains metadata information about shift configurations for a store.
class ShiftMetadata {
  final List<String> availableTags;
  final Map<String, dynamic> settings;
  final DateTime? lastUpdated;

  const ShiftMetadata({
    required this.availableTags,
    required this.settings,
    this.lastUpdated,
  });

  /// Check if metadata has any tags
  bool get hasTags => availableTags.isNotEmpty;

  /// Get tag count
  int get tagCount => availableTags.length;

  /// Copy with method for immutability
  ShiftMetadata copyWith({
    List<String>? availableTags,
    Map<String, dynamic>? settings,
    DateTime? lastUpdated,
  }) {
    return ShiftMetadata(
      availableTags: availableTags ?? this.availableTags,
      settings: settings ?? this.settings,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() => 'ShiftMetadata(tags: $tagCount, lastUpdated: $lastUpdated)';
}
