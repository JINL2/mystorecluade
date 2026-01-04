import '../../domain/entities/denomination_delete_result.dart';

/// Mapper for DenominationDeleteResult from RPC response
class DenominationDeleteResultMapper {
  const DenominationDeleteResultMapper._();

  /// Maps RPC response JSON to DenominationDeleteResult entity
  static DenominationDeleteResult fromRpcResponse(Map<String, dynamic> json) {
    final success = json['success'] as bool;

    if (success) {
      return const DenominationDeleteResult(success: true);
    }

    final blockingLocationsJson = json['blocking_locations'] as List<dynamic>?;
    final blockingLocations = blockingLocationsJson
            ?.map((item) => BlockingLocationMapper.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];

    return DenominationDeleteResult(
      success: false,
      error: json['error'] as String?,
      blockingLocations: blockingLocations,
      denominationValue: json['denomination_value'] != null
          ? (json['denomination_value'] as num).toDouble()
          : null,
    );
  }
}

/// Mapper for BlockingLocation from JSON
class BlockingLocationMapper {
  const BlockingLocationMapper._();

  /// Maps JSON to BlockingLocation entity
  static BlockingLocation fromJson(Map<String, dynamic> json) {
    return BlockingLocation(
      locationId: json['location_id'] as String,
      locationName: json['location_name'] as String,
      locationType: json['location_type'] as String,
      reason: json['reason'] as String,
      balance: json['balance'] != null ? (json['balance'] as num).toDouble() : null,
      quantity: json['quantity'] != null ? (json['quantity'] as num).toInt() : null,
    );
  }
}
