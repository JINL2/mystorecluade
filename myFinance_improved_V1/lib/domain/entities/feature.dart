class Feature {
  final String featureId;
  final String featureName;
  final String featureRoute;
  final String featureIcon;
  final String? iconKey;

  const Feature({
    required this.featureId,
    required this.featureName,
    required this.featureRoute,
    required this.featureIcon,
    this.iconKey,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Feature &&
          runtimeType == other.runtimeType &&
          featureId == other.featureId;

  @override
  int get hashCode => featureId.hashCode;
}