import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../sale_product/domain/entities/cart_item.dart';
import '../../domain/value_objects/invoice_calculator.dart';

// Invoice Model
class SaleInvoice {
  final String id;
  final String invoiceNumber;
  final DateTime date;
  final String? customerId;
  final String customerName;
  final String? customerPhone;
  final String? priceBookId;
  final String priceBookName;
  final List<CartItem> items;
  final double subtotal;
  final double discountPercentage;
  final double discountAmount;
  final double taxAmount;
  final double total;
  final InvoiceStatus status;
  final PaymentMethod? paymentMethod;
  final double paidAmount;
  final double changeAmount;
  final DeliveryInfo? deliveryInfo;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SaleInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    this.customerId,
    required this.customerName,
    this.customerPhone,
    this.priceBookId,
    required this.priceBookName,
    required this.items,
    required this.subtotal,
    this.discountPercentage = 0,
    this.discountAmount = 0,
    this.taxAmount = 0,
    required this.total,
    this.status = InvoiceStatus.draft,
    this.paymentMethod,
    this.paidAmount = 0,
    this.changeAmount = 0,
    this.deliveryInfo,
    required this.createdAt,
    this.updatedAt,
  });

  factory SaleInvoice.empty() {
    final now = DateTime.now();
    return SaleInvoice(
      id: '',
      invoiceNumber: '',
      date: now,
      customerName: 'Guest',
      priceBookName: 'General price book',
      items: [],
      subtotal: 0,
      total: 0,
      createdAt: now,
    );
  }

  SaleInvoice copyWith({
    String? id,
    String? invoiceNumber,
    DateTime? date,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? priceBookId,
    String? priceBookName,
    List<CartItem>? items,
    double? subtotal,
    double? discountPercentage,
    double? discountAmount,
    double? taxAmount,
    double? total,
    InvoiceStatus? status,
    PaymentMethod? paymentMethod,
    double? paidAmount,
    double? changeAmount,
    DeliveryInfo? deliveryInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SaleInvoice(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      date: date ?? this.date,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      priceBookId: priceBookId ?? this.priceBookId,
      priceBookName: priceBookName ?? this.priceBookName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      total: total ?? this.total,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paidAmount: paidAmount ?? this.paidAmount,
      changeAmount: changeAmount ?? this.changeAmount,
      deliveryInfo: deliveryInfo ?? this.deliveryInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Calculate total using Domain layer business logic
  double calculateTotal() {
    return InvoiceCalculator.calculateFinalTotal(
      subtotal: subtotal,
      discountPercentage: discountPercentage,
      discountAmount: discountAmount,
      taxAmount: taxAmount,
    );
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}

// Invoice Status
enum InvoiceStatus {
  draft,
  pending,
  paid,
  cancelled,
  refunded;

  String get displayName {
    switch (this) {
      case InvoiceStatus.draft:
        return 'Draft';
      case InvoiceStatus.pending:
        return 'Pending';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.cancelled:
        return 'Cancelled';
      case InvoiceStatus.refunded:
        return 'Refunded';
    }
  }

  Color get color {
    switch (this) {
      case InvoiceStatus.draft:
        return TossColors.gray500;
      case InvoiceStatus.pending:
        return TossColors.warning;
      case InvoiceStatus.paid:
        return TossColors.success;
      case InvoiceStatus.cancelled:
        return TossColors.error;
      case InvoiceStatus.refunded:
        return TossColors.primary;
    }
  }
}

// Payment Method
enum PaymentMethod {
  cash,
  bankTransfer,
  card,
  digitalWallet,
  other;

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank transfer';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.digitalWallet:
        return 'Digital Wallet';
      case PaymentMethod.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.digitalWallet:
        return Icons.phone_android;
      case PaymentMethod.other:
        return Icons.payment;
    }
  }
}

// Delivery Info
class DeliveryInfo {
  final bool isDelivery;
  final String? address;
  final String? district;
  final String? city;
  final String? phone;
  final String? recipientName;
  final DateTime? deliveryDate;
  final String? notes;

  DeliveryInfo({
    required this.isDelivery,
    this.address,
    this.district,
    this.city,
    this.phone,
    this.recipientName,
    this.deliveryDate,
    this.notes,
  });

  String get fullAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (district != null && district!.isNotEmpty) parts.add(district!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    return parts.join(', ');
  }

  DeliveryInfo copyWith({
    bool? isDelivery,
    String? address,
    String? district,
    String? city,
    String? phone,
    String? recipientName,
    DateTime? deliveryDate,
    String? notes,
  }) {
    return DeliveryInfo(
      isDelivery: isDelivery ?? this.isDelivery,
      address: address ?? this.address,
      district: district ?? this.district,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      recipientName: recipientName ?? this.recipientName,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      notes: notes ?? this.notes,
    );
  }
}

// Currency and Payment Models for Payment Method Page

class CurrencyDenomination {
  final String denominationId;
  final int value;

  CurrencyDenomination({
    required this.denominationId,
    required this.value,
  });

  factory CurrencyDenomination.fromJson(Map<String, dynamic> json) {
    return CurrencyDenomination(
      denominationId: json['denomination_id']?.toString() ?? '',
      value: (json['value'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'denomination_id': denominationId,
      'value': value,
    };
  }
}

class PaymentCurrency {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final String flagEmoji;
  final double? exchangeRateToBase;
  final String? rateDate;
  final List<CurrencyDenomination> denominations;

  PaymentCurrency({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.flagEmoji,
    this.exchangeRateToBase,
    this.rateDate,
    this.denominations = const [],
  });

  factory PaymentCurrency.fromJson(Map<String, dynamic> json) {
    return PaymentCurrency(
      currencyId: json['currency_id']?.toString() ?? '',
      currencyCode: json['currency_code']?.toString() ?? '',
      currencyName: json['currency_name']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      flagEmoji: json['flag_emoji']?.toString() ?? '',
      exchangeRateToBase: (json['exchange_rate_to_base'] as num?)?.toDouble(),
      rateDate: json['rate_date']?.toString(),
      denominations: json['denominations'] != null && json['denominations'] is List
          ? (json['denominations'] as List)
              .map((item) => CurrencyDenomination.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency_id': currencyId,
      'currency_code': currencyCode,
      'currency_name': currencyName,
      'symbol': symbol,
      'flag_emoji': flagEmoji,
      'exchange_rate_to_base': exchangeRateToBase,
      'rate_date': rateDate,
      'denominations': denominations.map((d) => d.toJson()).toList(),
    };
  }

  String get displayName => '$flagEmoji $currencyCode';
}

class BaseCurrencyResponse {
  final PaymentCurrency baseCurrency;
  final List<PaymentCurrency> companyCurrencies;

  BaseCurrencyResponse({
    required this.baseCurrency,
    required this.companyCurrencies,
  });

  factory BaseCurrencyResponse.fromJson(Map<String, dynamic> json) {
    return BaseCurrencyResponse(
      baseCurrency: PaymentCurrency.fromJson(json['base_currency'] as Map<String, dynamic>),
      companyCurrencies: json['company_currencies'] != null && json['company_currencies'] is List
          ? (json['company_currencies'] as List)
              .map((item) => PaymentCurrency.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_currency': baseCurrency.toJson(),
      'company_currencies': companyCurrencies.map((c) => c.toJson()).toList(),
    };
  }

  // Helper method to find currency by code
  PaymentCurrency? findCurrencyByCode(String code) {
    try {
      return companyCurrencies.firstWhere(
        (currency) => currency.currencyCode == code,
      );
    } catch (e) {
      return baseCurrency.currencyCode == code ? baseCurrency : null;
    }
  }
}
