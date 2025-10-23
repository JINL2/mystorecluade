import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_verification.freezed.dart';

/// Balance verification entity
@freezed
class BalanceVerification with _$BalanceVerification {
  const factory BalanceVerification({
    required bool isBalanced,
    required double totalAssets,
    required double totalLiabilitiesAndEquity,
    required String totalAssetsFormatted,
    required String totalLiabilitiesAndEquityFormatted,
  }) = _BalanceVerification;
}
