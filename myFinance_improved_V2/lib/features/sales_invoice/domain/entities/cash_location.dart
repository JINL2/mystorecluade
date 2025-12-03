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
    switch (type) {
      case 'bank':
        return 'Bank';
      case 'cash':
        return 'Cash';
      case 'vault':
        return 'Vault';
      default:
        // Capitalize first letter for unknown types
        return type.isNotEmpty
            ? '${type[0].toUpperCase()}${type.substring(1)}'
            : 'Unknown';
    }
  }

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
