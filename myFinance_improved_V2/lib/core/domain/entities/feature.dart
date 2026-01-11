class Feature {
  final String featureId;
  final String featureName;
  final String? featureDescription;
  final String featureRoute;
  final String featureIcon;
  final String? iconKey;
  final bool isShowMain;

  const Feature({
    required this.featureId,
    required this.featureName,
    this.featureDescription,
    required this.featureRoute,
    required this.featureIcon,
    this.iconKey,
    this.isShowMain = true, // Default to true for backward compatibility
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Feature &&
          runtimeType == other.runtimeType &&
          featureId == other.featureId &&
          isShowMain == other.isShowMain;

  @override
  int get hashCode => featureId.hashCode;

  // ============================================================================
  // Mock Factory (for skeleton loading)
  // ============================================================================

  static Feature mock() => const Feature(
        featureId: 'mock-feature-id',
        featureName: 'Mock Feature',
        featureDescription: 'Mock feature description',
        featureRoute: '/mock-route',
        featureIcon: 'star',
        iconKey: 'star',
        isShowMain: true,
      );

  static List<Feature> mockList([int count = 4]) =>
      List.generate(count, (i) => Feature(
            featureId: 'mock-feature-id-$i',
            featureName: 'Feature $i',
            featureDescription: 'Feature $i description',
            featureRoute: '/feature-$i',
            featureIcon: 'star',
            iconKey: 'star',
            isShowMain: true,
          ));
}