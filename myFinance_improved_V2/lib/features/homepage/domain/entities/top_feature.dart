import 'package:equatable/equatable.dart';

/// Top feature based on user's usage
///
/// Represents a frequently used feature by the user.
/// Used for Quick Access section on homepage.
class TopFeature extends Equatable {
  const TopFeature({
    required this.featureId,
    required this.featureName,
    this.featureDescription,
    required this.clickCount,
    required this.lastClicked,
    required this.icon,
    required this.route,
    this.categoryId,
    this.iconKey,
  });

  final String featureId;
  final String featureName;
  final String? featureDescription;
  final String? categoryId;
  final int clickCount;
  final DateTime lastClicked;
  final String icon;
  final String route;
  final String? iconKey;

  /// Check if feature was clicked recently (within last 7 days)
  bool get isRecentlyUsed {
    final daysSinceLastClick = DateTime.now().difference(lastClicked).inDays;
    return daysSinceLastClick <= 7;
  }

  @override
  List<Object?> get props => [
        featureId,
        featureName,
        featureDescription,
        categoryId,
        clickCount,
        lastClicked,
        icon,
        route,
        iconKey,
      ];

  @override
  String toString() {
    return 'TopFeature(id: $featureId, name: $featureName, clicks: $clickCount)';
  }
}
