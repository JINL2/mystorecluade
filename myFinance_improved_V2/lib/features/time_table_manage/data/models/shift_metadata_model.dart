import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/shift_metadata.dart';

/// Shift Metadata Model (DTO + Mapper)
///
/// Data Transfer Object for ShiftMetadata entity with JSON serialization.
class ShiftMetadataModel {
  final List<String> availableTags;
  final Map<String, dynamic> settings;
  final String? lastUpdated;

  const ShiftMetadataModel({
    required this.availableTags,
    required this.settings,
    this.lastUpdated,
  });

  /// Create from JSON
  factory ShiftMetadataModel.fromJson(Map<String, dynamic> json) {
    return ShiftMetadataModel(
      availableTags: (json['available_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      settings: json['settings'] as Map<String, dynamic>? ?? {},
      lastUpdated: json['last_updated'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'available_tags': availableTags,
      'settings': settings,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    };
  }

  /// Map to Domain Entity
  ShiftMetadata toEntity() {
    return ShiftMetadata(
      availableTags: availableTags,
      settings: settings,
      lastUpdated: DateTimeUtils.toLocalSafe(lastUpdated),
    );
  }

  /// Create from Domain Entity
  factory ShiftMetadataModel.fromEntity(ShiftMetadata entity) {
    return ShiftMetadataModel(
      availableTags: entity.availableTags,
      settings: entity.settings,
      lastUpdated: entity.lastUpdated != null ? DateTimeUtils.toUtc(entity.lastUpdated!) : null,
    );
  }
}
