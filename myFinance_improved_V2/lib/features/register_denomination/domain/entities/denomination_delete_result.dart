/// Result of denomination deletion attempt
class DenominationDeleteResult {
  const DenominationDeleteResult({
    required this.success,
    this.error,
    this.blockingLocations = const [],
    this.denominationValue,
  });

  final bool success;
  final String? error;
  final List<BlockingLocation> blockingLocations;
  final double? denominationValue;

  bool get hasBlockingLocations => blockingLocations.isNotEmpty;
}

/// Location that is blocking denomination deletion
class BlockingLocation {
  const BlockingLocation({
    required this.locationId,
    required this.locationName,
    required this.locationType,
    required this.reason,
    this.balance,
    this.quantity,
  });

  final String locationId;
  final String locationName;
  final String locationType;
  final String reason;
  final double? balance;
  final int? quantity;
}
