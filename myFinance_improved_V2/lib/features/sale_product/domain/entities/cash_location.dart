import 'package:equatable/equatable.dart';

/// Cash location entity for payment method
/// Note: displayName/displayType are in presentation/extensions/cash_location_extension.dart
class CashLocation extends Equatable {
  final String id;
  final String name;
  final String type; // 'bank' or 'cash'
  final String storeId;
  final bool isCompanyWide;
  final String currencyCode;
  final String? bankAccount;
  final String? bankName;

  const CashLocation({
    required this.id,
    required this.name,
    required this.type,
    required this.storeId,
    required this.isCompanyWide,
    required this.currencyCode,
    this.bankAccount,
    this.bankName,
  });

  /// Business logic helpers
  bool get isBank => type == 'bank';
  bool get isCash => type == 'cash';
  bool get isVault => type == 'vault';

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        storeId,
        isCompanyWide,
        currencyCode,
        bankAccount,
        bankName,
      ];
}
