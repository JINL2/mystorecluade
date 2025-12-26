// lib/features/cash_location/domain/entities/stock_flow/shared_entities.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_entities.freezed.dart';

/// Location summary information
@freezed
class LocationSummary with _$LocationSummary {
  const factory LocationSummary({
    required String cashLocationId,
    required String locationName,
    required String locationType,
    String? bankName,
    String? bankAccount,
    required String currencyCode,
    required String currencyId,
    String? baseCurrencySymbol,
  }) = _LocationSummary;
}

/// Counter account information for journal entries
@freezed
class CounterAccount with _$CounterAccount {
  const factory CounterAccount({
    required String accountId,
    required String accountName,
    required String accountType,
    required double debit,
    required double credit,
    required String description,
  }) = _CounterAccount;
}

/// Currency information
@freezed
class CurrencyInfo with _$CurrencyInfo {
  const factory CurrencyInfo({
    required String currencyId,
    required String currencyCode,
    required String currencyName,
    required String symbol,
  }) = _CurrencyInfo;
}

/// Created by user information
@freezed
class CreatedBy with _$CreatedBy {
  const factory CreatedBy({
    required String userId,
    required String fullName,
    String? profileImage,
  }) = _CreatedBy;
}
