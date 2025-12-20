import 'package:equatable/equatable.dart';

import '../entities/payment_currency.dart';

/// Invoice item for creation
class InvoiceItem extends Equatable {
  final String productId;
  final int quantity;
  final double? unitPrice;

  const InvoiceItem({
    required this.productId,
    required this.quantity,
    this.unitPrice,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'product_id': productId,
      'quantity': quantity,
    };
    if (unitPrice != null && unitPrice! > 0) {
      json['unit_price'] = unitPrice;
    }
    return json;
  }

  @override
  List<Object?> get props => [productId, quantity, unitPrice];
}

/// Create invoice result
class CreateInvoiceResult extends Equatable {
  final bool success;
  final String? invoiceId;
  final String? invoiceNumber;
  final double? totalAmount;
  final List<String>? warnings;
  final String? message;

  const CreateInvoiceResult({
    required this.success,
    this.invoiceId,
    this.invoiceNumber,
    this.totalAmount,
    this.warnings,
    this.message,
  });

  @override
  List<Object?> get props => [
        success,
        invoiceId,
        invoiceNumber,
        totalAmount,
        warnings,
        message,
      ];
}

/// Currency data result
class CurrencyDataResult extends Equatable {
  final PaymentCurrency baseCurrency;
  final List<PaymentCurrency> companyCurrencies;

  const CurrencyDataResult({
    required this.baseCurrency,
    required this.companyCurrencies,
  });

  @override
  List<Object?> get props => [baseCurrency, companyCurrencies];
}
