class Feature {
  final String featureId;
  final String featureName;
  final String featureRoute;
  final String featureIcon;
  final String? iconKey;
  final bool isShowMain;

  const Feature({
    required this.featureId,
    required this.featureName,
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
}