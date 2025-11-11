import 'available_content_dto.dart';

/// Extension to map AvailableContentDto → Simple Map
///
/// Note: This DTO doesn't have a corresponding domain entity.
/// It's used as metadata and typically consumed directly.
extension AvailableContentDtoMapper on AvailableContentDto {
  Map<String, String> toMap() {
    return {
      'content': content,
      'type': type,
    };
  }
}
