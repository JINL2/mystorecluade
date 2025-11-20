// lib/features/report_control/data/models/subscription_response_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_response_dto.freezed.dart';
part 'subscription_response_dto.g.dart';

/// DTO for subscription RPC response
@freezed
class SubscriptionResponseDto with _$SubscriptionResponseDto {
  const factory SubscriptionResponseDto({
    @JsonKey(name: 'subscription_id') required String subscriptionId,
  }) = _SubscriptionResponseDto;

  factory SubscriptionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResponseDtoFromJson(json);
}
