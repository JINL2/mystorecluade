import 'package:equatable/equatable.dart';

/// Cash location entity for payment method
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

  /// Helper getters for UI display
  String get displayName {
    if (type == 'bank' && bankName != null) {
      return '$name - $bankName';
    }
    return name;
  }

  String get displayType {
    return type == 'bank' ? 'Bank' : 'Cash';
  }

  bool get isBank => type == 'bank';
  bool get isCash => type == 'cash';

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
