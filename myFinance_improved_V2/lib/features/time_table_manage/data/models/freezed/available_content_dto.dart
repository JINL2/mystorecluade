import 'package:freezed_annotation/freezed_annotation.dart';

part 'available_content_dto.freezed.dart';
part 'available_content_dto.g.dart';

/// Available Content DTO
///
/// Maps to manager_shift_get_cards RPC field: available_contents
@freezed
class AvailableContentDto with _$AvailableContentDto {
  const factory AvailableContentDto({
    @JsonKey(name: 'content') @Default('') String content,
    @JsonKey(name: 'type') @Default('') String type,
  }) = _AvailableContentDto;

  factory AvailableContentDto.fromJson(Map<String, dynamic> json) =>
      _$AvailableContentDtoFromJson(json);
}
